# Use Python 3.11 slim image
FROM python:3.11-slim-bullseye

# Ensure all packages are up to date
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install system dependencies
# (Moved to above with upgrade step)

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install UV
RUN pip install uv

# Set working directory
WORKDIR /app

# Copy project files
COPY pyproject.toml ./
COPY src/ ./src/
COPY README.md ./

# Install dependencies
RUN uv sync --no-dev

# Create non-root user
RUN useradd --create-home --shell /bin/bash appuser
USER appuser

# Expose port (if needed)
EXPOSE 8000

# Set entrypoint
ENTRYPOINT ["uv", "run", "modern-python-template"]
