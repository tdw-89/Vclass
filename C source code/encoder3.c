#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//void convert_to_ordinal2(FILE* fna_fp, FILE* output2_fp);
void convert_to_ordinal2(FILE* fna_fp);

int main(int argc, char* argv[])
{
    char file_name2[10000];
    //char output_file_name2[10000];
    int list_noc2 = 1;
    char list_char = 'a';
    FILE *fna_fp;
    //FILE *output2_fp;
    FILE *list_ptr2;
    
    list_ptr2 = fopen("list_of_files2.txt", "r");
    list_noc2 = fscanf(list_ptr2, "%s", file_name2);
    //while (list_noc2 > 0 && list_noc2 != EOF)
    //{
        fna_fp = fopen(file_name2, "r");
        printf("%s is the input file name\n", file_name2);
        //sprintf(output_file_name2, "%s_converted.csv", file_name2);
        //output2_fp = fopen(output_file_name2, "w");
        //printf("%s is the output file name\n", output_file_name2);

        convert_to_ordinal2(fna_fp);
        fclose(fna_fp);
        //fclose(output2_fp);
        //file_name2[0] = '\0';
        //output_file_name2[0] = '\0';
     //   list_noc2 = fscanf(list_ptr2, "%s", file_name);
    //}
    return 0;
}

void convert_to_ordinal2(FILE* fna_fp)
{
	char sequence_id[10000];
	char output_file_name2[10000];
	int i = 0,
	    file_count = 1,
	    char_count = 0;
	char buffer;
	FILE* output2_fp;
	
	sprintf(output_file_name2, "%dfna_converted.csv", file_count);
	output2_fp = fopen(output_file_name2, "w");
	buffer = getc(fna_fp);
	
	do {
	
		if(buffer == '>')
		{
			sequence_id[i] = buffer;
			i++;
			for (buffer = getc(fna_fp); (buffer != EOF && buffer != '\n'); buffer = getc(fna_fp))
			{
				sequence_id[i] = buffer;
				i++;
			}
			sequence_id[i] = '\0';
			fprintf(output2_fp, "%s\n", sequence_id);
			i = 0;
		}
		else
		{
			do {
				
			buffer = getc(fna_fp);
				
			} while (buffer != '>');
				
			sequence_id[i] = buffer;
			i++;
			for (buffer = getc(fna_fp); (buffer != EOF && buffer != '\n'); buffer = getc(fna_fp))
			{
				sequence_id[i] = buffer;
				i++;
			}
			sequence_id[i] = '\0';
			fprintf(output2_fp, "%s\n", sequence_id);
			i = 0;
		}
		char_count = 0;
		for (buffer = getc(fna_fp); (buffer != EOF && char_count != 1024 && buffer != '>'); buffer = getc(fna_fp))
		{
			if (buffer == 'A')
			{
				fprintf(output2_fp, "%.2f,", 0.25);
				char_count++;
			}
			else if(buffer == 'G')
			{
				fprintf(output2_fp, "%.2f,", 0.50);
				char_count++;
			}
			else if (buffer == 'C')
			{
				fprintf(output2_fp, "%.2f,", 0.75);
				char_count++;
			}
			else if (buffer == 'T')
			{
				fprintf(output2_fp, "%.2f,", 1.00);
				char_count++;
			}
			else if (buffer == 'N')
			{
				fprintf(output2_fp, "%.2f,", 0.00);
				char_count++;
			}
			if (char_count % 32 == 0)
			{
				fprintf(output2_fp, "\n");
			}
		}
		file_count++;
		fclose(output2_fp);
		output_file_name2[0] = '\0';
		sprintf(output_file_name2, "%dfna_converted.csv", file_count);
		output2_fp = fopen(output_file_name2, "w");
		//fprintf(output2_fp, "\n");
	}while (buffer != EOF);
	fclose(output2_fp);
}

















