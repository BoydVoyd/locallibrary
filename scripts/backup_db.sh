#!/bin/bash

# Generate timestamp for backup filename
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups"
BACKUP_FILE="library_data_${TIMESTAMP}.json"

# Create backups directory if it doesn't exist
mkdir -p $BACKUP_DIR

echo "Creating database backup..."

# Create Django fixture backup
poetry run python manage.py dumpdata --indent 2 > "${BACKUP_DIR}/${BACKUP_FILE}"

if [ $? -eq 0 ]; then
    echo "✅ Backup created successfully: ${BACKUP_DIR}/${BACKUP_FILE}"
    
    # Keep only the 5 most recent backups
    ls -t ${BACKUP_DIR}/library_data_*.json | tail -n +6 | xargs -r rm
    echo "🧹 Cleaned up old backups (keeping 5 most recent)"
else
    echo "❌ Backup failed!"
    exit 1
fi