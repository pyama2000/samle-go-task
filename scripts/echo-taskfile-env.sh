#!/usr/bin/env bash

if [ "$ENV_VAR" == "" ]; then
  echo 'ENV_VAR is not defined'
else
  echo "$ENV_VAR"
fi
