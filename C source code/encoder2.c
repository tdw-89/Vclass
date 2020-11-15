#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void convert_to_ordinal(FILE* fsa_fp, FILE* output_fp);

int main(int argc, char* argv[])
{
    char file_name[10000];
    char output_file_name[10000];
    int list_noc = 1;
    char list_char = 'a';
    FILE *fsa_fp;
    FILE *output_fp;
    FILE *list_ptr;

    list_ptr = fopen("list_of_files.txt", "r");
    list_noc = fscanf(list_ptr, "%s", file_name);
    while (list_noc > 0)
    {
        fsa_fp = fopen(file_name, "r");
        //printf("%s is the input file name\n", file_name);
        sprintf(output_file_name, "%s_converted.csv", file_name);
        output_fp = fopen(output_file_name, "w");
        //printf("%s is the output file name\n", output_file_name);

        convert_to_ordinal(fsa_fp, output_fp);
        fclose(fsa_fp);
		fclose(output_fp);
		file_name[0] = '\0';
		output_file_name[0] = '\0';
        list_noc = fscanf(list_ptr, "%s", file_name);
    }
    return 0;
}

void convert_to_ordinal(FILE* fsa_fp, FILE* output_fp)
{
	char sequence_id[10000];

	int i = 0,
		char_count = 0,
		line_count = 0;

	char buffer;

	for (buffer = getc(fsa_fp); (buffer != EOF && buffer != '\n'); buffer = getc(fsa_fp))
	{
		sequence_id[i] = buffer;
		i++;
	}
	sequence_id[i] = '\0';
	fprintf(output_fp, "%s\n", sequence_id);
	i = 0;
	for (buffer = getc(fsa_fp); (buffer != EOF && char_count != 1024 && buffer != '>'); buffer = getc(fsa_fp))
	{
		if (buffer == 'A')
		{
			fprintf(output_fp, "%.2f,", 0.25);
			char_count++;
		}
		else if(buffer == 'G')
		{
			fprintf(output_fp, "%.2f,", 0.50);
			char_count++;
		}
		else if (buffer == 'C')
		{
			fprintf(output_fp, "%.2f,", 0.75);
			char_count++;
		}
		else if (buffer == 'T')
		{
			fprintf(output_fp, "%.2f,", 1.00);
			char_count++;
		}
		else if (buffer == 'N')
		{
			fprintf(output_fp, "%.2f,", 0.00);
			char_count++;
		}
		if (char_count % 32 == 0)
		{
			fprintf(output_fp, "\n");
			line_count++;
		}
	}

}
