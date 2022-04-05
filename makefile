ToY: lex.yy.c y.tab.c
	gcc -g lex.yy.c y.tab.c -o ToY

lex.yy.c: y.tab.c ToY.l
	lex ToY.l

y.tab.c: ToY.y
	yacc -d ToY.y

clean:
	rm -rf lex.yy.c y.tab.c y.tab.h ToY ToY.dSYM

force:
	touch ToY.y
	$(MAKE)
