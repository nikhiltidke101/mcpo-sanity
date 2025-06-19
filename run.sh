#!/bin/bash
uset -a && source .env && set +a     
uv run mcpo --port 8000 -- npx -y @sanity/mcp-server@latest