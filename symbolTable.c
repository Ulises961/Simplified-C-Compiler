#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>


typedef struct symbol{
    char* name;
    int type, value;
    struct symbol* next;
} symbol;

typedef struct symbolHT{
    symbol* head;
    symbol* tail;
}symbolHT;

symbolHT symbolTable;

symbol lookup(char* name){
    symbol* temp = symbolTable.head;
    
    while(temp != NULL){
        if(strcmp(temp->name, name) == 0)
            return *temp;
        
        temp = temp->next;
    }

    return *temp;
}

symbol* createSymbol(char* name, int type, int value){
    symbol* temp;
    temp->name = name;
    temp->type = type;
    temp->value = value;
    return temp;
}

void addToTail(char* name, int type, int value){
    symbol* newSymbol = createSymbol(name, type, value);

    if(symbolTable.head != NULL){ //is not empty
        symbolTable.tail->next = newSymbol;

    }else if(symbolTable.head == symbolTable.tail){
        symbolTable.head->next = newSymbol;
        symbolTable.tail = symbolTable.head->next;

    }else{
        symbolTable.tail->next = newSymbol;
        symbolTable.tail = symbolTable.tail->next;
    }
}
