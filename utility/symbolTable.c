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
    printf("Initialization successful\n");
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

    // in case head and tail are still NULL
    /*if (symbolTable->head == NULL){
        if (symbolTable->tail != NULL)
            exit(1); // error

        printf("Null HEAD\n");
        symbolPtr->next = symbolTable->head;

        symbolTable->head = symbolPtr;
        symbolTable->tail = symbolPtr;
    }
    
    printf("Head Name: %s Type: %s Value: %d\n", symbolTable->head->name, symbolTable->head->type, symbolTable->head->value);
    printf("Tail Name: %s Type: %s Value: %d\n", symbolTable->tail->name, symbolTable->tail->type, symbolTable->tail->value);*/

    // assignType(symbolPtr, type);
    //symbolPtr->next = NULL;

    return symbolPtr;
}

symbol* lookup(char* name){
    printf("looking up...\n");

    //symbol* temp = symbolTable->head;

    symbol* temp;

    if (symbolTable->head == NULL){
        printf("Symbol table empty...\n");
        return NULL;
    }
    else{
        printf("Name: %s Type: %s Value: %d\n", temp->name, temp->type, temp->value);
        
        while(temp != NULL){
            if(strcmp(temp->name, name) == 0){
                printf("Found variable %s in symbol table\n", name);
                return temp;
            }
            
            temp = temp->next;
        }

        printf("Variable not found\n");
    }

    return temp;
}

void addToTail(symbol* newSymbol){

    if (lookup(newSymbol->name) == NULL){
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
    else{
        printf("Error, variable %s already defined...\n", newSymbol->name);
        exit(1);
    }
}
