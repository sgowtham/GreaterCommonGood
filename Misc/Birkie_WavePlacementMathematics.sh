#! /bin/bash
#
# Computes Percentage Back Equivalency (PBE) given 
#   - winner's time
#   - my time
#   - event adjustment factor
#
# Usage:
# Birkie_WavePlacementMathematics.sh

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

# show_help()
function show_help() {
  echo
  echo "  Usage: $(basename $0) WINNER_TIME MY_TIME EVENT_ADJUSTMENT_FACTOR"
  echo "   e.g.: $(basename $0) 2:00:00     2:36:00 +8"
  echo
  echo "  Wave Placement Qualifer Races:"
  echo "    https://www.birkie.com/ski/events/birkie/"
  echo "    https://www.birkie.com/ski/events/qualifier-races/"
  echo
}

# Argument check
if [ $# -ne 3 ]
then
  show_help
  exit ${E_ARGS}
fi

# Necessary variables
TIME_WINNER="$1"
TIME_MINE="$2"
EVENT_ADJUSTMENT_FACTOR="$3"
PBE="0"

# Compute Percentage Back Equivalency (PBE)
MINUTES_WINNER=$(hms2minutes ${TIME_WINNER})
MINUTES_WINNER=$(printf "%03d" "${MINUTES_WINNER}")
MINUTES_MINE=$(hms2minutes ${TIME_MINE})
MINUTES_MINE=$(printf "%03d" "${MINUTES_MINE}")
PERCENTAGE_BACK=$(echo "((${MINUTES_MINE} - ${MINUTES_WINNER})/${MINUTES_WINNER}) * 100" | bc -l)
PERCENTAGE_BACK=$(printf "%.2f" "${PERCENTAGE_BACK}")
EVENT_ADJUSTMENT_FACTOR=$(printf "%d" "${EVENT_ADJUSTMENT_FACTOR}")

if [ ${EVENT_ADJUSTMENT_FACTOR} -gt 0 ]
then
  PBE=$(echo "${PERCENTAGE_BACK} + ${EVENT_ADJUSTMENT_FACTOR}" | bc -l)
else
  PBE=$(echo "${PERCENTAGE_BACK} + 0 ${EVENT_ADJUSTMENT_FACTOR}" | bc -l)
fi
PBE=$(printf "%.2f" "${PBE}")

echo
echo "  1. Winner's Time                    : ${TIME_WINNER} = ${MINUTES_WINNER} minutes"
echo "  2. My Time                          : ${TIME_MINE} = ${MINUTES_MINE} minutes"
echo "  3. Percentage Back, PB              : [(${MINUTES_MINE} - ${MINUTES_WINNER})/${MINUTES_WINNER}] * 100 = ${PERCENTAGE_BACK}%"
echo "  4. Event Adjustment Factor, EAF     : ${EVENT_ADJUSTMENT_FACTOR}%"
echo "  5. Percentage Back Equivalency, PBE : PB + EAF = ${PERCENTAGE_BACK}% + ${EVENT_ADJUSTMENT_FACTOR}% = ${PBE}%"
echo
echo "  Birkie : https://www.birkie.com/ski/events/birkie/#wave-placement"
echo "  Korte  : https://www.birkie.com/ski/events/kortelopet/#wave-placement"
echo
echo
