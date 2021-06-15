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

program: program stmt // left recursion
      |     // closing epsylon
      ;

stmt : varDeclInit ';' 
      | simpleExp ';' { $$ = $1->value; printf("Result: %d\n", $1->value); }
      | IF '(' simpleExp ')' '{'stmt'}' { if($3->value){printf("The condition is true\n");} }
      | IF '(' simpleExp ')' '{'stmt'}' ELSE '{'stmt'}' {if($3->value){printf("The condition is true\n");} else{ printf("This is the else branch executed;\n");}}
      | WHILE '(' simpleExp ')' DO '{'stmt'}' { printf("The while loop should execute here\n");} 
      | RETURN ';' { printf("Exiting program\n"); exit(0);} // Eg: return;
      | RETURN simpleExp ';' { printf("%d\n", $2->value); return $2->value;} //Eg: return x: 2;
      | PRINT simpleExp ';' { printf("%d\n", $2->value); } // Eg: print x ;
      ;

varDeclInit :   typeSpec varDeclId ':' simpleExp  { // Eg:  bool y : true 
            symbol* x = createSymbol($1,$2,$4->value); // we create a new symbol 
      
            $$ = x->value ; // we assign the value of our new variable to the head of the rule
      
            addSymbol(x); // And then look for it in the symbol table, if it already exists then it throws and error 

      }
      | varDeclId ':' simpleExp {
            // if id of variable is not found in the symbol table, throw error
            // otherwise update its value
            symbol* out = lookup($1);  
            if (out == NULL){
                        printf("Error... Variable %s undefined..\n",$1);
                        exit(1);
            }
            else{
                  if(out->type == $3->type) // check if variable type and new value type correspond
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

typeSpec : INT {$$ = 11119; }  // Arbitrary codes to identify the type in the symbol table
      | BOOLEAN {$$ = 11120;}  
      ;

simpleExp : simpleExp OR andExp  {
                  // Checking coherent types for relational operations 
                  if ($1->type != 11120 || $3->type != 11120){ 
                        printf("\nInvalid boolean operation with integers!\n");
                        exit(1);     
                  }

                  // we evaluate the expression and return it inside a new symbol
                  int res = ($1->value || $3->value); 
                  symbol* x = createSymbol(11120, "temp", res);
                  $$ = x; 
            }
      | andExp { $$ = $1; }
      ;

andExp : andExp AND unaryRelExp { 
                  // as above, check if type of both expressions is boolean
                  if ($1->type != 11120 || $3->type != 11120){ 
                        printf("\nInvalid boolean operation with integers!\n");
                        exit(1);     
                  }

                  // we assign the value of the and operation to the head of the rule
                  int res = ($1->value && $3->value);  
                  symbol* x = createSymbol(11120, "temp", res);  
                  $$ = x; 
            }
      | unaryRelExp {$$ = $1;} // either a boolean or an arithmetic operation 
      ;

unaryRelExp : NOT unaryRelExp { 
                  int res = !($2->value); 
                  symbol* x = createSymbol(11120, "temp", res);
                  $$ = x; 
            }
      | relExp { $$ = $1; } 
      ;

relExp : sumExp relOp sumExp { symbol * x = compare($1, $2, $3); $$ = x; } // sums have lesser priority than multiplication
      | sumExp { $$ = $1; } // can be either a sum or a multiplication
      ;

// Arbitrary numbers for each relational operator to uniquely identify them in symbol table
relOp : GR { $$ = 11111 ; } 
      | GREQ { $$ = 11112 ;}
      | SM { $$ = 11113 ; }
      | SMEQ {$$ = 11114 ; }
      | EQ { $$ = 11115 ; }
      | NEQ { $$ = 11116 ; }
      ;

sumExp : sumExp sumOp mulExp {
            // we make a type check to ensure that the operation is valid
            if($1->type == 11120 || $3->type == 11120 ){
                  printf("\nError: you cannot sum two bool!\n");
                  exit(1);
            }else
                  $$ = sum($1->value, $2, $3->value); 
      } 
      | mulExp { $$ = $1; } 
      ;

sumOp : '+' { $$ = 11117;} // code representing the plus operation
      | '-' { $$ = 11118;} // code representing the minus operation
      ;

mulExp : mulExp mulOp unaryExp { 
            // we make a type check to ensure that the operation is valid
            if ($1->type != 11119 || $3->type != 11119){
                        printf("\nInvalid integer operation with boolean!\n");
                        exit(1);     
                  }

            // we execute the multiply function
            $$ = multiply($1->value, $2, $3->value); 
      }
      | unaryExp { $$ = $1; }
      ;

mulOp : '*' { $$ = 11121; } // code representing the product operation
      | '/'  { $$ = 11122; } // code representing the division operation
      | POW { $$ = 11123;} // code representing the power operation
      ;

unaryExp : '-' unaryExp {
                  // we create the temporary variable on which the operation is executed
                  symbol* x = createSymbol(11119, "temp", ($2->value)); 
                  x->value = - x->value;
                  $$ = x;
                   
            }
      | NUM { 
                  symbol* x = createSymbol(11119, "temp", $1); // integer
                  $$ = x;
            }
      | TRUE {
            symbol* x = createSymbol(11120, "temp", 1); // boolean true
            $$ = x; 
            }
      | FALSE { symbol* x = createSymbol(11120, "temp", 0); // boolean false
            $$ = x;}   
      | ID {  
                  symbol* out = lookup($1);  // we perform a lookup to check if the variable exists
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
      initialize(); // initializes the symbol table
      yyparse();
      
      return 0;
}
