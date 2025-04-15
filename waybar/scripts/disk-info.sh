#!/bin/bash
DISK=$1
FIELD=$2  # pode ser "free" ou "tooltip"

if [ "$FIELD" = "free" ]; then
    df -h $DISK | awk 'NR==2 {print $4}'
elif [ "$FIELD" = "tooltip" ]; then
    df -h $DISK | awk 'NR==2 {print "Usado: "$3" de "$2" ("$5")"}'
else
    echo "n/a"
fi
