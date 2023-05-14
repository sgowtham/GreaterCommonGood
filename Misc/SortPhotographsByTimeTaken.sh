#! /bin/bash
#
# BASH script to rename the photographs in a folder (includes sub-folders) in
# chronological order of the time taken as recorded in the EXIF data. Assumes
# that the photographs have .jpg extension for their file names. Depends on
# exiftool, a third-party application.
# 
# Usage:
# SortPhotographsByTimeTaken.sh

# CommonFunctions.sh
if [ -e "../CommonFunctions.sh" ]
then
  source "../CommonFunctions.sh"
else
  echo
  echo "  This script needs CommonFunctions.sh to perform various tasks."
  echo "  Ensure CommonFunctions.sh is located one folder above in the tree"
  echo "  and is accessible"
  echo "  Exiting the script."
  echo
  exit 66
fi

# Argument check
if [ $# -ne 0 ]
then
  echo
  echo "  Usage: $(basename $0)"
  echo
  exit ${E_ARGS}
fi

# Necessary variables
SOURCE="/full/path/to/source/folder/"
TARGET="/full/path/to/target/folder/"

# SOURCE folder check
if ! check_existence ${SOURCE}
then
  echo
  echo "  ${SOURCE} folder does not exist."
  echo "  Invalid input. Exiting."
  echo
  exit ${E_ENTITY_MISSING}
fi

if ! check_readable ${SOURCE}
then
  echo
  echo "  ${SOURCE} folder exists but is not readable."
  echo "  Incorrect permissions. Exiting."
  echo
  exit ${E_ENTITY_PERMISSIONS}
fi

# TARGET folder check (assumes the location is write-able)
if ! check_existence ${TARGET}
then
  echo
  echo "  ${TARGET} folder does not exist."
  echo "  Creating ${TARGET}"
  mkdir -p ${TARGET}
  echo
fi

# Make a list of all .jpg images
IMAGES=($(find "${SOURCE}" -iname "*.jpg"))

# Rename the image as TIMESTAMP__BASENAME.jpg
# Depends on a third-party tool called exiftool
echo
for file in ${IMAGES[@]}
do
  TIMESTAMP=$(exiftool ${file} | \
               grep -i "Date/Time Original" | \
               head -1 | \
               awk -F ' :' '{ print $NF }' | \
               sed 's/^[ \t]*//;s/[ \t]*$//' | \
               sed 's/://g' | \
               sed 's/ /_/g')
  BASENAME=$(basename ${file})

  # Replace 'cp' with 'mv' iff confident
  echo "  Renaming ${file} as ${TIMESTAMP}__${BASENAME}"
  cp ${file} ${TARGET}/${TIMESTAMP}__${BASENAME}
done
echo
