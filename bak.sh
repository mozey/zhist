#!/usr/bin/env bash

# WARNING Do not exit on error since this file is included in ~/.zshrc
# Make sure script is executed with bash
# https://stackoverflow.com/a/3327108/639133
MY_SHELL=$(ps -p $$ | awk 'FNR == 2 {print $4}')
if [[ "${MY_SHELL}" != "bash" ]]; then
  # This might happens if the script is included like this
  #   if [ -f ~/.zhist/bak.sh ]; then . ~/.zhist/bak.sh; fi
  echo "bak.sh failed, not bash"

else
  # This script creates backups of the zsh history file, see
  # https://github.com/mozey/zhist

  HOME=${HOME}

  # HISTFILE is the history file
  HISTFILE="${HOME}/.zsh_history"
  # BACKUP is the backup file
  BACKUP="${HOME}/.zhist/.zsh_history"

  # https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html
  #
  #   -s file
  #     True if file exists and has a size greater than zero.
  #
  #   file1 -nt file2
  #     True if file1 is newer (according to modification date) than file2,
  #     or if file1 exists and file2 does not.
  #
  #   arg1 OP arg2
  #     OP is one of ‘-eq’, ‘-ne’, ‘-lt’, ‘-le’, ‘-gt’, or ‘-ge’. 
  #     These arithmetic binary operators...
  #
  if [[ -s "${HISTFILE}" ]]; then

    # This behaves differently in zsh
    if [[ "${HISTFILE}" -nt "$BACKUP" ]]; then

      # History is newer than backup, or backup doesn't exist
      HISTFILE_C=$(wc -c "${HISTFILE}" | awk '{print $1}')
      BACKUP_C=$(wc -c "${BACKUP}" | awk '{print $1}') || "0"

      if [[ "$HISTFILE_C" -gt "${BACKUP_C}" ]]; then
        # History has more characters than backup
        cp -f "${HISTFILE}" "${BACKUP}"
      fi
    fi
  fi

fi
