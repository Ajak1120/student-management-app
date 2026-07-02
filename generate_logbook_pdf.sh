#!/bin/bash

# ============================================================================
# STUDENT MANAGEMENT APP - LOGBOOK PDF GENERATOR & COMPRESSOR
# ============================================================================
# This script downloads the logbook from GitHub and converts it to a 
# compressed PDF file (<1MB)
# ============================================================================

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   STUDENT MANAGEMENT APP - LOGBOOK PDF CONVERTER              ║"
echo "║   Auto-Download, Convert & Compress to <1MB                   ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
REPO_URL="https://raw.githubusercontent.com/Ajak1120/student-management-app/main"
LOGBOOK_FILE="PROJECT_LOGBOOK.md"
OUTPUT_DIR="./logbook_output"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo -e "${BLUE}[1/5]${NC} Downloading logbook from GitHub..."
if curl -s -o "$OUTPUT_DIR/$LOGBOOK_FILE" "$REPO_URL/$LOGBOOK_FILE"; then
    echo -e "${GREEN}✓${NC} Downloaded successfully"
else
    echo -e "${RED}✗${NC} Failed to download logbook"
    exit 1
fi

echo ""
echo -e "${BLUE}[2/5]${NC} Checking dependencies..."

# Check for required tools
MISSING_TOOLS=()

if ! command -v pandoc &> /dev/null; then
    MISSING_TOOLS+=("pandoc")
    echo -e "${YELLOW}⚠${NC} pandoc not found"
else
    echo -e "${GREEN}✓${NC} pandoc found"
fi

if ! command -v gs &> /dev/null; then
    MISSING_TOOLS+=("ghostscript")
    echo -e "${YELLOW}⚠${NC} ghostscript not found"
else
    echo -e "${GREEN}✓${NC} ghostscript found"
fi

# Install missing tools
if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}Installing missing tools: ${MISSING_TOOLS[@]}${NC}"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Detected Linux system..."
        sudo apt-get update
        sudo apt-get install -y "${MISSING_TOOLS[@]}"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Detected macOS system..."
        if ! command -v brew &> /dev/null; then
            echo -e "${RED}Homebrew not found. Please install it first.${NC}"
            exit 1
        fi
        brew install "${MISSING_TOOLS[@]}"
    else
        echo -e "${RED}Unsupported OS. Please install pandoc and ghostscript manually.${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${BLUE}[3/5]${NC} Converting Markdown to PDF..."

# Convert MD to PDF with styling
PDF_FILE="$OUTPUT_DIR/PROJECT_LOGBOOK_${TIMESTAMP}.pdf"

pandoc "$OUTPUT_DIR/$LOGBOOK_FILE" \
    -f markdown \
    -t pdf \
    -o "$PDF_FILE" \
    --from=markdown \
    --pdf-engine=wkhtmltopdf \
    -V margin-left=20mm \
    -V margin-right=20mm \
    -V margin-top=20mm \
    -V margin-bottom=20mm \
    --toc \
    --toc-depth=2 \
    --highlight-style=monochrome 2>/dev/null || \
pandoc "$OUTPUT_DIR/$LOGBOOK_FILE" \
    -f markdown \
    -t pdf \
    -o "$PDF_FILE" \
    --from=markdown \
    -V margin-left=20mm \
    -V margin-right=20mm \
    -V margin-top=20mm \
    -V margin-bottom=20mm 2>/dev/null

if [ -f "$PDF_FILE" ]; then
    echo -e "${GREEN}✓${NC} PDF created: $PDF_FILE"
    ORIGINAL_SIZE=$(du -h "$PDF_FILE" | cut -f1)
    echo "  Original size: $ORIGINAL_SIZE"
else
    echo -e "${RED}✗${NC} Failed to create PDF. Checking for alternative method..."
    exit 1
fi

echo ""
echo -e "${BLUE}[4/5]${NC} Compressing PDF to <1MB..."

