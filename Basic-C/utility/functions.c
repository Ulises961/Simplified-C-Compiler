#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>
#include "symbolTable.c"

int power(int, int);


// Evaluates the type of operation based on a specific integer code and outputs the result
// of that operation, in this case the type of operation is comparing the
// values given as input, codes for the operations are defined in the Parser.y file
symbol* compare(symbol* a, int b, symbol* c){
      bool res;
      switch (b){
            case 11111: res = (a->value > c->value);
            break;
            case 11112: res = (a->value >= c->value);
            break;
            case 11113: res = (a->value < c->value); 
            break;
            case 11114: res = (a->value <= c->value);
            break;
            case 11115: res = (a->value == c->value);
            break;
            case 11116: res = (a->value != c->value);
            break;
      }
      symbol * result = (symbol*)malloc(sizeof(symbol));
      
      assignType(result, 11120);

      if(res)
            assignValue(result, true);
      else
            assignValue(result, false);
            
      return result;
}


// Same as compare but with sum or subtraction operations
symbol* sum ( int a, int op, int c){
      int res = 0;
      switch (op){
            case 11117 : res = (a + c);
                  break;
            case 11118 : res = (a - c);
                  break;
      }
      
      symbol * result = (symbol*)malloc(sizeof(symbol));
      result-> value = res;
      assignType(result,11119);

      return result;
}


// Same as compare but with multiplication, division and power operations
symbol* multiply ( int a, int op, int c){
      int res;
      switch (op){
            case 11121 : res =  a * c;
                  break;
            case 11122 : res =  a / c; 
                  break;
            case 11123 : res =  power(a,c);
                  break;
    }
      symbol * result = (symbol*)malloc(sizeof(symbol));
      result-> value = res;
      result-> type = 11119;
      return result;
}

int power(int num, int pow){
      if(pow == 0)
            return 1;
      else if(pow == 1)
            return num;
      
      return power(num * num, pow - 1);
}


