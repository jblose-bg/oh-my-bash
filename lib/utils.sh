#! bash oh-my-bash.module
############################---Description---###################################
#                                                                              #
# Summary       : A collection of handy utilities and functions for bash       #
# Support       : destro.nnt@gmail.com                                         #
# Created date  : Mar 18,2017                                                  #
# Latest Modified date : Mar 18,2017                                           #
#                                                                              #
################################################################################

############################---Usage---#########################################

# source ~/path/to/directory/utils.sh

########################## Styled text output ##################################

# e_header "I am a sample script"
# e_success "I am a success message"
# e_error "I am an error message"
# e_warning "I am a warning message"
# e_underline "I am underlined text"
# e_bold "I am bold text"
# e_note "I am a note"

################# Performing simple Yes/No confirmations #######################

# seek_confirmation "Do you want to print a success message?"
# if is_confirmed; then
#   e_success "Here is a success message"
# else
#   e_error "You did not ask for a success message"
# fi

############ Testing if packages, apps, gems, etc. are installed ###############

# if _omb_util_command_exists 'git'; then
#   e_success "Git good to go"
# else
#   e_error "Git should be installed. It isn't. Aborting."
#   exit 1
# fi

# if is_os "darwin"; then
#   e_success "You are on a mac"
# else
#   e_error "You are not on a mac"
#   exit 1
# fi

##################### Sending notifications to Pushover ########################

# pushover "We just finished performing a lengthy task."

############################### Comparing A List ###############################

# recipes=(
#   A-random-package
#   bash
#   Another-random-package
#   git
# )
# list="$(to_install "${recipes[*]}" "$(brew list)")"
# if [[ "$list" ]]; then
# for item in ${list[@]}
#   do
#     echo "$item is not on the list"
#   done
# else
# e_arrow "Nothing to install.  You've already got them all."
# fi


################################################################################

function _omb_util_setexit {
  return "$1"
}

function _omb_util_defun_print {
  builtin eval -- "function $1 { local $3; $2 \"\$@\" && printf '%s\n' \"\${$3}\"; }"
}

#
# Test whether a command---either an alias, a keyword, a function, a builtin,
# or a file---is defined.
#
# $1 = cmd to test
#
# Usage:
#
#   if _omb_util_command_exists 'git'; then
#     some action
#   else
#     some other action
#   fi
#

if ((_omb_bash_version >= 40000)); then
  _omb_util_command_exists() {
    type -t -- "$@" &>/dev/null # bash-4.0
  }
  _omb_util_binary_exists() {
    type -P -- "$@" &>/dev/null # bash-4.0
  }
