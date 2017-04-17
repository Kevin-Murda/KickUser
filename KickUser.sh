#!/bin/sh

# Tested on: FreeBSD, Ubuntu, CentOS, Debian, OpenBSD, Fedora

# Set default flag for script:
DEFAULT_FLAG='-s' # Flag -s means kick from all shells.
SUDO=''

# Use $(id -u) instead of $UID for cross-platform performance.
if [ $(id -u) != 0 ]; then
  # If you are not root, then we add sudo to beginning of some commands.
  SUDO='sudo'
fi

displayHelp() {
  echo -n '> You need to include at least 1 argument(username), '
  echo 'flags are optional.'
  echo
  printf '%-12s' '> Usage: '
  echo "$(basename ${0}) [username] [-r|-s|-l]"
  printf '%-12s' '> Example: '
  echo "$(basename ${0}) john"
  printf '%-12s' '> Example: '
  echo "$(basename ${0}) john -r"
  echo
  echo '> Flags:'
  printf '%-12s' '  -r'
  echo -n 'Kick only remote client (ssh).'
  if [ ${DEFAULT_FLAG} = '-r' ]; then echo ' (Default)'; else echo; fi
  printf '%-12s' '  -s'
  echo -n 'Kick from all shells (including ssh).'
  if [ ${DEFAULT_FLAG} = '-s' ]; then echo ' (Default)'; else echo; fi
  printf '%-12s' '  -l'
  echo -n 'Same as -s, but it also locks account after being kicked.'
  if [ ${DEFAULT_FLAG} = '-l' ]; then echo ' (Default)'; else echo; fi
  echo
  exit 1
}

if [ ${#} -lt 1 ]; then
  displayHelp
fi

# Check if username is valid and assign variables.
if [ ${#1} -lt 3 ] || [ $(echo ${1} | cut -c 1) = '-' ]; then
  if [ ${1} == '-r' ] || [ ${1} = '-s' ] || [ ${1} = '-l' ]; then
    FLAG=${1}
    USER=${2}
  fi
else
  FLAG=${2}
  USER=${1}
fi

# Check if username is really set.
if [ "${USER}" = '' ]; then
  displayHelp
fi

# Check if username exists in system.
id -u ${USER} > /dev/null 2>&1
if [ ${?} -eq 1 ]; then
  echo "Username '${USER}' does not exist."
  exit 1
fi

# Force flags to be lowercase.
if [ ${#} -lt 2 ]; then
  FLAG=$(echo ${DEFAULT_FLAG} | tr A-Z a-z)
else
  FLAG=$(echo ${FLAG} | tr A-Z a-z)
fi

if [ ${FLAG} = '-r' ]; then
  ps -U ${USER} | grep sshd | sed 's/^ *//g' | cut -d ' ' -f 1 | \
  ${SUDO} xargs kill -9 > /dev/null 2>&1
elif [ ${FLAG} = '-s' ] || [ ${FLAG} = '-l' ]; then
  # If shells are open via ssh, shells will get killed with ssh and
  # kill command will return error that pid of closed shells are not found.
  # To prevent script from displaying error, we redirect stderr to /dev/null.
  ps -U ${USER} | grep sh | sed 's/^ *//g' | cut -d ' ' -f 1 | \
  ${SUDO} xargs kill -9 > /dev/null 2>&1
fi

if [ ${FLAG} = '-l' ]; then
  if [ $(uname -o) = 'FreeBSD' ]; then
    ${SUDO} pw lock ${USER}
  else
    ${SUDO} usermod -L ${USER}
  fi
fi

exit 0
