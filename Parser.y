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
       int integer;			//value of an identifier of type int
       bool boolean;
       }


%token <integer>  NUM //
%token <boolean>  BOOL
%token <lexeme> ID

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
%token INT
%token BOOLEAN
%type <integer> intExpr
%type <boolean> boolExpr

%left '-' '+'
%left '*' '/'
%left AND OR
%right NOT
%right UMINUS

%%
program  : intExpr '\n'      {printf("Result: %d (size: %lu)\n", $1, sizeof($1)); exit(0);}
      | boolExpr '\n' {
            if ($1 == 1)
                  printf("Result: true (size: %lu)\n", sizeof($1));
            else
                printf("Result: false (size: %lu)\n", sizeof($1));  
            exit(0);}
      | ID '\n'            {printf("ID: %s\n", $1); exit(0);}
      | INT '\n' {printf("Int type recognized\n"); exit(0);}
      | declaration
      ;

declaration: INT ID ':' intExpr'\n' {printf("Variable %s, of type int, value: %d\n", $2, $4); exit(0);}
             | BOOLEAN ID ':' boolExpr'\n' {printf("Variable %s, of type bool, value: %d\n", $2, $4); exit(0);}
      ;



intExpr  : intExpr '+' intExpr  {$$ = $1 + $3;}
      | intExpr '-' intExpr  {$$ = $1 - $3;}
      | intExpr '*' intExpr  {$$ = $1 * $3;}
      | intExpr '/' intExpr  {$$ = $1 / $3;}
      | NUM            {$$ = $1;}
      | '-' intExpr %prec UMINUS {$$ = -$2;}
      | '(' intExpr ')' { $$ = $2; }
      ;

boolExpr : boolExpr AND boolExpr {$$ = $1 && $3;}
      | boolExpr OR boolExpr {$$ = $1 || $3;}
      | NOT boolExpr { if($2==1){ $$=0; }else{ $$=1;} } 
      | BOOL {$$ = $1;}
      | '(' boolExpr ')' { $$ = $2; }
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