# HumidityTemperature_SensorData.py
#
# Python script to read from the DS18B20 temperature sensor in Raspberry Pi 3
# Model B V1.2 (circa 2015). The measurements are saved in a meaningfully named
# file (e.g., LOCATION_TIMESTAMP_HumidityTemperature_SensorData.dat) and
# transferred to a designated remote server for archival and post-processing
# purposes. 
#
# TODO:
# Use sensor_id in the filename, if need be (when multiple sensors are used),
# and remove the sensor_id column from the recorded data
#
# Usage:
# python3 ./HumidityTemperature_SensorData.py LOCATION COUNTER_MAX
#
# If a Python LIBRARY is missing, the following command may be used:
# python3 -m pip install LIBRARY

# Variables (edit if/when necessary)
# sleep_timer represents the number of seconds between successive measurements
# Raspberry Pi and the sensor take 2-3 additional seconds making the interval
# between measurements approximately 1 minute
# remote_username and remote_server represent the credentials of the designated
# remote server which will host the recorded data for archival and
# post-processing purposes. The setup assumes that passwordless data transfer
# is configured/enabled between the RaspberryPi and remote server using the 
# SSH keys
sleep_timer     = 55
remote_username = "sgowtham"
remote_server   = "sgowtham.com"
remote_folder   = "/var/www/sgowtham/assets/analytics/RaspberryPi/"
remote_website  = "https://sgowtham.com/assets/analytics/RaspberryPi"
github_repo     = "https://github.com/sgowtham/GreaterCommonGood/"
remote_details  = str(remote_username) + '@' + str(remote_server) + ':' + str(remote_folder)


# PLEASE DO NOT EDIT BELOW THIS LINE UNLESS THERE IS AN ABSOLUTE NEED

# Necessary libraries
import datetime
import glob
import math
import numpy as np
import os
import random
import re
import subprocess
import sys
import time

# Argument check
if len(sys.argv) != 3:
  print("")
  print("  Usage: python3 " + sys.argv[0] + " LOCATION      COUNTER_MAX")
  print("   e.g.: python3 " + sys.argv[0] + " BendOR        100")
  print("         python3 " + sys.argv[0] + " CableWI       100")
  print("         python3 " + sys.argv[0] + " HoughtonMI    100")
  print("         python3 " + sys.argv[0] + " MarquetteMI   100")
  print("         python3 " + sys.argv[0] + " ParkCityUT    100")
  print("         python3 " + sys.argv[0] + " TrondheimNOR  100")
  print("")
  sys.exit()

# Additional variables
# location is used in creating a file to store the recordings
# counter_max represents the number of measurements - taken approximately once
# every minute
# device_location is where external sensor data is stored in Raspeberry Pi
# date_time is the timestamp used for uniquely naming the file that stores the
# measurements
location        = str(sys.argv[1])
counter_max     = int(sys.argv[2])
device_location = '/sys/bus/w1/devices/'
date_time       = datetime.datetime.now()
date_time       = date_time.strftime("%Y%m%d_%H%M%S")

# Open the file for recording data
# Given that the file_name uses the timestamp (including seconds) and since any
# given attempt of this workflow takes more than one second to run/complete, it
# is unlikely that any two runs will have the exact same file_name
file_name        = str(location) + '_' + str(date_time) + '_HumidityTemperature_SensorData.dat' 
file_touch_time  = date_time[:-2]
file_touch_time  = file_touch_time.replace("_", "")
file_name_handle = open(file_name, "w")


# Function declarations

# List of DS18B20 sensors
# Files related to any given DS18B20 sensor reside in a folder that has the
# following naming format: 28-030497940a6a 
# '28-' is common to all DS18B20 sensors (when multiple are wired in) and that
# the '28-*' folder resides under '/sys/bus/w1/devices/' in Raspberry Pi.
# If no sensor is detected, stop the workflow with a helpful error message
# TODO:
# Test with multiple DS18B20 sensors
def detect_sensor():
  ds18b20_sensors = glob.glob(device_location + '28*')
  if len(ds18b20_sensors) > 0:
    for sensor in glob.glob(device_location + '28*'):
      ds18b20 = sensor.split("/")[-1]
      # Uncomment the line below for debugging purposes only
      # print(ds18b20)
    return ds18b20
  else:
    print("")
    print("")
    print("  DS18B20 sensor was not detected in %s" % device_location)
    print("  Exiting the workflow")
    print("")
    print("  Following steps might help before the next attempt")
    print("    1. Check the sensor(s) and connections")
    print("    2. Reboot the Raspberry Pi")
    print("")
    print("")
    sys.exit()

# Read the temperature data (in Celsius) from the sensor's 'w1_slave' file and
# convert it to Fahrenheit
def read_temperature(ds18b20):

  # DS18B20 stores temperature for each sensor in a file called 'w1_slave'
  # Read the contents of this file and close
  sensor_id            = str(ds18b20)
  file_name_sensor     = '/sys/bus/w1/devices/' + str(sensor_id) + '/w1_slave'
  file_handle_sensor   = open(file_name_sensor)
  file_contents_sensor = file_handle_sensor.read()
  file_handle_sensor.close()

  # The releavant information is in the second line of 'w1_slave' file
  # The 10th field in the second line when separated by space looks like t=#####
  # ##### in t-##### is the temperature data we desire/need
  # ##### is extracted from t-####, converted to a floating-point number for
  # further processing
  second_line      = file_contents_sensor.split("\n")[1]
  temperature_data = second_line.split(" ")[9]
  temperature      = float(temperature_data[2:])

  # Convert the temperature above to Celsius, and then to Fahrenheit
  celsius    = temperature / 1000
  fahrenheit = (celsius * 1.8) + 32

  # Return the values of celsius and fahrenheit
  return celsius, fahrenheit

