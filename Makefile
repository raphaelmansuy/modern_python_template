# Modern Python Template Makefile
# Requires: uv, make

.PHONY: help install install-dev test test-cov lint format check clean build docs serve-docs pre-commit setup-dev

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Setup and Installation
install: ## Install project dependencies
	uv sync --no-dev

install-dev: ## Install project with development dependencies
	uv sync --all-extras

setup-dev: install-dev ## Setup development environment
	uv run pre-commit install
	@echo "Development environment is ready!"

# Testing
test: ## Run tests
	uv run pytest

test-cov: ## Run tests with coverage report
	uv run pytest --cov=modern_python_template --cov-report=term-missing --cov-report=html

test-fast: ## Run tests without coverage
	uv run pytest --no-cov -x

test-slow: ## Run all tests including slow ones
	uv run pytest -m "not slow"

test-integration: ## Run integration tests only
	uv run pytest -m integration

test-unit: ## Run unit tests only
	uv run pytest -m unit

# Code Quality
lint: ## Run linting with ruff
	uv run ruff check .

lint-fix: ## Run linting with automatic fixes
	uv run ruff check --fix .

format: ## Format code with ruff
	uv run ruff format .

format-check: ## Check code formatting
	uv run ruff format --check .

type-check: ## Run type checking with mypy
	uv run mypy src/

check: lint format-check type-check ## Run all code quality checks

# Pre-commit
pre-commit: ## Run pre-commit hooks on all files
	uv run pre-commit run --all-files

pre-commit-install: ## Install pre-commit hooks
	uv run pre-commit install

# Documentation
docs: ## Build documentation
	uv run mkdocs build

docs-serve: ## Serve documentation locally
	uv run mkdocs serve

docs-deploy: ## Deploy documentation to GitHub Pages
	uv run mkdocs gh-deploy

# Build and Release
build: clean ## Build the package
	uv build

clean: ## Clean build artifacts
	rm -rf build/
	rm -rf dist/
	rm -rf src/*.egg-info/
	rm -rf .pytest_cache/
	rm -rf .coverage
	rm -rf htmlcov/
	rm -rf .mypy_cache/
	rm -rf .ruff_cache/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

# Development helpers
dev-deps: ## Show development dependencies
	uv tree --dev

update: ## Update all dependencies
	uv sync --upgrade

lock: ## Generate lock file
	uv lock

# Docker (if using containers)
docker-build: ## Build Docker image
	docker build -t modern-python-template .

docker-run: ## Run Docker container
	docker run -it --rm modern-python-template

# Git helpers
git-clean: ## Clean git repository
	git clean -fd
	git reset --hard HEAD

# CI/CD helpers
ci-test: ## Run CI tests
	uv run pytest --cov=modern_python_template --cov-report=xml --cov-report=term

ci-check: ## Run CI checks
	uv run ruff check .
	uv run ruff format --check .
	uv run mypy src/

# Environment info
env-info: ## Show environment information
	@echo "Python version: $(shell python --version)"
	@echo "UV version: $(shell uv --version)"
	@echo "Current directory: $(shell pwd)"
	@echo "Virtual environment: $(shell echo $$VIRTUAL_ENV)"

# Quick development cycle
dev: install-dev lint test ## Quick development cycle: install, lint, test

# Production readiness check
prod-check: check test-cov build ## Production readiness check

# Help for specific targets
help-test: ## Show testing help
	@echo "Testing targets:"
	@echo "  test        - Run all tests"
	@echo "  test-cov    - Run tests with coverage"
	@echo "  test-fast   - Run tests without coverage"
	@echo "  test-slow   - Run including slow tests"
	@echo "  test-unit   - Run unit tests only"
	@echo "  test-integration - Run integration tests only"

help-lint: ## Show linting help
	@echo "Linting targets:"
	@echo "  lint        - Run linting"
	@echo "  lint-fix    - Run linting with fixes"
	@echo "  format      - Format code"
	@echo "  format-check - Check formatting"
	@echo "  type-check  - Run type checking"
	@echo "  check       - Run all checks"
