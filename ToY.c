#include <stdio.h>
#include "ToY.h"

extern int yylex();
extern int yylineno;
extern char* yytext;


int main(void)
{
	int ntoken, vtoken;
	int error = 0;
	
	ntoken = yylex();
	while(ntoken) {
		printf("ntoken is %d\n", ntoken);
		switch (ntoken) {
			case BOOL:
				if (yylex() != IDENTIFIER) error = 1;
				if (yylex() != ENDSTATEMENT) error = 1;
				break;
			default:
				printf("default\n");
		}
		ntoken = yylex();
		if (error == 1) break;
	}
	if (error == 1) printf("NOT VALID\n");
	else printf("VALID\n");
	return 0;
}
