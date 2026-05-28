"""
MyFCD Scraper Module

Scrapes food nutrition data from the Malaysian Food Composition Database (MyFCD).
URL: https://myfcd.moh.gov.my

Flow:
  1. Search for a food item by name on the current database listing page.
  2. Parse the results table to find the best matching food.
  3. Follow the detail link to the food's nutrient composition page.
  4. Extract macronutrients (Energy, Protein, Fat, Carbohydrate, etc.) per 100g.
"""

import re
import logging
from typing import Optional, Dict, Any, List
from urllib.parse import urljoin

from bs4 import BeautifulSoup, Tag

from .base import BaseScraper

logger = logging.getLogger(__name__)

# MyFCD base URL
MYFCD_BASE = "https://myfcd.moh.gov.my"

# Known nutrient keys we want to extract (mapped to canonical JSON keys)
NUTRIENT_MAP = {
    # Energy
    "energy": ["energy", "tenaga", "calories", "kalori"],
    # Protein
    "protein": ["protein", "protin"],
    # Total Fat
    "total_fat": ["fat", "total fat", "lemak", "jumlah lemak"],
    # Carbohydrate
    "carbohydrate": ["carbohydrate", "karbohidrat", "carbo", "cho"],
    # Dietary Fiber
    "dietary_fiber": ["fiber", "fibre", "dietary fiber", "dietary fibre", "serat"],
    # Sugar
    "sugar": ["sugar", "sugars", "gula"],
    # Sodium
    "sodium": ["sodium", "natrium"],
    # Cholesterol
    "cholesterol": ["cholesterol", "kolestrol"],
    # Saturated Fat
    "saturated_fat": ["saturated fat", "lemak tepu", "saturates"],
}


def _normalize(text: str) -> str:
    """Lowercase and strip extra whitespace."""
    return re.sub(r"\s+", " ", text.lower().strip())


def _match_nutrient_key(cell_text: str) -> Optional[str]:
    """
    Try to match a table cell's text to one of our canonical nutrient keys.
    Returns the canonical key or None.
    """
    norm = _normalize(cell_text)
    for canonical, aliases in NUTRIENT_MAP.items():
        for alias in aliases:
            if alias in norm:
                return canonical
    return None


def _extract_numeric(value_text: str) -> Optional[float]:
    """
    Extract the first float/integer from a string like '290 kcal' or '12.5 g'.
    Returns None if no number found.
    """
    # Replace common Unicode minus and non-breaking spaces
    cleaned = value_text.replace("\u2013", "-").replace("\u2014", "-").replace("\xa0", " ")
    match = re.search(r"-?\d+(?:\.\d+)?", cleaned.replace(",", ""))
    if match:
        try:
            return float(match.group())
        except ValueError:
            return None
    return None


