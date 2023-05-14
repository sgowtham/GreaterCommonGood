# Strava_CreateManualActivity_InitialSetup.py
#
# Python3 script to perform the necessary initial setup. Successful completion
# will facilitate using Strava_CreateManualActivity.py. The following resource
# was found to be very useful in understanding Strava APIs and a Python
# workflow:
#
# https://medium.com/swlh/using-python-to-connect-to-stravas-api-and-analyse-your-activities-dummies-guide-5f49727aac86
#
#
# Complete the following steps prior to running this script.
#
#   1. Open a web browswer, log into your Strava account.
#
#   2. Open the following URL in a browser and create an API
#
#      https://www.strava.com/settings/api
#
#      I chase 'Personal Growth' as the 'Application Name'
#              'Performance Analysis' as the 'Category'
#              'Club' was left empty (optional)
#              'https://sgowtham.com' as the 'Website' (optional)
#              'Learning Python using Strava.' as the 'Activity Description'
#              'localhost' as the 'Authorization Callback Domain'
#
#   3. Upon successful creation of the API, note down the Client ID
#
#   4. Open the following URL in a browser (replace CLIENT_ID from step #3)
#
#      https://www.strava.com/oauth/authorize?client_id=CLIENT_ID&response_type=code&redirect_uri=http://localhost/exchange_token&approval_prompt=force&scope=read,read_all,profile:read_all,profile:write,activity:read,activity:read_all,activity:write
#
#   5. Authorize the application
#
#   6. From what looks like an error page, copy the value of the 'code' from the URL
#
#   7. Update the 'Necessary variables' section below
#
#   8. Save and close the file
#
#   9. Run the following command
#
#      python3 Strava_CreateManualActivity_InitialSetup.py


# Necessary libraries
import json
import pandas
import requests
import sys
import time

# Necessary variables
# Copy these over from https://www.strava.com/settings/api and from step #6
# above
strava_client_id     = ''
strava_client_secret = ''
strava_client_code   = ''

# Make Strava auth API call with client_id, client_secret and code
response = requests.post(
             url = 'https://www.strava.com/oauth/token',
             data = {
                      'client_id'    : strava_client_id,
                      'client_secret': strava_client_secret,
                      'code'         : strava_client_code,
                      'grant_type'   : 'authorization_code'
                    }
           )

# Save json response as a variable
strava_tokens = response.json()

# Save tokens to file
with open('Strava_CreateManualActivity.json', 'w') as outfile:
    json.dump(strava_tokens, outfile)

# Open JSON file and print the file contents to check it's worked properly
with open('Strava_CreateManualActivity.json') as check:
  strava_tokens = json.load(check)

print(strava_tokens)