else
  _omb_util_command_exists() {
    while (($#)); do
      type -t -- "$1" &>/dev/null || return 1
      shift
    done
  }
  _omb_util_binary_exists() {
    while (($#)); do
      type -P -- "$1" &>/dev/null || return 1
      shift
    done
  }
fi
_omb_util_function_exists() {
  declare -F "$@" &>/dev/null # bash-3.2
}

#
# Set Colors
#
# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if [[ ! -t 1 ]]; then
  _omb_term_colors=
  _omb_term_bold=
  _omb_term_underline=
  _omb_term_reset=

  _omb_term_black=
  _omb_term_brown=
  _omb_term_green=
  _omb_term_olive=
  _omb_term_navy=
  _omb_term_purple=
  _omb_term_teal=
  _omb_term_silver=

  _omb_term_background_black=
  _omb_term_background_brown=
  _omb_term_background_green=
  _omb_term_background_olive=
  _omb_term_background_navy=
  _omb_term_background_purple=
  _omb_term_background_teal=
  _omb_term_background_silver=

  _omb_term_red=
  _omb_term_white=
  _omb_term_violet=
else
  if _omb_util_binary_exists tput; then
    _omb_term_colors=$(tput colors 2>/dev/null || tput Co 2>/dev/null)
    _omb_term_bold=$(tput bold 2>/dev/null || tput md 2>/dev/null)
    _omb_term_underline=$(tput smul 2>/dev/null || tput ul 2>/dev/null)
    _omb_term_reset=$(tput sgr0 2>/dev/null || tput me 2>/dev/null)
  else
    _omb_term_colors=
    _omb_term_bold=$'\e[1m'
    _omb_term_underline=$'\e[4m'
    _omb_term_reset=$'\e[0m'
  fi

  if ((_omb_term_colors >= 8)); then
    _omb_term_black=$(tput setaf 0 2>/dev/null || tput AF 0 2>/dev/null)
    _omb_term_brown=$(tput setaf 1 2>/dev/null || tput AF 1 2>/dev/null)
    _omb_term_green=$(tput setaf 2 2>/dev/null || tput AF 2 2>/dev/null)
    _omb_term_olive=$(tput setaf 3 2>/dev/null || tput AF 3 2>/dev/null)
    _omb_term_navy=$(tput setaf 4 2>/dev/null || tput AF 4 2>/dev/null)
    _omb_term_purple=$(tput setaf 5 2>/dev/null || tput AF 5 2>/dev/null)
    _omb_term_teal=$(tput setaf 6 2>/dev/null || tput AF 6 2>/dev/null)
    _omb_term_silver=$(tput setaf 7 2>/dev/null || tput AF 7 2>/dev/null)
  else
    _omb_term_black=$'\e[30m'
    _omb_term_brown=$'\e[31m'
    _omb_term_green=$'\e[32m'
    _omb_term_olive=$'\e[33m'
    _omb_term_navy=$'\e[34m'
    _omb_term_purple=$'\e[35m'
    _omb_term_teal=$'\e[36m'
    _omb_term_silver=$'\e[37m'
  fi

  _omb_term_background_black=$'\e[40m'
  _omb_term_background_brown=$'\e[41m'
  _omb_term_background_green=$'\e[42m'
  _omb_term_background_olive=$'\e[43m'
  _omb_term_background_navy=$'\e[44m'
  _omb_term_background_purple=$'\e[45m'
  _omb_term_background_teal=$'\e[46m'
  _omb_term_background_silver=$'\e[47m'

  if ((_omb_term_colors >= 16)); then
    _omb_term_red=$(tput setaf 9 2>/dev/null || tput AF 9 2>/dev/null)
    _omb_term_white=$(tput setaf 15 2>/dev/null || tput AF 15 2>/dev/null)
    _omb_term_background_red=$_omb_term_background_brown$'\e[101m'
    _omb_term_background_white=$_omb_term_background_silver$'\e[107m'
  else
    _omb_term_red=$_omb_term_bold$_omb_term_brown
    _omb_term_white=$_omb_term_bold$_omb_term_silver
    _omb_term_background_red=$_omb_term_bold$_omb_term_background_brown
    _omb_term_background_white=$_omb_term_bold$_omb_term_background_silver
  fi

  if ((_omb_term_colors == 256)); then
    _omb_term_violet=$(tput setaf 171 2>/dev/null || tput AF 171 2>/dev/null)
    _omb_term_background_violet=$'\e[48;5;171m'
  else
    _omb_term_violet=$_omb_term_purple
    _omb_term_background_violet=$_omb_term_background_purple
  fi
fi

_omb_term_bold_black=$_omb_term_bold$_omb_term_black
_omb_term_bold_brown=$_omb_term_bold$_omb_term_brown
_omb_term_bold_green=$_omb_term_bold$_omb_term_green
_omb_term_bold_olive=$_omb_term_bold$_omb_term_olive
_omb_term_bold_navy=$_omb_term_bold$_omb_term_navy
_omb_term_bold_purple=$_omb_term_bold$_omb_term_purple
_omb_term_bold_teal=$_omb_term_bold$_omb_term_teal
_omb_term_bold_silver=$_omb_term_bold$_omb_term_silver
_omb_term_bold_red=$_omb_term_bold$_omb_term_red
_omb_term_bold_white=$_omb_term_bold$_omb_term_white
_omb_term_bold_violet=$_omb_term_bold$_omb_term_violet

_omb_term_underline_black=$_omb_term_underline$_omb_term_black
_omb_term_underline_brown=$_omb_term_underline$_omb_term_brown
_omb_term_underline_green=$_omb_term_underline$_omb_term_green
_omb_term_underline_olive=$_omb_term_underline$_omb_term_olive
_omb_term_underline_navy=$_omb_term_underline$_omb_term_navy
_omb_term_underline_purple=$_omb_term_underline$_omb_term_purple
_omb_term_underline_teal=$_omb_term_underline$_omb_term_teal
_omb_term_underline_silver=$_omb_term_underline$_omb_term_silver
_omb_term_underline_red=$_omb_term_underline$_omb_term_red
_omb_term_underline_white=$_omb_term_underline$_omb_term_white
_omb_term_underline_violet=$_omb_term_underline$_omb_term_violet


#
# Headers and Logging
#
_omb_log_header()    { printf "\n${_omb_term_bold}${_omb_term_violet}==========  %s  ==========${_omb_term_reset}\n" "$@"; }
_omb_log_arrow()     { printf "➜ %s\n" "$@"; }
_omb_log_success()   { printf "${_omb_term_green}✔ %s${_omb_term_reset}\n" "$@"; }
_omb_log_error()     { printf "${_omb_term_brown}✖ %s${_omb_term_reset}\n" "$@"; }
_omb_log_warning()   { printf "${_omb_term_olive}➜ %s${_omb_term_reset}\n" "$@"; }
_omb_log_underline() { printf "${_omb_term_underline}${_omb_term_bold}%s${_omb_term_reset}\n" "$@"; }
_omb_log_bold()      { printf "${_omb_term_bold}%s${_omb_term_reset}\n" "$@"; }
_omb_log_note()      { printf "${_omb_term_underline}${_omb_term_bold}${_omb_term_navy}Note:${_omb_term_reset}  ${_omb_term_olive}%s${_omb_term_reset}\n" "$@"; }

#
# USAGE FOR SEEKING CONFIRMATION
# seek_confirmation "Ask a question"
# Credit: https://github.com/kevva/dotfiles
#
# if is_confirmed; then
#   some action
# else
#   some other action
# fi
#
seek_confirmation() {
  printf "\\n${_omb_term_bold}%s${_omb_term_reset}" "$@"
  read -p " (y/n) " -n 1
  printf "\\n"
}

# Test whether the result of an 'ask' is a confirmation
is_confirmed() {
  [[ $REPLY =~ ^[Yy]$ ]]
}

#
# Test which OS the user runs
# $1 = OS to test
# Usage: if is_os 'darwin'; then
#
is_os() {
  [[ $OSTYPE == $1* ]]
}

#
# Pushover Notifications
# Usage: pushover "Title Goes Here" "Message Goes Here"
# Credit: http://ryonsherman.blogspot.com/2012/10/shell-script-to-send-pushover.html
#
pushover () {
  PUSHOVERURL="https://api.pushover.net/1/messages.json"
  API_KEY=$PUSHOVER_API_KEY
  USER_KEY=$PUSHOVER_USER_KEY
  DEVICE=$PUSHOVER_DEVICE

  TITLE="${1}"
  MESSAGE="${2}"

  curl \
  -F "token=${API_KEY}" \
  -F "user=${USER_KEY}" \
  -F "device=${DEVICE}" \
  -F "title=${TITLE}" \
  -F "message=${MESSAGE}" \
  "${PUSHOVERURL}" > /dev/null 2>&1
}

## @fn _omb_util_get_shopt optnames...
if ((_omb_bash_version >= 40100)); then
  _omb_util_get_shopt() { shopt=$BASHOPTS; }
else
  _omb_util_get_shopt() {
    shopt=
    local opt
    for opt; do
      if shopt -q "$opt" &>/dev/null; then
        shopt=${shopt:+$shopt:}$opt
      fi
    done
  }
fi

_omb_util_unload_hook=()
_omb_util_unload() {
  local hook
  for hook in "${_omb_util_unload_hook[@]}"; do
    eval -- "$hook"
  done
}

_omb_util_original_PS1=$PS1
_omb_util_unload_hook+=('PS1=$_omb_util_original_PS1')

_omb_util_prompt_command=()
_omb_util_prompt_command_hook() {
  local status=$? lastarg=$_ hook
  for hook in "${_omb_util_prompt_command[@]}"; do
    _omb_util_setexit "$status" "$lastarg"
    eval -- "$hook"
  done
}

_omb_util_unload_hook+=('_omb_util_prompt_command=()')

: "${_omb_util_prompt_command_setup=}"
_omb_util_add_prompt_command() {
  local other
  for other in "${_omb_util_prompt_command[@]}"; do
    [[ $1 == "$other" ]] && return 0
  done
  _omb_util_prompt_command+=("$1")

  if [[ ! $_omb_util_prompt_command_setup ]]; then
    _omb_util_prompt_command_setup=1
    local hook=_omb_util_prompt_command_hook

    # See if we need to use the overriden version
    if _omb_util_function_exists append_prompt_command_override; then
      append_prompt_command_override "$hook"
      return
    fi

    # Set OS dependent exact match regular expression
    local prompt_re
    if [[ $OSTYPE == darwin* ]]; then
      # macOS
      prompt_re='[[:<:]]'$hook'[[:>:]]'
    else
      # Linux, FreeBSD, etc.
      prompt_re='\<'$hook'\>'
    fi
    [[ $PROMPT_COMMAND =~ $prompt_re ]] && return 0

    if ((_omb_bash_version >= 50100)); then
      local other
      for other in "${PROMPT_COMMAND[@]}"; do
        [[ $hook == "$other" ]] && return 0
      done
      PROMPT_COMMAND+=("$hook")
    else
      PROMPT_COMMAND="$hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
    fi
  fi
}

_omb_util_glob_expand() {
  local set=$- shopt gignore=$GLOBIGNORE
  _omb_util_get_shopt failglob nullglob extglob

  shopt -u failglob
  shopt -s nullglob
  shopt -s extglob
  set +f
  GLOBIGNORE=

  eval -- "$1=($2)"

  GLOBIGNORE=$gignore
  # Note: dotglob is changed by GLOBIGNORE
  if [[ :$shopt: == *:dotglob:* ]]; then
    shopt -s dotglob
  else
    shopt -u dotglob
  fi
  [[ $set == *f* ]] && set -f
  [[ :$shopt: != *:extglob:* ]] && shopt -u extglob
  [[ :$shopt: != *:nullglob:* ]] && shopt -u nullglob
  [[ :$shopt: == *:failglob:* ]] && shopt -s failglob
  return 0
}
