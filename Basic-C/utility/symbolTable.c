#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>

// This is the struct in which our variables are stored
typedef struct symbol{
    char* name; 
    int type, value;
    struct symbol* next; // a pointer to the next symbol/variable
} symbol;


// This is a head tail list made in which the symbols will be stored
// we decided to use a head tail list for better performance
typedef struct symbolHT{
    symbol* head;
    symbol* tail;
}symbolHT;

// we declare our symbolTable as a global variable
symbolHT* symbolTable; 


// This function initializes our symbolTable
void initialize(){
    symbolTable = (symbolHT*) malloc(sizeof(symbolHT));
}

// This function assigns a value to a previously declared symbol
void assignValue(symbol* variable, int value){

    if(variable->type == 11120){
      
        if(value == 0 || value == 1)
            variable->value = value;
        else{
            printf("\nError: invalid assignment of int value to bool variable!\n");
            exit(1);
        }
            
    }else if(variable->type == 11119){
        variable->value = value; 
    }else{
        printf("\nError: invalid assignment of bool value to int variable!\n");
        exit(1);
    }
}

// This function assigns a type to a previously declared symbol
void assignType(symbol* variable, int type){
   
    if(type != 11119 && type != 11120){
        printf("Null pointer exception!");
        return;
    }

    variable->type = type;
}

// This function creates and initializes a new symbol
symbol* createSymbol(int type, char* name, int value){
    
    symbol* symbolPtr = malloc(sizeof(symbol));
    
    assignType(symbolPtr, type);
    assignValue(symbolPtr, value);
    symbolPtr->name = name;
    symbolPtr->next = NULL;
      
    return symbolPtr;
}

//this function performs the lookup in our symbolTable
symbol* lookup(char* name){
    symbol* temp = symbolTable->head;
    
    while(temp != NULL){
        if(strcmp(temp->name, name) == 0)
            return temp;
        
        temp = temp->next;
    }

    return temp;
}

// This function adds a new symbol to the symbolTable
void addSymbol(symbol* newSymbol){
    
    if (lookup(newSymbol->name) != NULL){
        printf("Error, variable %s already defined...\n", newSymbol->name);
        exit(1);
    }

    if (symbolTable->head == NULL){
        symbolTable->head = newSymbol;
        symbolTable->tail = symbolTable->head;

    } else if(symbolTable->head == symbolTable->tail){
        symbolTable->head->next = newSymbol;
        symbolTable->tail = newSymbol;

    } else{
        symbolTable->tail->next = newSymbol;
        symbolTable->tail = newSymbol;
    }
}

// This function prints the content of our symbolTable
// and we used it for debugging purposes
void printSymbolTable(){
    int index = 0;
    symbol* temp = symbolTable->head;

    while(temp != NULL){

        printf("\nVariable %d", index);
        printf("\nName: %s", temp->name);
        printf("\nType: %d", temp->type);
        printf("\nValue: %d\n", temp->value);

        index++;
        temp = temp->next;
    }
}