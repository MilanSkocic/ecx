/**
 * @file io.c
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

/**
 * @brief Count the number of rows and columns
 * @param[in] stream File pointer
 * @param[in] buffer_size Size of line buffer
 * @param[in] skip_header Number of lines to skip before reading data
 * @param[in] separators Separators to be used for tokenizing lines
 * @param[out] nrows Number of rows in the file
 * @param[out] ncols Number of columns in the file
 */
static int io_nrow_ncol(FILE *stream, const size_t buffer_size, const size_t skip_header, 
                char *separators, 
                size_t *nrows, size_t *ncols){

    size_t i, j, k;
    int status;
    char *line, *token;
    token = NULL;

    line = (char *)calloc(buffer_size, sizeof(char));
    i = 0;
    j = 0;
    k = 0;
    *ncols = 0;
    *nrows = 0;

    errno = 0;

    // count number of rows
    while(!feof(stream)&(!errno)){
        // firts line count nubmber of cols
        strcpy(line, "");
        fgets(line, buffer_size, stream);
        if(k>=skip_header){
            *ncols = j;
            j = 0;
            token = strtok(line, separators);
            while(token != NULL){
                token = strtok(NULL, separators);
                j++;
            }
            if((j != (*ncols))&(k>skip_header)){
                errno = EBADR;
            }
            token = NULL;
            i++;
        }
        k++;
    }
    free(line);

    *nrows = i;
    *ncols = j;

    return errno;
}

static int io_read_z_data(FILE *stream, size_t buffer_size, 
                        size_t skip_header,
                        size_t nrows, size_t ncols){
    
    errno = 0;

    
    
    return errno;

}

/**
 * @brief Read Zplot data file
 * @param[in] fpath Path to the data file
 * @param[in] verbose Flag for verbose output 
 */
int read_z(char *fpath, int verbose){

    FILE *stream;
    double *data_z;

    const size_t buffer_size = 2056;
    const size_t skip_header = 11;
    char *separators = ",";
    size_t nrows;
    size_t ncols;

    nrows = 0;
    ncols = 0;

    stream = fopen(fpath, "r");

    errno = io_nrow_ncol(stream, buffer_size, skip_header, separators, &nrows, &ncols);

    if(verbose){
        printf("N rows= %ld\n", nrows);
        printf("N cols= %ld\n", ncols);
        printf("Errno: %d - %s", errno, strerror(errno));
    }

    fclose(stream);

    data_z = (double *)calloc(nrows*ncols, sizeof(double));


    free(data_z);

    return errno;
}