# Keep looping through every sleep_timer seconds and process the data
def read_record_rest_repeat(ds18b20):

  # Sensor's ID
  sensor_id = str(ds18b20)

  # Comment the print statements below to save some resoures, if need be
  print("")
  print("# Filename  : %s" % (file_name))
  print("# Sensor    : DS18B20 w/ Raspberry Pi 3 Model B V1.2 (circa 2015)")
  print("# Sensor ID : %s" % sensor_id)
  print("# Format    : Measurement ID, Sensor ID, Time Stamp, Celsius, Fahrenheit")
  print("#             Fields are separated by the | character")
  print("#")
  print("# Upon successful completion, the recording may be viewed at")
  print("# %s/%s" % (remote_website, file_name))
  print("#")
  print("# and under the RaspberryPi folder at the following public GitHub repository")
  print("# %s" % (github_repo))
  print("")
  print("")

  # Header information (entered as comments)
  file_name_handle.write("#\n")
  file_name_handle.write("# Filename  : %s\n" % (file_name))
  file_name_handle.write("# Sensor    : DS18B20 w/ Raspberry Pi 3 Model B V1.2 (circa 2015)\n")
  file_name_handle.write("# Sensor ID : %s\n" % sensor_id)
  file_name_handle.write("# Format    : Measurement ID, Sensor ID, Time Stamp, Celsius, Fahrenheit\n")
  file_name_handle.write("#             Fields are separated by the | character\n")
  file_name_handle.write("#\n")
  file_name_handle.write("# Upon successful completion, the file may be viewed at\n")
  file_name_handle.write("# %s/%s\n" % (remote_website, file_name))
  file_name_handle.write("#\n")
  file_name_handle.write("# and at the following public GitHub repository\n")
  file_name_handle.write("# %s\n" % (github_repo))
  file_name_handle.write("#\n")

  # Initiate the counter
  counter = 0

  # Run the loop indefinitely (or in other words, until counter_max number of 
  # measurements have been recorded OR until CTRL+C is pressed)
  while True:
    if read_temperature(ds18b20) != None:
      # Increment the counter
      counter = counter + 1

      # Set the current timestamp and temperature
      date_time  = datetime.datetime.now()
      date_time  = date_time.strftime("%Y-%m-%d %H:%M:%S")
      celsius    = read_temperature(ds18b20)[0]
      fahrenheit = read_temperature(ds18b20)[1]

      # Comment the Terminal display to save some resoures, if need be
      print("%04d|%s|%19s|%07.3f|%07.3f" % (counter, sensor_id, date_time, celsius, fahrenheit))

      # Record the data in the file
      file_name_handle.write("%04d|%s|%19s|%07.3f|%07.3f\n" % (counter, sensor_id, date_time, celsius, fahrenheit))

      # Pause/Sleep for sleep_timer seconds
      time.sleep(sleep_timer)

      # Once every 5 measurements (i.e., approximately 5 minutes), save the data
      # to the hard drive to prevent loss of recorded measurements in case of an
      # accidental power outage (or other such scenario)
      if counter % 5 == 0:
        file_name_handle.flush()

      # If counter_max measurements have been made, then stop the program
      if counter == counter_max:

        # Comment the print statements below to save some resoures, if need be
        print("")
        print("# %d measurements have been recorded" % (counter_max))
        print("# Recording will stopp and the program will terminate after")
        print("# trasnferring the file to a designated remote server for")
        print("# archival and post-processing purposes")
        print("")

        # Close the file
        file_name_handle.close()

        # Change the file_name's timestamp and transfer the data
        # The second and third rsync commands do not transfer anything unless
        # the first (or second) rsync command transferred partial data for some
        # reason
        os.system('touch -t %s %s' % (file_touch_time, file_name))
        os.system('rsync -ave ssh -hPz %s %s' % (file_name, remote_details))
        os.system('rsync -ave ssh -hPz %s %s' % (file_name, remote_details))
        os.system('rsync -ave ssh -hPz %s %s' % (file_name, remote_details))

        # Terminate the program
        time.sleep(1)
        quit()

# Start the main program
# Include handling when CTRL+C is pressed to terminate
if __name__ == '__main__':

  try:
    # Gather the sensor's ID
    sensor_id = detect_sensor()

    # Run the loop to gather measurements
    read_record_rest_repeat(sensor_id)

  except KeyboardInterrupt:
    # Close the file
    file_name_handle.close()

    # Change the file_name's timestamp and transfer the data
    # The second and third rsync commands do not transfer anything unless the
    # first (or second) rsync command transferred partial data for some reason
    os.system('touch -t %s %s' % (file_touch_time, file_name))
    os.system('rsync -ave ssh -hPz %s %s' % (file_name, remote_details))
    os.system('rsync -ave ssh -hPz %s %s' % (file_name, remote_details))
    os.system('rsync -ave ssh -hPz %s %s' % (file_name, remote_details))

    # Terminate the program
    time.sleep(1)
    quit()
