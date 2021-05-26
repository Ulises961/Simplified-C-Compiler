#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>


typedef struct symbol{
    char* name;
    char* type;
    int value;
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
    if(variable->type == "bool"){
        if(value == 0 || value == 1)
            variable->value = value;
        else{
            printf("\nError: invalid assignment of boolean variable!\n");
            return;
        }
            
    }else
        variable->value = value;
}

void assignType(symbol* variable, char* type){
    // if(!(type == 11119 && type == 11120)){
    //     printf("Null pointer exception!");
    //     return;
    // }

    // variable->type = type;
}

symbol* createSymbol(char* name, char* type, int value){
    symbol* symbolPtr = malloc(sizeof(symbol));

    symbolPtr->name = name;
    symbolPtr->type = type;
    symbolPtr->value = value;

    return symbolPtr;
}

symbol* lookup(char* name){

    symbol* temp = symbolTable->head;

    if (symbolTable->head == NULL)
        return NULL;
    else{      
        while(temp != NULL){
            if(strcmp(temp->name, name) == 0)
                return temp;

            temp = temp->next;
        }
    }

    return temp;
}

void addToTail(char* name, char* type, int value){

    symbol* symbolPtr = createSymbol(name, type, value);

    if (lookup(name) != NULL){
        printf("Error, variable %s already defined...\n", symbolPtr->name);
        exit(1);
    }

    //printf("Creating variable in symbol table: %s, of type: %s, value: %d\n", name, type, value);

    if(symbolTable->head == NULL){
            symbolTable->head = symbolPtr;
            symbolTable->tail = symbolTable->head;

    }else if(symbolTable->head == symbolTable->tail){
            symbolTable->head->next = symbolPtr;
            symbolTable->tail = symbolPtr;

    }else{
            symbolTable->tail->next = symbolPtr;
            symbolTable->tail = symbolPtr;
    }
}
