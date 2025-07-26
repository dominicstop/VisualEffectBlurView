#!/bin/bash

# NOTE:
# assumes the script is run on repo root

SCRIPT_BASE_URL="https://raw.githubusercontent.com/dominicstop/DGSwiftUtilities/refs/heads/main/scripts"

# where the script was launched from
EXE_CWD_PATH=$(pwd)

# MARK: Functions
# ---------------

LIB_ROOT_PATH==$(pwd)
find_project_root() {
  CURRENT_DIR=$(pwd)

  while [ "$CURRENT_DIR" != "/" ]; do
    if [ -d "$CURRENT_DIR/.git" ]; then
      LIB_ROOT_PATH="$CURRENT_DIR"
      echo "Project root found at: $LIB_ROOT_PATH"
      return 0
    fi

    CURRENT_DIR=$(dirname "$CURRENT_DIR")
  done

  echo "Error: .git directory not found in any parent directories."
  exit 1
}

goto_project_root() {
  find_project_root
  cd $LIB_ROOT_PATH
}

# MARK: Script Main
# ---------------

# E.g. delete-version.sh
SCRIPT_NAME=$(basename "$0")

SCRIPT_URL="${SCRIPT_BASE_URL}/${SCRIPT_NAME}"
TEMP_SCRIPT_NAME="temp-$SCRIPT_NAME"
TEMP_SCRIPT_PATH="/tmp/$TEMP_SCRIPT_NAME"

echo "Script Repo URL: $SCRIPT_BASE_URL"
echo "Script: $SCRIPT_NAME"

echo "Fetching script..."
curl -s $SCRIPT_URL -o $TEMP_SCRIPT_PATH
chmod +x $TEMP_SCRIPT_PATH

echo "Navigating to project root..."
goto_project_root

echo "Executing script: $TEMP_SCRIPT_PATH"
$TEMP_SCRIPT_PATH "$@" 

echo "Cleaning up..."
rm -f $TEMP_SCRIPT_PATH