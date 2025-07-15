"""Tests for the core module."""

import pytest
from pydantic import ValidationError

from modern_python_template.core import (
    DataModel,
    calculate_statistics,
    greet,
    process_data,
)


class TestDataModel:
    """Tests for the DataModel class."""

    def test_valid_data_model(self):
        """Test creating a valid DataModel."""
        model = DataModel(name="Test", value=42.5, tags=["tag1", "tag2"])
        assert model.name == "Test"
        assert model.value == 42.5
        assert model.tags == ["tag1", "tag2"]
        assert model.metadata is None

    def test_data_model_with_metadata(self):
        """Test creating a DataModel with metadata."""
        metadata = {"key": "value", "number": 123}
        model = DataModel(name="Test", value=42, metadata=metadata)
        assert model.metadata == metadata

    def test_data_model_validation_empty_name(self):
        """Test that empty name raises ValidationError."""
        with pytest.raises(ValidationError):
            DataModel(name="", value=42)

    def test_data_model_validation_negative_value(self):
        """Test that negative value raises ValidationError."""
        with pytest.raises(ValidationError):
            DataModel(name="Test", value=-1)

    def test_data_model_validation_zero_value(self):
        """Test that zero value raises ValidationError."""
        with pytest.raises(ValidationError):
            DataModel(name="Test", value=0)

    def test_data_model_str_representation(self):
        """Test string representation of DataModel."""
        model = DataModel(name="Test", value=42)
        assert str(model) == "DataModel(name='Test', value=42)"

    def test_data_model_whitespace_stripping(self):
        """Test that whitespace is stripped from name."""
        model = DataModel(name="  Test  ", value=42)
        assert model.name == "Test"


class TestGreet:
    """Tests for the greet function."""

    def test_greet_with_name(self):
        """Test greeting with a specific name."""
        result = greet("Alice")
        assert result == "Hello, Alice!"

    def test_greet_default(self):
        """Test greeting with default name."""
        result = greet()
        assert result == "Hello, World!"

    def test_greet_empty_string(self):
        """Test greeting with empty string."""
        result = greet("")
        assert result == "Hello, World!"

    def test_greet_whitespace_only(self):
        """Test greeting with whitespace only."""
        result = greet("   ")
        assert result == "Hello, World!"

    def test_greet_with_whitespace(self):
        """Test greeting with name containing whitespace."""
        result = greet("  Alice  ")
        assert result == "Hello, Alice!"


class TestProcessData:
    """Tests for the process_data function."""

    def test_process_data_valid(self, sample_data):
        """Test processing valid data."""
        result = process_data(sample_data)
        assert len(result) == 3
        assert all(isinstance(item, DataModel) for item in result)
        assert result[0].name == "Alpha"
        assert result[1].value == 23.5
        assert result[2].tags == ["important", "large"]

    def test_process_data_empty_list(self):
        """Test that empty list raises ValueError."""
        with pytest.raises(ValueError, match="Data cannot be empty"):
            process_data([])

    def test_process_data_invalid_item(self):
        """Test that invalid item raises ValidationError."""
        invalid_data = [{"name": "Test", "value": -1}]  # negative value
        with pytest.raises(ValidationError):
            process_data(invalid_data)

    def test_process_data_mixed_types(self):
        """Test processing data with mixed value types."""
        mixed_data = [
            {"name": "Int", "value": 42},
            {"name": "Float", "value": 3.14},
        ]
        result = process_data(mixed_data)
        assert len(result) == 2
        assert result[0].value == 42
        assert result[1].value == 3.14

    def test_process_data_with_metadata(self):
        """Test processing data with metadata."""
        data_with_metadata = [
            {
                "name": "Test",
                "value": 42,
                "metadata": {"category": "test", "priority": 1},
            }
        ]
        result = process_data(data_with_metadata)
        assert len(result) == 1
        assert result[0].metadata == {"category": "test", "priority": 1}


class TestCalculateStatistics:
    """Tests for the calculate_statistics function."""

    def test_calculate_statistics_valid_data(self, sample_data_models):
        """Test calculating statistics with valid data."""
        stats = calculate_statistics(sample_data_models)
        
        assert stats["count"] == 3
        assert stats["total"] == 165.5
        assert stats["average"] == pytest.approx(55.16666666666667, rel=1e-9)
        assert stats["min"] == 23.5
        assert stats["max"] == 100

    def test_calculate_statistics_empty_data(self):
        """Test calculating statistics with empty data."""
        stats = calculate_statistics([])

        expected_stats = {
            "count": 0,
            "total": 0,
            "average": 0,
            "min": 0,
            "max": 0,
        }

        assert stats == expected_stats

    def test_calculate_statistics_single_item(self):
        """Test calculating statistics with single item."""
        single_item = [DataModel(name="Single", value=42)]
        stats = calculate_statistics(single_item)

        expected_stats = {
            "count": 1,
            "total": 42,
            "average": 42,
            "min": 42,
            "max": 42,
        }

        assert stats == expected_stats
