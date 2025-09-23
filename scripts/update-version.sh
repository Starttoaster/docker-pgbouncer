#!/bin/bash

# Script to update PgBouncer version in Dockerfile
# Usage: ./scripts/update-version.sh <new_version>

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <new_version>"
    echo "Example: $0 1.22.0"
    exit 1
fi

NEW_VERSION=$1
DOCKERFILE="Dockerfile"

# Check if Dockerfile exists
if [ ! -f "$DOCKERFILE" ]; then
    echo "Error: Dockerfile not found"
    exit 1
fi

# Extract current version
CURRENT_VERSION=$(grep "ARG PGBOUNCER_VERSION=" "$DOCKERFILE" | cut -d'=' -f2)

if [ -z "$CURRENT_VERSION" ]; then
    echo "Error: Could not find PGBOUNCER_VERSION in Dockerfile"
    exit 1
fi

echo "Current version: $CURRENT_VERSION"
echo "New version: $NEW_VERSION"

# Update Dockerfile
sed -i.bak "s/ARG PGBOUNCER_VERSION=$CURRENT_VERSION/ARG PGBOUNCER_VERSION=$NEW_VERSION/" "$DOCKERFILE"

# Remove backup file
rm "${DOCKERFILE}.bak"

echo "Updated Dockerfile with version $NEW_VERSION"

# Update README if it contains version references
if [ -f "README.md" ]; then
    sed -i.bak "s/PgBouncer $CURRENT_VERSION/PgBouncer $NEW_VERSION/g" "README.md"
    sed -i.bak "s/v$CURRENT_VERSION/v$NEW_VERSION/g" "README.md"
    rm "README.md.bak"
    echo "Updated README.md with version $NEW_VERSION"
fi

echo "Version update complete!"
echo ""
echo "Next steps:"
echo "1. Test the build: docker build -t pgbouncer:$NEW_VERSION ."
echo "2. Commit changes: git add . && git commit -m 'Update to PgBouncer $NEW_VERSION'"
echo "3. Create tag: git tag v$NEW_VERSION"
echo "4. Push changes: git push origin main && git push origin v$NEW_VERSION"
