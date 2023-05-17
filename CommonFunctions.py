# CommonFunctions.py
#
# Commonly used entities by various python scripts.
#
# Usage:
# from CommonFunctions import *

# Necessary libraries
from lxml import html
from bs4 import BeautifulSoup
from re import search
import urllib.request as request
import colorsys
import datetime
import time
import re
import os
import sys
import random
import math
import numpy as np
import pandas as pd
import plotly.express as px
import plotly.figure_factory as ff
import plotly.graph_objects as go

# https://gist.github.com/bobspace/2712980
# Customized
colors = [
  "Aqua",
  "Aquamarine",
  "Beige",
  "Bisque",
  "BlanchedAlmond",
  "BlueViolet",
  "Brown",
  "BurlyWood",
  "CadetBlue",
  "Chartreuse",
  "Chocolate",
  "Coral",
  "CornflowerBlue",
  "Crimson",
  "Cyan",
  "DarkBlue",
  "DarkCyan",
  "DarkGoldenRod",
  "DarkGray",
  "DarkGreen",
  "DarkKhaki",
  "DarkMagenta",
  "DarkOliveGreen",
  "DarkOrange",
  "DarkOrchid",
  "DarkRed",
  "DarkSalmon",
  "DarkSeaGreen",
  "DarkSlateBlue",
  "DarkSlateGray",
  "DarkSlateGrey",
  "DarkTurquoise",
  "DarkViolet",
  "DeepPink",
  "DeepSkyBlue",
  "DimGrey",
  "DodgerBlue",
  "FireBrick",
  "ForestGreen",
  "Fuchsia",
  "Gainsboro",
  "Gold",
  "GoldenRod",
  "Gray",
  "Grey",
  "Green",
  "GreenYellow",
  "IndianRed",
  "Indigo",
  "Khaki",
  "Lavender",
  "LawnGreen",
  "LightBlue",
  "LightCoral",
  "LightCyan",
  "LightGray",
  "LightGreen",
  "LightPink",
  "LightSalmon",
  "LightSeaGreen",
  "LightSkyBlue",
  "LightSlateGray",
  "LightSteelBlue",
  "Lime",
  "LimeGreen",
  "Maroon",
  "MediumAquaMarine",
  "MediumBlue",
  "MediumOrchid",
  "MediumPurple",
  "MediumSeaGreen",
  "MediumSlateBlue",
  "MediumSpringGreen",
  "MediumTurquoise",
  "MediumVioletRed",
  "MidnightBlue",
  "MistyRose",
  "Moccasin",
  "Navy",
  "OldLace",
  "Olive",
  "OliveDrab",
  "Orange",
  "OrangeRed",
  "Orchid",
  "PaleGoldenRod",
  "PaleGreen",
  "PaleTurquoise",
  "PaleVioletRed",
  "PeachPuff",
  "Peru",
  "Pink",
  "Plum",
  "PowderBlue",
  "Purple",
  "RebeccaPurple",
  "RosyBrown",
  "RoyalBlue",
  "SaddleBrown",
  "SandyBrown",
  "SeaGreen",
  "Sienna",
  "Silver",
  "SkyBlue",
  "SlateBlue",
  "SlateGrey",
  "SpringGreen",
  "SteelBlue",
  "Tan",
  "Teal",
  "Thistle",
  "Tomato",
  "Turquoise",
  "Violet",
  "YellowGreen",
]

# Randomize the colors array
# random.shuffle(colors)

# Function: seconds2hhmmss()
def seconds2hhmmss(seconds):
  m, s = divmod(seconds, 60)
  h, m = divmod(m, 60)

  if seconds >= 3600:
    return f"{h:d}:{m:02d}:{s:02d}"
  else:
    return f"{m:d}:{s:02d}"

# Function to convert decimal time to h:mm:ss
def time_decimal2hhmmss(decimal_time):
  hours   = int(decimal_time)
  minutes = (decimal_time*60) % 60
  seconds = (decimal_time*3600) % 60

  hhmmss = print("%d:%02d:%02d" % (hours, minutes, seconds))

  return hhmmss

# Function: rgb2hex()
# Converter using output from colorsys.hls_to_rgb
def rgb2hex(red, green, blue):
  return "#{:02x}{:02x}{:02x}".format(int(red * 255), int(green * 255), int(blue * 255))

## Plotly Parameters
#
g_config = {
             'displayModeBar'         : True,
             'modeBarButtonsToRemove' : ['toImage']
           }
#
g_title_x              = 0.50
g_title_font_color     = 'DarkSlateGray'
g_title_font_size      = 15
#
g_xaxis_tickangle      = -45
g_xaxis_titlefont_size = 12
g_xaxis_tickfont_size  = 10
#
g_yaxis_titlefont_size = 12
g_yaxis_tickfont_size  = 10
#
g_hovermode            = 'x unified'
#
g_plot_bgcolor         = 'white'
#
g_xaxes_linewidth      = 2
g_xaxes_linecolor      = '#cccccc'
g_xaxes_gridwidth      = 0.50
g_xaxes_gridcolor      = '#cccccc'
#
g_yaxes_linewidth      = 2
g_yaxes_linecolor      = '#cccccc'
g_yaxes_gridwidth      = 0.50
g_yaxes_gridcolor      = '#cccccc'
#
# https://plotly.com/python/reference/scatter/#scatter-marker-symbol
g_marker_size_single = 9
g_marker_size_trend  = 3
g_line_width_single  = 7
g_line_width_trend   = 1
#
g_bargap      = 0.25
g_bargroupgap = 0.15
g_hole        = 0.35

