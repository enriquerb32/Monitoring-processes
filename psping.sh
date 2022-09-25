#!/bin/bash

# For monitoring processes

## We initialise each variable
time_out=1
i=0
ps_user=-e
user_name=
count=
exe_name=
process_count=0
user_id=

## Main function

# Loop finishes when all parameters are used
while [ "$1" != "" ]; do

    if [[ "$1" =~ ^-t$ ]]; then time_out="$2" ; fi

    if [[ "$1" =~ ^-u$ ]]; then user_name="$2"; fi

    if [[ "$1" =~ ^-c$ ]]; then count="$2"; fi

    exe_name=$1

    shift

done

# If username exists -> ps -u username ; else -> ps -e is default
if [ ! $user_name = "" ] ; then

    user_id=`id -u $user_name`

    if [ $user_id ]; then

        ps_user="-u $user_name"

        echo "Pinging $exe_name for the user $user_name"

    else

        echo "This user does not exist"
        exit;

    fi

else

    echo "Pinging $exe_name for any user"

fi

# loops a -c given times and -t time_out. If count is null, the loop is infinite
while [[ ! $count || $i < $count ]]; do

    process_count=`ps $ps_user | grep -w $exe_name | wc -l`

    echo "$exe_name: $process_count instance(s) ..."

    sleep $time_out;

    i=$(($i+1))

done
