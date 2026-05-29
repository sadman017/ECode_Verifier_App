"""
Base Scraper Module

Provides shared utilities for all scrapers:
- User-Agent rotation (desktop & mobile)
- Retry logic with exponential backoff
- requests.Session management
- Playwright stealth fallback for JS-rendered or protected pages
"""

import random
import logging
import asyncio
from typing import Optional, Dict, Any
from urllib.parse import urljoin

import requests
from bs4 import BeautifulSoup
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type

# Playwright imports (stealth mode for bot protection bypass)
from playwright.async_api import async_playwright, Page, Browser
from playwright_stealth import stealth_async

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# USER-AGENT ROTATION POOL
# ---------------------------------------------------------------------------
# A diverse pool of realistic User-Agent strings to avoid fingerprinting.
# Rotated randomly per request.
USER_AGENTS = [
    # Windows - Chrome
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    # Windows - Firefox
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:125.0) Gecko/20100101 Firefox/125.0",
    # Windows - Edge
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.2478.51",
    # macOS - Safari
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Safari/605.1.15",
    # macOS - Chrome
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    # Linux - Chrome
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    # Android - Chrome
    "Mozilla/5.0 (Linux; Android 14; SM-S928B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36",
    # Android - Samsung Internet
    "Mozilla/5.0 (Linux; Android 14; SM-S928B) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/24.0 Chrome/120.0.0.0 Mobile Safari/537.36",
    # iOS - Safari
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/15E148 Safari/604.1",
    # iOS - Chrome
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/124.0.6367.71 Mobile/15E148 Safari/604.1",
]


def get_random_user_agent() -> str:
    """Return a random User-Agent string from the rotation pool."""
    return random.choice(USER_AGENTS)


