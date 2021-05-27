%{

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>
#include "lex.yy.c"
#include "utility/symbolTable.c"
#include "utility/functions.c"

//#include <symbolTab>

void yyerror(char *);
int yylex(void);


%}


%union {
       char* lexeme;			//identifier
       int integer;			//value of an identifier of type int
       bool boolean;
      struct symbol* symbol;       
}


%token <integer>  NUM //
%token <integer> BOOL
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

%token <boolean> TRUE
%token <boolean> FALSE

%token <lexeme> INT
%token <lexeme> BOOLEAN
%type <lexeme> varDeclId

%type <integer> typeSpec
%type <integer> stmt
%type <integer> compoundStmt
%type <integer> relOp
%type <integer> mulOp
%type <integer> sumOp
%type <integer> unaryExp
%type <integer> mulExp
%type <integer> simpleExp
%type <integer> sumExp
%type <integer> variable

%type <boolean> boolExp
%type <boolean> unaryRelExp

%type <symbol> varDeclInit

%left '-' '+'
%left '*' '/'
%left AND OR
%right NOT
%right UMINUS


%%

program : program program '\n' { printf("Reached parsing\n");}
      | stmt ';'
      | varDeclInit ';'
      | PRINT stmt ';' {printf("%d\n",$2);}
      | RETURN { printf("Exiting\n"); exit(0);}
      | RETURN simpleExp ';' {return $2;}
      |
      ;

varDeclInit :   typeSpec varDeclId ':' simpleExp  { 
            symbol* x;
            
            if(x = lookup($2))
                  $$ = x ;
            else{
                  x = createSymbol($1,$2,$4);
                  printf( "\n Name of node is: %s\n Value of node is: %d \n Type of node is: %d\n", x-> name, x->value, x->type);
                  $$ = x ;
            }
            addSymbol(x);
            printSymbols();
      }  
     
    
      ;
varDeclId : ID { $$ = $1; }
      /* |ID[NUM] {} */
      ;

typeSpec : INT {$$ = 11119; }
      | BOOLEAN {$$ = 11120;}
      ;

stmt : varDeclInit {$$ = $1->value;}
      | IF '(' simpleExp ')' compoundStmt { if($3)$5;}
      | IF '(' simpleExp ')' compoundStmt ELSE compoundStmt {if($3){$5;} else {$7;};}
      | WHILE '(' simpleExp ')' DO compoundStmt {while($3){$6;}}
      | BREAK ';' {break;}
      | simpleExp { $$ = $1; }
      ;

compoundStmt : '{' stmt '}' {$$ = $2;}

simpleExp : boolExp  {$$ = $1; printf("Boolean result: %s\n", (($1 == 1) ? "true" : "false"));}
      | unaryExp {$$ = $1; printf("Unary result: %d\n", $1);}
      | sumExp { $$ = $1; printf("Result: %d\n", $1);}
      ;

boolExp : boolExp OR boolExp { $$ = $1 || $3 ; }
      | boolExp AND unaryRelExp { $$ = $1 &&  $3; }
      | unaryRelExp {$$ = $1;}
      ;

unaryRelExp : NOT unaryRelExp { $$ = !($2); }
      | sumExp relOp sumExp { $$ = compare($1,$2,$3); }
      | TRUE {$$ = 1;}
      | FALSE {$$ = 0;}
      | '(' unaryRelExp ')'  { $$ = $2; }
      ;
      
relOp : GR { $$ = 11111 ; }
      | GREQ { $$ = 11112 ;}
      | SM { $$ = 11113 ; }
      | SMEQ {$$ = 11114 ; }
      | EQ { $$ = 11115 ; }
      | NEQ { $$ = 11116 ; }
      ;

sumExp : sumExp sumOp mulExp { $$ = sum($1,$2,$3); }
      | mulExp { $$ = $1; }
      ;

sumOp : '+' { $$ = 11117;}
      | '-'  { $$ = 11118;}
      ;

mulExp : mulExp mulOp unaryExp { $$ = multiply($1,$2,$3); }
      | unaryExp
      ;

mulOp : '*' { $$ = 11121; }
      | '/'  { $$ = 11122; }
      ;

unaryExp : '-' unaryExp { $$ = -$2; }
      | '(' sumExp ')' { $$ = $2; }
      | NUM { $$ = $1;}
      | variable
      ;

variable :  ID {  symbol* out = lookup($1);  
            if (out == NULL){
                        printf("Error... Variable %s undefined..\n",$1);
                        exit(1);
            }
            else
                  $$ = out->value;
      }
      ;

%%


void yyerror(char *s) {
      fprintf(stderr, "%s\n", s);
}

int main(void) {
      initialize(); // initialize symbol table
      yyparse();
      
      return 0;
}
