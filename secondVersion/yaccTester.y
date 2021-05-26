%{

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>
#include "lex.yy.c"
#include "../symbolTable.c"

//#include <symbolTab>

void yyerror(char *);
int yylex(void);
bool compare(int, int, int);
int sum ( int, int, int);
int multiply ( int, int, int);
int symbols[26];

%}


%union {
       char* lexeme;			//identifier
       int integer;			//value of an identifier of type int
       bool boolean;
       }


%token <integer>  NUM //
%token BOOL
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
%token INT
//%token BOOLEAN
%type <integer> relOp
%type <integer> mulOp
%type <integer> sumOp
%type <integer> unaryExp
%type <integer> mulExp
%type <integer> simpleExp
%type <integer> sumExp
%type <integer> intExp
%type <lexeme> varDeclId
%type <lexeme> varDeclInit
%type <boolean> boolExp


%type <lexeme> typeSpec

%type <boolean> unaryRelExp
%left '-' '+'
%left '*' '/'
%left AND OR
%right NOT
%right UMINUS




%%
program : 
      typeSpec varDeclInit ';' { symbol* x = createSymbol($2,$1);
                                          printf("%s",x->name);exit(1);}
      | stmt {}
      |program program {}
      |boolExp '\n'{ printf("%d",$1);exit(1);}
      ; 
varDeclInit : 
      varDeclId { $$ = $1; }
      | varDeclId ':' simpleExp {
            symbol* x = lookup($1);

            if(x != NULL){
                  assignValue(x, $3);
            }
            $$ = x;
        }
      ;
varDeclId : ID { $$ = $1;}
      |ID[NUM] {}
      ;
typeSpec : INT {$$ = 11119;}
      | BOOL {$$ = 11120;}
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
      |boolExp  {$$ = $1;}
      |unaryExp {$$ = $1;}
      ;
boolExp : boolExp OR boolExp { $$ = $1 || $3 ;}
      | boolExp AND unaryRelExp { $$ = $1 &&  $3;}
      | unaryRelExp {$$ = $1;}
    
      ;
unaryRelExp: NOT unaryRelExp { $$ = !($2); }
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
sumExp: sumExp sumOp mulExp { $$ = sum ($1,$2,$3); }
      |mulExp { $$ = $1; }
      ;
sumOp: '+' { $$ = 11117;}
      |'-'  { $$ = 11118;}
      ;
mulExp : mulExp mulOp unaryExp { $$ = multiply($1,$2,$3);}
      | unaryExp
      ;
mulOp: '*' { $$ = 11121;}
      | '/'  { $$ = 11122;}
      ;
unaryExp: '-' NUM { $$ = -$2;}
      |NUM { $$ = $1;}
      ;


%%


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
            case 11111: res = (a > c);
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
int sum ( int a, int b, int c){
      switch (b){
            case 11117 : return (a + b);
            case 11118 : return (a - b); 
      }
}

int multiply ( int a, int b, int c){
      switch (b){
            case 11121 : return (a * b);
            case 11122 : return (a / b); 
      }
}