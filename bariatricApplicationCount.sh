#!/bin/bash

FOLDER="/Users/danaportenier/Box Sync/Applications from Duke Box"

# Count files added today
TODAY_COUNT=$(find "$FOLDER" -type f -mtime -1 | wc -l)
echo "Files added today: $TODAY_COUNT"

# Count files added in the last month (approximately 30 days)
MONTH_COUNT=$(find "$FOLDER" -type f -mtime -30 | wc -l)
echo "Files added in the last month: $MONTH_COUNT"