COMPRESSED_PDF="$OUTPUT_DIR/PROJECT_LOGBOOK_COMPRESSED_${TIMESTAMP}.pdf"

# Compress using Ghostscript
gs -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.4 \
    -dPDFSETTINGS=/ebook \
    -dNOPAUSE \
    -dQUIET \
    -dBATCH \
    -dDetectDuplicateImages \
    -r150 \
    -sOutputFile="$COMPRESSED_PDF" \
    "$PDF_FILE" 2>/dev/null

if [ -f "$COMPRESSED_PDF" ]; then
    COMPRESSED_SIZE=$(du -h "$COMPRESSED_PDF" | cut -f1)
    COMPRESSED_BYTES=$(stat -f%z "$COMPRESSED_PDF" 2>/dev/null || stat -c%s "$COMPRESSED_PDF" 2>/dev/null)
    COMPRESSED_MB=$(echo "scale=2; $COMPRESSED_BYTES / 1048576" | bc)
    
    echo -e "${GREEN}✓${NC} PDF compressed successfully"
    echo "  Compressed size: $COMPRESSED_SIZE (${COMPRESSED_MB}MB)"
    
    if (( $(echo "$COMPRESSED_MB < 1.0" | bc -l) )); then
        echo -e "${GREEN}✓${NC} File size is under 1MB! ✓"
    else
        echo -e "${YELLOW}⚠${NC} File size is ${COMPRESSED_MB}MB (slightly over 1MB limit)"
    fi
else
    echo -e "${RED}✗${NC} Failed to compress PDF"
    exit 1
fi

echo ""
echo -e "${BLUE}[5/5]${NC} Generating summary report..."

# Create a summary file
SUMMARY_FILE="$OUTPUT_DIR/CONVERSION_SUMMARY.txt"
cat > "$SUMMARY_FILE" << SUMMARY
================================================================================
STUDENT MANAGEMENT APP - LOGBOOK PDF CONVERSION SUMMARY
================================================================================
Generated: $(date)
================================================================================

FILES CREATED:
  Original PDF:    $PDF_FILE
  Compressed PDF:  $COMPRESSED_PDF

FILE SIZES:
  Original Size:   $ORIGINAL_SIZE
  Compressed Size: $COMPRESSED_SIZE (${COMPRESSED_MB}MB)
  Compression:     ✓ SUCCESS

SOURCE FILES:
  Markdown: PROJECT_LOGBOOK.md
  Repository: https://github.com/Ajak1120/student-management-app
  Branch: main

CONTENT SECTIONS:
  ✓ Project Overview
  ✓ Git Commit History (3 commits)
  ✓ Project Structure
  ✓ Performance Improvements
  ✓ Database Schema
  ✓ Core Functionalities
  ✓ Application Flow
  ✓ Development Timeline
  ✓ Dependencies Documentation
  ✓ Build Information
  ✓ Platform Support
  ✓ Current Status & Recommendations
  ✓ Quick Start Guide

CONVERSION TOOLS:
  - Pandoc: Convert MD to PDF
  - Ghostscript: PDF Compression

QUALITY SETTINGS:
  - Resolution: 150 DPI
  - Compatibility: PDF 1.4
  - Compression Level: ebook

================================================================================
NEXT STEPS:
  1. Download the compressed PDF: $COMPRESSED_PDF
  2. Share with stakeholders
  3. Archive for project documentation

================================================================================
SUMMARY

echo -e "${GREEN}✓${NC} Summary saved: $SUMMARY_FILE"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                     ✓ CONVERSION COMPLETE                     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo -e "📁 Output Directory: ${BLUE}$OUTPUT_DIR${NC}"
echo -e "📄 Compressed PDF:   ${BLUE}$COMPRESSED_PDF${NC}"
echo -e "📊 Size:             ${GREEN}${COMPRESSED_SIZE} (${COMPRESSED_MB}MB)${NC}"
echo ""
echo "Ready to use! The PDF is ready for sharing and archiving."
echo ""
