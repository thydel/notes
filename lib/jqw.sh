#!/bin/bash

jq -f $(dirname $0)/$(basename $0 .sh).jq
