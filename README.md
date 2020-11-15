############# All Scripts Are A Work In Progress! ############
############# Use At Your Own Risk!               ############
##############################################################


From the command line:

Change the working directory to a directory with the fsa_encoder and fna_encoder files, all of the .fsa and .fna files 
you want to convert, and the 'Converted2.sh' script.

run the conversion program with the following command:

$ bash Conversion2.sh

From R: 

Load the scripts 'Import_encoded' and 'Import_encoded_fna' and 'Algorithm'
Use 'Import_encoded' and 'Import_encoded_fna' to load the encoded data from .fsa and .fna files 
respectively, and create a training/test set from them. 
Use Algorithm to train the model.
