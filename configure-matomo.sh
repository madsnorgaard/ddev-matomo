#!/bin/bash

#ddev-generated
# Matomo Configuration Script
# This script helps configure Matomo version and settings

set -e

COMPOSE_FILE=".ddev/docker-compose.matomo.yaml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}DDEV Matomo Configuration${NC}"
echo "================================="

if [ ! -f "$COMPOSE_FILE" ]; then
    echo -e "${RED}Error: $COMPOSE_FILE not found${NC}"
    echo "Please run this script from your DDEV project root directory."
    exit 1
fi

# Function to update a value in the compose file
update_value() {
    local key="$1"
    local value="$2"
    local description="$3"
    
    if sed -i "s|$key:.*|$key: $value|" "$COMPOSE_FILE"; then
        echo -e "${GREEN}✓${NC} Updated $description to: $value"
    else
        echo -e "${RED}✗${NC} Failed to update $description"
    fi
}

# Get current version
current_version=$(grep "image: matomo:" "$COMPOSE_FILE" | sed 's/.*matomo://' | tr -d ' ')
echo -e "${YELLOW}Current Matomo version:${NC} $current_version"
echo

# Version selection
echo "Select Matomo version:"
echo "1) Matomo 5 (latest - recommended)"
echo "2) Matomo 4 (LTS - until Nov 2025)"
echo "3) Specific version (e.g., 5.1.2, 4.15.1)"
echo "4) Keep current version ($current_version)"
echo

read -p "Enter choice (1-4): " version_choice

case $version_choice in
    1)
        new_version="5"
        ;;
    2)
        new_version="4"
        ;;
    3)
        read -p "Enter specific version (e.g., 5.1.2): " new_version
        ;;
    4)
        new_version="$current_version"
        echo -e "${GREEN}Keeping current version: $current_version${NC}"
        ;;
    *)
        echo -e "${RED}Invalid choice. Keeping current version.${NC}"
        new_version="$current_version"
        ;;
esac

if [ "$new_version" != "$current_version" ]; then
    update_value "    image" "matomo:$new_version" "Matomo version"
fi

echo

# Database configuration
current_db=$(grep "MATOMO_DATABASE_DBNAME:" "$COMPOSE_FILE" | sed 's/.*: //')
echo -e "${YELLOW}Current database name:${NC} $current_db"
read -p "Enter database name (press enter for '$current_db'): " new_db

if [ -n "$new_db" ] && [ "$new_db" != "$current_db" ]; then
    update_value "      MATOMO_DATABASE_DBNAME" "$new_db" "database name"
fi

echo
echo -e "${GREEN}Configuration complete!${NC}"
echo
echo "Next steps:"
echo "1. Run: ${YELLOW}ddev restart${NC}"
echo "2. Visit: ${YELLOW}https://matomo.\$(ddev describe | grep Name | awk '{print \$2}').ddev.site${NC}"
echo
echo "If you changed the database name, make sure to create it:"
echo "   ${YELLOW}echo \"CREATE DATABASE IF NOT EXISTS $new_db;\" | ddev mysql${NC}"