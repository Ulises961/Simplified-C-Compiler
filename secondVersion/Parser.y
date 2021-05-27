%{

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>
#include "lex.yy.c"
#include "utility/symbolTable.c"
#include "utility/functions.c"

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
%type <integer> varDeclInit
%type <integer> compoundStmt
%type <integer> relOp
%type <integer> mulOp
%type <integer> sumOp
%type <integer> andExp
%type <integer> unaryExp
%type <integer> mulExp
%type <integer> simpleExp
%type <integer> sumExp
%type <integer> variable
%type <integer> relExp

%type <integer> unaryRelExp

%left '-' '+'
%left '*' '/'
%left AND OR
%left SMEQ SM GR GREQ EQ NEQ
%right NOT


%%

program: program stmt '\n'
      | program '\n'
      |
      ;

stmt : varDeclInit ';'
      | simpleExp ';' { $$ = $1; printf("Result: %d\n", $1); }
      | IF '(' simpleExp ')' compoundStmt { if($3==true)$5;}
      | IF '(' simpleExp ')' compoundStmt ELSE compoundStmt {if($3==true){$5;} else {$7;};}
      | WHILE '(' simpleExp ')' DO compoundStmt {while($3){$6;}}
      | BREAK ';' {break;}
      | RETURN ';' { printf("Exiting program\n"); exit(0);}
      | RETURN simpleExp ';' {return $2;}
      | PRINT simpleExp ';' { printf("%d\n", $2); }
      ;

varDeclInit :   typeSpec varDeclId ':' simpleExp  { 
            symbol* x;
            
            if(x = lookup($2))
                  $$ = x->value ;
            else{
                  x = createSymbol($1,$2,$4);
                  //printf( "\n Name of node is: %s\n Value of node is: %d \n Type of node is: %d\n", x-> name, x->value, x->type);
                  $$ = x->value ;
            }
            addSymbol(x);
            //printSymbols();
      }    
      ;

varDeclId : ID { $$ = $1; }
      /* |ID[NUM] {} */
      ;

typeSpec : INT {$$ = 11119; }
      | BOOLEAN {$$ = 11120;}
      ;

compoundStmt : '{' stmt '}' {$$ = $2;}

simpleExp : simpleExp OR simpleExp  { $$ = $1 || $3 ; }
      | andExp
      ;

andExp : andExp AND unaryRelExp { $$ = $1 && $3 ; }
      | unaryRelExp {$$ = $1;}
      ;

unaryRelExp : NOT unaryRelExp { $$ = !($2); }
      | relExp
      ;

relExp : sumExp relOp sumExp { $$ = compare($1,$2,$3); }
      | sumExp

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
      | NUM { $$ = $1;}
      | TRUE {$$ = 1; }
      | FALSE {$$ = 0;}
      | variable
      | '(' simpleExp ')' { $$ = $2; }
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
