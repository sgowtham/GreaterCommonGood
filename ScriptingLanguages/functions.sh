# functions.sh
#
# User-defined functions are stored in this file. This is a READ-WRITE file,
# and may be modified to fit specific needs. If this file is edited and saved,
# run the following command to bring the changes into effect in the same
# Terminal. Alternatively, this file can be sourced from ${HOME}/.bashrc so
# that changes are in automatically effect every time a new Terminal is opened.
#
# The variables whose scope is limited to the definition of the function they
# are part of is declared in lowercase alphabets.
#
# source functions.sh

# Exit/Error/Return codes (64 - 113)
# Number of arguments, input validation and files (64 - 69)
export E_SUCCESS=0
export E_ARGS=64
export E_INPUT=65
export E_ENTITY_MISSING=66
export E_ENTITY_ZERO_SIZE=67
export E_ENTITY_USELESS=68
export E_ENTITY_PERMISSION=69
#
# Software installation/compilation (70 - 79)
export E_EASYBUILD=70
export E_COMPILE=71
export E_COMPRESS=72
export E_UNCOMPRESS=72
export E_CONFIGURE=73
export E_EXECUTE=74
export E_INSTALL=75
export E_MAKE=76
export E_MISSING_CMD=77
export E_MISSING_LIB=78
export E_INTEGRITY=79
# 
# LaTeX and gnuplot (80 - 89)
export E_BIBTEX=80
export E_DVIPDF=81
export E_DVIPS=82
export E_LATEX=83
export E_MKINDEX=84
export E_PDFLATEX=85
export E_PS2PDF=86
export E_GNUPLOT=87
#
# Git (90 - 99)
export E_GIT_ADD=90
export E_GIT_BRANCH=91
export E_GIT_CHECKOUT=92
export E_GIT_CLONE=93
export E_GIT_COMMIT=94
export E_GIT_FETCH=95
export E_GIT_PULL=96
export E_GIT_PUSH=97
export E_GIT_REPO=98
export E_GIT_RM=99
export E_GIT_STATUS=100
export E_GIT_TAG=101
#
# Miscellaneous (105 - 113)
export E_DUPLICATE=109
export E_PATH=110
export E_PING=112
export E_LOCK=112
export E_ROOT=113

## BEGIN: hello, world!

# hello_world()
# Print "Hello, World" and a user-supplied string
function hello_world() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} STRING"
    echo "   e.g.: ${FUNCNAME} eleanor"
    echo "         ${FUNCNAME} george"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local user_name="$1"

  # Print the result
  echo
  echo "  Hello, World."
  echo "  Username is ${user_name}"
  echo
}
export -f hello_world

## END: hello, world!

## BEGIN: String operations

# validate_alphabet()
# Checks if a string contains only alphabetic characters
function validate_alphabet() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} ALPHABETICAL_STRING"
    echo "   e.g.: ${FUNCNAME} Eleanor"
    echo "         ${FUNCNAME} George"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Regular expression pattern for alphabets
  # ^         : beginning of the string
  # [a-zA-Z]+ : one or more occurrences of a-z or A-Z
  # $         : end of the string
  local regexpr_pattern='^[a-zA-Z]+$'

  # Check the original_string against regexpr_pattern
  if [[ ${original_string} =~ ${regexpr_pattern} ]]
  then
    return 0          # Valid user input
  else
    return ${E_INPUT} # Invalid user input
  fi
}
export -f validate_alphabet

# validate_numeral()
# Checks if a string contains only numerals
function validate_numeral() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} NUMERAL_STRING"
    echo "   e.g.: ${FUNCNAME} 12345"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Regular expression pattern for numerals
  # ^     : beginning of the string
  # [0-9] : 0, 1, 2, 3, 4, 5, 6, 7, 8 or 9
  # +     : one or more occurrence of the previous pattern (i.e., [0-9])
  # $     : end of the string
  local regexpr_pattern='^[0-9]+$'

  # Check the original_string against the regexpr_pattern
  if [[ ${original_string} =~ ${regexpr_pattern} ]]
  then
    return 0          # Valid user input
  else
    return ${E_INPUT} # Invalid user input
  fi
}
export -f validate_numeral

# validate_integer()
# Checks if a string contains only integers
function validate_integer() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} INTEGER"
    echo "   e.g.: ${FUNCNAME} 100"
    echo "         ${FUNCNAME} 0"
    echo "         ${FUNCNAME} -2000"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Regular expression pattern for integers
  # ^     : beginning of the string
  # [+-]  : + or - sign
  # ?     : zero or one occurrence of the previous pattern (i.e., +/-)
  # [0-9] : 0, 1, 2, 3, 4, 5, 6, 7, 8 or 9
  # +     : one or more occurrence of the previous pattern (i.e., [0-9])
  # $     : end of the string
  local regexpr_pattern='^[+-]?[0-9]+$'

  # Check the original_string against the regexpr_pattern
  if [[ ${original_string} =~ ${regexpr_pattern} ]]
  then
    return 0          # Valid user input
  else
    return ${E_INPUT} # Invalid user input
  fi
}
export -f validate_integer

