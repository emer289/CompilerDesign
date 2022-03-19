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
%token<int_val> INT IF ELSE STRING FOR BOOL VOID RETURN COMMA STRUCT
%token<int_val> INCR LS_GR EQU_NOTEQU OR AND NOT ADD SUB MUL DIV
%token<int_val> LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN TRUE FALSE
%token <ToY_item>   ID
%token <int_val>    ICONST
%token <str_val>    STRING_LIT

/* precedencies and associativities */
%left LPAREN RPAREN
%right ASSIGN INCR NOT
%left LS_GR EQU_NOTEQU OR AND ADD SUB MUL DIV


%start program

/* expression rules */

%%

program:  declarations  statements struct_optional functions_optional
        ;

/* declarations */
declarations: declarations declaration | declaration;


declaration: INT ID SEMI int_init
            | STRING ID SEMI str_init
            | BOOL ID SEMI bool_init
            ;


int_init : ID ASSIGN exp SEMI ;
str_init : ID ASSIGN STRING_LIT SEMI ;
bool_init : ID ASSIGN arule SEMI ;

exp: values
    | exp aritmetic_op values
    ;

aritmetic_op: ADD
            | SUB
            | MUL
            | DIV
            ;

values: ID
    | ICONST
    ;

/* statements */
statements: statements statement | statement ;

statement:
	if_statement | for_statement
;

incr:
    ID INCR SEMI
    ;

if_statement:
	IF LPAREN arule RPAREN tail optional_else
;

optional_else: ELSE tail | /* empty */ ;

tail: LBRACE statements RBRACE
    | LBRACE incr RBRACE ;

for_statement:
    FOR LPAREN int_init arule SEMI ID INCR RPAREN tail
    ;

arule: NOT expression
      | LPAREN arule RPAREN
      | expression
      ;

expression:
        arule AND arule
        | crule
        ;
crule:
    | brule
    | brule OR arule
    ;

brule:
      values compare values
      |TRUE
      |FALSE
      ;





compare: LS_GR
       | EQU_NOTEQU
       ;

struct_optional: structs | /* empty */ ;

structs: structs | struct ;

struct: STRUCT ID LBRACE RBRACE

/* functions */
functions_optional: functions | /* empty */ ;

functions: functions function | function ;

function: function_head function_tail ;

function_head: type ID LPAREN parameters_optional RPAREN

type: INT | STRING | BOOL | VOID;

parameters_optional: parameters | /* empty */ ;

parameters: parameters COMMA parameter | parameter ;

parameter : type ID ;

function_tail: LBRACE declarations_optional statements_optional return_optional RBRACE ;

declarations_optional: declarations | /* empty */ ;

statements_optional: statements | /* empty */ ;

return_optional: RETURN SEMI | /* empty */ ;

%%

void yyerror ()
{
  fprintf(stderr, "Error %d\n", lineno);
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

	printf("VAlID!");

	// symbol table dump
	yyout = fopen("ToY_dump.out", "w");
	ToY_dump(yyout);
	fclose(yyout);

	return flag;
}
