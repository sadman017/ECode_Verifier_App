# 🇲🇾 Malaysian Scraper API

An unofficial FastAPI-based wrapper to scrape data from Malaysian government databases that do not expose public APIs:

| Endpoint | Source | Data |
|----------|--------|------|
| `GET /api/nutrition?food_name=...` | [MyFCD](https://myfcd.moh.gov.my) | Food macronutrients (Energy, Protein, Fat, Carbs, etc.) per 100g |
| `GET /api/halal?product_name=...` | [JAKIM MyeHalal](https://myehalal.halal.gov.my) | Halal certification status & expiry details |

## Features

- **Dual scraping strategy**: Lightweight `requests` + BeautifulSoup first; falls back to **Playwright with stealth mode** if the site blocks standard HTTP requests.
- **User-Agent rotation**: 10+ realistic desktop & mobile browser UAs rotated per request.
- **Retry logic**: Exponential backoff with `tenacity` (3 attempts).
- **Rate limiting**: 10 requests/minute per IP via `slowapi`.
- **Structured error handling**: Returns clear HTTP status codes (`400`, `404`, `429`, `503`, `500`).

## Project Structure

```
scraper_api/
├── main.py              # FastAPI app & routes
├── scrapers/
│   ├── __init__.py
│   ├── base.py          # BaseScraper (UA rotation, retries, Playwright stealth)
│   ├── myfcd.py         # MyFCD nutrition scraper
│   └── jakim.py         # JAKIM halal scraper
├── requirements.txt
└── README.md
```

## Setup

### 1. Clone / Navigate

```bash
cd scraper_api
```

### 2. Create a virtual environment (recommended)

```bash
python -m venv venv

# Linux/macOS
source venv/bin/activate

# Windows
venv\Scripts\activate
```

### 3. Install Python dependencies

```bash
pip install -r requirements.txt
```

### 4. Install Playwright browsers

The JAKIM scraper uses Playwright with stealth mode. You must download the browser binaries:

```bash
playwright install chromium
```

> If you are running in a Docker/container environment, you may also need system dependencies:
> ```bash
> playwright install-deps chromium
> ```

## Running the API

### Development (with auto-reload)

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Production

```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 2
```

> **Note:** Playwright is async but **not thread-safe** for the same browser instance. If scaling beyond 1-2 workers, consider running a single worker or using an external queue (e.g., Celery + Redis) for scraping tasks.

## API Documentation

Once running, interactive docs are available at:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Usage Examples

### Nutrition (MyFCD)

```bash
curl "http://localhost:8000/api/nutrition?food_name=Nasi%20Lemak"
```

**Example Response:**

```json
{
  "success": true,
  "data": {
    "food_name": "Nasi Lemak",
    "source": "https://myfcd.moh.gov.my/...",
    "matched_food_description": "Nasi lemak, with anchovies and peanuts",
    "ndb_no": "F001234",
    "food_group": "Prepared foods",
    "nutrients_per_100g": {
      "energy": 290,
      "protein": 6.2,
      "total_fat": 12.5,
      "carbohydrate": 38.0,
      "dietary_fiber": 2.1,
      "sugar": 1.5,
      "sodium": 520
    }
  }
}
```

### Halal Certification (JAKIM)

```bash
curl "http://localhost:8000/api/halal?product_name=Munchy%27s"
```

**Example Response:**

```json
{
  "success": true,
  "data": {
    "product_name": "Munchy's",
    "certified": true,
    "source": "https://myehalal.halal.gov.my/portal-halal/v1/",
    "certifications": [
      {
        "premise_name": "MUNCHY FOOD INDUSTRIES SDN BHD",
        "company_name": "MUNCHY FOOD INDUSTRIES SDN BHD",
        "address": "Lot 1, Jalan Kusta...",
        "city_state": "Johor Bahru, Johor",
        "postcode": "81100",
        "expiry_date": "31/12/2026",
        "company_code": "COMP-20190115-084732"
      }
    ]
  }
}
```

## Error Responses

| Status | Meaning | When |
|--------|---------|------|
| `400` | Bad Request | Missing or empty query parameter |
| `404` | Not Found | No matching record in the target database |
| `429` | Too Many Requests | Rate limit exceeded (10/min per IP) |
| `503` | Service Unavailable | Target government site is down or blocking requests |
| `500` | Internal Server Error | Unexpected application error |

## Scraping Strategies

### MyFCD (myfcd.moh.gov.my)
- **Primary**: `requests` + BeautifulSoup (server-side rendered Joomla site).
- **Fallback**: Playwright stealth if the site starts returning blocks.
- Searches the current food database listing, parses the results table, follows the detail link, and extracts the nutrient composition table.

### JAKIM MyeHalal (myehalal.halal.gov.my)
- **Primary**: Playwright stealth (modern JS SPA with SSL/TLS protections that block plain requests).
- **Fallback**: Direct HTTP probing for any exposed internal API endpoints.
- Navigates the portal, selects "Produk Makanan" category, fills the search form, submits, waits for results, and parses certification records.

## Important Notes

1. **Respectful Scraping**: These are government portals. The API includes rate limiting by default. Do not remove or bypass these limits.
2. **Fragile by Nature**: Scrapers depend on the current HTML/JS structure of third-party sites. If MyFCD or JAKIM redesigns their portals, the parsers may need updates.
3. **No Caching**: This implementation fetches live data on every request. For production use at scale, consider adding Redis caching (e.g., cache results for 24 hours).
4. **Not Official**: This is an unofficial community wrapper. It is not affiliated with or endorsed by MOH Malaysia or JAKIM.

## License

MIT License — use at your own risk.
# FASTAPI
It is a python FASTAPI from JAKIM to help people identify whether the food is halal, haram or mubah.
