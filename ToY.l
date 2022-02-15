
%{
	#include "ToY.h"
%}


%%

int		return INTEGER;
void		return VOID;
printf		return PRINTF;
string		return STRING;
struct		return STRUCT;
if		return IF;
then		return THEN;
else		return ELSE;
for		return FOR;
return 	return RETURN;
bool		return BOOL;
true		return TRUELIT;
false		return FALSELIT;
";"		return ENDSTATEMENT;
"+"|"-"|"*"|"/"|mod|and|or|not	return ARITHOP;
">"|"<"|">="|"<="|"=="|"!="	return COMPARE;
"{"		return OPENCURLY;
"}"		return CLOSECURLY;
"("		return OPENBRACE;
")"		return CLOSEBRACE;
"="		return ASSIGN;

\"([^\\].)*\"	return STRLIT;
"//".*[\n]	return COMMENT;
[a-zA-Z][_a-zA-Z0-9]* 	return IDENTIFIER;
[+-]?[1-9][0-9]*	return INTLIT;
[ \t\n]+	;
.		printf("ERROR\n");

%%

int yywrap(void)
{
	return 1; 
}
