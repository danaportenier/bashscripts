#!/bin/bash

FOLDER="/Users/danaportenier/Box Sync/Applications from Duke Box"

# Use find to list all files, then use stat to extract creation month and year, finally group and count them
find "$FOLDER" -type f -print0 | xargs -0 stat -f "%Sm" -t "%Y-%m" | sort | uniq -c | while read count month; do
    echo "$month: $count files"
done

