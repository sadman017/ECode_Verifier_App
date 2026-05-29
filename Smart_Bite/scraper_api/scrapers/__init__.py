"""
Malaysian Government Database Scrapers

This package contains scrapers for:
- MyFCD (Food Composition Database)
- JAKIM MyeHalal (Halal Certification Directory)
"""

from .myfcd import MyFCDScraper
from .jakim import JakimHalalScraper

__all__ = ["MyFCDScraper", "JakimHalalScraper"]
