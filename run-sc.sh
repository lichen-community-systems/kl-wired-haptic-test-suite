#!/usr/bin/env bash

# Check if a file was specified
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 file.scd"
    exit 1
fi

SC_FILE=$1

# Check if the file exists
if [[ ! -f "$SC_FILE" ]]; then
    echo "Error: File '$SC_FILE' not found"
    exit 1
fi

# Find the sclang executable
SCLANG_CMD=$(which sclang)
if [[ -z "$SCLANG_CMD" ]]; then
    # Try common locations if which didn't find it
    for path in "/Applications/SuperCollider.app/Contents/MacOS/sclang" "/usr/local/bin/sclang" "/usr/bin/sclang"; do
        if [[ -x "$path" ]]; then
            SCLANG_CMD="$path"
            break
        fi
    done

    if [[ -z "$SCLANG_CMD" ]]; then
        echo "Error: Could not find sclang executable"
        exit 1
    fi
fi

# Execute sclang with the file directly
"$SCLANG_CMD" "$SC_FILE"
