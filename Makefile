default:
	clear
	jflex MyGrammar.flex
	bison MyGrammar.y -L java
	javac *.java
	
clean:
	rm MyGrammar.java *.class Yylex.java Yylex.java\~
