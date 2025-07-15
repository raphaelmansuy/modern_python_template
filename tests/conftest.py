"""Test configuration and fixtures."""

import pytest
from modern_python_template.core import DataModel


@pytest.fixture
def sample_data():
    """Sample data for testing."""
    return [
        {"name": "Alpha", "value": 42, "tags": ["important", "first"]},
        {"name": "Beta", "value": 23.5, "tags": ["second"]},
        {"name": "Gamma", "value": 100, "tags": ["important", "large"]},
    ]


@pytest.fixture
def sample_data_models():
    """Sample DataModel instances for testing."""
    return [
        DataModel(name="Alpha", value=42, tags=["important", "first"]),
        DataModel(name="Beta", value=23.5, tags=["second"]),
        DataModel(name="Gamma", value=100, tags=["important", "large"]),
    ]


@pytest.fixture
def empty_data():
    """Empty data for testing."""
    return []
