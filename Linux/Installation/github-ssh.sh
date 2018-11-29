#!/bin/sh

# config github ssh access

if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1

else 
  echo 'test'
fi
