# Modern Python Template

A modern Python project template with best practices, featuring Python 3.11+, UV package manager, Ruff for linting/formatting, and pytest for testing.

## Features

- **Python 3.11+** with modern type annotations
- **UV** for fast dependency management
- **Ruff** for linting and formatting
- **pytest** for testing with coverage
- **Pydantic** for data validation
- **Click** for CLI interface
- **Rich** for beautiful terminal output
- **Pre-commit** hooks for code quality
- **PEP 621** compliant `pyproject.toml`
- **Comprehensive Makefile** for development tasks

## Quick Start

### Prerequisites

- Python 3.11+
- [UV](https://github.com/astral-sh/uv) package manager

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/modern-python-template.git
cd modern-python-template

# Setup development environment
make setup-dev

# Or manually:
uv sync --all-extras
uv run pre-commit install
```

### Usage

```bash
# Run the CLI
uv run modern-python-template --help

# Basic greeting
uv run modern-python-template hello Alice

# Run demo
uv run modern-python-template demo

# Process JSON data
uv run modern-python-template process data.json --stats
```

## Development

### Common Tasks

```bash
# Install dependencies
make install-dev

# Run tests
make test

# Run tests with coverage
make test-cov

# Lint code
make lint

# Format code
make format

# Run all checks
make check

# Build package
make build

# Clean build artifacts
make clean
```

### Project Structure

```
modern-python-template/
├── src/
│   └── modern_python_template/
│       ├── __init__.py
│       ├── core.py          # Core functionality
│       └── cli.py           # Command line interface
├── tests/
│   ├── conftest.py          # Test configuration
│   ├── test_core.py         # Core tests
│   └── test_cli.py          # CLI tests
├── docs/                    # Documentation
├── pyproject.toml           # Project configuration (PEP 621)
├── Makefile                 # Development tasks
├── README.md               # This file
└── .pre-commit-config.yaml # Pre-commit configuration
```

### Testing

```bash
# Run all tests
make test

# Run with coverage
make test-cov

# Run specific test types
make test-unit
make test-integration
make test-slow
```

### Code Quality

This project uses:

- **Ruff** for linting and formatting
- **MyPy** for type checking
- **Pre-commit** hooks for automated checks

```bash
# Run linting
make lint

# Auto-fix linting issues
make lint-fix

# Format code
make format

# Type checking
make type-check

# Run all checks
make check
```

### Configuration

The project is configured through `pyproject.toml`:

- **Build system**: Hatchling
- **Dependencies**: Managed by UV
- **Ruff**: Linting and formatting configuration
- **pytest**: Test configuration with coverage
- **MyPy**: Type checking configuration

## API Reference

### Core Functions

```python
from modern_python_template import greet, process_data

# Simple greeting
message = greet("World")

# Process data with validation
data = [{"name": "item", "value": 42}]
processed = process_data(data)
```

### CLI Commands

```bash
# Available commands
modern-python-template --help

# Commands:
#   hello    - Say hello to someone
#   process  - Process data from JSON file
#   demo     - Run demonstration
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`make test`)
5. Run code quality checks (`make check`)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Development Setup

```bash
# Setup development environment
make setup-dev

# This will:
# - Install all dependencies including dev dependencies
# - Install pre-commit hooks
# - Prepare the development environment
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [UV](https://github.com/astral-sh/uv) for fast Python packaging
- [Ruff](https://github.com/astral-sh/ruff) for excellent linting and formatting
- [pytest](https://docs.pytest.org/) for testing framework
- [Pydantic](https://docs.pydantic.dev/) for data validation
- [Click](https://click.palletsprojects.com/) for CLI interface
- [Rich](https://rich.readthedocs.io/) for beautiful terminal output
