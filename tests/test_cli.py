"""Tests for the CLI module."""

import json
import tempfile
from pathlib import Path

from click.testing import CliRunner

from modern_python_template.cli import cli


class TestCLI:
    """Tests for the CLI functionality."""

    def test_cli_hello_default(self) -> None:
        """Test hello command with default name."""
        runner = CliRunner()
        result = runner.invoke(cli, ["hello"])
        assert result.exit_code == 0
        assert "Hello, World!" in result.output

    def test_cli_hello_with_name(self) -> None:
        """Test hello command with specific name."""
        runner = CliRunner()
        result = runner.invoke(cli, ["hello", "Alice"])
        assert result.exit_code == 0
        assert "Hello, Alice!" in result.output

    def test_cli_demo(self) -> None:
        """Test demo command."""
        runner = CliRunner()
        result = runner.invoke(cli, ["demo"])
        assert result.exit_code == 0
        assert "Modern Python Template Demo" in result.output
        assert "Statistics:" in result.output

    def test_cli_process_valid_file(self) -> None:
        """Test process command with valid file."""
        sample_data = [
            {"name": "Alpha", "value": 42, "tags": ["important"]},
            {"name": "Beta", "value": 23.5, "tags": ["second"]},
        ]

        with tempfile.NamedTemporaryFile(mode="w", suffix=".json", delete=False) as f:
            json.dump(sample_data, f)
            temp_path = Path(f.name)

        try:
            runner = CliRunner()
            result = runner.invoke(cli, ["process", str(temp_path)])
            assert result.exit_code == 0
            assert "Processed 2 items" in result.output
        finally:
            temp_path.unlink()

    def test_cli_process_with_stats(self) -> None:
        """Test process command with statistics."""
        sample_data = [
            {"name": "Alpha", "value": 42},
            {"name": "Beta", "value": 23.5},
        ]

        with tempfile.NamedTemporaryFile(mode="w", suffix=".json", delete=False) as f:
            json.dump(sample_data, f)
            temp_path = Path(f.name)

        try:
            runner = CliRunner()
            result = runner.invoke(cli, ["process", str(temp_path), "--stats"])
            assert result.exit_code == 0
            assert "Statistics:" in result.output
            assert "count: 2" in result.output
        finally:
            temp_path.unlink()

    def test_cli_process_with_output(self) -> None:
        """Test process command with output file."""
        sample_data = [
            {"name": "Alpha", "value": 42},
        ]

        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".json", delete=False
        ) as input_file:
            json.dump(sample_data, input_file)
            input_path = Path(input_file.name)

        with tempfile.NamedTemporaryFile(suffix=".json", delete=False) as output_file:
            output_path = Path(output_file.name)

        try:
            runner = CliRunner()
            result = runner.invoke(
                cli, ["process", str(input_path), "--output", str(output_path)]
            )
            assert result.exit_code == 0
            assert "Results saved to" in result.output
            assert str(output_path) in result.output

            # Check that output file was created and contains expected data
            with output_path.open() as f:
                output_data = json.load(f)
            assert len(output_data) == 1
            assert output_data[0]["name"] == "Alpha"
            assert output_data[0]["value"] == 42
        finally:
            input_path.unlink()
            if output_path.exists():
                output_path.unlink()

    def test_cli_process_nonexistent_file(self) -> None:
        """Test process command with non-existent file."""
        runner = CliRunner()
        result = runner.invoke(cli, ["process", "nonexistent.json"])
        assert result.exit_code != 0

    def test_cli_process_invalid_json(self) -> None:
        """Test process command with invalid JSON."""
        with tempfile.NamedTemporaryFile(mode="w", suffix=".json", delete=False) as f:
            f.write("invalid json")
            temp_path = Path(f.name)

        try:
            runner = CliRunner()
            result = runner.invoke(cli, ["process", str(temp_path)])
            assert result.exit_code != 0
            assert "Error:" in result.output
        finally:
            temp_path.unlink()

    def test_cli_process_invalid_data_format(self) -> None:
        """Test process command with invalid data format."""
        invalid_data = {"not": "a list"}

        with tempfile.NamedTemporaryFile(mode="w", suffix=".json", delete=False) as f:
            json.dump(invalid_data, f)
            temp_path = Path(f.name)

        try:
            runner = CliRunner()
            result = runner.invoke(cli, ["process", str(temp_path)])
            assert result.exit_code != 0
            assert "Input data must be a list" in result.output
        finally:
            temp_path.unlink()

    def test_cli_version(self) -> None:
        """Test version option."""
        runner = CliRunner()
        result = runner.invoke(cli, ["--version"])
        assert result.exit_code == 0
        assert "version" in result.output.lower()

    def test_cli_help(self) -> None:
        """Test help option."""
        runner = CliRunner()
        result = runner.invoke(cli, ["--help"])
        assert result.exit_code == 0
        assert "Modern Python Template CLI" in result.output
