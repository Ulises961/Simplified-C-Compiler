%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
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
%token '['
%token  ']'
%token '{'
%token '}'
%token '('
%token ')'
%token 'true'
%token 'false'


%

%left '-' '+'
%left '*' '/'
%right UMINUS

%start line

%%
line  : expr '\n'      {printf("Result: %f\n", $1); exit(0);}
      | ID             {printf("Result: %s\n", $1); exit(0);}
      ;
expr  : expr ':' expr  {$$ = assign($1,$2);}
      | expr '-' expr  {$$ = $1 - $3;}
      | expr '*' expr  {$$ = $1 * $3;}
      | expr '/' expr  {$$ = $1 / $3;}
      | INT            {$$ = $1;}
      | '-' expr %prec UMINUS {$$ = -$2;}
      ;

%%

#include "lex.yy.c"

assign (x,y){

return z = x+y

}
return 