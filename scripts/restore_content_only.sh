#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <backup_file>"
    echo "Available content-only backups:"
    ls -la backups/library_content_only_*.json 2>/dev/null || echo "No content-only backups found"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "backups/$BACKUP_FILE" ]; then
    echo "Error: Backup file 'backups/$BACKUP_FILE' not found"
    exit 1
fi

echo "WARNING: This will load content data into the current database."
echo "Make sure you've run migrations first: poetry run python manage.py migrate"
echo ""
read -p "Continue with restore? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Restore cancelled"
    exit 1
fi

echo "Loading content data from backups/$BACKUP_FILE..."
poetry run python manage.py loaddata "backups/$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Content restore completed successfully!"
    echo ""
    echo "Remember to create a superuser account:"
    echo "poetry run python manage.py createsuperuser"
else
    echo "Error occurred during content restore"
    exit 1
fi