# validate_ninteger()
# Checks if a string contains only negative integers
function validate_ninteger() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} NEGATIVE_INTEGER"
    echo "   e.g.: ${FUNCNAME} -1"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Regular expression pattern for integers
  # ^     : beginning of the string
  # -     : - sign
  # [0-9] : 0, 1, 2, 3, 4, 5, 6, 7, 8 or 9
  # +     : one or more occurrence of the previous pattern (i.e., [0-9])
  # $     : end of the string
  local regexpr_pattern='^-[0-9]+$'

  # Check the original_string against the regexpr_pattern
  if [[ ${original_string} =~ ${regexpr_pattern} ]]
  then
    return 0          # Valid user input
  else
    return ${E_INPUT} # Invalid user input
  fi
}
export -f validate_ninteger

# validate_pinteger()
# Checks if a string contains only positive integers
function validate_pinteger() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} POSITIVE_INTEGER"
    echo "   e.g.: ${FUNCNAME} 0"
    echo "         ${FUNCNAME} +1"
    echo "         ${FUNCNAME} 100"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Regular expression pattern for integers
  # ^     : beginning of the string
  # [+]   : + sign
  # ?     : zero or one occurrence of the previous pattern (i.e., +)
  # [0-9] : 0, 1, 2, 3, 4, 5, 6, 7, 8 or 9
  # +     : one or more occurrence of the previous pattern (i.e., [0-9])
  # $     : end of the string
  local regexpr_pattern='^[+]?[0-9]+$'

  # Check the original_string against the regexpr_pattern
  if [[ ${original_string} =~ ${regexpr_pattern} ]]
  then
    return 0          # Valid user input
  else
    return ${E_INPUT} # Invalid user input
  fi
}
export -f validate_pinteger

# validate_float()
# Checks if a string contains only floating-point numbers
function validate_float() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FLOATING_POINT_NUMBER"
    echo "   e.g.: ${FUNCNAME} 3.14159"
    echo "         ${FUNCNAME} 0"
    echo "         ${FUNCNAME} -2.71828"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Regular expression pattern for floating-point numbers
  # ^      : beginning of the string
  # [+-]?  : zero or one occurrence of + or - sign
  # [0-9]+ : one or more occurrences of [0-9]
  # \.?    : zero or one occurrence of '.' character
  # [0-9]* : zero or more occurrences of [0-9]
  # $      : end of the string  
  local regexpr_pattern='^[+-]?[0-9]+\.?[0-9]*$'

  # Check the original_string against regexpr_pattern
  if [[ ${original_string} =~ ${regexpr_pattern} ]]
  then
    return 0          # Valid user input
  else
    return ${E_INPUT} # Invalid user input
  fi
}
export validate_float

# validate_pfloat()
# Checks if a string contains only non-negative floating-point numbers
function validate_pfloat() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} NON_NEGATIVE_FLOATING_POINT_NUMBER"
    echo "   e.g.: ${FUNCNAME} 3.14159"
    echo "         ${FUNCNAME} 0"
    echo "         ${FUNCNAME} +3.14159"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Regular expression pattern for non-negative floating-point numbers
  # ^      : beginning of the string
  # [+]?   : zero or one occurrence of + sign
  # [0-9]+ : one or more occurrences of [0-9]
  # \.?    : zero or one occurrence of '.' character
  # [0-9]* : zero or more occurrences of [0-9]
  # $      : end of the string  
  local regexpr_pattern='^[+]?[0-9]+\.?[0-9]*$'

  # Check the original_string against regexpr_pattern
  if [[ ${original_string} =~ ${regexpr_pattern} ]]
  then
    return 0          # Valid user input
  else
    return ${E_INPUT} # Invalid user input
  fi
}
export validate_pfloat

# validate_nfloat()
# Checks if a string contains only negative floating-point numbers
function validate_nfloat() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} NEGATIVE_FLOATING_POINT_NUMBER"
    echo "   e.g.: ${FUNCNAME} -3.14159"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Regular expression pattern for floating-point numbers
  # ^      : beginning of the string
  # -      : - sign
  # [0-9]+ : one or more occurrences of [0-9]
  # \.?    : zero or one occurrence of '.' character
  # [0-9]* : zero or more occurrences of [0-9]
  # $      : end of the string  
  local regexpr_pattern='^-[0-9]+\.?[0-9]*$'

  # Check the original_string against regexpr_pattern
  if [[ ${original_string} =~ ${regexpr_pattern} ]]
  then
    return 0          # Valid user input
  else
    return ${E_INPUT} # Invalid user input
  fi
}
export validate_nfloat

# validate_alphanum()
# Checks if a string contains only alphabets and non-negative integers
function validate_alphanum() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} ALPHA_NUMERIC_STRING"
    echo "   e.g.: ${FUNCNAME} Eleanor1234"
    echo "         ${FUNCNAME} 123George"
    echo "         ${FUNCNAME} Deep4Blue"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Strip off all the non-alphabets and non non-negative integers from 
  # the original_string using sed and regular expressions 
  sanitized_string=$(echo "${original_string}" | sed "s/[^a-zA-Z0-9]//g")

  # Compare original_string and sanitized_string, and return a value
  if [ "${original_string}" != "${sanitized_string}" ]
  then
    return ${E_INPUT} # Invalid user input
  else
    return 0          # Valid user input
  fi
}
export -f validate_alphanum

