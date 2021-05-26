#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>

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