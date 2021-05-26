all:
	flex Analyzer.l
	yacc -vd yaccTester.y
	gcc y.tab.c -ly -ll -o tester