# validate_hostname()
# Checks if a string validates as hostname
# https://www.regexpal.com/23
function validate_hostname() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} HOSTNAME"
    echo "   e.g.: ${FUNCNAME} google.com"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local host_name="$1"

  # Regular expression pattern for a hostname
  #   It must start with an alphanumeric character
  #   It cannot contain non-alphanumeric characters other than hyphen (-) and
  #     period (.) 
  #   It must end with an alphanumeric character
  # ^          : beginning of the string
  # \-         : - (hyphen)
  # \.         : . (period)
  # $          : end of the string
  local regexpr_pattern='^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$'

  # Check the host_name against regexpr_pattern
  if [[ ${host_name} =~ ${regexpr_pattern} ]]
  then
    return 0          # Valid user input
  else
    return ${E_INPUT} # Invalid user input
  fi
}
export -f validate_hostname

# validate_ipaddress()
# Checks if a string validates as an IP address
# https://www.linuxjournal.com/content/validating-ip-address-bash-script
function validate_ipaddress() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} IPv4_ADDRESS"
    echo "   e.g.: ${FUNCNAME} 172.217.8.174"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local ip_address="$1"

  # Regular expression pattern for an IPv4 address
  # ^          : beginning of the string
  # [0-9]{1,3} : 1-3 occurrences of 0-9
  # \.         : . (period)
  # $          : end of the string
  local regexpr_pattern='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'

  # Check the ip_address against regexpr_pattern
  if [[ ${ip_address} =~ ${regexpr_pattern} ]]
  then
    # Check if each octet is between 0 and 255
    #   Save the built-in Internal Field Separator (IFS)
    #   Set the IFS to be a period
    #   Create an array from ip_address using the new IFS
    #   Restore the original value of IFS
    OIFS=${IFS}
    IFS="."
    ip=(${ip_address})
    IFS=${OIFS}
    if [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
    then
      return 0          # Valid user input
    else
      return ${E_INPUT} # Invalid user input
    fi
  else
    return ${E_INPUT} # Invalid user input
  fi
}
export -f validate_ipaddress

# validate_time()
# Checks if a string validates as time in human readable format (hh:mm:ss)
function validate_time() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} TIME_IN_HUMAN_READABLE_FORMAT"
    echo "   e.g.: ${FUNCNAME} 01:01:01"
    echo "         ${FUNCNAME} 12:10:05"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local time_hrf="$1"

  # Regular expression pattern for time in human readable format
  # ^          : beginning of the string
  # [0-2][0-4] : Hour - between 00 and 24
  # [0-5][0-9] : Minute and Second - between 00 and 59
  # :          : : (colon)
  # $          : end of the string
  local regexpr_pattern='^[0-2][0-4]:[0-5][0-9]:[0-5][0-9]$'

  # Check the time_hrf against regexpr_pattern
  if [[ ${time_hrf} =~ ${regexpr_pattern} ]]
  then
    return 0          # Valid user input
  else
    return ${E_INPUT} # Invalid user input
  fi
}
export -f validate_time

# lc2uc()
# Converts a string from lowercase to uppercase
function lc2uc() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} STRING"
    echo "   e.g.: ${FUNCNAME} Michigan"
    echo "         ${FUNCNAME} yooPER"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Parse the original string and print the result
  echo "${original_string}" | tr [a-z] [A-Z]
}
export -f lc2uc

# uc2lc()
# Converts a string from uppercase to lowercase
function uc2lc() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} STRING"
    echo "   e.g.: ${FUNCNAME} Michigan"
    echo "         ${FUNCNAME} yooPER"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Parse the original string and print the result
  echo "${original_string}" | tr [A-Z] [a-z]
}
export -f uc2lc

# ltrim()
# Removes leading white space from a string
function ltrim() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} STRING"
    echo "   e.g.: ${FUNCNAME} \"     Michigan\""
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Parse the original string and print the result
  echo "${original_string}" | sed "s/^[ \t]*//"
}
export -f ltrim

# rtrim()
# Removes trailing white space from a string
function rtrim() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} STRING"
    echo "   e.g.: ${FUNCNAME} \"Michigan    \""
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Parse the original string and print the result
  echo "${original_string}" | sed "s/[ \t]*$//"
}
export rtrim

# trim()
# Removes leading and trailing white space from a string
function trim() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} STRING"
    echo "   e.g.: ${FUNCNAME} \"   Michigan    \""
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$1"

  # Parse the original string and print the result
  echo "${original_string}" | sed "s/^[ \t]*//;s/[ \t]*$//"
}
export -f trim
  
# ucfirst()
# Converts the first alphabet of the first world in a string to upper case
function ucfirst () {

  # Argument check
  if [ $# -eq 0 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} STRING"
    echo "   e.g.: ${FUNCNAME} \"michigan is a state in the US\""
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local original_string="$@"

  # Parse the original string and print the result
  local first_character=${original_string:0:1}
  local rest_of_the_string=${original_string:1}
  local first_character_uc=$(echo "${first_character}" | tr [a-z] [A-Z])
  echo "${first_character_uc}${rest_of_the_string}"
}
export -f ucfirst 

# ucwords()
# Converts the first alphabet of every word in a string to upper case (i.e., title case)
function ucwords() {

  # Argument check
  if [ $# -eq 0 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} STRING"
    echo "   e.g.: ${FUNCNAME} \"michigan is a state in the US\""
    echo
    return ${E_ARGS}
  fi

  for i in $@
  do
    i=${i,,}
    echo -n "${i^} "
  done
}
export -f ucwords

## END: String operations

## BEGIN: Mathematical operations

# abs()
# Prints the absolute value of an integer
# Works with BASH version 4 or higher
function abs() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} INTEGER"
    echo "   e.g.: ${FUNCNAME} 1234"
    echo "         ${FUNCNAME} -1234"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local number="$1"

  # Input validation
  if ! validate_integer ${number}
  then
    echo "  ${number} is not an integer."
    echo "  Invalid input. Exiting."
    return ${E_INPUT}
  fi

  # Print the result
  echo -E "${number#-}"
}
export -f abs

