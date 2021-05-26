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
    int test;
}symbolHT;

symbolHT* symbolTable;


void initialize(){
    symbolTable = (symbolHT*) malloc(sizeof(symbolHT));
    symbolTable->test = 1;
    //printf("Initialization successful\n");
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
    //printf("looking up...\n");

    symbol* temp = symbolTable->head;

    if (symbolTable->head == NULL){
        //printf("Symbol table empty...\n");
        return NULL;
    }
    else{      
        while(temp != NULL){
            if(strcmp(temp->name, name) == 0){
                //printf("Found variable %s in symbol table\n", name);
                return temp;
            }
            
            temp = temp->next;
        }

        //printf("Variable %s not found\n", name);
    }

    return temp;
}

void addToTail(char* name, char* type, int value){

    symbol* symbolPtr = createSymbol(name, type, value);

    if (lookup(name) != NULL){
        printf("Error, variable %s already defined...\n", symbolPtr->name);
        exit(1);
    }

    //printf("Creating variable %s\n", name);

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
