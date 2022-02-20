import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;

class Yytoken {
  public String type;
  public Object value;
  public Yytoken(String type) {
    this.type = type;
  }
  public Yytoken(String type, Object value) {
    this.type = type;
    this.value = value;
  }
}

%%

%unicode

%{
StringBuffer stringBuffer = new StringBuffer();

public static void main(String[] args) throws FileNotFoundException, IOException{
            FileReader yyin = new FileReader(args[0]);
            Yylex yy = new Yylex(yyin);
            Yytoken t;
            while ((t = yy.yylex()) != null)
                System.out.println(t.type);
}
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?

Identifier = [:jletter:] [:jletterdigit:]*


%%
<YYINITIAL> {


"="                            { return new Yytoken("EQ"); }
"+"                            { return new Yytoken("PLUS"); }
"-"                            { return new Yytoken("MINUS"); }
"*"                            { return new Yytoken("MUL"); }
"/"                            { return new Yytoken("DIV"); }
"mod"                          { return new Yytoken("MOD"); }
"and"                          { return new Yytoken("AND"); }
"or"                           { return new Yytoken("OR"); }      
"not"                          { return new Yytoken("NOT"); }  

"int"                          { return new Yytoken("INT"); }  
"void"                         { return new Yytoken("VOID"); }  
"printf"                       { return new Yytoken("PRINTF"); }  
"String"                       { return new Yytoken("STRING"); }  
"struct"                       { return new Yytoken("STRUCT"); }  
"if"                           { return new Yytoken("IF"); }  
"then"                         { return new Yytoken("THEN"); }  
"else"                         { return new Yytoken("ELSE"); }  
"for"                          { return new Yytoken("FOR"); }  
"return"                       { return new Yytoken("RETURN"); }  
"bool"                         { return new Yytoken("BOOL"); }  
"true"                         { return new Yytoken("TRUE"); } 
"false"                        { return new Yytoken("FALSE"); }  
";"                            { return new Yytoken("ENDSTATEMENT"); } 
"{"                            { return new Yytoken("OPENCURLY"); }  
"}"                            { return new Yytoken("CLOSECURLY"); }  
"("                            { return new Yytoken("OPENBRACE"); }
")"                            { return new Yytoken("CLOSEBRACE"); }  


[+]?[0-9]+                    { String t = yytext();
                            char s = t.charAt(0);
                            if(s == '+'){
                               if(Integer.valueOf(t)<32768){
                                      return new Yytoken("DIGIT");
                                    }else{
                                      return new Yytoken("ERROR");
                                    }
                                  
                                }else if(s == '-'){
                              if(Integer.valueOf(t)<32769){
                                      return new Yytoken("DIGIT");
                                    }else{
                                      return new Yytoken("ERROR");
                                    }
                            }else{
                              if(Integer.valueOf(t)<32768){
                                      return new Yytoken("DIGIT");
                                    }else{
                                      return new Yytoken("ERROR");
                                    }
                            }
                            }
                           


{Identifier}                   { return new Yytoken("IDENTIFIER"); }

\"[^\n\r\"\\]+\"               { return new Yytoken("STRING_LITERAL"); }
{EndOfLineComment}             { return new Yytoken("COMMENT"); }

{WhiteSpace}                   { /* ignore */ }

.*                             { return new Yytoken("ERROR"); }
}

/* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                                yytext()+">"); }