# fabs()
# Prints the absolute value of a floating-point number
function fabs() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FLOATING_POINT_NUMBER"
    echo "   e.g.: ${FUNCNAME} 3.14159"
    echo "         ${FUNCNAME} -2.71828"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local number="$1"

  # Input validation
  if ! validate_float ${number}
  then
    echo "  ${number} is not a floating-point number."
    echo "  Invalid input. Exiting."
    return ${E_INPUT}
  fi

  # Compute and print the result
  # If FLOATING_POINT_NUMBER is less than 0, print the negative
  # If not, print it as is
  echo "${number}" | awk '{ if($1>=0) { print $1} else {print $1*(-1) }}'
}
export -f fabs

# round()
# Rounds up a given floating-point number to a specified number of decimal
# places 
function round() {

  # Argument check
  if [ $# -ne 2 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FLOATING_POINT_NUMBER DECIMAL_PLACES"
    echo "   e.g.: ${FUNCNAME} 3.14159 2"
    echo "         ${FUNCNAME} -2.71828 3"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local number="$1"
  local decimal_places="$2"

  # Input validation
  if ! validate_float ${number} 
  then
    echo "  ${number} is not a floating-point number."
    echo "  Invalid input. Exiting."
    return ${E_INPUT}
  fi

  if ! validate_pinteger ${decimal_places}
  then
    echo "  ${decimal_places} is not a non-negative integer."
    echo "  Invalid input. Exiting."
    return ${E_INPUT}
  fi

  # Compute and print the result
  echo $(printf %.${decimal_places}f $(echo "scale=${decimal_places};(((10^${decimal_places})*${number})+0.5)/(10^${decimal_places})" | bc)) 
}
export -f round

# ceil()
# Rounds up a given floating-point number to the next integer
function ceil() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FLOATING_POINT_NUMBER"
    echo "   e.g.: ${FUNCNAME} 3.49"
    echo "         ${FUNCNAME} 3.51"
    echo "         ${FUNCNAME} -3.51"
    echo "         ${FUNCNAME} -3.49"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local number="$1"

  # Input validation
  if ! validate_float ${number} 
  then
    echo "  ${number} is not a floating-point number."
    echo "  Invalid input. Exiting."
    return ${E_INPUT}
  fi

  # Compute and print the result
  echo "${number}" | awk '{printf("%d\n",$0+=$0<0?0:0.9)}'
}
export -f ceil

# pi()
# Prints the value of PI for 5 decimal places
function pi() {

  # Argument check
  if [ $# -ne 0 ]
  then
    echo
    echo "  Usage: ${FUNCNAME}"
    echo
    return ${E_ARGS}
  fi

  # Compute and print the result
  echo "1" | awk '{ printf "%0.5f\n", $1*4*atan2(1,1); }'
}
export -f pi

# sqrt()
# Square root of a non-negative number
function sqrt() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} NON_NEGATIVE_NUMBER"
    echo "   e.g.: ${FUNCNAME} 0"
    echo "         ${FUNCNAME} 1"
    echo "         ${FUNCNAME} 122.50"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local number="$1"

  # Validate NON_NEGATIVE_NUMBER
  if ! validate_pfloat ${number}
  then
    echo
    echo "  ${number} must be a non-negative number."
    echo "  Invalid input. Exiting."
    echo
    return ${E_ARGS}
  fi

  # Compute and print the result
  echo "scale = 5; sqrt(${number})" | bc -l
}
export -f sqrt

