#!/bin/bash

folder_path="/Users/danaportenier/Box Sync/Applications from Duke Box"
output_file="bariatricApplications.json"

# Start the JSON array
echo "[" > "$output_file"

first_file=true

# For each CSV file in the folder
for csv_file in "$folder_path"/*.csv; do
    # Check if this is the first file we're processing. If not, append a comma to separate JSON objects.
    if [ "$first_file" = true ]; then
        first_file=false
    else
        echo "," >> "$output_file"
    fi

    # Transform the CSV to JSON and append it to the output file
    awk -F, '
    NR > 2 {
        # Remove quotes from the field values
        gsub(/"/, "", $1)
        gsub(/"/, "", $2)

        # Escape special characters in the field values for JSON
        gsub(/\\/, "\\\\", $1)
        gsub(/\\/, "\\\\", $2)
        gsub(/"/, "\\\"", $1)
        gsub(/"/, "\\\"", $2)

        # Store field values in arrays
        keys[NR-2] = $1
        values[NR-2] = $2
    }

    END {
        printf "{\n"

        for (i=1; i<NR-1; i++) {
            comma = (i < NR-2) ? "," : ""
            printf "    \"%s\": \"%s\"%s\n", keys[i], values[i], comma
        }

        printf "}\n"
    }
    ' "$csv_file" >> "$output_file"
done

# Close the JSON array
echo "]" >> "$output_file"

