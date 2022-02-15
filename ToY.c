#include <stdio.h>
#include "ToY.h"

extern int yylex();
extern int yylineno;
extern char* yytext;


int main(void)
{
	int ntoken, vtoken;

	ntoken = yylex();
	while(ntoken) {
		vtoken = yylex();
		printf("ntoken is %d\n", ntoken);
		switch(ntoken){
		// case BOOL:
		// {

		// 	if(vtoken == IDENTIFIER){
		// 		printf("VALID\n");
		// 	}
		// }
		default:
			printf("default");
		}
		ntoken = yylex();
	}
	return 0;
}