# sum()
# Sums up a given sequence of numbers
function sum() {

  # Argument check
  if [ $# -ne 3 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} BEGIN STEP/INCREMENT END"
    echo "   e.g.: ${FUNCNAME} 1 1 10"
    echo "         ${FUNCNAME} 0.10 0.10 0.50"
    echo "         ${FUNCNAME} 10 -1 1"
    echo "         ${FUNCNAME} -0.10 -0.10 -0.50"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local begin="$1"
  local step="$2"
  local end="$3"

  # Input validation
  if ! validate_float ${begin}
  then
    echo
    echo "  ${begin} must be a floating-point number."
    echo "  Invalid input. Exiting."
    echo
    return ${E_INPUT}
  fi

  if ! validate_float ${step}
  then
    echo
    echo "  ${step} must be a floating-point number."
    echo "  Invalid input. Exiting."
    echo
    return ${E_INPUT}
  fi

  if ! validate_float ${end}
  then
    echo
    echo "  ${end} must be a floating-point number."
    echo "  Invalid input. Exiting."
    echo
    return ${E_INPUT}
  fi

  if [[ ${start} -eq ${end} ]]
  then
    if [[ ${step} -ne ${start} ]]
    then
      echo
      echo "  END is equal to START."
      echo "  STEP/INCREMENT must be equal to START."
      echo "  Invalid input. Exiting."
      echo
      return ${E_INPUT}
    fi
  fi

  if [[ ${start} -gt ${end} ]]
  then
    if [[ ${step} -gt ${start} ]]
    then
      echo
      echo "  END is less than START."
      echo "  STEP/INCREMENT must be less than or equal to START."
      echo "  Invalid input. Exiting."
      echo
      return ${E_INPUT}
    fi
  fi

  if [[ ${start} -lt ${end} ]]
  then
    if [[ ${step} -lt ${start} ]]
    then
      echo
      echo "  END is greater than START."
      echo "  STEP/INCREMENT must be greater than or equal to START."
      echo "  Invalid input. Exiting."
      echo
      return ${E_INPUT}
    fi
  fi

  # Compute and print the result
  seq ${begin} ${step} ${end} | paste -sd+ | bc -l
}
export -f sum

# factorial()
# Prints factorial of a given non-negative integer (numeral)
function factorial() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} SIGN-LESS_NON_NEGATIVE_INTEGER"
    echo "   e.g.: ${FUNCNAME} 0"
    echo "         ${FUNCNAME} 1"
    echo "         ${FUNCNAME} 10"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local number="$1"

  # Input validation
  if ! validate_numeral ${number}
  then
    echo
    echo "  ${number} needs to be a sign-less non-negative integer."
    echo "  Invalid input. Exiting."
    echo
    return ${E_INPUT}
  fi  

  # Compute and print the result
  # If the NUMBER is less than or equal to 1, factorial is 1
  # If the NUMBER is greater than 1, use recursion
  if [[ ${number} -le 1 ]]
  then
    echo "1"
  else
    tmp=$(factorial $[${number}-1])
    echo $((${number} * tmp))
  fi
}
export -f factorial

# sin()
# Prints the sine of an angle to 5 decimal places
function sin() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} RADIAN"
    echo "   e.g.: ${FUNCNAME} 1.57079"
    echo "         ${FUNCNAME} 3.14159"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local radian="$1"

  # Input validation
  if ! validate_float ${radian}
  then
    echo
    echo "  ${radian} must be a floating-point number."
    echo "  Invalid input. Exiting."
    echo
    return ${E_INPUT}
  fi

  # Compute and print the result
  echo "scale = 5; s(${radian})" | bc -l
}
export -f sin

# cos()
# Prints the cosine of an angle to 5 decimal places
function cos() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} RADIAN"
    echo "   e.g.: ${FUNCNAME} 1.57079"
    echo "         ${FUNCNAME} 3.14159"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local radian="$1"

  # Input validation
  if ! validate_float ${radian}
  then
    echo
    echo "  ${radian} must be a floating-point number."
    echo "  Invalid input. Exiting."
    echo
    return ${E_INPUT}
  fi

  # Compute and print the result
  echo "scale = 5; c(${radian})" | bc -l
}
export -f cos

# tan()
# Prints the tangent of an angle to 5 decimal places
function tan() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} RADIAN"
    echo "   e.g.: ${FUNCNAME} 1.57079"
    echo "         ${FUNCNAME} 3.14159"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local radian="$1"

  # Input validation
  if ! validate_float ${radian}
  then
    echo
    echo "  ${radian} must be a floating-point number."
    echo "  Invalid input. Exiting."
    echo
    return ${E_INPUT}
  fi

  # Compute and print the result
  echo "scale = 5; s(${radian})/c(${radian})" | bc -l
}
export -f tan

## END: Mathematical operations

## BEGIN: Time operations

# seconds2hms()
# Convert seconds to human readable format (hh:mm:ss)
function seconds2hms() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} SECONDS"
    echo "   e.g.: ${FUNCNAME} 0"
    echo "         ${FUNCNAME} 1"
    echo "         ${FUNCNAME} 61"
    echo "         ${FUNCNAME} 3661"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  local seconds="$1"

  # Input validation
  if ! validate_numeral ${seconds}
  then
    echo
    echo "  SECONDS needs to be a numeral (without +/- sign). Exiting."
    echo
    return ${E_INPUT}
  fi  

  # Convert SECONDS to hh:mm:ss format and print the result
  ((hours=seconds/3600))
  ((minutes=seconds%3600/60))
  ((seconds=seconds%60))

  printf "%d:%02d:%02d\n" "${hours}" "${minutes}" "${seconds}"
}
export -f seconds2hms

## END: Time operations

## BEGIN: File operations

# check_existence()
# Checks if a given entity (file or folder) exists
function check_existence() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FILE_OR_FOLDER"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  entity="$1"

  # Check if the ENTITY exists
  if [ ! -e "${entity}" ]
  then
    echo
    echo "  ${entity} does not exist."
    echo "  Invalid input. Exiting."
    echo
    return ${E_INPUT}
  fi
}
export -f check_existence

# check_readable()
# Checks if a given entity (file or folder) is readable
function check_readable() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FILE_OR_FOLDER"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  entity="$1"

  # Check if the ENTITY is readable
  if [ ! -r "${entity}" ]
  then
    echo
    echo "  ${entity} is not readable."
    echo "  Check permissions. Exiting."
    echo
    return ${E_ENTITY_PERMISSION}
  fi
}
export -f check_readable

