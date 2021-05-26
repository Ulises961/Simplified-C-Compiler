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

symbolHT* symbolTable;

void initialize(){
  
    symbolTable = (symbolHT*) malloc(sizeof(symbolHT));
}

void assignValue(symbol* variable, int value){
    if(variable->type == 11120){
        if(value == 0 || value == 1)
            variable->value = value;
        else{
            printf("\nError: invalid assignment!\n");
            return;
        }
            
    }else
        variable->value = value;
}

void assignType(symbol* variable, int type){
   
    if(type != 11119 && type != 11120){
        printf("Null pointer exception!");
        return;
    }

    variable->type = type;
}

symbol* createSymbol(int type, char* name, int value){
    symbol* symbolPtr = malloc(sizeof(symbol));
    
    assignType(symbolPtr, type);
    assignValue(symbolPtr, value);
    symbolPtr->name = name;
    symbolPtr->next = NULL;
      
    return symbolPtr;
}

symbol* lookup(char* name){
    symbol* temp = symbolTable->head;
    
    while(temp != NULL){
        if(strcmp(temp->name, name) == 0)
            return temp;
        
        temp = temp->next;
    }

    return temp;
}

void addToTail(symbol* newSymbol){

    if(symbolTable->head == NULL){
        symbolTable->head = newSymbol;
        symbolTable->tail = symbolTable->head;

    }else if(symbolTable->head == symbolTable->tail){
        symbolTable->head->next = newSymbol;
        symbolTable->tail = newSymbol;

    }else{
        symbolTable->tail->next = newSymbol;
        symbolTable->tail = newSymbol;
    }
}