#! /bin/bash
#
# BASH script to extract relevant information from the recorded data (.dat file) and
# prepare a CSV file for graphing purposes.
#
# Usage:
# HumidityTemperature_SensorData2CSV.sh LOCATION_TIMESTAMP

# Argument check
if [ $# -ne 1 ]
then
  echo
  echo "  Usage: $(basename $0) LOCATION_TIMESTAMP"
  echo "   e.g.: $(basename $0) HoughtonMI_202305150543"
  echo
  exit ${E_ARGS}
fi

# TODO:
# Move these functions to CommonFunctions.sh in the parent folder 

# file_existence()
# Check if a given file exists
# Usage: file_existence FILE_NAME
function file_existence() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FILE_NAME"
    echo
    return ${E_ARGS}
  fi

  # Necessary variables
  local filename="$1"

  # Check if the CSV file exists
  if [ ! -e "${filename}" ]
  then
    echo
    echo "  ${filename} does not exist."
    echo "  Exiting the script/workflow."
    echo
    exit ${E_ENTITY_MISSING}
  fi
}

# file_size()
# Check the size of a given file
# Usage: file_size FILE_NAME
function file_size() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FILE_NAME"
    echo
    return ${E_ARGS}
  fi

  # Necessary variables
  local filename="$1"

  # Check the size of the file
  if [ ! -s "${filename}" ]
  then
    echo
    echo "  ${filename} is empty."
    echo "  Exiting the script/workflow."
    echo
    exit ${E_ENTITY_ZERO_SIZE}
  fi
}

# Variables
LOCATION_TIMESTAMP="$1"
FILE_NAME_BASE="${LOCATION_TIMESTAMP}_HumidityTemperature_SensorData"
FILE_NAME_DAT="${FILE_NAME_BASE}.dat"
FILE_NAME_CSV="${FILE_NAME_BASE}.csv"
FILE_NAME_SQL="${FILE_NAME_BASE}.sql"
FILE_NAME_HTML="${FILE_NAME_BASE}.html"

# Sanity check/Input validation
file_existence ${FILE_NAME_DAT}
file_size      ${FILE_NAME_DAT}

# Header for CSV file
# The header naming convention is critical
# Snow_Celsius (or Snow_Fahrenheit) is used to read the color information
# stored in a Python variable called g_color_snow_celsius (or
# g_color_snow_fahrenheit)
cat << EOC > ${FILE_NAME_CSV}
Timestamp, Snow_Celsius, Snow_Fahrenheit
EOC

# Parse the DAT file and prepare CSV file
#   1. Dump/Display the contents of the file
#   2. Ignore the lines that start with # AND blank/empty lines
#   3. Retain columns (or fields) 3, 4 and 5 by using | as the field separator
#   4. Append the CSV file
cat ${FILE_NAME_DAT} | \
  sed -e 's/#.*$//' -e '/^$/d' | \
  awk -F '|' '{ print $3 ",  " $4 ",  " $5 }' >> ${FILE_NAME_CSV}