# check_writable()
# Checks if a given entity (file or folder) is writable
function check_writable() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FILE_OR_FOLDER"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  entity="$1"

  # Check if the ENTITY is writable
  if [ ! -w "${entity}" ]
  then
    echo
    echo "  ${entity} is not writable."
    echo "  Check permissions. Exiting."
    echo
    return ${E_ENTITY_PERMISSION}
  fi
}
export -f check_writable

# check_file()
# Checks if a given entity is a file
function check_file() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FILE"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  entity="$1"

  # Check if the ENTITY is file
  if [ ! -f "${entity}" ]
  then
    echo
    echo "  ${entity} is not a file."
    echo "  Invalid input. Exiting."
    echo
    return ${E_INPUT}
  fi
}
export -f check_file

# check_folder()
# Checks if a given entity is a folder
function check_folder() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FOLDER"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  entity="$1"

  # Check if the ENTITY is folder
  if [ ! -d "${entity}" ]
  then
    echo
    echo "  ${entity} is not a folder."
    echo "  Invalid input. Exiting."
    echo
    return ${E_INPUT}
  fi
}
export -f check_folder

# smart_extract()
# Perform smart extraction of a compressed entity
function smart_extract() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} COMPRESSED_ENTITY"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  compressed_entity="$1"
  compressed_entity_folder=$(dirname $(readlink -f ${compressed_entity}))

  # Input validation
  check_existence ${compressed_entity}
  check_readable  ${compressed_entity}
  check_writable  ${compressed_entity_folder}

  # Using switch-case construct prevents deeply nested if statements
  case ${compressed_entity} in
    *.tar) 
      file ${compressed_entity} | grep "POSIX tar archive" 2>&1 > /dev/null
      if [ $? -eq 0 ]
      then
        tar -xvf ${compressed_entity}
      else
        echo
        echo "  ${compressed_entity} is not of the TAR kind."
        echo "  Invalid input. Exiting."
        return ${E_INPUT}
      fi
      ;;

    *.tbz2)
      file ${compressed_entity} | grep "bzip2 compressed data" 2>&1 > /dev/null
      if [ $? -eq 0 ]
      then
        tar -xvjf ${compressed_entity}
      else
        echo
        echo "  ${compressed_entity} is not of the TBZ2 kind."
        echo "  Invalid input. Exiting."
        return ${E_INPUT}
      fi
      ;;

    *.tar.bz2)
      file ${compressed_entity} | grep "bzip2 compressed data" 2>&1 > /dev/null
      if [ $? -eq 0 ]
      then
        tar -xvjf ${compressed_entity}
      else
        echo
        echo "  ${compressed_entity} is not of the TAR-BZ2 kind."
        echo "  Invalid input. Exiting."
        return ${E_INPUT}
      fi
      ;;

    *.bz2)
      file ${compressed_entity} | grep "bzip2 compressed data" 2>&1 > /dev/null
      if [ $? -eq 0 ]
      then
        bunzip2 ${compressed_entity}
      else
        echo
        echo "  ${compressed_entity} is not of the BZIP2 kind."
        echo "  Invalid input. Exiting."
        return ${E_INPUT}
      fi
      ;;

    *.tgz)
      file ${compressed_entity} | grep "gzip compresssed data" 2>&1 > /dev/null
      if [ $? -eq 0 ]
      then
        tar -xvzf ${compressed_entity}
      else
        echo
        echo "  ${compressed_entity} is not of the TGZ kind."
        echo "  Invalid input. Exiting."
        return ${E_INPUT}
      fi
      ;;

    *.tar.gz)
      file ${compressed_entity} | grep "gzip compresssed data" 2>&1 > /dev/null
      if [ $? -eq 0 ]
      then
        tar -xvzf ${compressed_entity}
      else
        echo
        echo "  ${compressed_entity} is not of the TAR-GZ kind."
        echo "  Invalid input. Exiting."
        return ${E_INPUT}
      fi
      ;;

    *.gz)
      file ${compressed_entity} | grep "gzip compresssed data" 2>&1 > /dev/null
      if [ $? -eq 0 ]
      then
        gunzip ${compressed_entity}
      else
        echo
        echo "  ${compressed_entity} is not of the GZIP kind."
        echo "  Invalid input. Exiting."
        return ${E_INPUT}
      fi
      ;;

    *.zip)
      file ${compressed_entity} | grep "Zip archive data" 2>&1 > /dev/null
      if [ $? -eq 0 ]
      then
        unzip ${compressed_entity}
      else
        echo
        echo "  ${compressed_entity} is not of the ZIP kind."
        echo "  Invalid input. Exiting."
        return ${E_INPUT}
      fi
      ;;

    *) 
      echo "  '${compressed_entity}' file type unknown"
      ;;
  esac
}
export -f smart_extract

## END: File operations

## BEGIN: Image operations/manipulations

