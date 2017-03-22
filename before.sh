#!/bin/bash

# TODO
# export sublime package

# TYPO & COLORS 
bold=$(tput bold)
normal=$(tput sgr0)
yellow="\033[1;33m"
green="\033[1;32m"
gray="\033[1;30m"
red="\033[0;31m"
nc="\033[0m"

# PROMPT
prompt="-->> "
prompt_info="${yellow}${prompt}${nc}"
prompt_gray="${gray}${prompt}${nc}"
prompt_success="${green}${prompt}${nc}"
prompt_warning="${red}${prompt}${nc}"

# CFG
entrypath=$(pwd)
user=$(whoami)
now=$(date +%F)
default_dir="$now-backup"

# INIT
folder=
save_message=0
save_fonts=0

# Hello !
printf "${yellow}Hello ${user}, let's save some datas together :) ${nc}"
read -r -p "Ready? [y/N] " response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  
  # save messages options
  printf "$prompt_info"
  read -r -p "${bold}Save Messages? ${normal}[y/N] " messages
  if [[ "$messages" =~ ^([yY][eE][sS]|[yY])+$ ]]
  then
    save_message=1
  fi

  # save fonts options
  printf "$prompt_info"
  read -r -p "${bold}Save Fonts? ${normal}[y/N] " fonts
  if [[ "$fonts" =~ ^([yY][eE][sS]|[yY])+$ ]]
  then
    save_fonts=1
  fi

  # set backup folder as default or custom
  printf "$prompt_info"
  read -r -p "${bold}Backup Name? ${normal}[default: $default_dir] " dirname

  if [ -z "$dirname" ]; then
    folder="${default_dir}"
  else
    folder="${dirname}"
  fi

  # remove backup folder if it exists
  if [ -d $folder ]; then
    printf "$prompt_warning"
    read -r -p "$folder already exists, delete and replace it? [y/N] " replace
    if [[ "$replace" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
      rm -rf folder
    else
      exit
    fi
  fi

  # create folder if doesn't exists
  if [ -z "$dirname" ] && [ ! -d "$folder" ]; then
    mkdir ./$folder
    printf "$prompt_success"
    printf "$entrypath/${green}$folder${nc} folder created !\n"
  fi

  # save messages if enabled
  if [ "$save_message" -eq 1 ]; then
    # check if Messages exists
    if [ -d ~/Library/Messages ]; then
      printf "$prompt_gray"
      printf "Saving Messages. Be patient, It could take awhile...\n"
      tar -zcf ./$folder/messages.tar.gz -P ~/Library/Messages
      printf "$prompt_success"
      printf "Messages saved !\n"
    else
      printf "$prompt_warning ~/Library/Messages Not found :(\n"
    fi
  fi

  # save fonts if enabled
  if [ "$save_fonts" -eq 1 ]; then
    # check if Messages exists
    if [ -d ~/Library/Fonts ]; then
      printf "$prompt_gray"
      printf "Saving Fonts...\n"
      tar -zcf ./$folder/fonts.tar.gz -P ~/Library/Fonts
      printf "$prompt_success"
      printf "Fonts saved !\n"
    else
      printf "$prompt_warning ~/Library/Fonts Not found :(\n"
    fi
  fi
fi