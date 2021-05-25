%{

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>
//#include <symbolTab>

void yyerror(char *);
int yylex(void);
bool compare(int, int, int);

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
%token <boolean>TRUE
%token <boolean>FALSE
%token RETURN
%token <lexeme> INT
%token <lexeme> BOOLEAN
%type <integer> relOp
%type <integer> unaryExp
%type <integer> intExp
%type <boolean> boolExp
%type <boolean> andExp
%type <lexeme> typeSpec
%type <integer> sumExp
%type <boolean> unaryRelExp
%left '-' '+'
%left '*' '/'
%left AND OR
%right NOT
%right UMINUS




%%
program : typeSpec varDeclInit ';' {}
      | stmt {}
      |program program {}
      |boolExp '\n'{ printf("%d",$1);exit(1);}
      ; 
varDeclInit : varDeclId
      |varDeclId ':' simpleExp
      ;
varDeclId : ID
      |ID[NUM]
      ;
typeSpec : INT
      | BOOL
      ;
 stmt : exp;
      |;
      |IF '(' simpleExp ')' compoundStmt
      |IF '(' simpleExp ')' compoundStmt ELSE compoundStmt
      |WHILE simpleExp DO compoundStmt
      |BREAK ';'
      |RETURN ';'
      |RETURN exp ';'
      ;
compoundStmt : '{'localDecls stmt'}'
localDecls : localDecls scopedVarDecl 
      |scopedVarDecl
      ;
scopedVarDecl : typeSpec varDeclInit;
exp : program
      | simpleExp
      ;
simpleExp : 
      |boolExp
      |unaryExp
      ;
boolExp : boolExp OR boolExp { $$ = $1 | $3 ;}
      | boolExp AND unaryRelExp { $$ = $1 &&  $3;}
      | unaryRelExp {$$ = $1;}
    
      ;
unaryRelExp: NOT unaryRelExp
      |sumExp relOp sumExp { $$ = compare($1,$2,$3); }
      |TRUE {$$ = true;}
      |FALSE {$$ = false;}
      ;
      
relOp: GR { $$ = 11111 ;}
      |GREQ { $$ = 11112 ;}
      |SM { $$ = 11113 ;}
      |SMEQ {$$ = 11114 ; }
      |EQ { $$ = 11115 ;}
      |NEQ { $$ = 11116 ; }
      ;
sumExp: sumExp sumOp mulExp 
      |mulExp
      ;
sumOp: '+'
      |'-'
      ;
mulExp : mulExp mulOp unaryExp
      | unaryExp
      ;
mulOp: '*'
      | '/'
      ;
unaryExp: '-' NUM
      |NUM
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




bool compare(int a, int b, int c){
      bool res;
      switch (b){
            case 11111: res = (a >c);
            break;
            case 11112: res = (a >= c);
            break;
            case 11113: res = (a < c); 
            break;
            case 11114: res = (a <= c);
            break;
            case 11115: res = (a == c);
            break;
            case 11116: res = (a != c);
            break;
             }
      return res;
}
