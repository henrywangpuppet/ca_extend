#!/bin/bash

# TODO: helper task?

# Exit with an error message and error code, defaulting to 1
fail() {
  # Print a stderr: entry if there were anything printed to stderr
  if [[ -s $_tmp ]]; then
    # Hack to try and output valid json by replacing newlines with spaces.
    echo "{ \"$1\": {\"status\": \"error\", \"message\": \"$2\", \"stderr\": \"$(tr '\n' ' ' <$_tmp)\" } }"
  else
    echo "{ \"$1\": {\"status\": \"error\", \"message\": \"$2\" } }"
  fi

  exit ${2:-1}
}

success() {
  echo "$1"
  exit 0
}

# Any temp files stored in variables prefixed by "_tmp" will be removed on exit
# TODO: does this work?
#cleanup() {
#  for f in ${!_tmp*}; do rm "${!f}"; done
#}

#trap 'cleanup' INT TERM

# Test for colors. If unavailable, unset variables are ok
if tput colors &>/dev/null; then
  green="$(tput setaf 2)"
  red="$(tput setaf 1)"
  reset="$(tput sgr0)"
fi

_tmp="$(mktemp)"

# Use indirection to munge PT_ environment variables
# e.g. "$PT_version" becomes "$version"
for v in ${!PT_*}; do
  declare "${v#*PT_}"="${!v}"
done
