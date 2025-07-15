# Modern Python Template Makefile
# Requires: uv, make

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
WHITE := \033[0;37m
BOLD := \033[1m
RESET := \033[0m

.PHONY: help install install-dev test test-cov lint format check clean build docs serve-docs pre-commit setup-dev

# Default target
help: ## Show this help message
	@echo "$(BOLD)$(BLUE)🐍 Modern Python Template - Available Commands$(RESET)"
	@echo ""
	@echo "$(BOLD)$(CYAN)📦 Setup & Installation:$(RESET)"
	@awk 'BEGIN {FS = ":.*?## "} /^(install|setup).*:.*?## / {printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BOLD)$(CYAN)🧪 Testing:$(RESET)"
	@awk 'BEGIN {FS = ":.*?## "} /^test.*:.*?## / {printf "  $(YELLOW)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BOLD)$(CYAN)✨ Code Quality:$(RESET)"
	@awk 'BEGIN {FS = ":.*?## "} /^(lint|format|check|type).*:.*?## / {printf "  $(PURPLE)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BOLD)$(CYAN)📚 Documentation:$(RESET)"
	@awk 'BEGIN {FS = ":.*?## "} /^docs.*:.*?## / {printf "  $(CYAN)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BOLD)$(CYAN)🚀 Build & Deploy:$(RESET)"
	@awk 'BEGIN {FS = ":.*?## "} /^(build|clean|docker).*:.*?## / {printf "  $(RED)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BOLD)$(CYAN)🛠️  Development:$(RESET)"
	@awk 'BEGIN {FS = ":.*?## "} /^(dev|pre-commit|env|git).*:.*?## / {printf "  $(WHITE)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BOLD)$(CYAN)⚡ Simple Commands:$(RESET)"
	@awk 'BEGIN {FS = ":.*?## "} /^(init|run|hello|go|fix|up|info|deps|ready|start|work|ship).*:.*?## / {printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BOLD)$(CYAN)🔤 Single Letter:$(RESET)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-z]:.*?## / {printf "  $(YELLOW)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BOLD)$(BLUE)💡 Usage: $(GREEN)make <target>$(RESET)"
	@echo "$(BOLD)$(BLUE)💡 Quick start: $(GREEN)make init$(RESET) or $(GREEN)make start$(RESET)"

# Setup and Installation
install: ## Install project dependencies
	@echo "$(BOLD)$(BLUE)📦 Installing project dependencies...$(RESET)"
	@uv sync --no-dev
	@echo "$(GREEN)✅ Dependencies installed successfully!$(RESET)"

install-dev: ## Install project with development dependencies
	@echo "$(BOLD)$(BLUE)📦 Installing development dependencies...$(RESET)"
	@uv sync --all-extras
	@echo "$(GREEN)✅ Development dependencies installed successfully!$(RESET)"

setup-dev: install-dev ## Setup development environment
	@echo "$(BOLD)$(BLUE)🔧 Setting up development environment...$(RESET)"
	@uv run pre-commit install
	@echo "$(GREEN)✅ Development environment is ready!$(RESET)"

# Testing
test: ## Run tests
	@echo "$(BOLD)$(YELLOW)🧪 Running tests...$(RESET)"
	@uv run pytest
	@echo "$(GREEN)✅ Tests completed!$(RESET)"

test-cov: ## Run tests with coverage report
	@echo "$(BOLD)$(YELLOW)🧪 Running tests with coverage...$(RESET)"
	@uv run pytest --cov=modern_python_template --cov-report=term-missing --cov-report=html
	@echo "$(GREEN)✅ Tests with coverage completed!$(RESET)"
	@echo "$(BLUE)📊 Coverage report generated in htmlcov/index.html$(RESET)"

test-fast: ## Run tests without coverage
	@echo "$(BOLD)$(YELLOW)🧪 Running fast tests...$(RESET)"
	@uv run pytest --no-cov -x
	@echo "$(GREEN)✅ Fast tests completed!$(RESET)"

test-slow: ## Run all tests including slow ones
	@echo "$(BOLD)$(YELLOW)🧪 Running all tests (including slow ones)...$(RESET)"
	@uv run pytest -m "not slow"
	@echo "$(GREEN)✅ All tests completed!$(RESET)"

test-integration: ## Run integration tests only
	@echo "$(BOLD)$(YELLOW)🧪 Running integration tests...$(RESET)"
	@uv run pytest -m integration
	@echo "$(GREEN)✅ Integration tests completed!$(RESET)"

test-unit: ## Run unit tests only
	@echo "$(BOLD)$(YELLOW)🧪 Running unit tests...$(RESET)"
	@uv run pytest -m unit
	@echo "$(GREEN)✅ Unit tests completed!$(RESET)"

# Code Quality
lint: ## Run linting with ruff
	@echo "$(BOLD)$(PURPLE)🔍 Running linting checks...$(RESET)"
	@uv run ruff check .
	@echo "$(GREEN)✅ Linting completed!$(RESET)"

lint-fix: ## Run linting with automatic fixes
	@echo "$(BOLD)$(PURPLE)🔧 Running linting with automatic fixes...$(RESET)"
	@uv run ruff check --fix .
	@echo "$(GREEN)✅ Linting fixes applied!$(RESET)"

format: ## Format code with ruff
	@echo "$(BOLD)$(PURPLE)🎨 Formatting code...$(RESET)"
	@uv run ruff format .
	@echo "$(GREEN)✅ Code formatting completed!$(RESET)"

format-check: ## Check code formatting
	@echo "$(BOLD)$(PURPLE)🔍 Checking code formatting...$(RESET)"
	@uv run ruff format --check .
	@echo "$(GREEN)✅ Code formatting check completed!$(RESET)"

type-check: ## Run type checking with mypy
	@echo "$(BOLD)$(PURPLE)🔍 Running type checking...$(RESET)"
	@uv run mypy src/
	@echo "$(GREEN)✅ Type checking completed!$(RESET)"

check: lint format-check type-check ## Run all code quality checks
	@echo "$(BOLD)$(PURPLE)🔍 Running all code quality checks...$(RESET)"
	@echo "$(GREEN)✅ All code quality checks completed!$(RESET)"

# Pre-commit
pre-commit: ## Run pre-commit hooks on all files
	@echo "$(BOLD)$(CYAN)🔧 Running pre-commit hooks...$(RESET)"
	@uv run pre-commit run --all-files
	@echo "$(GREEN)✅ Pre-commit hooks completed!$(RESET)"

pre-commit-install: ## Install pre-commit hooks
	@echo "$(BOLD)$(CYAN)🔧 Installing pre-commit hooks...$(RESET)"
	@uv run pre-commit install
	@echo "$(GREEN)✅ Pre-commit hooks installed!$(RESET)"

# Documentation
docs: ## Build documentation
	@echo "$(BOLD)$(CYAN)📚 Building documentation...$(RESET)"
	@uv run mkdocs build
	@echo "$(GREEN)✅ Documentation built successfully!$(RESET)"

docs-serve: ## Serve documentation locally
	@echo "$(BOLD)$(CYAN)📚 Serving documentation locally...$(RESET)"
	@uv run mkdocs serve

docs-deploy: ## Deploy documentation to GitHub Pages
	@echo "$(BOLD)$(CYAN)📚 Deploying documentation to GitHub Pages...$(RESET)"
	@uv run mkdocs gh-deploy
	@echo "$(GREEN)✅ Documentation deployed!$(RESET)"

# Build and Release
build: clean ## Build the package
	@echo "$(BOLD)$(RED)📦 Building package...$(RESET)"
	@uv build
	@echo "$(GREEN)✅ Package built successfully!$(RESET)"

clean: ## Clean build artifacts
	@echo "$(BOLD)$(RED)🧹 Cleaning build artifacts...$(RESET)"
	@rm -rf build/
	@rm -rf dist/
	@rm -rf src/*.egg-info/
	@rm -rf .pytest_cache/
	@rm -rf .coverage
	@rm -rf htmlcov/
	@rm -rf .mypy_cache/
	@rm -rf .ruff_cache/
	@find . -type d -name __pycache__ -exec rm -rf {} +
	@find . -type f -name "*.pyc" -delete
	@echo "$(GREEN)✅ Build artifacts cleaned!$(RESET)"

# Development helpers
dev-deps: ## Show development dependencies
	@echo "$(BOLD)$(WHITE)📋 Development dependencies:$(RESET)"
	@uv tree --dev

update: ## Update all dependencies
	@echo "$(BOLD)$(WHITE)🔄 Updating dependencies...$(RESET)"
	@uv sync --upgrade
	@echo "$(GREEN)✅ Dependencies updated!$(RESET)"

lock: ## Generate lock file
	@echo "$(BOLD)$(WHITE)🔒 Generating lock file...$(RESET)"
	@uv lock
	@echo "$(GREEN)✅ Lock file generated!$(RESET)"

# Docker (if using containers)
docker-build: ## Build Docker image
	@echo "$(BOLD)$(RED)🐳 Building Docker image...$(RESET)"
	@docker build -t modern-python-template .
	@echo "$(GREEN)✅ Docker image built successfully!$(RESET)"

docker-run: ## Run Docker container
	@echo "$(BOLD)$(RED)🐳 Running Docker container...$(RESET)"
	@docker run -it --rm modern-python-template

# Git helpers
git-clean: ## Clean git repository
	@echo "$(BOLD)$(WHITE)🧹 Cleaning git repository...$(RESET)"
	@git clean -fd
	@git reset --hard HEAD
	@echo "$(GREEN)✅ Git repository cleaned!$(RESET)"

# CI/CD helpers
ci-test: ## Run CI tests
	@echo "$(BOLD)$(YELLOW)🚀 Running CI tests...$(RESET)"
	@uv run pytest --cov=modern_python_template --cov-report=xml --cov-report=term
	@echo "$(GREEN)✅ CI tests completed!$(RESET)"

ci-check: ## Run CI checks
	@echo "$(BOLD)$(PURPLE)🚀 Running CI checks...$(RESET)"
	@uv run ruff check .
	@uv run ruff format --check .
	@uv run mypy src/
	@echo "$(GREEN)✅ CI checks completed!$(RESET)"

# Environment info
env-info: ## Show environment information
	@echo "$(BOLD)$(WHITE)🔍 Environment Information:$(RESET)"
	@echo "  $(BLUE)Python version:$(RESET) $(shell python --version)"
	@echo "  $(BLUE)UV version:$(RESET) $(shell uv --version)"
	@echo "  $(BLUE)Current directory:$(RESET) $(shell pwd)"
	@echo "  $(BLUE)Virtual environment:$(RESET) $(shell echo $$VIRTUAL_ENV)"

# Quick development cycle
dev: install-dev lint test ## Quick development cycle: install, lint, test
	@echo "$(BOLD)$(GREEN)🚀 Development cycle completed!$(RESET)"

# Production readiness check
prod-check: check test-cov build ## Production readiness check
	@echo "$(BOLD)$(GREEN)🚀 Production readiness check completed!$(RESET)"

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

# Simple Commands (Easy to remember aliases)
init: setup-dev ## 🚀 Initialize project (alias for setup-dev)
	@echo "$(BOLD)$(GREEN)🎉 Project initialized successfully!$(RESET)"

run: ## 🏃 Run the demo
	@echo "$(BOLD)$(BLUE)🏃 Running demo...$(RESET)"
	@uv run modern-python-template demo

hello: ## 👋 Say hello (test the CLI)
	@echo "$(BOLD)$(BLUE)👋 Testing CLI...$(RESET)"
	@uv run modern-python-template hello

go: test ## 🏃 Quick test run (alias for test)
	@echo "$(BOLD)$(GREEN)🏃 Quick test completed!$(RESET)"

fix: lint-fix format ## 🔧 Fix all code issues (lint + format)
	@echo "$(BOLD)$(GREEN)🔧 Code fixes applied!$(RESET)"

up: update ## ⬆️ Update dependencies (alias for update)
	@echo "$(BOLD)$(GREEN)⬆️ Dependencies updated!$(RESET)"

info: env-info ## ℹ️ Show environment info (alias for env-info)

deps: dev-deps ## 📋 Show dependencies (alias for dev-deps)

ready: prod-check ## ✅ Check if ready for production (alias for prod-check)
	@echo "$(BOLD)$(GREEN)✅ Production readiness check completed!$(RESET)"

start: ## 🚀 Quick start development
	@echo "$(BOLD)$(BLUE)🚀 Starting development environment...$(RESET)"
	@$(MAKE) init
	@$(MAKE) run
	@echo "$(BOLD)$(GREEN)🎉 Development environment ready!$(RESET)"

# Ultra-simple single letter commands
t: test ## 🧪 Test (single letter)
l: lint ## 🔍 Lint (single letter)  
f: format ## 🎨 Format (single letter)
c: clean ## 🧹 Clean (single letter)
b: build ## 📦 Build (single letter)
h: help ## ❓ Help (single letter)

# Common workflow shortcuts
work: ## 🔄 Common workflow: fix code, test, ready
	@echo "$(BOLD)$(BLUE)🔄 Running common workflow...$(RESET)"
	@$(MAKE) fix
	@$(MAKE) test
	@echo "$(BOLD)$(GREEN)🔄 Workflow completed!$(RESET)"

ship: ## 🚢 Ship it: full check and build
	@echo "$(BOLD)$(BLUE)🚢 Preparing to ship...$(RESET)"
	@$(MAKE) check
	@$(MAKE) test-cov
	@$(MAKE) build
	@echo "$(BOLD)$(GREEN)🚢 Ready to ship!$(RESET)"
