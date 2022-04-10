#!/bin/bash

printHelp ()
{ 
  echo "Usage: $0 -p 4 -i INPUT_DIRECTORY -x \"command -to run/\""
  echo -e "\t-p The maximum number of processes to start concurrently"
  echo -e "\t-i The directory containing the files to run the command on"
  echo -e "\t-x The command to run that the file will be appended to"
  exit 1
}

while getopts "p:x:i:" opt; do
  case "$opt" in
    p ) procs="$OPTARG" ;;
    x ) command="$OPTARG" ;;
    i ) INPUT_DIRECTORY="$OPTARG" ;;
    ? ) printHelp ;;
  esac
done

if [[ -z $procs ]] || [[ -z $command ]] || [[ -z $INPUT_DIRECTORY ]]
then
  echo "Invalid arguments"
  printHelp
fi

total=$(ls $INPUT_DIRECTORY | wc -l)
files="$(ls -Sr $INPUT_DIRECTORY)"

for k in $(seq 1 $procs $total)
do
  for i in $(seq 0 $procs)
  do
    if [ $((i+k)) -gt $total ]
    then
      wait
      exit 0
    fi

    file=$(echo "$files" | sed $(expr $i + $k)"q;d")
    LOG_OUTPUT=$("Token Triggered... beginning parrallel execution of"  "$command $INPUT_DIRECTORY/$file
    $command" "$INPUT_DIRECTORY/$file" "& with $procs cores.")&
  done

  wait
done