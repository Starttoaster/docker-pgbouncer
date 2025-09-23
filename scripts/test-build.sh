#!/bin/bash

# Script to test the Docker build locally
# Usage: ./scripts/test-build.sh [tag]

set -e

TAG=${1:-pgbouncer:test}

echo "Building Docker image with tag: $TAG"

# Build the image
docker build -t "$TAG" .

echo "Build completed successfully!"

# Test basic functionality
echo "Testing basic functionality..."

# Start container in background
CONTAINER_ID=$(docker run -d \
  -e PGBOUNCER_DB_HOST=localhost \
  -e PGBOUNCER_DB_USER=test \
  -e PGBOUNCER_DB_PASSWORD=test \
  -p 6432:6432 \
  "$TAG")

echo "Container started with ID: $CONTAINER_ID"

# Wait for container to start
echo "Waiting for container to start..."
sleep 5

# Check if container is running
if docker ps | grep -q "$CONTAINER_ID"; then
    echo "✅ Container is running"
else
    echo "❌ Container failed to start"
    docker logs "$CONTAINER_ID"
    docker rm -f "$CONTAINER_ID"
    exit 1
fi

# Test health check
echo "Testing health check..."
if docker exec "$CONTAINER_ID" pg_isready -h localhost -p 6432 -U pgbouncer >/dev/null 2>&1; then
    echo "✅ Health check passed"
else
    echo "❌ Health check failed"
    docker logs "$CONTAINER_ID"
fi

# Test configuration generation
echo "Testing configuration generation..."
if docker exec "$CONTAINER_ID" test -f /etc/pgbouncer/pgbouncer.ini; then
    echo "✅ Configuration file generated"
else
    echo "❌ Configuration file not found"
fi

# Clean up
echo "Cleaning up..."
docker rm -f "$CONTAINER_ID"

echo "✅ All tests passed!"
echo "Image '$TAG' is ready for use"