# ---------------------------------------------------------------------------
# BASE SCRAPER CLASS
# ---------------------------------------------------------------------------
class BaseScraper:
    """
    Base scraper providing HTTP requests with UA rotation, retries,
    and a Playwright stealth fallback for JavaScript-heavy or protected sites.
    """

    def __init__(self, base_url: str, timeout: int = 30):
        self.base_url = base_url.rstrip("/")
        self.timeout = timeout
        self.session = requests.Session()
        # Default headers to look like a real browser
        self.session.headers.update({
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
            "Accept-Language": "en-US,en;q=0.9,ms;q=0.8",
            "Accept-Encoding": "gzip, deflate, br",
            "DNT": "1",
            "Connection": "keep-alive",
            "Upgrade-Insecure-Requests": "1",
            "Sec-Fetch-Dest": "document",
            "Sec-Fetch-Mode": "navigate",
            "Sec-Fetch-Site": "none",
            "Sec-Fetch-User": "?1",
        })

    def _rotate_ua(self) -> None:
        """Assign a new random User-Agent to the session."""
        ua = get_random_user_agent()
        self.session.headers["User-Agent"] = ua
        logger.debug(f"Rotated User-Agent: {ua[:60]}...")

    # -----------------------------------------------------------------------
    # REQUESTS-BASED FETCHING (with retries)
    # -----------------------------------------------------------------------
    @retry(
        stop=stop_after_attempt(3),
        wait=wait_exponential(multiplier=2, min=2, max=10),
        retry=retry_if_exception_type((requests.RequestException,)),
        reraise=True,
    )
    def fetch_html(self, url: str, params: Optional[Dict[str, Any]] = None) -> BeautifulSoup:
        """
        Fetch HTML content using requests with retries and UA rotation.
        Returns a BeautifulSoup parsed object.

        Raises:
            requests.HTTPError: On 4xx/5xx responses after retries.
            requests.RequestException: On network failures after retries.
        """
        self._rotate_ua()
        full_url = urljoin(self.base_url, url)
        logger.info(f"Fetching (requests): {full_url}")

        response = self.session.get(full_url, params=params, timeout=self.timeout)
        response.raise_for_status()

        # Simple bot-check heuristic: if response contains common anti-bot phrases
        lower_text = response.text.lower()
        if any(phrase in lower_text for phrase in ["access denied", "blocked", "captcha", "ddos protection"]):
            logger.warning("Anti-bot page detected via heuristic — will fallback to Playwright.")
            raise requests.HTTPError("Anti-bot protection triggered", response=response)

        return BeautifulSoup(response.content, "lxml")

    def fetch_html_post(self, url: str, data: Optional[Dict[str, Any]] = None) -> BeautifulSoup:
        """
        Fetch HTML via POST request (for form submissions).
        Same retry/UA logic as fetch_html.
        """
        self._rotate_ua()
        full_url = urljoin(self.base_url, url)
        logger.info(f"Posting (requests): {full_url}")

        response = self.session.post(full_url, data=data, timeout=self.timeout)
        response.raise_for_status()
        return BeautifulSoup(response.content, "lxml")

    # -----------------------------------------------------------------------
    # PLAYWRIGHT STEALTH FALLBACK
    # -----------------------------------------------------------------------
    async def fetch_html_stealth(
        self,
        url: str,
        wait_selector: Optional[str] = None,
        wait_for_timeout: int = 5000,
        interact_callback=None,
    ) -> BeautifulSoup:
        """
        Fetch HTML using Playwright with stealth mode enabled.
        This bypasses basic bot protections by masking automation indicators.

        Args:
            url: The URL to navigate to.
            wait_selector: A CSS selector to wait for before extracting HTML.
            wait_for_timeout: Max time (ms) to wait for selector.
            interact_callback: Optional async callable(page) to interact with the page
                             (fill forms, click buttons, etc.) before extraction.

        Returns:
            BeautifulSoup parsed object of the final page HTML.
        """
        full_url = urljoin(self.base_url, url)
        logger.info(f"Fetching (Playwright stealth): {full_url}")

        async with async_playwright() as p:
            # Launch Chromium with anti-detection flags
            browser = await p.chromium.launch(
                headless=True,
                args=[
                    "--disable-blink-features=AutomationControlled",
                    "--no-sandbox",
                    "--disable-dev-shm-usage",
                    "--disable-gpu",
                ],
            )

            async with browser:
                context = await browser.new_context(
                    viewport={"width": 1920, "height": 1080},
                    user_agent=get_random_user_agent(),
                    locale="en-US",
                    timezone_id="Asia/Kuala_Lumpur",
                )

                page = await context.new_page()

                # Apply playwright-stealth to mask navigator.webdriver, plugins, etc.
                await stealth_async(page)

                # Navigate with a realistic wait
                await page.goto(full_url, wait_until="networkidle", timeout=60000)

                # Optional human-like delay
                await asyncio.sleep(random.uniform(1.5, 3.5))

                # Run custom interactions (form fill, clicks) if provided
                if interact_callback:
                    await interact_callback(page)
                    await asyncio.sleep(random.uniform(1.0, 2.5))

                # Wait for a specific element to ensure JS has rendered content
                if wait_selector:
                    try:
                        await page.wait_for_selector(wait_selector, timeout=wait_for_timeout)
                    except Exception as e:
                        logger.warning(f"Selector '{wait_selector}' not found within timeout: {e}")

                html = await page.content()

        return BeautifulSoup(html, "lxml")

    # -----------------------------------------------------------------------
    # CONVENIENCE: TRY REQUESTS FIRST, FALLBACK TO PLAYWRIGHT
    # -----------------------------------------------------------------------
    async def fetch_html_smart(
        self,
        url: str,
        params: Optional[Dict[str, Any]] = None,
        wait_selector: Optional[str] = None,
        interact_callback=None,
    ) -> BeautifulSoup:
        """
        Intelligent fetch: try requests first (fast), fallback to Playwright stealth
        if blocked or on failure.

        Returns:
            BeautifulSoup parsed object.

        Raises:
            Exception: If both methods fail.
        """
        try:
            # Try lightweight requests first
            if params:
                # Build full URL with query string for logging
                from urllib.parse import urlencode
                query = urlencode(params)
                sep = "&" if "?" in url else "?"
                return self.fetch_html(f"{url}{sep}{query}")
            return self.fetch_html(url)
        except Exception as exc:
            logger.warning(f"requests method failed ({exc}), falling back to Playwright stealth.")
            # Fallback to Playwright
            built_url = url
            if params:
                from urllib.parse import urlencode
                query = urlencode(params)
                sep = "&" if "?" in url else "?"
                built_url = f"{url}{sep}{query}"
            return await self.fetch_html_stealth(
                built_url,
                wait_selector=wait_selector,
                interact_callback=interact_callback,
            )