# jpg2eps()
# Converts all JPG images in the current folder to EPS
function jpg2eps() {

  # Argument check
  if [ $# -ne 0 ]
  then
    echo
    echo "  Usage: ${FUNCNAME}"
    echo
    return ${E_ARGS}
  fi

  # Loop through all images of the relevant kind
  for img in $(ls *.jpg)
  do
    # Display a message to identify which image is being worked on
    echo
    echo "  Working on ${img}"

    # Extract the basename using echo and awk commands
    FILE_BASENAME=$(echo "${img}" | awk -F '.' '{ print $1 }')

    # Check if the EPS file already exists. 
    # If yes, do not convert the JPG to EPS.
    # If not, convert the JPG to EPS
    if [ -f "${FILE_BASENAME}.eps" ]
    then
      echo "  ${FILE_BASENAME}.eps already exists. Skipping conversion"
    else
      echo "  ${FILE_BASENAME}.eps does not exist. Converting from ${FILE_BASENAME}.jpg"
      convert ${FILE_BASENAME}.jpg eps3:${FILE_BASENAME}.eps
    fi
  done
}
export -f jpg2eps

# png2eps()
# Converts all PNG images in the current folder to EPS
function png2eps() {

  # Argument check
  if [ $# -ne 0 ]
  then
    echo
    echo "  Usage: ${FUNCNAME}"
    echo
    return ${E_ARGS}
  fi

  # Loop through all images of the relevant kind
  for img in $(ls *.png)
  do
    # Display a message to identify which image is being worked on
    echo
    echo "  Working on ${img}"

    # Extract the basename using echo and awk commands
    FILE_BASENAME=$(echo "${img}" | awk -F '.' '{ print $1 }')

    # Check if the EPS file already exists. 
    # If yes, do not convert the PNG to EPS.
    # If not, convert the PNG to EPS
    if [ -f "${FILE_BASENAME}.eps" ]
    then
      echo "  ${FILE_BASENAME}.eps already exists. Skipping conversion"
    else
      echo "  ${FILE_BASENAME}.eps does not exist. Converting from ${FILE_BASENAME}.png"
      convert ${FILE_BASENAME}.png eps3:${FILE_BASENAME}.eps
    fi
  done
}
export -f png2eps

# png2jpg()
# Converts all PNG images in the current folder to JPG
function png2jpg() {

  # Argument check
  if [ $# -ne 0 ]
  then
    echo
    echo "  Usage: ${FUNCNAME}"
    echo
    return ${E_ARGS}
  fi

  # Loop through all images of the relevant kind
  for img in $(ls *.png)
  do
    # Display a message to identify which image is being worked on
    echo
    echo "  Working on ${img}"

    # Extract the basename using echo and awk commands
    FILE_BASENAME=$(echo "${img}" | awk -F '.' '{ print $1 }')

    # Check if the JPG file already exists. 
    # If yes, do not convert the PNG to JPG.
    # If not, convert the PNG to JPG
    if [ -f "${FILE_BASENAME}.jpg" ]
    then
      echo "  ${FILE_BASENAME}.jpg already exists. Skipping conversion"
    else
      echo "  ${FILE_BASENAME}.jpg does not exist. Converting from ${FILE_BASENAME}.png"
      convert ${FILE_BASENAME}.png ${FILE_BASENAME}.jpg
    fi
  done
}
export -f png2jpg

## END: Image operations/manipulations

## BEGIN: Git operations

# validate_git_repo
# Checks if the current folder is part of a valid Git repository
validate_git_repo() {
  if [ $# -ne 0 ]
  then
    echo
    echo "  Usage: ${FUNCNAME}"
    echo
    return ${E_ARGS}
  fi

  git rev-parse --show-toplevel &> /dev/null
  if [ $? -gt 0 ]
  then
    echo
    echo "  Not a valid Git repository."
    echo
    return ${E_GIT_REPO}
  else
    return 0
  fi
}
export -f validate_git_repo

# fooling_git
# Git does not add empty folders to the repository.
# If inside a valid Git repository, creates an empty .fooling_git
# file in every folder. 
fooling_git() {
  if [ $# -ne 0 ]
  then
    echo
    echo "  Usage: ${FUNCNAME}"
    echo
    return ${E_ARGS}
  fi

  # Validate Git repository
  if validate_git_repo
  then
    cd $(git rev-parse --show-toplevel)
    for folder in $(find . -type d | grep -v ".git")
    do
      if [ -w "${folder}" ]
      then
        if [ ! -e "${folder}/.fooling_git" ]
        then
          touch ${folder}/.fooling_git
        fi
      fi
    done
  fi
}
export -f fooling_git

# git_repack
# Repacks a Git repository
git_repack() {
  if [ $# -ne 0 ]
  then
    echo
    echo "  Usage: ${FUNCNAME}"
    echo
    return ${E_ARGS}
  fi

  # Validate Git repository
  if validate_git_repo
  then
    cd $(git rev-parse --show-toplevel)
    du -sh ./.git
    du -sk ./.git
    git repack -a -d --depth=5000 --window=5000
    du -sh ./.git
    du -sk ./.git
  fi
}
export -f git_repack

# git_purge_file
# Purges a file from Git repository's history
git_purge_file() {
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FULL_RELATIVE_PATH_TO_FILE"
    echo
    return ${E_ARGS}
  fi

  # Validate Git repository
  if validate_git_repo
  then
    cd $(git rev-parse --show-toplevel)
    git filter-branch --force --index-filter \
      "git rm --cached --ignore-unmatch $1" \
      --prune-empty --tag-name-filter cat -- --all
    git push origin --force --all
    git push origin --force --tags
    rm -rf .git/refs/original
    git reflog expire --expire=now --all
    git gc --prune=now
    git gc --aggressive --prune=now
  fi
}
export -f git_purge_file

# git_purge_folder
# Purges a folder from Git repository's history
git_purge_folder() {
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} FULL_RELATIVE_PATH_TO_FOLDER"
    echo
    return ${E_ARGS}
  fi

  # Validate Git repository
  if validate_git_repo
  then
    cd $(git rev-parse --show-toplevel)
    git filter-branch --force --index-filter \
      "git rm -r --cached --ignore-unmatch $1" \
      --prune-empty --tag-name-filter cat -- --all
    git push origin --force --all
    git push origin --force --tags
    rm -rf .git/refs/original
    git reflog expire --expire=now --all
    git gc --prune=now
    git gc --aggressive --prune=now
  fi
}
export -f git_purge_folder

# git_gource
# Creates a MP4 video using Git repository's commit history
git_gource() {
  if [ $# -ne 2 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} START_DATE END_DATE"
    echo "   e.ge: ${FUNCNAME} 2018-06-01 $(date +'%Y-%m-%d')"
    echo
    return ${E_ARGS}
  fi

  # Validate Git repository
  if validate_git_repo
  then
    # Get the repository name from the "git rev-parse --show-toplevel"
    START_DATE="$1"
    END_DATE="$2"
    # https://stackoverflow.com/questions/19724531/how-to-remove-all-non-numeric-characters-from-a-string-in-bash
    # TIME_PERIOD="$(echo ${START_DATE//[!0-9]/})_$(echo ${END_DATE//[!0-9]/})"
    TIME_PERIOD="$(echo ${START_DATE} | sed 's/[^0-9]//g')_$(echo ${END_DATE} | sed 's/[^0-9]//g')"
    GIT_TOP_LEVEL=$(git rev-parse --show-toplevel)
    GIT_REPO_NAME_LOCAL=$(basename $(git rev-parse --show-toplevel))
    GIT_REPO_NAME_GLOBAL=$(basename -s .git $(git config --get remote.origin.url))
    gource \
      --camera-mode overview \
      --title "${GIT_REPO_NAME_GLOBAL}" \
      --hide dirnames,filenames \
      --start-date "$1" \
      --stop-date  "$2" \
      --seconds-per-day 0.05 \
      --auto-skip-seconds 1 \
      --max-file-lag 0.01 \
      -w --key \
      --font-size 21 \
      -1280x800 -o - | \
    ffmpeg -y \
      -r 60 \
      -f image2pipe \
      -vcodec ppm -i - \
      -vcodec libx264 \
      -preset ultrafast \
      -pix_fmt yuv420p \
      -crf 1 \
      -threads 0 \
      -bf 0 \
      ${HOME}/Desktop/${GIT_REPO_NAME_GLOBAL}_${TIME_PERIOD}.mp4
  fi
}
export -f git_gource

## END: Git operations

## BEGIN: Misc operations

# login_counter()
# List all users that have logged into the current workstation in 
# descending order of the number of login attempts
function login_counter() {

  # Argument check
  if [ $# -ne 0 ]
  then
    echo
    echo "  Usage: ${FUNCNAME}"
    echo
    return ${E_ARGS}
  fi

  echo
  echo "  $(hostname) @ $(date -R)"
  echo

  # Run the last command
  #   sed removes empty lines
  #   awk extracts the usernames using space as the field separator
  #   sort sorts the usernames alphabetically
  #   uniq counts the number of duplicates (of usernames)
  #   sort sorts the usernames and their login count descending order
  last | \
    sed "/^\s*$/d" | \
    awk '{ print $1 }' | \
    sort | \
    uniq -c | \
    sort -nr
  echo
}
export -f login_counter

# ping_server
# Pings a server to check/validate network connectivity
ping_server() {

  # Argument check
  if [ $# -ne 1 ]
  then
    echo
    echo "  Usage: ${FUNCNAME} REMOTE_WORSTATION_HOSTNAME_OR_IPv4ADDRESS"
    echo "   e.g.: ${FUNCNAME} colossus.it.mtu.edu"
    echo "         ${FUNCNAME} 141.219.64.104"
    echo
    return ${E_ARGS}
  fi

  # Save the argument(s) in local variable(s)
  ping_server="$1"

  # Input validation
  if validate_hostname ${ping_server} || validate_ipaddress ${ping_server}
  then
    # Ping parameters
    ping_count="10"
    ping_interval="0.20"

    # Ping the server, compute packet ratio and print the result
    ping_cmd="ping -q -c ${ping_count} -i ${ping_interval}"
    ping_test=$(${ping_cmd} ${ping_server} | grep "packets transmitted")
    packets_sent=$(echo ${ping_test} | awk '{ print $1 }')
    packets_recd=$(echo ${ping_test} | awk '{ print $4 }')
    packet_ratio=$(echo "${packets_recd}/${packets_sent}" | bc)
    echo "${packet_ratio}"
  else
    echo
    echo "  ${ping_server} is not a valid hostname/IPv4 address."
    echo "  Invalid input. Exiting."
    echo
    return ${E_INPUT}
  fi
}
export -f ping_server

# rand_man()
# Displays the man page for a random command
# Press 'q' to exit and return to command prompt
function rand_man() {

  # Argument check
  if [ $# -ne 0 ]
  then
    echo
    echo "  Usage: ${FUNCNAME}"
    echo
    return ${E_ARGS}
  fi

  # Use shuf and head commands to pick a random command in /bin
  # Use the man command to display its manual
  man $(ls /bin | shuf | head -1)
}
export -f rand_man

## END: Misc operations
