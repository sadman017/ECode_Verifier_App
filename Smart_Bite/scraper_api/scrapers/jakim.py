"""
JAKIM Halal Scraper Module

Scrapes halal certification status from the JAKIM MyeHalal public portal.
URL: https://myehalal.halal.gov.my/portal-halal/v1/

Flow:
  1. Navigate to the MyeHalal public portal.
  2. Select "Produk Makanan" (Food Product) category.
  3. Enter the product/company name in the search field.
  4. Submit search and wait for results table.
  5. Parse results to extract certification details.

Note:
  This portal is a modern JavaScript-heavy application with SSL/TLS protections
  that often block plain HTTP requests. Therefore, Playwright with stealth mode
  is the primary scraping strategy, with requests as a lightweight fallback.
"""

import re
import logging
from typing import Optional, Dict, Any, List
from urllib.parse import urljoin

from bs4 import BeautifulSoup, Tag

from .base import BaseScraper

logger = logging.getLogger(__name__)

# MyeHalal portal base URL
MYEHALAL_BASE = "https://myehalal.halal.gov.my"


def _normalize(text: str) -> str:
    """Lowercase, strip whitespace, collapse spaces."""
    return re.sub(r"\s+", " ", text.lower().strip())


class JakimHalalScraper(BaseScraper):
    """
    Scraper for JAKIM MyeHalal certification directory.
    """

    def __init__(self):
        super().__init__(base_url=MYEHALAL_BASE, timeout=30)

    # -----------------------------------------------------------------------
    # SEARCH via Playwright Stealth (Primary)
    # -----------------------------------------------------------------------
    async def _search_halal_stealth(self, product_name: str) -> List[Dict[str, Any]]:
        """
        Search the MyeHalal portal using Playwright with stealth mode.
        This is the primary method because the portal blocks plain requests.
        """
        portal_path = "/portal-halal/v1/"
        logger.info(f"[JAKIM] Stealth search for: {product_name}")

        async def _interact(page):
            """Interact with the portal: select category, fill search, click search."""
            # Wait a moment for React/Vue to mount
            await page.wait_for_timeout(2000)

            # --- Step 1: Select category "Produk Makanan" (Food Product) ---
            # The portal uses dropdowns/selects; we try common selectors
            category_selectors = [
                "select[id*='kategori']",
                "select[name*='kategori']",
                "select[id*='category']",
                "select[name*='category']",
                "select",
            ]
            for sel in category_selectors:
                try:
                    count = await page.locator(sel).count()
                    if count > 0:
                        # Option text contains "Produk" or "Product"
                        options = await page.locator(sel).evaluate(
                            """el => Array.from(el.options).map(o => ({text: o.text, value: o.value}))"""
                        )
                        target_value = None
                        for opt in options:
                            opt_text = opt.get("text", "")
                            if any(k in opt_text.lower() for k in ["produk", "product", "makanan"]):
                                target_value = opt.get("value")
                                break
                        if target_value:
                            await page.locator(sel).select_option(target_value)
                            logger.debug(f"Selected category value: {target_value}")
                        break
                except Exception as exc:
                    logger.debug(f"Category select attempt failed for '{sel}': {exc}")
                    continue

            # --- Step 2: Fill search input ---
            search_selectors = [
                "input[placeholder*='Cari']",
                "input[placeholder*='Search']",
                "input[name*='nama']",
                "input[id*='nama']",
                "input[name*='search']",
                "input[id*='search']",
                "input[type='text']",
            ]
            filled = False
            for sel in search_selectors:
                try:
                    count = await page.locator(sel).count()
                    if count > 0:
                        await page.locator(sel).first.fill(product_name)
                        filled = True
                        logger.debug(f"Filled search input: {sel}")
                        break
                except Exception as exc:
                    logger.debug(f"Search fill attempt failed for '{sel}': {exc}")
                    continue

            if not filled:
                # Last resort: type into the first visible text input
                try:
                    await page.locator("input[type='text']").first.fill(product_name)
                except Exception as exc:
                    logger.warning(f"Could not fill any search input: {exc}")

            # --- Step 3: Click search button or press Enter ---
            btn_selectors = [
                "button:has-text('Cari')",
                "button:has-text('Search')",
                "button[id*='cari']",
                "button[id*='search']",
                "button[type='submit']",
                "input[type='submit']",
                ".search-btn",
                "button",
            ]
            clicked = False
            for sel in btn_selectors:
                try:
                    count = await page.locator(sel).count()
                    if count > 0:
                        await page.locator(sel).first.click()
                        clicked = True
                        logger.debug(f"Clicked search button: {sel}")
                        break
                except Exception as exc:
                    logger.debug(f"Button click failed for '{sel}': {exc}")
                    continue

            if not clicked:
                await page.keyboard.press("Enter")
                logger.debug("Submitted search via Enter key.")

        soup = await self.fetch_html_stealth(
            portal_path,
            wait_selector="table, .table, [class*='result'], [class*='list']",
            wait_for_timeout=8000,
            interact_callback=_interact,
        )
        return self._parse_halal_results(soup)

    # -----------------------------------------------------------------------
    # SEARCH via Requests (Fallback)
    # -----------------------------------------------------------------------
    def _search_halal_requests(self, product_name: str) -> List[Dict[str, Any]]:
        """
        Attempt to search via direct HTTP request.
        MyeHalal may expose an internal API endpoint; we probe common patterns.
        """
        logger.info(f"[JAKIM] Trying requests fallback for: {product_name}")

        # Some government SPAs still serve initial HTML with embedded JSON or
        # expose /api/ endpoints. We try a few heuristics.
        probe_urls = [
            "/portal-halal/v1/",
            "/api/halal/search",
            "/portal-halal/api/search",
        ]

        for url in probe_urls:
            try:
                params = {"q": product_name, "kategori": "produk_makanan"}
                soup = self.fetch_html(url, params=params)
                results = self._parse_halal_results(soup)
                if results:
                    return results
            except Exception as exc:
                logger.debug(f"Probe failed for {url}: {exc}")
                continue

        return []

    # -----------------------------------------------------------------------
    # RESULT PARSING
    # -----------------------------------------------------------------------
    def _parse_halal_results(self, soup: BeautifulSoup) -> List[Dict[str, Any]]:
        """
        Parse the MyeHalal results page (or any HTML containing certification data).
        Handles both table-based and card/div-based layouts.
        """
        results = []
        text_blob = soup.get_text(separator=" ", strip=True)

        # Heuristic: if the page explicitly says no results, return empty early
        if any(phrase in text_blob.lower() for phrase in [
            "tiada rekod", "no records", "no results found", "tiada hasil"
        ]):
            logger.info("[JAKIM] Page indicates no records found.")
            return results

        # --- Strategy A: Look for tables ---
        tables = soup.find_all("table")
        for table in tables:
            rows = table.find_all("tr")
            for row in rows:
                cells = row.find_all(["td", "th"])
                if len(cells) < 3:
                    continue
                parsed = self._extract_result_from_cells(cells)
                if parsed:
                    results.append(parsed)

        # --- Strategy B: Look for div/card patterns (common in SPAs) ---
        if not results:
            cards = soup.find_all("div", class_=re.compile(r"card|item|row|result|list"))
            for card in cards:
                # Extract text lines
                lines = [line.strip() for line in card.stripped_strings if len(line.strip()) > 2]
                if len(lines) >= 3:
                    parsed = self._extract_result_from_text_lines(lines)
                    if parsed:
                        results.append(parsed)

        # --- Strategy C: Generic anchor-based extraction ---
        if not results:
            for a in soup.find_all("a", href=True):
                text = a.get_text(strip=True)
                if text and len(text) > 3:
                    parent = a.find_parent(["div", "tr", "li"])
                    if parent:
                        lines = [line.strip() for line in parent.stripped_strings if len(line.strip()) > 2]
                        parsed = self._extract_result_from_text_lines(lines)
                        if parsed:
                            results.append(parsed)

        logger.info(f"[JAKIM] Parsed {len(results)} certification records.")
        return results

    def _extract_result_from_cells(self, cells: List[Tag]) -> Optional[Dict[str, Any]]:
        """Try to extract a structured result from a table row's cells."""
        texts = [c.get_text(strip=True) for c in cells if c.get_text(strip=True)]
        return self._extract_result_from_text_lines(texts)

    def _extract_result_from_text_lines(self, lines: List[str]) -> Optional[Dict[str, Any]]:
        """
        Heuristic text extraction from a list of strings.
        Looks for known Malay/English field indicators.
        """
        if not lines:
            return None

        record: Dict[str, Any] = {
            "premise_name": "",
            "company_name": "",
            "address": "",
            "city_state": "",
            "postcode": "",
            "expiry_date": "",
            "company_code": "",
        }

        has_any_field = False
        combined = " | ".join(lines)

        for line in lines:
            lower = line.lower()
            # Nama Premis / Premise Name
            if any(k in lower for k in ["nama premis", "premise name", "premis"]):
                record["premise_name"] = self._clean_label(line)
                has_any_field = True
            # Nama Syarikat / Company Name
            elif any(k in lower for k in ["nama syarikat", "company name", "syarikat"]):
                record["company_name"] = self._clean_label(line)
                has_any_field = True
            # Alamat / Address
            elif any(k in lower for k in ["alamat", "address", "lot ", "jalan ", "no. ", "no "]):
                record["address"] = self._clean_label(line)
                has_any_field = True
            # Bandar & Negeri / City & State
            elif any(k in lower for k in ["bandar", "city", "negeri", "state", "wilayah", "selangor", "johor", "penang", "perak", "kedah", "kelantan", "terengganu", "pahang", "negeri sembilan", "melaka", "sabah", "sarawak", "kuala lumpur", "putrajaya", "labuan"]):
                # If it looks like a city/state line (short, contains known state)
                if len(line) < 80:
                    record["city_state"] = self._clean_label(line)
                    has_any_field = True
            # Poskod / Postcode
            elif any(k in lower for k in ["poskod", "postcode", "postal"]):
                record["postcode"] = self._clean_label(line)
                has_any_field = True
            # Tarikh Luput / Expiry Date
            elif any(k in lower for k in ["tarikh luput", "expiry date", "luput", "expiry"]):
                record["expiry_date"] = self._clean_label(line)
                has_any_field = True
            # Kod Syarikat / Company Code
            elif any(k in lower for k in ["kod syarikat", "company code", "comp-"]):
                record["company_code"] = self._clean_label(line)
                has_any_field = True
            elif "COMP-" in line.upper():
                record["company_code"] = line.strip()
                has_any_field = True

        # Fallback: if we have a date pattern but no explicit label
        if not record["expiry_date"]:
            date_match = re.search(r"\d{2}[/-]\d{2}[/-]\d{4}", combined)
            if date_match:
                record["expiry_date"] = date_match.group()
                has_any_field = True

        # Fallback: if we have a COMP code but no explicit label
        if not record["company_code"]:
            comp_match = re.search(r"COMP-\d{8}-\d{6}", combined, re.IGNORECASE)
            if comp_match:
                record["company_code"] = comp_match.group().upper()
                has_any_field = True

        return record if has_any_field else None

    @staticmethod
    def _clean_label(line: str) -> str:
        """Remove common label prefixes like 'Nama Premis :' from values."""
        cleaned = re.sub(r"^(Nama Premis|Premise Name|Nama Syarikat|Company Name|Alamat|Address|Bandar|City|Negeri|State|Poskod|Postcode|Tarikh Luput|Expiry Date|Kod Syarikat|Company Code)\s*[:\-]\s*", "", line, flags=re.IGNORECASE)
        return cleaned.strip()

    # -----------------------------------------------------------------------
    # PUBLIC API
    # -----------------------------------------------------------------------
    async def search_halal(self, product_name: str) -> Optional[Dict[str, Any]]:
        """
        Search JAKIM MyeHalal for a product/premise and return certification status.

        Returns:
            A dict with certification status and details, or None if not found.
        """
        if not product_name or not product_name.strip():
            raise ValueError("product_name cannot be empty")

        product_name = product_name.strip()
        logger.info(f"[JAKIM] Searching halal status for: {product_name}")

        # --- Primary: Playwright stealth (expected to work) ---
        results = []
        try:
            results = await self._search_halal_stealth(product_name)
        except Exception as exc:
            logger.warning(f"[JAKIM] Stealth search failed: {exc}")

        # --- Fallback: requests (unlikely to work but cheap to try) ---
        if not results:
            try:
                results = self._search_halal_requests(product_name)
            except Exception as exc:
                logger.warning(f"[JAKIM] requests fallback also failed: {exc}")

        if not results:
            logger.info(f"[JAKIM] No certification records found for '{product_name}'.")
            return None

        # Filter: keep only results that actually match the query (fuzzy)
        filtered = self._filter_by_relevance(product_name, results)
        if not filtered:
            filtered = results  # fallback to all if strict filter empties

        return {
            "product_name": product_name,
            "certified": len(filtered) > 0,
            "source": f"{MYEHALAL_BASE}/portal-halal/v1/",
            "certifications": filtered,
        }

    def _filter_by_relevance(
        self, query: str, results: List[Dict[str, Any]]
    ) -> List[Dict[str, Any]]:
        """
        Fuzzy filter: keep records where premise_name or company_name
        contains words from the query.
        """
        query_words = set(_normalize(query).split())
        filtered = []
        for r in results:
            texts = " ".join([
                r.get("premise_name", ""),
                r.get("company_name", ""),
            ])
            text_set = set(_normalize(texts).split())
            if any(w in text_set for w in query_words):
                filtered.append(r)
        return filtered
