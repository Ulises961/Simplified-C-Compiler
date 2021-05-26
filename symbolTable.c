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


symbol* lookup(char* name){
    symbol* temp = symbolTable->head;
    
    while(temp != NULL){
        if(strcmp(temp->name, name) == 0)
            return temp;
        
        temp = temp->next;
    }

    return temp;
}

symbol* createSymbol(char* name, int type, int value){
    symbol* symbolPtr = malloc(sizeof(symbol));
    symbolPtr->name = name;
    symbolPtr->type = type;
    symbolPtr->value = value;
    symbolPtr->next = NULL;
    return symbolPtr;
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


int main(){
    initialize();

    symbol* a = createSymbol("aa", 1, 1);
    symbol* b = createSymbol("bb", 1, 1);
    symbol* c = createSymbol("cc", 1, 1);

    addToTail(a);
    addToTail(b);
    addToTail(c);

    printf("Inside the symboltable we have: %s\n", symbolTable->head->name);
    printf("Inside the symboltable we have: %s\n", symbolTable->head->next->name);
    printf("Inside the symboltable we have: %s\n", symbolTable->head->next->next->name);
    
    symbol* temp = lookup("cc");

    if(temp != NULL)
        printf("\ntemp = %s\n", temp->name);

    printf("\nend\n");
    return 0;
}