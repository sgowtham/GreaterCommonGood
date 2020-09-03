#! /bin/bash
#
# BASH script to chronologically rename the photographs in a folder 
# (includes sub-folders). Resulting order assumes that the devices 
# contrtibuting photographs are in sync with the same time SOURCE.
# 
# Usage:
# sort_photographs.sh

# Necessary variables
SOURCE="/full/path/to/source/folder/"
TARGET="/full/path/to/target/folder/"

# Check if the script is called with any arguments. If yes, print an error
# message (help text) and exit
if [ $# -ne 0 ]
then
  echo
  echo "  Usage: `basename $0`"
  echo
  exit
fi

# Check if the SOURCE folder exists. If not, print an error message (help text)
# and exit
if [ ! -d "${SOURCE}" ]
then
  echo
  echo "  SOURCE folder with images does not exist"
  echo
  exit
fi

# Check if the TARGET folder exists. If not, create it. Assumes that the path
# for TARGET is user-writable
if [ ! -d ${TARGET} ]
then
  echo
  echo "  TARGET folder does not exist."
  mkdir -p ${TARGET}
  echo
fi

# Make a list of all images. Assumes .jpg type. Edit to fit other types
IMAGES=($(find "$SOURCE" -iname "*.jpg"))

# Rename each of the images as TIMESTAMP--BASENAME.jpg
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
  echo "  Renaming ${file} as ${TIMESTAMP}--${BASENAME}"
  # Replace 'cp' with 'mv' iff confident
  cp ${file} ${TARGET}/${TIMESTAMP}--${BASENAME}
done
echo
