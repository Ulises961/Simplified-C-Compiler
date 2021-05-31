all:
	flex Analyzer.l
	yacc -vd Parser.y
	gcc y.tab.c -ly -ll -o compiler.out