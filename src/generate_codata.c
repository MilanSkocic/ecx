
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define N 128

void format_names(char *line){
    size_t i;
    size_t size = 60;

    for(i=0; i<size; i++){
        if(!isalnum(line[i])){
            line[i] = '_';
        }
    }
    line[55] = '[';
    line[56] = '2';
    line[57] = ']';
    line[58] = '=';
    line[59] = '{';
    
    for(i=(size-6); i>=0; i--){
        if(line[i]!='_'){
            break;
        }
        line[i] = ' ';
    }
    for(i=0; i<size; i++){
        line[i] = toupper(line[i]);
    }
}

void format_values(char *line){
    size_t i;
    size_t j;
    size_t size = 25;
    size_t i0 = 60;
    char *temp = (char *)malloc(sizeof(char)*25);
    for(i=0; i<25; i++){
        temp[i] = ' ';
    }
    j = 0;
    temp[j] = line[i0];
    j++;
    for(i=(i0+1); i<(i0+size-2);i++){
        if(isdigit(line[i])){
            temp[j] = line[i];
            j++;
        }
        if((line[i]=='.') & (isdigit(line[i-1])>0) & (isdigit(line[i+1])>0)){
            temp[j] = line[i];
            j++;
        }
        if(line[i]=='e'){
            temp[j] = line[i];
            j++;
        }
        if((line[i]=='-') | (line[i]=='+')){
            temp[j] = line[i];
            j++;
        }
    }
    j = 0;
    for(i=0; i<25; i++){
        line[60+i] = temp[i];
    }
    line[84] = ',';
    free(temp);
}

void format_uncertainties(char *line){
    size_t i;
    size_t j;
    size_t size = 25;
    size_t i0 = 85;
    char *temp = (char *)malloc(sizeof(char)*25);
    for(i=0; i<size; i++){
        temp[i] = ' ';
    }
    j = 0;
    if(line[i0] != '('){
        temp[j] = line[i0];
    }
    j++;
    for(i=(i0+1); i<(i0+size-2);i++){
        if (strncmp(&line[i0], "(exact)", 7)==0){
            temp[0] = '0';
            temp[1] = '.';
            temp[2] = '0';
            break;
        }

        if(isdigit(line[i])){
            temp[j] = line[i];
            j++;
        }
        if((line[i]=='.') & (isdigit(line[i-1])>0) & (isdigit(line[i+1])>0)){
            temp[j] = line[i];
            j++;
        }
        if(line[i]=='e'){
            temp[j] = line[i];
            j++;
        }
        if((line[i]=='-') | (line[i]=='+')){
            temp[j] = line[i];
            j++;
        }
    }
    j = 0;
    for(i=0; i<size; i++){
        line[i0+i] = temp[i];
        if(line[i0+i] == ' '){
            j++;
        }
    }
    if(j == size){
        line[i0] = '0';
        line[i0+1] = '.';
        line[i0+2] = '0';
    }

    line[106] = '}';
    line[107] = ';';
    line[108] = '/';
    line[109]='/';
    free(temp);
}

int read_line(FILE *f, char *buf){

    char c;
    size_t i = 0;
    int eof=0;

    while((c=fgetc(f)) != '\n'){
        if(c==EOF){
            eof=1;
            break;
        }
        else{
            if(i<N){
                buf[i] = c;
                i++;
                eof=0;
            }
        }
    }
    if(i==0){
        buf[0] = '\n';
        buf[1] = '\0';


    }
    return eof;
}

void clean_line(char *buf){

    size_t i;
    for(i=0; i<=N; i++){
        buf[i] = ' ';
    }
    buf[N] = '\0';
    buf[N-1] = '\n';
}

int main(int argc, char **argv){

    FILE *fptr =  fopen("./codata.txt", "r");
    FILE *pcode = fopen("electrox_codata.h", "w");

    char *line = (char *)malloc(sizeof(char)*(N+1));
    int i=0;
    int eof=0;
    while(eof==0){
        clean_line(line);
        eof = read_line(fptr, line);
        if(i>10){
            format_names(line);
            format_values(line);
            format_uncertainties(line);
            if(eof==0){
                fputs("const double ", pcode);
            }
        }else{
            line[0] = '/';
            line[1] = '/';
        }
        if(eof==0){
            //printf("%ld - %s", strlen(line), line);
            fputs(line, pcode);
        }
        i++;
    }

    free(line);

    fclose(fptr);
    fclose(pcode);



    return EXIT_SUCCESS;


}