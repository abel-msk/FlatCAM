#!/bin/bash
die() {
    local exit_code=${2:-1} # Use argument 2 as exit code, default to 1 if not provided
    echo "$0: ERROR: $1" >&2 # Print error message to stderr
    exit "$exit_code" # Exit the script with the specified code
}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "The script is running from: $SCRIPT_DIR"
SRC="${SCRIPT_DIR%/*}"
ROOT="${SRC%/*}"
SRC="${ROOT}/FlatCAM"

source $ROOT/.venv/bin/activate
#pyinstaller  -F --onefile --windowed  -y  --clean --name="ReFlatCAM" --icon="$SCRIPT_DIR/resources/flatcam_icon256.icns" ./FlatCAM.py
# help_bin = pkgutil.get_data( 'helpmod', 'help_data.txt' )

pyinstaller  --windowed  --onedir  -y  --clean   --name="FlatCAM" \
  --collect-all vispy  --collect-all language_data --collect-all rasterio \
  --add-data $SRC/tclCommands/*:tclCommands  \
  --add-data $SRC/translate/*:translate \
  --add-data $SRC/preprocessors/*:preprocessors \
  --distpath "$SCRIPT_DIR/dist" \
  --icon="$SRC/assets/macos/flatcam_icon256.icns"  "./FlatCAM/FlatCAM.py"

#pyinstaller  -y "$SCRIPT_DIR/ReFlatCAM.spec"
#  --collect-submodules vispy.glsl

hdiutil create -volname "FlatCAM" -srcfolder "$SCRIPT_DIR/dist/FlatCAM.app" -ov -format UDZO "$SCRIPT_DIR/dist/FlatCAM.dmg"
