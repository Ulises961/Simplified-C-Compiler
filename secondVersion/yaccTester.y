%{

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>
#include "lex.yy.c"
#include "symbolTable.c"

//#include <symbolTab>

void yyerror(char *);
int yylex(void);
bool compare(int, int, int);
int sum ( int, int, int);
int multiply ( int, int, int);
void addToTail(symbol*);


%}


%union {
       char* lexeme;			//identifier
       int integer;			//value of an identifier of type int
       bool boolean;
      struct symbol* symbol;       
}


%token <integer>  NUM //
%token <integer>BOOL
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
%token PRINT
%token RETURN
%token <boolean>TRUE
%token <boolean>FALSE
%token <integer>INT

%type <integer> relOp
%type <integer> mulOp
%type <integer> sumOp
%type <integer> unaryExp
%type <integer> mulExp
%type <integer> simpleExp
%type <integer> sumExp
%type <lexeme> varDeclId
%type <symbol> varDeclInit
%type <integer> stmt
%type <integer> compoundStmt
%type <boolean> boolExp
%type <integer> typeSpec
%type <boolean> unaryRelExp

%left '-' '+'
%left '*' '/'
%left AND OR
%right NOT
%right UMINUS




%%
program : 
      program program { printf("Reached parsing");}
      |stmt 
      |varDeclInit ';'
      |PRINT stmt ';' {printf("%d\n",$2);}
      |RETURN { printf("Exiting"); exit(0);}
      |RETURN simpleExp ';' {return $2;}
      ;

varDeclInit :   typeSpec varDeclId ':' simpleExp  ';' '\n'  { 
            symbol* x;
            if(x = lookup($2))
                  $$ = x ;
            else{
                  x = createSymbol($1,$2,$4);
                  printf( "\n Name of node is: %s\n Value of node is: %d \n Type of node is: %d\n", x-> name, x->value, x->type);
                  $$ = x ;
            }
            addToTail(x);
            
      }  
     
    
      ;
varDeclId : ID { $$ = $1; }
      /* |ID[NUM] {} */
      ;
typeSpec : INT {$$ = 11119; }
      | BOOL {$$ = 11120;}
      ;
 stmt : 
      varDeclInit {$$ = $1->value;}
      |IF '(' simpleExp ')' compoundStmt { if($3)$5;}
      |IF '(' simpleExp ')' compoundStmt ELSE compoundStmt {if($3){$5;} else {$7;};}
      |WHILE '(' simpleExp ')' DO compoundStmt {while($3){$6;}}
      |BREAK ';' {break;}
      |simpleExp ';' { $$ = $1;}
      ;
compoundStmt : '{'stmt'}'{$$ = $2;}

simpleExp : 
      boolExp  {$$ = $1;}
      |unaryExp {$$ = $1;}
      |sumExp { $$ = $1;}
      | ID {  symbol* out = lookup($1);  
            if (out == NULL){
                        printf("Error... Variable %s undefined..\n",$1);
                        exit(1);
            }
            else
                  $$ = out->value;
      }
      ;
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
sumExp: sumExp sumOp sumExp { $$ = sum ($1,$2,$3); }
      |mulExp { $$ = $1; }
       | '('sumExp')'             { $$ = $2; }
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
      initialize();
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
int sum ( int a, int op, int c){
      switch (op){
            case 11117 : return (a + c);
            case 11118 : return (a - c); 
      }
}

int multiply ( int a, int op, int c){
      switch (op){
            case 11121 : return (a * c);
            case 11122 : return (a / c); 
      }
}