class MyFCDScraper(BaseScraper):
    """
    Scraper for the Malaysian Food Composition Database (MyFCD).
    """

    def __init__(self):
        super().__init__(base_url=MYFCD_BASE, timeout=30)

    # -----------------------------------------------------------------------
    # SEARCH
    # -----------------------------------------------------------------------
    def _search_food_requests(self, food_name: str) -> List[Dict[str, Any]]:
        """
        Search MyFCD current database via requests.
        Returns a list of result dicts with keys: ndb_no, description, food_group, detail_url.
        """
        search_url = "/myfcdcurrent/"
        params = {
            "search": food_name,
            # Some Joomla sites use 'view' or 'task' params; we include common ones
            "view": "search",
        }
        soup = self.fetch_html(search_url, params=params)
        return self._parse_search_results(soup)

    async def _search_food_stealth(self, food_name: str) -> List[Dict[str, Any]]:
        """
        Search MyFCD via Playwright stealth (fallback if requests blocked).
        """
        search_url = "/myfcdcurrent/"
        params = {"search": food_name, "view": "search"}

        async def _interact(page):
            # Try to find the search input and fill it if present
            try:
                # Common input names on Joomla sites
                selectors = [
                    "input[name='search']",
                    "input[name='keyword']",
                    "input#search",
                    "input[type='search']",
                ]
                for sel in selectors:
                    if await page.locator(sel).count() > 0:
                        await page.locator(sel).fill(food_name)
                        # Try to submit by pressing Enter or clicking a search button
                        submit_btn = "input[type='submit'], button[type='submit'], .search-button, #search-btn"
                        if await page.locator(submit_btn).first.count() > 0:
                            await page.locator(submit_btn).first.click()
                        else:
                            await page.keyboard.press("Enter")
                        break
            except Exception as exc:
                logger.warning(f"Interaction fallback issue: {exc}")

        soup = await self.fetch_html_smart(
            search_url,
            params=params,
            wait_selector="table",
            interact_callback=_interact,
        )
        return self._parse_search_results(soup)

    def _parse_search_results(self, soup: BeautifulSoup) -> List[Dict[str, Any]]:
        """
        Parse the search results page HTML to extract food listings.
        Handles both current and legacy table layouts.
        """
        results = []
        # MyFCD uses tables with class names like 'table', 'category', or no class
        tables = soup.find_all("table")
        logger.debug(f"Found {len(tables)} tables on search results page.")

        for table in tables:
            rows = table.find_all("tr")
            for row in rows:
                cells = row.find_all(["td", "th"])
                if len(cells) < 3:
                    continue

                # Try to identify data rows by looking for a link in one of the cells
                link: Optional[Tag] = None
                description = ""
                ndb_no = ""
                food_group = ""

                for idx, cell in enumerate(cells):
                    text = cell.get_text(strip=True)
                    if not text:
                        continue
                    # First meaningful text might be NDB No or Description
                    if idx == 0:
                        ndb_no = text
                    elif idx == 1:
                        description = text
                    elif idx == 2:
                        food_group = text

                    # Look for detail link (usually points to nutrient detail page)
                    a_tag = cell.find("a", href=True)
                    if a_tag and not link:
                        link = a_tag

                if description and link:
                    href = link["href"]
                    detail_url = urljoin(self.base_url, href)
                    results.append({
                        "ndb_no": ndb_no,
                        "description": description,
                        "food_group": food_group,
                        "detail_url": detail_url,
                    })

        # If no links found in tables, fallback: look for any anchor tags with food-related paths
        if not results:
            for a in soup.find_all("a", href=True):
                href = a["href"]
                if any(k in href.lower() for k in ["food", "nutrient", "detail", "view=article"]):
                    text = a.get_text(strip=True)
                    if text and len(text) > 2:
                        results.append({
                            "ndb_no": "",
                            "description": text,
                            "food_group": "",
                            "detail_url": urljoin(self.base_url, href),
                        })

        logger.info(f"Parsed {len(results)} search results from MyFCD.")
        return results

    # -----------------------------------------------------------------------
    # DETAIL / NUTRIENT EXTRACTION
    # -----------------------------------------------------------------------
    def _fetch_detail(self, detail_url: str) -> BeautifulSoup:
        """Fetch a food detail page using requests."""
        return self.fetch_html(detail_url)

    async def _fetch_detail_stealth(self, detail_url: str) -> BeautifulSoup:
        """Fetch a food detail page using Playwright stealth fallback."""
        return await self.fetch_html_stealth(detail_url, wait_selector="table")

    def _parse_nutrients(self, soup: BeautifulSoup) -> Dict[str, Any]:
        """
        Parse a MyFCD food detail page and extract macronutrients.
        Returns a dict with canonical nutrient keys and per-100g values.
        """
        nutrients: Dict[str, Optional[float]] = {}
        nutrient_table = None

        # Strategy 1: Find a table that contains "Nutrient" or "Per 100g" headers
        tables = soup.find_all("table")
        for table in tables:
            text = table.get_text(separator=" ", strip=True).lower()
            if any(k in text for k in ["nutrient", "per 100", "value", "unit", "energy", "protein"]):
                nutrient_table = table
                break

        if not nutrient_table:
            logger.warning("No nutrient table found on detail page.")
            return nutrients

        # Parse rows of the nutrient table
        rows = nutrient_table.find_all("tr")
        for row in rows:
            cells = row.find_all(["td", "th"])
            if len(cells) < 2:
                continue

            # First cell(s) usually contain nutrient name; last meaningful cell contains value
            name_text = cells[0].get_text(strip=True)
            key = _match_nutrient_key(name_text)
            if not key:
                # Some tables have nutrient name in second column
                if len(cells) >= 3:
                    name_text = cells[1].get_text(strip=True)
                    key = _match_nutrient_key(name_text)

            if key and key not in nutrients:
                # Value is usually in the second-to-last or last numeric-looking cell
                for c in reversed(cells[1:]):
                    val_text = c.get_text(strip=True)
                    num = _extract_numeric(val_text)
                    if num is not None:
                        nutrients[key] = num
                        break

        logger.debug(f"Extracted nutrients: {nutrients}")
        return nutrients

    # -----------------------------------------------------------------------
    # PUBLIC API
    # -----------------------------------------------------------------------
    async def search_nutrition(self, food_name: str) -> Optional[Dict[str, Any]]:
        """
        Search for a food by name and return its macronutrient data.

        Returns:
            A dict with food metadata and nutrients_per_100g, or None if not found.
        """
        if not food_name or not food_name.strip():
            raise ValueError("food_name cannot be empty")

        food_name = food_name.strip()
        logger.info(f"[MyFCD] Searching nutrition for: {food_name}")

        # --- Try requests first ---
        results = []
        try:
            results = self._search_food_requests(food_name)
        except Exception as exc:
            logger.warning(f"[MyFCD] requests search failed: {exc}")

        # --- Fallback to Playwright if no results or exception ---
        if not results:
            try:
                results = await self._search_food_stealth(food_name)
            except Exception as exc:
                logger.error(f"[MyFCD] Stealth search also failed: {exc}")
                raise RuntimeError(f"Unable to reach MyFCD after trying both methods: {exc}")

        if not results:
            logger.info(f"[MyFCD] No results found for '{food_name}'.")
            return None

        # Pick the best match (first result, or simple substring scoring)
        best_match = self._pick_best_match(food_name, results)
        detail_url = best_match["detail_url"]
        logger.info(f"[MyFCD] Best match: {best_match['description']} -> {detail_url}")

        # --- Fetch detail page ---
        detail_soup = None
        try:
            detail_soup = self._fetch_detail(detail_url)
        except Exception as exc:
            logger.warning(f"[MyFCD] requests detail fetch failed: {exc}")
            try:
                detail_soup = await self._fetch_detail_stealth(detail_url)
            except Exception as exc2:
                logger.error(f"[MyFCD] stealth detail fetch also failed: {exc2}")
                raise RuntimeError(f"Unable to fetch food detail page: {exc2}")

        nutrients = self._parse_nutrients(detail_soup)

        return {
            "food_name": food_name,
            "source": detail_url,
            "matched_food_description": best_match.get("description", ""),
            "ndb_no": best_match.get("ndb_no", ""),
            "food_group": best_match.get("food_group", ""),
            "nutrients_per_100g": nutrients,
        }

    def _pick_best_match(self, query: str, results: List[Dict[str, Any]]) -> Dict[str, Any]:
        """
        Simple scoring: prefer results whose description contains the query words.
        Falls back to the first result if no clear winner.
        """
        query_words = set(_normalize(query).split())
        scored = []
        for r in results:
            desc = _normalize(r.get("description", ""))
            score = sum(1 for w in query_words if w in desc)
            scored.append((score, r))

        scored.sort(key=lambda x: x[0], reverse=True)
        # If top score > 0, use it; otherwise use first result
        if scored and scored[0][0] > 0:
            return scored[0][1]
        return results[0]
