#!/bin/bash

# Create build directory
mkdir -p build

# Function to check if command succeeded
check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed!"
        exit 1
    fi
}

# First compilation to generate .aux files
echo "First compilation..."
pdflatex -interaction=nonstopmode -output-directory=build main.tex
check_success "First pdflatex run"

# Check if .bib file exists and biber is needed
if [ -f "refs.bib" ]; then
    echo "Processing bibliography with biber..."
    biber --debug build/main
    check_success "Biber run"

    # Show biber log for debugging
    echo "=== Biber Log ==="
    cat build/main.blg | tail -10

    # Second compilation to include citations
    echo "Second compilation..."
    pdflatex -interaction=nonstopmode -output-directory=build main.tex
    check_success "Second pdflatex run"

    # Third compilation to resolve cross-references and finalize
    echo "Third compilation..."
    pdflatex -interaction=nonstopmode -output-directory=build main.tex
    check_success "Third pdflatex run"
else
    echo "Warning: refs.bib not found, skipping bibliography processing"
fi

echo "Build complete!"

# Check if PDF was generated successfully
if [ -f "build/main.pdf" ]; then
    xdg-open build/main.pdf
    echo "Build again if the pictures do not show up."
else
    echo "Error: PDF not generated!"
    exit 1
fi