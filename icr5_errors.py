"""Shared exceptions for the IC-R5 tools."""


class ICR5Error(RuntimeError):
    """Communication, image, or CSV validation failure."""
