#!/bin/sh

repo=$(gh repo list $1 | awk '{print $1}' | fzf)

if [[ -z $repo ]]; then 
  echo "exiting"
  exit
fi


gh repo view $repo --web
