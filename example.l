class Token {
	String text;
	Token(String t) {
		text = t;
	}
}

%%

Digit = [0-9]
AnyLet = [A-Za-z]
Others = [0-9 & .]
WhiteSp = [\040\ n]

%type Token

%class Lexer

%eofval {
	return new Token(null); %
	eofval
}

%%

{Digit}+ {
	return new Token(yytext());
}
{WhiteSp}+ {
	//do something
}

. {
	throw new Error("Illegal character <" +yytext()+">");

}
 
%%

import java.io*;

public static void main(String argv[]) throws IOException {
	Yylex yy = new Yylex(System.in);
	Yytoken t;
	while ((t = ))
}