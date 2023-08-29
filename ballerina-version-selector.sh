#!/bin/bash

file_name='Ballerina.toml'
export BALLERINA_HOME="/usr/lib/ballerina"

# Default values
default_version="2201.4.1"
selected_ballerina_dist=22010401

# Function to set version and distribution
set_version_and_distribution() {
  ballerina_version="$1"
  selected_ballerina_dist="$2"
}

if [ -f "$file_name" ]; then
  ref_word="distribution"
  # use grep to find the line containing the reference word
  ref_line=$(grep -n "$ref_word" "$file_name" | cut -d ":" -f 1)

  # extract the desired version from the line
  version=$(sed "${ref_line}q;d" "$file_name" | awk '{print $3}  ')
  ballerina_version=$(echo "$version" | tr -d '"')
  echo "--> BALLERINA TOML VERSION"
  echo ${ballerina_version}
  sanatized_ballerina_version=$(echo $ballerina_version | awk -F'[.]' '{printf("%d%02d%02d\n", $1,$2,$3);}')

  if [ "$sanatized_ballerina_version" -le 22010305 ]; then
    set_version_and_distribution "2201.3.5" 22010305
  elif [ "$sanatized_ballerina_version" -le 22010401 ]; then
    set_version_and_distribution "2201.4.1" 22010401
  elif [ "$sanatized_ballerina_version" -le 22010500 ]; then
    set_version_and_distribution "2201.5.0" 22010500
  elif [ "$sanatized_ballerina_version" -le 22010600 ]; then
    set_version_and_distribution "2201.6.0" 22010600
  elif [ "$sanatized_ballerina_version" -le 22010700 ]; then
    set_version_and_distribution "2201.7.0" 22010700
  else
    set_version_and_distribution "2201.7.2" 22010702
  fi
else
  set_version_and_distribution "2201.4.1" 22010401
fi

export PATH="${BALLERINA_HOME}/${ballerina_version}/bin:$PATH"
export BALLERINA_DISTRIBUTION="$selected_ballerina_dist"

echo "BALLERINA COMPILING VERSION"
bal -v
echo "$PATH" >> "$GITHUB_PATH"
echo "BALLERINA DISTRIBUTION VERSION"
echo "$BALLERINA_DISTRIBUTION"
echo "BALLERINA_DISTRIBUTION=$BALLERINA_DISTRIBUTION" >> "$GITHUB_ENV"

