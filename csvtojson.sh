#!/bin/bash

folder_path="/Users/danaportenier/Box Sync/Applications from Duke Box"
output_file="updatedBariatricApplication.json"

# Start the JSON array
echo "[" > "$output_file"

first_file=true

# For each CSV file in the folder
for csv_file in "$folder_path"/*.csv; do
    # Check if the file exists
    if [ ! -f "$csv_file" ]; then
        continue
    fi

    # Check if this is the first file we're processing. If not, append a comma to separate JSON objects.
    if [ "$first_file" = true ]; then
        first_file=false
    else
        echo "," >> "$output_file"
    fi

    # Transform the CSV to JSON and append it to the output file
    awk -F, '
    NR > 1 {
        # Remove quotes from the field names and values
        gsub(/"/, "", $1)
        gsub(/"/, "", $2)

        # Escape special characters in the field values for JSON
        gsub(/\\/, "\\\\", $2)
        gsub(/"/, "\\\"", $2)
        gsub(/\t/, "\\t", $2)
        gsub(/\r/, "\\r", $2)
        gsub(/\n/, "\\n", $2)

        # Print JSON key-value pairs
        if (NR == 2) {
            printf "{\n"
        } else {
            printf ",\n"
        }
        printf "    \"%s\": \"%s\"", $1, $2
    }
    END {
        printf "\n}"
    }
    ' "$csv_file" >> "$output_file"
done

# Close the JSON array
echo "]" >> "$output_file"

echo "JSON conversion completed. Output written to $output_file"
