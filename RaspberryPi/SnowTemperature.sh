#! /bin/bash
# 
# BASH script to run SnowTemperature.py, and transfer the recorded data to a
# designated remote server for archival and post-processing purposes.
#
# Usage:
# SnowTemperature.sh

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
if [ $# -ne 2 ]
then
  echo
  echo "  Usage: $(basename $0) LOCATION      MAX_MEASUREMENTS"
  echo "   e.g.: $(basename $0) BendOR        100"
  echo "         $(basename $0) CableWI       100"
  echo "         $(basename $0) HoughtonMI    100"
  echo "         $(basename $0) MarquetteMI   100"
  echo "         $(basename $0) ParkCityUT    100"
  echo "         $(basename $0) TrondheimNOR  100"
  echo
  exit ${E_ARGS}
fi

# Necessary variables
POSCAR="POSCAR"
OUTCAR="OUTCAR"
OUTPUT_FILE="$1"
OUTPUT_FOLDER=$(dirname $(readlink -f ${OUTPUT_FILE}))

# Validate POSCAR, OUTCAR, OUTPUT_FILE and OUTPUT_FOLDER
check_existence ${POSCAR}
check_readable  ${POSCAR}
check_file      ${POSCAR}
check_existence ${OUTCAR}
check_readable  ${OUTCAR}
check_file      ${OUTCAR}
check_writable  ${OUTPUT_FOLDER}

# Remove output/temporary files from prior runs, if any
rm -f Final.tmp.* LINE_NUMBERS.tmp
rm -f ${OUTPUT_FILE}
 
# Atoms related information
# Extracted from POSCAR and OUTCAR
 
# Total number of atom types
declare -a ATOM_TYPE=($(sed -n '6 p' ${POSCAR}))
ATOM_TYPE_TOTAL=${#ATOM_TYPE[@]}
 
# Total number of atoms
ATOMS_TOTAL=0
i=0
while [[ "${i}" -lt "${ATOM_TYPE_TOTAL}" ]]
do
  iATOM_TYPE=${ATOM_TYPE[$i]}
  ATOMS_TOTAL=$(expr ${ATOMS_TOTAL} + ${iATOM_TYPE})
  i=$(expr ${i} + 1)
done
 
# Atom labels
declare -a ATOM_LABEL=($(grep "POTCAR:" ${OUTCAR} | \
                           head -${ATOM_TYPE_TOTAL} | \
                           awk '{print $3}' | \
                           sed -e 's/_.*//g'))
ATOM_LABEL_TOTAL=${#ATOM_LABEL[@]}
 
# Check if POSCAR and OUTCAR are from the same (or successfully completed)
# simulation
if [[ "${ATOM_TYPE_TOTAL}" -ne "${ATOM_LABEL_TOTAL}" ]]
then
  echo
  echo "  ERROR : Atom Type Total (${ATOM_TYPE_TOTAL}) does NOT"
  echo "          match Atom Label Count (${ATOM_LABEL_COUNT})."
  echo "  Please make sure OUTCAR and POSCAR are from the same"
  echo "  system and (successfully completed) simulation."
  echo 
  exit ${E_INPUT}
fi

# Print initial summary
echo
echo "  ${POSCAR} and ${OUTCAR} found"
echo "  ${OUTPUT_FILE} writable in ${OUTPUT_FOLDER}"
echo
echo "  Number of atom types   :" ${ATOM_TYPE_TOTAL}
echo "  Atom type(s)           :" ${ATOM_LABEL[@]}
echo "  Atom type count(s)     :" ${ATOM_TYPE[@]}
echo "  Total number of atoms  :" ${ATOMS_TOTAL}
 
# ATOM_LABEL_2 is an array of atom labels
# with each atom label appearing an appropriate
# number of times, to a total of ATOMS_TOTAL
declare -a ATOM_LABEL_2
REPEAT=0
j=0
 
while [[ "${j}" -lt "${ATOM_TYPE_TOTAL}" ]]
do
  k=1
 
  while [[ "${k}" -le "${ATOM_TYPE[${j}]}" ]]
  do
    REPEAT=$(expr ${REPEAT} + 1)
    k=$(expr ${k} + 1)
    ATOM_LABEL_2[${REPEAT}]=${ATOM_LABEL[${j}]}
  done
 
  j=$(expr ${j} + 1)
done
 
# Record the line numbers where coordinates are written
# in OUTCAR. Actual coordinates begin 2 lines below
# the recorded numbers
grep -n "POSITION" ${OUTCAR} | \
  sed -e 's/:/ /g' | \
  sed -e 's/POSITION.*//g' > LINE_NUMBERS.tmp
 
touch ${OUTPUT_FILE}
truncate -s0 ${OUTPUT_FILE}

FRAME_NUMBER=1
while read START
do
  START_HERE=$(expr ${START} + 2)
  END_HERE=$(expr ${START_HERE} + ${ATOMS_TOTAL} - 1)
 
  echo "${ATOMS_TOTAL}" >> ${OUTPUT_FILE}
  echo "# Frame Number: ${FRAME_NUMBER}" >> ${OUTPUT_FILE}
  sed -n "${START_HERE},${END_HERE} p" ${OUTCAR} | \
    awk '{printf "%12.8f %12.8f %12.8f\n", $1, $2, $3}' > Final.tmp.${FRAME_NUMBER}
 
  l=1
  while read X Y Z
  do
    echo "${ATOM_LABEL_2[${l}]} ${X} ${Y} ${Z}" > Final.tmp.${FRAME_NUMBER}.${l}
    awk '{ printf "%-3s %12.8f %12.8f %12.8f\n", $1, $2, $3, $4 }' Final.tmp.${FRAME_NUMBER}.${l} >> ${OUTPUT_FILE}
    l=$(expr ${l} + 1)
  done<Final.tmp.${FRAME_NUMBER}
 
  FRAME_NUMBER=$(expr ${FRAME_NUMBER} + 1)
done<LINE_NUMBERS.tmp

FRAMES_TOTAL=$(expr ${FRAME_NUMBER} - 1)
echo "  Total number of frames :" ${FRAMES_TOTAL}
echo

# Remove temporary files
rm -f Final.tmp.*
rm -f LINE_NUMBERS.tmp
