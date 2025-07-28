# Add this as scripts/backup_content_only.sh
#!/bin/bash

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backups/library_content_only_${TIMESTAMP}.json"

echo "Creating content-only backup: $BACKUP_FILE"

poetry run python manage.py dumpdata \
  --exclude auth.permission \
  --exclude contenttypes \
  --exclude admin.logentry \
  --exclude sessions.session \
  --format json \
  --indent 2 \
  catalog > "$BACKUP_FILE"

echo "Content-only backup created successfully!"