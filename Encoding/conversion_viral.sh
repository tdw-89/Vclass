#!/bin/bash

ls | grep "GCF" > list_of_files_viral.txt

./encoder_viral_exe

rm "list_of_files_viral.txt"

ls | grep -v "csv" | grep -v "viral"| xargs rm

find ./ -size -5k -and -name '*csv*' -delete

ls | grep "csv" > list_of_converted_files_viral_keep.txt

echo "Done"
