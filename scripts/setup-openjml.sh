#!/bin/bash
# Setup script for OpenJML
# Downloads and configures OpenJML for JML verification

set -e

OPENJML_VERSION="21-0.18"
OPENJML_DIR="tools/openjml"
OPENJML_URL="https://github.com/OpenJML/OpenJML/releases/download/v${OPENJML_VERSION}/openjml.zip"

echo "Setting up OpenJML ${OPENJML_VERSION}..."

# Create tools directory if it doesn't exist
mkdir -p tools

# Check if OpenJML is already installed
if [ -d "$OPENJML_DIR" ] && [ -f "$OPENJML_DIR/openjml.jar" ]; then
    echo "OpenJML is already installed at $OPENJML_DIR"
    exit 0
fi

# Download OpenJML
echo "Downloading OpenJML from ${OPENJML_URL}..."
cd tools

if command -v wget &> /dev/null; then
    wget -O openjml.zip "$OPENJML_URL"
elif command -v curl &> /dev/null; then
    curl -L -o openjml.zip "$OPENJML_URL"
else
    echo "Error: Neither wget nor curl is available. Please download OpenJML manually."
    exit 1
fi

# Extract OpenJML
echo "Extracting OpenJML..."
unzip -q openjml.zip -d openjml || {
    echo "Error: Failed to extract OpenJML. Please ensure unzip is installed."
    rm -f openjml.zip
    exit 1
}

# Clean up zip file
rm -f openjml.zip

# Verify installation
if [ -f "openjml/openjml.jar" ]; then
    echo "OpenJML successfully installed at $OPENJML_DIR"
    echo "You can now run JML verification using:"
    echo "  ./scripts/verify-jml.sh"
else
    echo "Error: OpenJML installation verification failed"
    exit 1
fi

cd ..

