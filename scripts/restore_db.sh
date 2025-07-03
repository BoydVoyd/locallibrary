#!/bin/bash

BACKUP_DIR="backups"

# Check if backup file is provided as argument
if [ $# -eq 0 ]; then
    echo "Available backups:"
    ls -la ${BACKUP_DIR}/library_data_*.json 2>/dev/null | awk '{print $9}' | sort -r
    echo ""
    echo "Usage: $0 <backup_filename>"
    echo "Example: $0 library_data_20250102_143022.json"
    exit 1
fi

BACKUP_FILE=$1

# Check if file exists
if [ ! -f "${BACKUP_DIR}/${BACKUP_FILE}" ]; then
    echo "❌ Backup file not found: ${BACKUP_DIR}/${BACKUP_FILE}"
    exit 1
fi

echo "⚠️  This will replace all data in your database!"
read -p "Are you sure? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 1
fi

echo "Clearing existing data..."
poetry run python manage.py flush --noinput

echo "Restoring from backup: ${BACKUP_DIR}/${BACKUP_FILE}"
poetry run python manage.py loaddata "${BACKUP_DIR}/${BACKUP_FILE}"

if [ $? -eq 0 ]; then
    echo "✅ Database restored successfully!"
else
    echo "❌ Restore failed!"
    exit 1
fi