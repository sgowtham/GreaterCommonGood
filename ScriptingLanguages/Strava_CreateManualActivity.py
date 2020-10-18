# Strava_CreateManualActivity.py
#
# Python3 script to create a manual activity in Strava. Review and run
# Strava_CreateManualActivity_InitialSetup.py before proceeding ahead. Use the
# wrapper BASH script, Strava_CreateManualActivity.sh, as it will perform
# necessary input validations and prevent unintended result or unnecessary
# frustrations.
#
# The following resources were found to be very useful in understanding Strava
# APIs and a Python workflow:
#
# https://medium.com/swlh/using-python-to-connect-to-stravas-api-and-analyse-your-activities-dummies-guide-5f49727aac86
# https://www.youtube.com/watch?v=2FPNb1XECGs
#
# Usage:
# Strava_CreateManualActivity.sh

# Necessary libraries
import json
import pandas
import requests
import sys
import time

# Necessary variables
# Copy these over from https://www.strava.com/settings/api
strava_client_id     = ''
strava_client_secret = ''

# Save the argument(s) as local variable(s)
activity_title          = sys.argv[1];
activity_start_datetime = sys.argv[2];
activity_duration       = sys.argv[3];

# Additional variables necessary to create the manual activity
activity_description = 'PLACEHOLDER DESCRIPTION - update if necessary.'
activity_type        = 'workout',
activity_distance    = '0.00'
activity_trainer     = '10'
activity_commute     = '10'

# Get the tokens from file to connect to Strava
with open('Strava_CreateManualActivity.json') as json_file:
  strava_tokens = json.load(json_file)

# If access_token has expired, then use the refresh_token to get the new
# access_token
if strava_tokens['expires_at'] < time.time():
  response = requests.post(
               url = 'https://www.strava.com/oauth/token',
               data = {
                        'client_id'     : strava_client_id,
                        'client_secret' : strava_client_secret,
                        'grant_type'    : 'refresh_token',
                        'refresh_token' : strava_tokens['refresh_token']
                      }
             )

  # Save response as json in new variable
  new_strava_tokens = response.json()

  # Save new tokens to a file
  with open('Strava_CreateManualActivity.json', 'w') as outfile:
    json.dump(new_strava_tokens, outfile)

  # Use new Strava tokens
  strava_tokens = new_strava_tokens

# Create the manual activity
access_token = strava_tokens['access_token']
activity_url = 'https://www.strava.com/api/v3/activities'
header       = { 'Authorization': 'Bearer ' + access_token }
payload      = {
                 'name'             : activity_title,
                 'description'      : activity_description,
                 'type'             : activity_type,
                 'start_date_local' : activity_start_datetime,
                 'elapsed_time'     : activity_duration,
                 'distance'         : activity_distance,
                 'trainer'          : activity_trainer,
                 'commute'          : activity_commute
               }

try:
  new_activity = requests.post(activity_url, headers=header, data=payload).json()

  # Uncomment the line below for debugging
  # print(new_activity)
except requests.ConnectionError as e:
  print("  Unable to create the manual activity.")
  print("  Detailed error message below.\n")
  print(str(e))
  print("")
