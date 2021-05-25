%{

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>

void yyerror(char *);
int yylex(void);

int symbols[26];

%}


%union {
       char* lexeme;			//identifier
       int value;			//value of an identifier of type int
       }


%token <value>  INT //
%token <lexeme> ID
%token BOOL
%token CHAR
%token BREAK
%token AND
%token OR
%token NOT
%token IF
%token ELSE
%token WHILE
%token DO
%token EQ
%token NEQ
%token GREQ
%token GR
%token SM
%token SMEQ
%token TRUE
%token FALSE

%type <value> expr

%left '-' '+'
%left '*' '/'
%left ':'
%right UMINUS

%%
program  : expr '\n'      {printf("Result: %d\n", $1); exit(0);}
      | ID '\n'            {printf("Result: %s\n", $1); exit(0);}
      ;

expr  : expr '+' expr  {$$ = $1 + $3;}
      | expr '-' expr  {$$ = $1 - $3;}
      | expr '*' expr  {$$ = $1 * $3;}
      | expr '/' expr  {$$ = $1 / $3;}
      | INT            {$$ = $1;}
      | '-' expr %prec UMINUS {$$ = -$2;}
      | '(' expr ')' { $$ = $2; }
      ;

%%

#include "lex.yy.c"

void yyerror(char *s) {
      fprintf(stderr, "%s\n", s);
}

int main(void) {
      yyparse();
      return 0;
}