#!/usr/bin/env bash
# Usage: run_cpp.sh <src_file> <exe_file>

interactive_indicator="// interactive"
interactive_flag=0

while read line; do
  if [ "$line" == "$interactive_indicator" ]; then
    interactive_flag=1
  fi
done < $1

if ! clang++ -Wall -Wextra -Wconversion -Wshadow -O2 -std=c++14 -o $2 $1; then
  echo -e "\033[1;4;31mCompilation failed\033[0m"
  exit
else
  echo -e "\033[1;4;32mCompilation suceeded\033[0m"
fi

if [ $interactive_flag -eq 1 ]; then
  ./$2
else
  out_file=/tmp/$1_out
  err_file=/tmp/$1_err
  ./$2 1> $out_file 2> $err_file
  echo -e "\033[1;4;34mstdout:\033[0m"
  cat $out_file
  echo
  echo -e "\033[1;4;34mstderr:\033[0m"
  cat $err_file
  echo
  rm $out_file $err_file
fi
