


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 1000

int get_file_name(FILE* list_fp, char input_file_name[]);
void convert_file(FILE* input_fp, int* file_count_ptr);

int main(int argc, char* argv[])
{
	char file_list[] = "list_of_files_viral.txt",
		input_file_name[SIZE];
	FILE* list_fp;
	FILE* input_fp;
	int more_files = 1,
		file_count = 1;
	int* file_count_ptr = &file_count;

	list_fp = fopen(file_list, "r");
	if (list_fp == NULL)
	{
		printf("Failed to open file list.\n");
		printf("Make sure that the file list is in the current directory.\n");
		printf("************************************\n");
		exit(1);
	}
	else
	{
		printf("List succesfully opened.\n");
		printf("************************************\n");
	}

	while (more_files == 1)
	{
		more_files = get_file_name(list_fp, input_file_name);
		input_fp = fopen(input_file_name, "r");
		if (input_fp == NULL && more_files == 1)
		{
			printf("Failed to open %s\n", input_file_name);
			printf("Check that the file is in the current directory\n");
			printf("************************************\n");
		}
		else if(more_files == 1)
		{
			convert_file(input_fp, file_count_ptr);
			
			fclose(input_fp);

		}

	}


	return 0;
}

int get_file_name(FILE* list_fp, char input_file_name[])
{
	int list_noc;

	list_noc = fscanf(list_fp, "%s", input_file_name);
	if (list_noc > 0)
	{
		return 1;
	}
	else 
	{
		fclose(list_fp);
		return 0;
	}

}

void convert_file(FILE* input_fp, int* file_count_ptr)
{
	char output_file_name[SIZE];
	FILE* output_fp;
	char buffer;
	int output_noc,
		char_count = 0;

	
 	sprintf(output_file_name, "%d.csv", *file_count_ptr);
	output_fp = fopen(output_file_name, "w");

	buffer = getc(input_fp);
		
	while (buffer != EOF)
	{
		if (buffer == '>')
		{
			for (buffer = getc(input_fp); (buffer != EOF && buffer != '\n'); buffer = getc(input_fp))
			{
			}
		}
		for (buffer = getc(input_fp); (buffer != EOF && char_count != 1024 && buffer != '>'); buffer = getc(input_fp))
		{
			if (buffer == 'A')
			{
				fprintf(output_fp, "%.2f,", 0.25);
				char_count++;
			}
			else if (buffer == 'G')
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
			}
		}

		char_count = 0;
		fclose(output_fp);
		output_file_name[0] = '\0';
		*file_count_ptr = *file_count_ptr + 1;
		printf("%d\n", *file_count_ptr);
		if (buffer != EOF)
		{
			sprintf(output_file_name, "%d.csv", *file_count_ptr);
			output_fp = fopen(output_file_name, "w");
		}

		
	}
	
}

