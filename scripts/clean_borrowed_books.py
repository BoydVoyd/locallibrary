#!/usr/bin/env python3
"""
Clean borrower references from Django fixture to avoid foreign key errors.
"""
import json
import sys
from pathlib import Path


def clean_fixture(input_file, output_file):
    """Remove borrower references from BookInstance objects in fixture."""

    with open(input_file, "r") as f:
        data = json.load(f)

    cleaned_count = 0

    for item in data:
        if item.get("model") == "catalog.bookinstance":
            fields = item.get("fields", {})
            if fields.get("borrower"):
                fields["borrower"] = None
                fields["due_back"] = None  # Clear due date too
                fields["status"] = "a"  # Set to 'available'
                cleaned_count += 1

    with open(output_file, "w") as f:
        json.dump(data, f, indent=2)

    print(f"Cleaned {cleaned_count} borrowed book references")
    print(f"Output saved to: {output_file}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python clean_borrowed_books.py <input_fixture> <output_fixture>")
        print(
            "Example: python clean_borrowed_books.py "
            "library_content_only_20250728_120000.json "
            "library_content_clean_20250728_120000.json"
        )
        sys.exit(1)

    input_file = Path("backups") / sys.argv[1]
    output_file = Path("backups") / sys.argv[2]

    if not input_file.exists():
        print(f"Error: Input file {input_file} not found")
        sys.exit(1)

    clean_fixture(input_file, output_file)
