%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "ToY.h"
	#include "y.tab.h"
	extern FILE *yyin;
	extern FILE *yyout;

	int lineno = 1; // initialize to 1
	void ret_print(char *token_type);
	void yyerror();
%}

%x ML_COMMENT

alpha     [a-zA-Z]
digit     [0-9]
alnum     {alpha}|{digit}
print     [ -~]

ID        {alpha}+{alnum}*
ICONST    "0"|[0-9]{digit}*
FCONST    "0"|{digit}*"."{digit}+
STRING_LIT    \"{print}*\"

%%

"//".*        { printf("Eat up comment at line %d\n", lineno); }


"for"                 { return FOR; }
"int"|"INT"           { return INT; }
"if"|"IF"             { return IF; }
"else"|"ELSE"         { return ELSE; }
"string"              { return STRING; }
"true"                { return TRUE; }
"false"                { return FALSE; }


"++"|"--"           { return INCR; }
">"|"<"|">="|"<="   { return LS_GR; }
"=="|"!="           { return EQU_NOTEQU; }

"+"                 { return ADD; }
"-"                 { return SUB; }
"/"                 { return DIV; }
"*"                 { return MUL; }

"or"                { return OR; }
"and"                { return AND; }
"not"                 { return NOT; }



"("       { return LPAREN; }
")"       { return RPAREN; }
"{"       { return LBRACE; }
"}"       { return RBRACE; }
";"       { return SEMI; }
"="       { return ASSIGN; }


{ID}    {
        // insert identifier into symbol table
        insert(yytext, strlen(yytext), UNDEF, lineno);
        yylval.ToY_item = lookup(yytext);
        return ID;
        }
{ICONST}    { yylval.int_val   = atoi(yytext); return ICONST; }
{STRING_LIT}    { yylval.str_val = malloc(yyleng * sizeof(char));
              strcpy(yylval.str_val, yytext);  return STRING_LIT; }


"\n"        { lineno += 1; }
[ \t\r\f]+  /* eat up whitespace */

.       { yyerror("Unrecognized character"); }

%%
