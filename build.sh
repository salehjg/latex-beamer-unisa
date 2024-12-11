#!/bin/bash

mkdir -p build && pdflatex -output-directory=build main.tex && xdg-open build/main.pdf
echo "Build again if the pictures do not show up."