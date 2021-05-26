all:
	flex Analyzer.l
	yacc -vd calc-yacc.y
	gcc y.tab.c -ly -ll -o tester