//======================================================================
// APPLICATION
//======================================================================
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "ecx.h"
#include "re.h"

#define VERSION_SIZE 256

typedef struct option_t {char *s; char *l; char *arg; char *help;} option;

static void version_text(){
    char v[VERSION_SIZE];
    strcpy(v, "ecx ");
    strcat(v, ecx_version());
    strcat(v, "\n\n");
    strcat(v, "Copyright (c) 2022 Milan Skocic\n");
    strcat(v, "License MIT\n");
    strcat(v, "\n");
    strcat(v, "Written by Milan Skocic\n");
    printf("%s", v);
}

//----------------------------------------------------------------------
// FUNCTION: USAGE_TEXT()
//----------------------------------------------------------------------
//{{{
static void usage_text(){
    printf("%s\n", "ecx SUBCOMMAND [-u|--usage] [-v|--version] [-h|--help]");
//}}}
}


//----------------------------------------------------------------------
// FUNCTION: HELP_TEXT()
//----------------------------------------------------------------------
//{{{
static void help_text(struct option_t *options){
    int i=0;
    char buf[64];
    printf("%s\n", "Usage: ecx SUBCOMMAND [OPTION]...");
    printf("%s\n", "ecx - library for electrochemistry.");
    printf("%s\n", "");
    while(options[i].s != NULL){
        buf[0] = '\0';
        strcat(buf, options[i].s);
        if(options[i].l != NULL){
            strcat(buf, ", ");
            strcat(buf, options[i].l);
        }
        if(options[i].arg != NULL){
            strcat(buf, " ");
            strcat(buf, options[i].arg);
        }
        printf("  %-24s", buf);
        printf("%-s\n", options[i].help);
        i++;
    }
    printf("%s\n", "");
}
//}}}
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// FUNCTION: LONG2SHORT()
//----------------------------------------------------------------------
//{{{
static char *long2short(char *option, struct option_t *options){
    int i=0;
    if(option==NULL){return NULL;}
    if(strlen(option)<3){return option;}
    if(!((option[0]=='-') && (option[1]=='-'))){return option;}

    while(options[i].s!=NULL){
        if(strcmp(option, options[i].l)==0){return options[i].s;}
        else{i++;}
    }
    return option;
}
//}}}
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// FUNCTION: MAIN()
//----------------------------------------------------------------------
//{{{
int main(int argc, char **argv){
    int i, opt;
    char *s=NULL;

    
    static struct option_t loptions[]={
    {"-u", "--usage",   NULL,        "Show usage text and exit."},
    {"-v", "--version", NULL,        "Show version information and exit."},
    {"-h", "--help ",   NULL,        "Show help text and exit."},
    {NULL, NULL,        NULL,        NULL} };

    for(i=1;i<argc;i++){
        s = long2short(argv[i], loptions);
        if(s!=NULL){argv[i]=s;}
    }

    while ((opt = getopt(argc, argv, ":y:p:aeuvh")) != -1) {
        switch (opt) {
            case 'v':
                version_text();
                return EXIT_SUCCESS;
                break;
            case 'u':
                usage_text();
                return EXIT_SUCCESS;
                break;
            case 'h':
                help_text(loptions);
                return EXIT_SUCCESS;
                break;
            case ':': 
                fprintf(stderr, "Option needs a value.\n"); 
                break; 
            case '?': 
                fprintf(stderr, "Unknown option: %c\n", opt);
                break;
        }
    }

    return EXIT_SUCCESS;
}
//}}}
//----------------------------------------------------------------------
