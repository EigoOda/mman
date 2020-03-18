#!/bin/bash

##################################################
# Description
#   Arguments
#     SCRIPT_DIR  : script directory path
#     temp        : temporary file
#     output      : output file 
#     name        : process name
#     memory_size : memory size
##################################################

# recent directory
SCRIPT_DIR=$( cd $( dirname $0 ) && pwd )

# prepare arguments
temp="$SCRIPT_DIR/Msize.txt"
output="$SCRIPT_DIR/memory_size.txt"

# output
exec > $temp
exec 2>&1

# format output file (temp)
if [ -f $temp ]; then
  cp /dev/null $temp 
fi

# formant output file (output)
if [ -f $output ]; then
  cp /dev/null $output
fi

# get memory data
for pid in $(grep VmSize /proc/*/status | cut -d/ -f3) ;do
name=$(grep Name /proc/$pid/status)
memorysize=$(grep VmSize /proc/$pid/status)
echo "-$name/PID:$pid/$memorysize"; echo
done

# shaping information
sed -i -e '/^$/d' -e 's/\t//g' -e 's/ //g' $temp
sed -i '/^grep/d' $temp 

# sort informaiton
sed "s/kB//g" $temp |sort -r -n -k 4 -t : > $output

# delete temporary file
if [ -f $temp ]; then
  rm -rf $temp
fi


