#! /bin/bash
# 
# BASH wrapper script to perform input validation, etc. prior to running
# Strava_CreateManualActivity.py. 
#
# Strava_CreateManualActivity.py requires Python3. To add additional parameters
# other than a title, start date/time and duration (in seconds), please review
# the script and Strava API documentation, and edit the scripts appropriately.
#
# Usage:
# Strava_CreateManualActivity.sh

# CommonFunctions.sh
if [ -e "CommonFunctions.sh" ]
then
  source "CommonFunctions.sh"
else
  echo
  echo "  This script needs CommonFunctions.sh to perform various tasks."
  echo "  Ensure CommonFunctions.sh and this script are in the same folder"
  echo "  OR update the path to CommonFunctions.sh."
  echo "  Exiting the script."
  echo
  exit
fi

# Argument check
if [ $# -ne 3 ]
then
  DATETIME=$(date +"%Y-%m-%dT%H:%M:%S+01:00")
  echo
  echo "  Usage: $(basename $0)  ACTIVITY_TITLE      ACTIVITY_START_DATETIME    ACTIVITY_DURATION"
  echo "   e.g.: $(basename $0)  \"Post-run Stretch\"  ${DATETIME}  3600"
  echo
  exit ${E_ARGS}
fi

# Save the argument(s) in local variable(s)
ACTIVITY_TITLE="$1"
ACTIVITY_START_DATETIME="$2"
ACTIVITY_DURATION="$3"

# Input validation
# It is assumed that a user enters appropriate values for ACTIVITY_TITLE and
# ACTIVITY_START_DATETIME
# TODO: Validate ACTIVITY_START_DATETIME
if ! validate_numeral ${ACTIVITY_DURATION}
then
  echo
  echo "  ACTIVITY_DURATION needs to be a sign-less non-negative integer."
  echo "  Invalid input. Exiting."
  echo
  return ${E_INPUT}
fi

# Run the python script
echo
echo "  Creating a manual activity with following details"
echo
echo "    Activity title           : ${ACTIVITY_TITLE}"
echo "    Activity start date/time : ${ACTIVITY_START_DATETIME}"
echo "    Activity duration        : ${ACTIVITY_DURATION} seconds"
python3 Strava_CreateManualActivity.sh "${ACTIVITY_TITLE}" "${ACTIVITY_START_DATETIME}" "${ACTIVITY_DURATION}"
echo
