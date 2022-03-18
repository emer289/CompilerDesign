%{
	#include "ToY.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
%}

/* YYSTYPE union */
%union{
    char char_val;
	int int_val;
	double double_val;
	char* str_val;
	list_t* ToY_item;
}

/* token definition */
%token<int_val> INT IF ELSE STRING
%token<int_val> INCR
%token<int_val> LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN
%token <ToY_item>   ID
%token <int_val>    ICONST
%token <str_val>    STRING_LIT

/* precedencies and associativities */
%left LPAREN RPAREN
%right ASSIGN INCR


%start program

/* expression rules */

%%

program:  declarations  statements
        ;

/* declarations */
declarations: declarations declaration | declaration;


declaration: INT names SEMI int_init
            | STRING names SEMI str_init;

type: INT ;

names: ID ;

int_init : ID ASSIGN ICONST SEMI
str_init : ID ASSIGN STRING_LIT SEMI

/* statements */
statements: statements statement | statement ;

statement:
	if_statement | ID INCR SEMI
;

if_statement:
	IF LPAREN RPAREN tail optional_else
;

optional_else: ELSE tail | /* empty */ ;

tail: LBRACE statements RBRACE ;


constant: ICONST  ;




%%

void yyerror ()
{
  fprintf(stderr, "Syntax error at line %d\n", lineno);
  exit(1);
}

int main (int argc, char *argv[]){

	// initialize symbol table
	init_hash_table();

	// parsing
	int flag;
	yyin = fopen(argv[1], "r");
	flag = yyparse();
	fclose(yyin);

	printf("Parsing finished!");

	// symbol table dump
	yyout = fopen("ToY_dump.out", "w");
	ToY_dump(yyout);
	fclose(yyout);

	return flag;
}
