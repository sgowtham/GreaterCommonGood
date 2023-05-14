# ds18b20_temperature.py
#
# Python script to read and store the data from DS18B20 temperature sensor
# in Raspberry Pi 3 Model B (circa 2015).
#
# Usage:
# python3 ds18b20_temperature.py LOCATION
#
# If a LIBRARY is missing, the following command may be used to install it:
# python3 -m pip install LIBRARY

# Necessary libraries
import datetime
import glob
import math
import numpy as np
import os
import random
import re
import sys
import time

# Argument check
if len(sys.argv) != 2:
  print("")
  print("  Usage: python3 " + sys.argv[0] + " LOCATION")
  print("   e.g.: python3 " + sys.argv[0] + " BendOR")
  print("         python3 " + sys.argv[0] + " CableWI")
  print("         python3 " + sys.argv[0] + " HoughtonMI")
  print("         python3 " + sys.argv[0] + " MarquetteMI")
  print("         python3 " + sys.argv[0] + " ParkCityUT")
  print("         python3 " + sys.argv[0] + " TrondheimNO")
  print("")
  sys.exit()

# System operations (if necessary)
os.system('sudo modprobe w1-gpio')
os.system('sudo modprobe w1-therm')

# Variables
location  = sys.argv[1]

# Necessary functions

# List of DS18B20 sensors
# Files related to any given DS18B20 sensor reside in a folder that has the
# following naming format: 28-030497940a6a 
# '28-' is common to all DS18B20 sensors (when multiple are wired in) and that
# the '28-*' folder resides under '/sys/bus/w1/devices/' in Raspberry Pi.
# If no sensor is detected, stop the workflow with a helpful error message
def sensor():
  device_location = '/sys/bus/w1/devices/'
  ds18b20_sensors = glob.glob(device_location + '28*')
  if len(ds18b20_sensors) > 0:
    for i in glob.glob(device_location + '28*'):
      ds18b20 = i.split("/")[-1]
      print(ds18b20)
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
def read(ds18b20):

  # DS18B20 stores temperature for each sensor in a file called 'w1_slave'
  # Read the contents of this file and close
  file_name_sensor     = '/sys/bus/w1/devices/' + ds18b20 + '/w1_slave'
  file_handle_sensor   = open(file_name_sensor)
  file_contents_sensor = file_handle_sensor.read()
  file_handle_sensor.close()

  # The releavant information is in the second line of this file
  second_line      = file_contents_sensor.split("\n")[1]
  temperature_data = second_line.split(" ")[9]
  temperature      = float(temperature_data[2:])

  celsius    = temperature / 1000
  fahrenheit = (celsius * 1.8) + 32

  return celsius, fahrenheit

# Keep looping through every 3 seconds and process the data
def loop(ds18b20):

  # Open the file for recording data
  # If a file by the same name exists, the contents will be overwritten
  date_time      = datetime.datetime.now()
  date_time      = date_time.strftime("%Y%m%d_%H%M%S")
  file_name_data = open("%s_%s_SnowTemperature.dat" % (location, date_time), "w")

  # Comment the print statements below to save some resoures, if need be
  print("")
  print("# Filename : %s_%s_SnowTemperature.dat" % (location, date_time))
  print("# Sensor   : DS18B20 w/ Raspberry Pi 3 Model B")
  print("# Format   : ID, Time Stamp, Celsius, Fahrenheit")
  print("#            Fields are separated by the | character")
  print("")

  # Header information (entered as comments)
  file_name_data.write("#\n")
  file_name_data.write("# Filename : %s_%s_SnowTemperature.dat\n" % (location, date_time))
  file_name_data.write("# Sensor   : DS18B20 w/ Raspberry Pi 3 Model B\n")
  file_name_data.write("# Format   : ID, Time Stamp, Celsius, Fahrenheit\n")
  file_name_data.write("#            Fields are separated by the | character\n")
  file_name_data.write("#\n")

  # Set the counter (used to break out of the loop after counter_max
  # measurements)
  counter     = 0
  counter_max = 1000

  while True:
    if read(ds18b20) != None:
      # Increment the counter
      counter = counter + 1

      # Capture the current time stamp and temperature
      date_time  = datetime.datetime.now()
      date_time  = date_time.strftime("%Y-%m-%d %H:%M:%S")
      celsius    = read(ds18b20)[0]
      fahrenheit = read(ds18b20)[1]

      # Comment the Terminal display to save some resoures, if need be
      print("%04d|%19s|%06.3f|%06.3f" % (counter, date_time, celsius, fahrenheit))

      # Record the data in the file
      file_name_data.write("%04d|%19s|%06.3f|%06.3f\n" % (counter, date_time, celsius, fahrenheit))

      # Pause/Sleep for 3 seconds
      time.sleep(3)

      # If counter_max measurements have been made, then stop the program
      if counter == counter_max:

        # Comment the print statements below to save some resoures, if need be
        print("")
        print("# %d measurements have been recorded" % (counter_max))
        print("# Recording will be stopped and the program will terminate")
        print("")

        # Close the file and terminate the program
        file_name_data.close()
        kill()

# Termination
def kill():
  quit()

# Start the main program
# Include handling when CTRL+C key combination is pressed to terminate
if __name__ == '__main__':
  try:
    serialNum = sensor()
    loop(serialNum)
  except KeyboardInterrupt:
    kill()
