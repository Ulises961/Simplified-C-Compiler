#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>


struct symbol{
    char* name;
    int type, value;
    symbol* next;
};

struct symbolHT{
    symbol head, tail;
}

symbolHT symbolTable;

symbol lookup(char* name){
    symbol temp = symbolTable.head;
    
    while(temp != null){
        if(strcmp(temp.name, name) == 0)
            return temp;
        
        temp = temp.next;
    }

    return temp;
}

symbol createSymbol(char* name, int type, int value){
    symbol temp;
    temp.name = name;
    temp.type = type;
    temp.value = value;
    return temp;
}

void addToTail(char* name, int type, int value){
    symbol newSymbol = createSymbol(name, type, value);

    if(symbolTable.head != null){ //is not empty
        symbolTable.tail.next = newSymbol;

    }else if(symbolTable.head == symbolTable.tail){
        symbolTable.head.next = newSymbol;
        symbolTable.tail = symbolTable.head.next;

    }else{
        symbolTable.tail.next = newSymbol;
        symbolTable.tail = symbolTable.tail.next;
    }
}