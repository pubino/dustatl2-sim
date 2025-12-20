#!/bin/bash
#
# build.sh - Compile and package Dust at L2 Simulator
#
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_DIR/build"
DIST_DIR="$PROJECT_DIR/dist"

echo "=== Dust at L2 Simulator Build Script ==="
echo "Project directory: $PROJECT_DIR"

# Clean previous builds
rm -rf "$BUILD_DIR" "$DIST_DIR"
mkdir -p "$BUILD_DIR" "$DIST_DIR"

# Compile Java sources
echo "Compiling Java sources..."

cd "$PROJECT_DIR"
javac -d "$BUILD_DIR" \
    -sourcepath . \
    -Xlint:-deprecation -Xlint:-removal \
    astro/galaxy/DustAtL2.java \
    astro/galaxy/DustAtL2Canvas.java \
    astro/galaxy/Body3d.java \
    astro/galaxy/Data3d.java \
    myutil/AppletFrame.java \
    myutil/GL.java \
    myutil/SL.java \
    myutil/Format.java

# Create JAR file
echo "Creating JAR file..."
cd "$BUILD_DIR"
jar cfe "$DIST_DIR/DustAtL2Sim.jar" astro.galaxy.DustAtL2 astro/ myutil/

echo "Build complete!"
echo "JAR file: $DIST_DIR/DustAtL2Sim.jar"
echo ""
echo "To run: java -jar $DIST_DIR/DustAtL2Sim.jar"
