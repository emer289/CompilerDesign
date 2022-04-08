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
%token <int_val> INT IF ELSE STRING FOR BOOL VOID RETURN COMMA STRUCT PRINTF
%token <int_val> INCR LS_GR EQU_NOTEQU OR AND NOT ADD SUB MUL DIV MOD
%token <int_val> LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN TRUE FALSE
%token <ToY_item>   ID
%token <int_val>    ICONST
%token <str_val>    STRING_LIT

%type <int_val> function_head
%type <int_val> function_tail
%type <int_val> return_mandatory

/* precedencies and associativities */
%left LPAREN RPAREN
%right ASSIGN INCR NOT
%left LS_GR EQU_NOTEQU OR AND ADD SUB MUL DIV


%start program

/* expression rules */

%%

program: statement program | function program | ;
/* declarations */

statement:
	 for_statement | if_statement | initialisations | declaration
	 | struct | print | function_call | incr
;

incr:
    ID INCR SEMI
    ;

declaration: INT ID SEMI      {
                if ($2->st_type != UNDEF) yyerror(lineno);
                $2->st_type = INT;
                addToScope($2);
              }
            | STRING ID SEMI  {
                if ($2->st_type != UNDEF) yyerror(lineno);
                $2->st_type = STRING;
                addToScope($2);
              }
            | BOOL ID SEMI    {
                if ($2->st_type != UNDEF) yyerror(lineno);
                $2->st_type = BOOL;
                addToScope($2);
              }
            ;

initialisations:  initialisation;

initialisation: ID ASSIGN exp SEMI {
      if ($1->st_type != INT) yyerror(1);
      if (lookup_scope($1->st_name, MAXTOKENLEN) == NULL) yyerror(lineno);
    }
	| ID ASSIGN STRING_LIT SEMI {
      if ($1->st_type != STRING) yyerror(1);
      if (lookup_scope($1->st_name, MAXTOKENLEN) == NULL) yyerror(lineno);
    }
	| ID ASSIGN brule SEMI  {
      if ($1->st_type != BOOL) yyerror(1);
      if (lookup_scope($1->st_name, MAXTOKENLEN) == NULL) yyerror(lineno);
    };



exp: values
    | exp aritmetic_op values
    ;

aritmetic_op: ADD
            | SUB
            | MUL
            | DIV
            ;


values: ID	{ if ($1->st_type != INT) yyerror(lineno);
		if (lookup_scope($1->st_name, MAXTOKENLEN) == NULL) yyerror(lineno); }
    | ICONST
    ;

/* statements */
statements: statements statement | statement ;

statement:
	if_statement | for_statement | initialisations | declarations
;

incr:
    ID INCR SEMI {if (lookup_scope($1->st_name, MAXTOKENLEN) == NULL) yyerror(lineno);}
    ;

if_statement:
	{incr_scope();} IF LPAREN arule RPAREN tail {hide_scope();} optional_else
  ;

all_vals: ICONST
    | ID
    | STRING_LIT
    | TRUE
    | FALSE;

optional_else: {incr_scope();} ELSE tail {hide_scope();} | /* empty */ ;

tail: LBRACE tail_options RBRACE ;

tail_options: statement tail_options | ;

for_statement:
    {incr_scope();} FOR LPAREN initialisation arule SEMI ID INCR RPAREN tail {hide_scope();}
    ;






bTer: TRUE | FALSE | values compare values;

bExp: NOT aExp | aExp ;

aExp: aExp AND bTer | oExp | LPAREN bExp RPAREN AND aExp ;

oExp: oExp OR bTer | bTer | LPAREN bExp RPAREN OR oExp | LPAREN bExp RPAREN ;

compare: LS_GR
       | EQU_NOTEQU
       ;

struct: STRUCT ID LBRACE struct_options RBRACE

struct_options: declaration struct_options | /* empty */  ;

print: PRINTF LPAREN print_content RPAREN SEMI ;

print_content: STRING_LIT
             | bExp
             | exp;

function_call: ID LPAREN function_call_params RPAREN SEMI;


function: {incr_scope();} 
	function_head function_tail 
	{if ($3 != $2) {yyerror(1);} hide_scope();}
	
  | 	{incr_scope();} 
  	vfunction_head vfunction_tail 
  	{hide_scope();}
  ;

function_head: type ID LPAREN parameters_optional RPAREN {
  $$=$1;
};

function_call_params: function_call_param | /* empty */ ;

function_call_param: function_call_param COMMA all_vals | all_vals  ;

vfunction_head: VOID ID LPAREN parameters_optional RPAREN;


/* functions */

function: function_head function_tail { if ($1 != $2) yyerror(lineno); }
  | vfunction_head vfunction_tail ;

function_head: INT ID LPAREN parameters_optional RPAREN {
               $2->st_type = INT;
               $$ = INT;
               }
               | STRING ID LPAREN parameters_optional RPAREN {
               $2->st_type = STRING;
               $$ = STRING;
               }
               | BOOL ID LPAREN parameters_optional RPAREN {
               $2->st_type = BOOL;
               $$ = BOOL;
               };

function_tail: LBRACE tail_options return_mandatory RBRACE {$$=$3;};

vfunction_head: VOID ID LPAREN parameters_optional RPAREN ;

vfunction_tail: LBRACE tail_options return_optional RBRACE;

parameters_optional: parameters | /* empty */ ;

parameter : type ID {
	$2->st_type = $1;
	addToScope($2);
	};
parameters: parameters COMMA parameter | parameter  ;

parameter : INT ID ;


return_optional: RETURN SEMI | ;

return_mandatory: RETURN ID SEMI {$$=$2->st_type;};

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

	printf("VAlID!\n");

	// symbol table dump
	yyout = fopen("ToY_dump.out", "w");
	ToY_dump(yyout);
	fclose(yyout);

	return flag;
}
