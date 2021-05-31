# Simplified Basic-C Compiler

The project developed parses and calculates statements written in a C-like fashion. It can initialize variables of type bool and int, compute the 4 basic arithmetic operations plus the power operation, and perform comparison of variables. Lastly, the parser does type-checking on its primitive data-types.

Although, scoping and control-flow structures have not been fully implemented (a stack structure is necessary in order to compute the correct execution branches at the right moment) it can parse them correctly. 

## Program

This is how a program in our Basic-C Compiler can start.
```bash 
flex Analyzer.l
yacc -vd Parser.y
gcc y.tab.c -ly -ll -o compiler.out
./compiler<input.txt
```

*Or if make is installed 
```bash 
make
./compiler<input.txt
```


### Valid input 

```bash
int x : 10;
int y : 20;

y: y + 1; // prints 21;

int k : y + x;
print k; // prints 31;

bool t : true;
bool f : false;
print f; // prints 0

if(t){print f;}

if(x > y) {return true;} else { return y;} // prints "This is the else branch executed;" 
while(t)do{print f;} // prints "The while loop should execute here"
return;
```

### Invalid input 

* Invalid variable declaration and initialization
```bash
int k = true;
int x : 10;
bool t : true;
```
* The following are invalid operations
```bash
x : 5 + t; 
bool result : (5 or 5); 
int res : (true + true); 
print (12 and true;)
```
* Missing return statement
```bash
int x : 2;
int y : 3;

print (x + y);
```
