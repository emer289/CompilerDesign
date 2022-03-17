%define api.prefix {MyGrammar}
%define api.parser.class {MyGrammar}
%define api.parser.public
%define parse.error verbose

%code imports{
  import java.io.InputStream;
  import java.io.InputStreamReader;
  import java.io.Reader;
  import java.io.IOException;
}

%code {
  public static void main(String args[]) throws IOException {
    MyGrammarLexer lexer = new MyGrammarLexer(System.in);
    MyGrammar parser = new MyGrammar(lexer);
    if(parser.parse())
      System.out.println("Parsing Result = SUCCESS");
    return;
  }
}

%token UNKNOWN_TOKEN EQ PLUS MINUS MUL DIV MOD
AND OR NOT INT VOID PRINTF STRING STRUCT IF THEN
ELSE FOR RETURN BOOL TRUE FALSE ENDSTATEMENT OPENCURLY
CLOSECURLY OPENBRACE CLOSEBRACE NUM IDENTIFIER STRING_LITERAL COMMENT

%%

prog:
  srule
;

srule   
    : EQ srule PLUS
    | EQ PLUS MINUS MUL DIV MOD AND OR NOT INT VOID PRINTF STRING STRUCT IF THEN ELSE FOR RETURN BOOL TRUE FALSE ENDSTATEMENT OPENCURLY CLOSECURLY OPENBRACE CLOSEBRACE
    | NUM
    | IDENTIFIER
    | STRING_LITERAL
    | COMMENT
;

%%

class MyGrammarLexer implements MyGrammar.Lexer {
  InputStreamReader it;
  Yylex yylex;

  public MyGrammarLexer(InputStream is){
    it = new InputStreamReader(is);
    yylex = new Yylex(it);
  }

  @Override
  public void yyerror (String s){
    System.err.println(s);
  }

  @Override
  public Object getLVal() {
    return null;
  }

  @Override
  public int yylex () throws IOException{
    return yylex.yylex();
  }
}