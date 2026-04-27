.PHONY: help install install-py install-js dev test lint build clean

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-18s %s\n", $$1, $$2}'

install: install-py install-js ## Install both Python and npm packages

install-py: ## Install Python package in editable mode
	pip install -e .

install-js: ## Install npm package globally from local
	npm install -g .

dev: install-py ## Alias for Python editable install (most common workflow)

test: ## Run tests
	python -m pytest tests/ -v

lint: lint-py lint-js ## Lint everything

lint-py: ## Lint Python with ruff
	python -m ruff check src/

lint-js: ## Lint JS with eslint
	npx eslint bin/

fmt: fmt-py ## Format everything

fmt-py: ## Format Python with ruff
	python -m ruff format src/

fmt-check: ## Check formatting without writing (CI)
	python -m ruff format --check src/

typecheck: ## Type-check Python with mypy
	python -m mypy src/

build: ## Build Python wheel + sdist
	python -m hatchling build

clean: ## Remove build artifacts and caches
	rm -rf dist/ build/ *.egg-info src/*.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name '*.pyc' -delete

run-py: ## Run the Python CLI (usage: make run-py PORT=3000)
	python -m portwhy $(PORT)

run-js: ## Run the JS CLI (usage: make run-js PORT=3000)
	node bin/portwhy.js $(PORT)
