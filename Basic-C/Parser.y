%{

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>
#include "lex.yy.c"
#include "utility/functions.c"

void yyerror(char *);
int yylex(void);


%}


%union {
       char* lexeme;			//identifier
       int integer;			//value of an identifier of type int
       struct symbol* symbol;       
}


%token <integer>  NUM
%token <lexeme> ID

%token POW
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

%token <symbol> TRUE
%token <symbol> FALSE

%token INT
%token BOOLEAN
%type <lexeme> varDeclId

%type <integer> typeSpec
%type <integer> stmt
%type <integer> varDeclInit

%type <integer> relOp
%type <integer> mulOp
%type <integer> sumOp
%type <symbol> andExp
%type <symbol> unaryExp
%type <symbol> mulExp
%type <symbol> simpleExp
%type <symbol> sumExp
%type <symbol> relExp
%type <symbol> unaryRelExp

%left AND OR
%left SMEQ SM GR GREQ EQ NEQ
%right NOT


%%

program: program stmt
      |
      ;

stmt : varDeclInit ';'
      | simpleExp ';' { $$ = $1->value; printf("Result: %d\n", $1->value); }
      | IF '(' simpleExp ')' '{'stmt'}' { if($3->value){printf("The condition is true\n");} }
      | IF '(' simpleExp ')' '{'stmt'}' ELSE '{'stmt'}' {if($3->value){printf("The condition is true\n");} else{ printf("This is the else branch executed;\n");}}
      | WHILE '(' simpleExp ')' DO '{'stmt'}' { printf("The while loop should execute here\n");} 
      | RETURN ';' { printf("Exiting program\n"); exit(0);}
      | RETURN simpleExp ';' { printf("%d\n", $2->value); return $2->value;}
      | PRINT simpleExp ';' { printf("%d\n", $2->value); }
      ;

varDeclInit :   typeSpec varDeclId ':' simpleExp  { 
            symbol* x;
            
            if(x = lookup($2))
                  $$ = x -> value ;
            else{
                  x = createSymbol($1,$2,$4->value);
                  //printf( "\n Name of node is: %s\n Value of node is: %d \n Type of node is: %d\n", x-> name, x->value, x->type);
                  $$ = x->value ;
            }
            addSymbol(x);
            //printSymbolTable();
      }
      | varDeclId ':' simpleExp {
            symbol* out = lookup($1);  
            if (out == NULL){
                        printf("Error... Variable %s undefined..\n",$1);
                        exit(1);
            }
            else{
                  if(out->type == $3->type)
                        assignValue(out,$3->value);
                  else{
                        printf("\nInvalid type assignment!\n");
                        exit(1);
                  }
            }          
      }
      ;

varDeclId : ID { $$ = $1; } 
      ;

typeSpec : INT {$$ = 11119; }
      | BOOLEAN {$$ = 11120;}
      ;

simpleExp : simpleExp OR andExp  {
                  if ($1->type != 11120 || $3->type != 11120){
                        printf("\nInvalid boolean operation with integers!\n");
                        exit(1);     
                  }

                  int res = ($1->value || $3->value); 
                  symbol* x = createSymbol(11120, "temp", res);
                  $$ = x; 
            }
      | andExp { $$ = $1; }
      ;

andExp : andExp AND unaryRelExp { 
                  if ($1->type != 11120 || $3->type != 11120){
                        printf("\nInvalid boolean operation with integers!\n");
                        exit(1);     
                  }

                  int res = ($1->value && $3->value); 
                  symbol* x = createSymbol(11120, "temp", res);
                  $$ = x; 
            }
      | unaryRelExp {$$ = $1;}
      ;

unaryRelExp : NOT unaryRelExp { 
                  int res = !($2->value); 
                  symbol* x = createSymbol(11120, "temp", res);
                  $$ = x; 
                  // $$ = !($2); 
            }
      | relExp { $$ = $1; }
      ;

relExp : sumExp relOp sumExp { symbol * x = compare($1, $2, $3); $$ = x; }
      | sumExp { $$ = $1; }
      ;

relOp : GR { $$ = 11111 ; }
      | GREQ { $$ = 11112 ;}
      | SM { $$ = 11113 ; }
      | SMEQ {$$ = 11114 ; }
      | EQ { $$ = 11115 ; }
      | NEQ { $$ = 11116 ; }
      ;

sumExp : sumExp sumOp mulExp { 
            if($1->type == 11120 || $3->type == 11120 ){
                  printf("\nError: you cannot sum two bool!\n");
                  exit(1);
            }else
                  $$ = sum($1->value, $2, $3->value); 
      } 
      | mulExp { $$ = $1; }
      ;

sumOp : '+' { $$ = 11117;}
      | '-'  { $$ = 11118;}
      ;

mulExp : mulExp mulOp unaryExp { 
            if ($1->type != 11119 || $3->type != 11119){
                        printf("\nInvalid integer operation with boolean!\n");
                        exit(1);     
                  }

            $$ = multiply($1->value, $2, $3->value); 
      }
      | unaryExp { $$ = $1; }
      ;

mulOp : '*' { $$ = 11121; }
      | '/'  { $$ = 11122; }
      | POW { $$ = 11123;}
      ;

unaryExp : '-' unaryExp {
                  symbol* x = createSymbol(11119, "temp", ($2->value));
                  x->value = - x->value;
                  $$ = x;
                   
            }
      | NUM {     symbol* x = createSymbol(11119, "temp", $1);
                  $$ = x;
                   }
      | TRUE {
            symbol* x = createSymbol(11120, "temp", 1); 
            $$ = x; 
            }
      | FALSE { symbol* x = createSymbol(11120, "temp", 0); 
            $$ = x;}   
      | ID {  
                  symbol* out = lookup($1);  
                  if (out == NULL){
                              printf("Error... Variable %s undefined..\n",$1);
                              exit(1);
                  }
                  else
                        $$ = out;
            }
      | '(' simpleExp ')' { $$ = $2; }
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
