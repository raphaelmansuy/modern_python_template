#!/usr/bin/env bash

# Setup script for modern Python template
# This script sets up the development environment

set -e

echo "🚀 Setting up Modern Python Template..."

# Check if UV is installed
if ! command -v uv &> /dev/null; then
    echo "❌ UV is not installed. Please install UV first:"
    echo "   curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

echo "✅ UV is installed"

# Check Python version
if ! python3 --version | grep -q "3.1[1-9]"; then
    echo "⚠️  Python 3.11+ is recommended for this template"
fi

# Install dependencies
echo "📦 Installing dependencies..."
uv sync --all-extras

# Install pre-commit hooks
echo "🔧 Installing pre-commit hooks..."
uv run pre-commit install

# Run initial checks
echo "🔍 Running initial checks..."
uv run ruff check .
uv run pytest --tb=short

echo "✅ Setup complete!"
echo ""
echo "🎉 Your modern Python template is ready!"
echo ""
echo "Next steps:"
echo "  • Run 'make help' to see available commands"
echo "  • Run 'make test' to run tests"
echo "  • Run 'make demo' to see the template in action"
echo "  • Edit src/modern_python_template/ to customize your project"
echo ""
echo "Happy coding! 🐍"
