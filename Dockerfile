FROM python:3.12-slim-bookworm

# Copy uv from the official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Verify Node.js installation
RUN node -v && npm -v

# Set up the application
WORKDIR /app
COPY . /app

# Create and activate virtual environment
RUN uv venv "/app/.venv"

# Install mcpo
RUN uv pip install . && rm -rf ~/.cache

# Install Sanity MCP server globally
RUN npm install -g @sanity/mcp-server@latest

# Expose the port
EXPOSE 8000

# Start the server
CMD ["uv", "run", "mcpo", "--port", "8000", "--", "npx", "-y", "@sanity/mcp-server@latest"]