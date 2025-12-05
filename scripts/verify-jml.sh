#!/bin/bash
# JML Verification Script using OpenJML
# Verifies JML specifications in the source code

set -e

OPENJML_DIR="tools/openjml"
OPENJML_JAR="$OPENJML_DIR/openjml.jar"

# Check if OpenJML is installed
if [ ! -f "$OPENJML_JAR" ]; then
    echo "OpenJML not found. Running setup script..."
    ./scripts/setup-openjml.sh
fi

# Source directories to verify
SOURCE_DIRS=(
    "src/main/java/org/springframework/samples/petclinic/owner"
    "src/main/java/org/springframework/samples/petclinic/vet"
)

# Collect all Java files with JML annotations
JAVA_FILES=()
for dir in "${SOURCE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        while IFS= read -r -d '' file; do
            # Check if file contains JML annotations
            if grep -q "/*@" "$file" || grep -q "//@" "$file"; then
                JAVA_FILES+=("$file")
            fi
        done < <(find "$dir" -name "*.java" -type f -print0)
    fi
done

if [ ${#JAVA_FILES[@]} -eq 0 ]; then
    echo "No Java files with JML annotations found."
    exit 0
fi

echo "Found ${#JAVA_FILES[@]} Java file(s) with JML annotations"
echo "Verifying JML specifications..."

# Run OpenJML verification
java -jar "$OPENJML_JAR" -check -cp "$(./mvnw dependency:build-classpath -q -DincludeScope=compile 2>/dev/null | tail -1)" "${JAVA_FILES[@]}" || {
    echo ""
    echo "JML verification completed with warnings/errors."
    echo "Review the output above for details."
    exit 1
}

echo "JML verification completed successfully!"


