"""Sphinx configuration file."""

# pylint: disable=redefined-builtin

import os
import sys

# Add project source directory to Python path
sys.path.insert(0, os.path.abspath("../../"))

project = "CI Templates Sphinx Example"
copyright = "2026"
author = "CI Templates"
release = "1.0.0"

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.napoleon",
    "sphinx.ext.viewcode",
    "sphinxcontrib.mermaid",
]

html_theme = "sphinx_book_theme"

autodoc_default_options = {
    "members": True,
    "undoc-members": True,
    "show-inheritance": True,
}
