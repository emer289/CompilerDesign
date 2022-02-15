%{
	#include "ToY.h"
%}


%%

int|void|printf|string|struct|if|then|else|for|return 	return KEYWORD;
bool					return BOOL;
true                    return TRUE
false				    return FALSE;
\"[a-zA-Z]+\"		  	return STRING;
"//".*[\n]				return COMMENT;
[a-zA-Z][_a-zA-Z0-9]* 	return IDENTIFIER;
[+-]?[1-9][0-9]*		return INTEGER;
"!="					return SYMBOL;
"{"|"}"|";"|"<"|">"|"=="|"<="|">="|"!"|"("|")"|"+"|"-"|"."|"="		return SYMBOL;
[ \t\n]				  	;
.						printf("ERROR\n");

%%

int yywrap(void)
{
	return 1; 
}
