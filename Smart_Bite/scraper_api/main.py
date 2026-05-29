"""
Malaysian Scraper API — FastAPI Entrypoint

Provides two public endpoints:
  GET /api/nutrition?food_name=...   -> Scrape food nutrition from MyFCD
  GET /api/halal?product_name=...    -> Scrape halal certification from JAKIM MyeHalal

Features:
  - Rate limiting (10 requests/minute per IP)
  - CORS enabled
  - Structured error handling
  - Async scraping with Playwright stealth fallback
  - Logging

Run locally:
    pip install -r requirements.txt
    playwright install
    uvicorn main:app --reload
"""

import logging
import sys
from contextlib import asynccontextmanager

from fastapi import FastAPI, Query, HTTPException, Request, status
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

from scrapers import MyFCDScraper, JakimHalalScraper

# ---------------------------------------------------------------------------
# LOGGING CONFIGURATION
# ---------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)-8s | %(name)s | %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)],
)
logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# RATE LIMITER
# ---------------------------------------------------------------------------
# In-memory rate limiting: 10 requests per minute per IP
limiter = Limiter(key_func=get_remote_address)

# ---------------------------------------------------------------------------
# LIFESPAN (startup/shutdown hooks)
# ---------------------------------------------------------------------------
@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan events."""
    logger.info("🚀 Malaysian Scraper API starting up...")
    yield
    logger.info("🛑 Malaysian Scraper API shutting down...")

# ---------------------------------------------------------------------------
# FASTAPI APP
# ---------------------------------------------------------------------------
app = FastAPI(
    title="Malaysian Scraper API",
    description=(
        "Unofficial API wrapper for Malaysian government databases:\n"
        "• MyFCD (Food Nutrition) — myfcd.moh.gov.my\n"
        "• JAKIM MyeHalal (Halal Certification) — halal.gov.my\n\n"
        "Built with FastAPI + Playwright stealth mode."
    ),
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

# Attach rate limiter to app state
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# CORS — allow all origins for public API usage
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------------------------------------------------------------------
# GLOBAL EXCEPTION HANDLER
# ---------------------------------------------------------------------------
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    """Catch-all exception handler to return JSON instead of plain text crashes."""
    logger.error(f"Unhandled exception at {request.url}: {exc}", exc_info=True)
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "detail": "An unexpected internal error occurred. Please try again later.",
            "error_type": type(exc).__name__,
        },
    )

# ---------------------------------------------------------------------------
# HEALTH CHECK
# ---------------------------------------------------------------------------
@app.get("/health", tags=["Health"], summary="Health check endpoint")
async def health_check():
    """Returns API health status."""
    return {"status": "ok", "service": "malaysian-scraper-api", "version": "1.0.0"}

# ---------------------------------------------------------------------------
# NUTRITION ENDPOINT (MyFCD)
# ---------------------------------------------------------------------------
@app.get(
    "/api/nutrition",
    tags=["Nutrition"],
    summary="Get food nutrition data from MyFCD",
    response_description="Macronutrient composition per 100g",
)
@limiter.limit("10/minute")
async def get_nutrition(
    request: Request,
    food_name: str = Query(
        ...,
        min_length=1,
        max_length=200,
        description="Name of the food item to search (e.g., 'Nasi Lemak', 'Roti Canai')",
    ),
):
    """
    Search the Malaysian Food Composition Database (MyFCD) for a food item
    and return its macronutrient data per 100g.

    **Query Parameters:**
    - `food_name` (required): The food name to look up.

    **Returns:**
    - `food_name`: The queried food name.
    - `source`: URL of the detail page scraped.
    - `matched_food_description`: Best-matching food description from the database.
    - `ndb_no`: Food database number (if available).
    - `food_group`: Classification group (e.g., 'Cereals and grain products').
    - `nutrients_per_100g`: Dictionary of macronutrients (energy_kcal, protein_g, etc.).
    """
    scraper = MyFCDScraper()
    try:
        result = await scraper.search_nutrition(food_name)
    except ValueError as ve:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(ve))
    except RuntimeError as re:
        logger.error(f"MyFCD scraper runtime error: {re}")
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="MyFCD website is unreachable or blocking requests. Please retry later.",
        )
    except Exception as exc:
        logger.error(f"Unexpected error in nutrition endpoint: {exc}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to fetch nutrition data due to an internal error.",
        )

    if result is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"No nutrition data found for '{food_name}' in MyFCD.",
        )

    return {
        "success": True,
        "data": result,
    }

# ---------------------------------------------------------------------------
# HALAL ENDPOINT (JAKIM MyeHalal)
# ---------------------------------------------------------------------------
@app.get(
    "/api/halal",
    tags=["Halal"],
    summary="Check JAKIM halal certification status",
    response_description="Halal certification details from JAKIM MyeHalal",
)
@limiter.limit("10/minute")
async def get_halal_status(
    request: Request,
    product_name: str = Query(
        ...,
        min_length=1,
        max_length=200,
        description="Name of the product, brand, or company to verify (e.g., 'Munchy\'s', 'BananaBro')",
    ),
):
    """
    Search the JAKIM MyeHalal portal to check if a product or premise
    is certified halal in Malaysia.

    **Query Parameters:**
    - `product_name` (required): The product/brand/company name to verify.

    **Returns:**
    - `product_name`: The queried product name.
    - `certified`: Boolean indicating if any active certification was found.
    - `source`: URL of the portal scraped.
    - `certifications`: List of matching certification records with premise name,
      company name, address, expiry date, and company code.
    """
    scraper = JakimHalalScraper()
    try:
        result = await scraper.search_halal(product_name)
    except ValueError as ve:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(ve))
    except RuntimeError as re:
        logger.error(f"JAKIM scraper runtime error: {re}")
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="JAKIM MyeHalal portal is unreachable or blocking requests. Please retry later.",
        )
    except Exception as exc:
        logger.error(f"Unexpected error in halal endpoint: {exc}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to fetch halal data due to an internal error.",
        )

    if result is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"No halal certification found for '{product_name}' in JAKIM MyeHalal.",
        )

    return {
        "success": True,
        "data": result,
    }

# ---------------------------------------------------------------------------
# ROOT / INFO
# ---------------------------------------------------------------------------
@app.get("/", tags=["Root"], include_in_schema=False)
async def root():
    """Redirect root to API docs."""
    return {
        "message": "Malaysian Scraper API is running.",
        "docs": "/docs",
        "endpoints": {
            "nutrition": "/api/nutrition?food_name=<name>",
            "halal": "/api/halal?product_name=<name>",
        },
    }

# ---------------------------------------------------------------------------
# MAIN (for direct execution)
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
