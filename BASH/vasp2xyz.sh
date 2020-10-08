#! /bin/bash
# 
# BASH script to extract the atomic positions (xyz) from POSCAR and OUTCAR
# files of VASP and write them to an XYZ file - to be used with Jmol, MolDen
# and such other third-party programs. This script needs to be run from the
# same folder that contains POSCAR and OUTCAR files. The output file will be
# overwritten, if it exists.
#
# Usage:
# vasp2xyz.sh

# functions.sh
if [ -e "functions.sh" ]
then
  source functions.sh
fi

# Argument check
if [ $# -ne 1 ]
then
  echo
  echo "  Usage: $(basename $0) OUTPUT_FILE"
  echo "   e.g.: $(basename $0) OUTPUT.xyz"
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
  exit
fi

# Print initial summary
echo
echo "  Number of Atom Types   :" ${ATOM_TYPE_TOTAL}
echo "  Atom Type              :" ${ATOM_LABEL[@]}
echo "  Atom Type Count        :" ${ATOM_TYPE[@]}
echo "  Total Number of Atoms  :" ${ATOMS_TOTAL}
 
# ATOM_LABEL_2 is an array of atom labels
# with each atom label appearing an appropriate
# number of times, to a total of $ATOMS_TOTAL
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
    echo ${ATOM_LABEL_2[$l]} ${X} ${Y} ${Z} > Final.tmp.${FRAME_NUMBER}.${l}
    awk '{ printf "%-3s %12.8f %12.8f %12.8f\n", $1, $2, $3, $4 }' Final.tmp.${FRAME_NUMBER}.${l} >> ${OUTPUT_FILE}
    l=$(expr ${l} + 1)
  done<Final.tmp.${FRAME_NUMBER}
 
  FRAME_NUMBER=$(expr ${FRAME_NUMBER} + 1)
done

# Remove temporary files from prior runs
rm -f Final.tmp.* LINE_NUMBERS.tmp
