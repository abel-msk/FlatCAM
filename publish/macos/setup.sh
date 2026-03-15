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
#echo "src=$SRC;  root=$ROOT"

cd $ROOT || die "Incorrect path $ROOT"

if [ ! -d ".venv" ]; then
  python3.14 -m venv .venv
fi

source .venv/bin/activate
pip3 install -r $SCRIPT_DIR/requirements.txt

echo "... Prepare QT forms"
pyrcc5 "$SRC/resources.qrc" -o "$SRC/resources.py"
pyrcc5 "$SRC/resources_dark.qrc" -o "$SRC/resources_dark.py"

echo "... Compile languages dictionary"
find "$SRC/translate" -name "*.po" -exec sh -c 't={} ; msgfmt "${t%.*}.po" -o  "${t%.*}.mo" ' \;

