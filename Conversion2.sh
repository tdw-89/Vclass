#!/bin/bash

ls | grep -v ".fna" | grep "GCF" > list_of_files.txt
ls | grep ".fna" > list_of_files2.txt

./fsa_encoder
./fna_encoder

#echo "Files:"
#ls | grep -c "converted.csv"
#echo "Files Converted:"
#ls | grep "GCF" | grep -cv "converted.csv"


rm "list_of_files.txt"  
rm "list_of_files2.txt"

 ls | grep "converted.csv" > list_of_converted_files.txt
