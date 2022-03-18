%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
"int"		           {printf("token is int\n"); return INT;}
"String"		       {printf("token is String\n"); return STRING;}
"print"				   {printf("token is print\n"); return print;}
[a-zA-Z]			   {yylval.id = yytext[0]; printf("token is id\n"); return identifier;}
[0-9]+                 {yylval.num = atoi(yytext); printf("token is num\n"); return number;}
[ \t\n]                ;
[-+=;]           	   {return yytext[0];}

\"([^\\].)*\"	       {printf("token is Strlit\n"); return STRLIT;}

.                      {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}

