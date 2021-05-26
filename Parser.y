%{

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>
#include "utility/symbolTable.c"
#include "utility/functions.c"

void yyerror(char *);
int yylex(void);

// custom function
bool compare(int, int, int);
int sum ( int, int, int);
int multiply ( int, int, int);

%}


%union {
       char* lexeme;			//identifier
       int integer;			//value of an identifier of type int
}


%token <integer>  NUM //
%token <integer>  BOOL
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
%token SMEQ
%token SM 
%token GR 
%token GREQ 
%token EQ 
%token NEQ 
%token TRUE
%token FALSE
%token RETURN
%token PRINT

%token <lexeme> INT
%token <lexeme> BOOLEAN

%type <integer> intExpr
%type <integer> boolExpr
%type <integer> expr
%type <lexeme> typeSpec
%type <integer> relExpr

%left '-' '+'
%left '*' '/'
%left AND OR
%left SMEQ SM GR GREQ EQ NEQ
%right NOT
%right UMINUS


%%
program: program statement '\n'
      |
      ;

statement: varDecl ';'
      | expr ';'
      | PRINT expr ';' {printf("%d\n",$2);}
      | RETURN ';' {printf ("Exiting program...\n"); exit(0);}
      ;


varDecl: typeSpec ID ':' expr {                                   // assignment of true or false values to int variable makes automatic conversion
            if (strcmp($1,"bool")==0 && ($4 != 0 && $4 != 1)){    // for bool variables only true, false, 0 and 1 are accepted
                  yyerror("TypeError, cannot assign int value to bool variable...\n");
                  exit(1);
            }
            if (strcmp($1,"int")==0)
                  printf("Variable %s, of type %s, value: %d\n", $2, $1, $4);
            else
                  printf("Variable %s, of type %s, value: %s\n", $2, $1, (($4 == 1) ? "true" : "false"));

            // create variable in symbol table
            addToTail($2,$1,$4);
      }
      }
      ;

typeSpec: INT 
      | BOOLEAN ;

expr : intExpr    { printf("Integer expression result: %d\n", $1); }
      | boolExpr  { printf("Boolean expression result: %s\n", (($1 == 1) ? "true" : "false"));}
      | relExpr   { printf("Relational expression result: %s\n", (($1 == 1) ? "true" : "false"));}
      | ID {  symbol* out = lookup($1);  
            if (out == NULL){
                        printf("Error... Variable %s undefined..\n",$1);
                        exit(1);
            }
            else
                  $$ = out->value;
      }
      ;

intExpr  : intExpr '+' intExpr      {$$ = $1 + $3;}
      | intExpr '-' intExpr         {$$ = $1 - $3;}
      | intExpr '*' intExpr         {$$ = $1 * $3;}
      | intExpr '/' intExpr         {$$ = $1 / $3;}
      | NUM                         {$$ = $1;}
      | '-' intExpr %prec UMINUS    {$$ = -$2;}
      | '(' intExpr ')'             { $$ = $2; }
      ;

boolExpr : boolExpr AND boolExpr    { $$ = $1 && $3; }
      | boolExpr OR boolExpr        { $$ = $1 || $3; }
      | NOT boolExpr                { if ($2==1) { $$ = 0; } else { $$ = 1; } } 
      | BOOL                        { $$  = $1; }
      | '(' boolExpr ')'            { $$ = $2; }
      ;

relExpr : expr SMEQ expr      {if ($1 <= $3) $$ = 1;else $$ = 0;}
      | expr SM expr          {if ($1 < $3) $$ = 1;else $$ = 0;}
      | expr GR expr          {if ($1 > $3) $$ = 1;else $$ = 0;}
      | expr GREQ expr        {if ($1 >= $3) $$ = 1;else $$ = 0;}
      | expr EQ expr          {if ($1 == $3) $$ = 1;else $$ = 0;}
      | expr NEQ expr         {if ($1 != $3) $$ = 1;else $$ = 0;}
      | '(' relExpr ')'            { $$ = $2; }
      ;


%%

#include "lex.yy.c"

void yyerror(char *s) {
      fprintf(stderr, "%s\n", s);
}

int main(void) {

      initialize(); //initialize symbol table

      yyparse();

      return 0;
}