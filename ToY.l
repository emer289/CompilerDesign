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

alpha     [a-zA-Z_]
digit     [0-9]
alnum     {alpha}|{digit}

ID        {alpha}+{alnum}*
ICONST    "0"|[0-9]{digit}*
FCONST    "0"|{digit}*"."{digit}+
STRING_LIT    \"([^"\\])*\"

%%

"//".*        { printf("comment at line %d\n", lineno); }
"##".*        { printf("comment at line %d\n", lineno); }

"bool"                { return BOOL; }
"int"                 { return INT; }
"true"                { return TRUE; }
"false"               { return FALSE; }
"void"                { return VOID; }
"printf"              { return PRINTF;}
"string"              { return STRING; }
"struct"              { return STRUCT;}
"if"                  { return IF; }
"then"                { return THEN;}
"else"                { return ELSE; }
"for"                 { return FOR; }
"return"              { return RETURN; }

"{"       { return LBRACE; }
"}"       { return RBRACE; }
";"       { return SEMI; }
">"|"<"|">="|"<="   { return LS_GR; }
"=="|"!="           { return EQU_NOTEQU; }
"!"|"not"           { return NOT; }
"+"                 { return ADD; }
"-"                 { return SUB; }
"/"                 { return DIV; }
"."                 { return FULLSTOP; }
"*"                 { return MUL; }
"="       { return ASSIGN; }
"mod"                 { return MOD;}
"++"|"--"           { return INCR; }
"or"                { return OR; }
"and"                { return AND; }

"("       { return LPAREN; }
")"       { return RPAREN; }


","       { return COMMA; }


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