# ds18b20_temperature.py
#
# Python script to read and store the data from DS18B20 temperature sensor
# in Raspberry Pi 3 Model B (circa 2015).
#
# Usage:
# python3 ds18b20_temperature.py

# Necessary libraries
# If a LIBRARY is missing, the following command may be used to install it:
# python3 -m pip install LIBRARY
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
# TODO
# Accept an argument which could be the LOCATION (alphabets only)
if len(sys.argv) > 1:
  print("")
  print("  Usage:")
  print("  python3 " + sys.argv[0])
  # print("  python3 " + sys.argv[0] + " Season")
  print("")
  sys.exit()

# Necessary functions
def sensor():
  for i in os.listdir('/sys/bus/w1/devices'):
    if i != 'w1_bus_master1':
      ds18b20 = i
  return ds18b20

# Read the temperature from the 'location' where the sensor stores the
# temperature data (in Celsius) and convert it to Fahrenheit
def read(ds18b20):
  location = '/sys/bus/w1/devices/' + ds18b20 + '/w1_slave'
  tfile    = open(location)
  text     = tfile.read()
  tfile.close()
  second_line      = text.split("\n")[1]
  temperature_data = second_line.split(" ")[9]
  temperature      = float(temperature_data[2:])
  celsius          = temperature / 1000
  fahrenheit       = (celsius * 1.8) + 32
  return celsius, fahrenheit

# Keep looping through every 3 seconds and process the data
def loop(ds18b20):

  # Open the file for recording data
  # If a file by the same name exists, the contents will be overwritten
  file_name = open("ds18b20_temperature.dat", "w")

  # Set the counter (maybe of use to break out of the loop)
  counter = 0
  print("")
  print("# --------------------------------------------------")
  print("#   ####  YYYY-MM-DD hh:mm:ss  CELSIUS  FAHRENHEIT")
  print("# --------------------------------------------------")
  while True:
    if read(ds18b20) != None:
      counter       = counter + 1
      cdatetime     = datetime.datetime.now()
      cdatetime_hrf = cdatetime.strftime("%Y-%m-%d %H:%M:%S")
      celsius       = read(ds18b20)[0]
      fahrenheit    = read(ds18b20)[1]
      print("%04d|%19s|%06.3f|%06.3f" % (counter, cdatetime_hrf, celsius, fahrenheit))
      file_name.write("%04d|%19s|%06.3f|%06.3f" % (counter, cdatetime_hrf, celsius, fahrenheit))
      time.sleep(3)

def kill():
  quit()

if __name__ == '__main__':
  try:
    serialNum = sensor()
    loop(serialNum)
  except KeyboardInterrupt:
    kill()
