import java.lang.*;
%%
%public
%standalone

%line
%column

Num = [+-]?[0-9]+

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?

String = \"[^\n\r\"\\]+\"

Identifier = [:jletter:] [:jletterdigit:]*

UNKNOWN_TOKEN = .
%%

<YYINITIAL> {
    "="     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.EQ;}
    "+"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.PLUS;}
    "-"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.MINUS;}

    "*"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.MUL;}
    "/"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.DIV;}
    "mod"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.MOD;}
    "and"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.AND;}
    "or"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.OR;}
    "not"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.NOT;}
    "int"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.INT;}
    "void"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.VOID;}
    "printf"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.PRINTF;}
    "String"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.STRING;}
    "Struct"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.STRUCT;}

    "if"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.IF;}
    "then"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.THEN;}
    "else"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.ELSE;}
    "for"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.FOR;}
    "return"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.RETURN;}
    "bool"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.BOOL;}
    "true"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.TRUE;}
    "false"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.FALSE;}
    ";"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.ENDSTATEMENT;}
    "{"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.OPENCURLY;}
    "}"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.CLOSECURLY;}
    "("     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.OPENBRACE;}
    ")"     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.CLOSEBRACE;}

     {Num}   { String t = yytext();
                                                    char s = t.charAt(0);
                                                    if(s == '+'){
                                                       if(Integer.valueOf(t)<32768){
                                                              return MyGrammarLexer.NUM;
                                                            }else{
                                                              return MyGrammarLexer.UNKNOWN_TOKEN;
                                                            }

                                                        }else if(s == '-'){
                                                      if(Integer.valueOf(t)<32769){
                                                              return MyGrammarLexer.NUM;
                                                            }else{
                                                              return MyGrammarLexer.UNKNOWN_TOKEN;
                                                            }
                                                    }else{
                                                      if(Integer.valueOf(t)<32768){
                                                              return MyGrammarLexer.NUM;
                                                            }else{
                                                              return MyGrammarLexer.UNKNOWN_TOKEN;
                                                            }
                                                    }
                                                    }
    {Identifier}     {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.IDENTIFIER;}
    {String}             {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.STRING_LITERAL;}
    {EndOfLineComment}             {System.out.println("[token at line " + yyline + ":" + yycolumn + " = \"" + yytext() + "\"]"); return MyGrammarLexer.COMMENT;}

    {WhiteSpace}                   { /* ignore */ }

    {UNKNOWN_TOKEN} {return MyGrammarLexer.UNKNOWN_TOKEN;}
}