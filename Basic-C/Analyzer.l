%{
#include <stdlib.h>
#include <string.h>
void yyerror(char *);
#include "y.tab.h"

%}

DIGIT       [0-9]
INT         {DIGIT}+

LETTER      [a-zA-Z]
ID          {LETTER}({LETTER}|{DIGIT})*

%%

[ \t\r\n] {/* skip blanks */}

{INT}    {yylval.integer = atoi(yytext);
          return NUM;}

"true"  {return TRUE;}
"false" {return FALSE;}
":"     {return ':';}
"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"**"     {return POW;}
"/"     {return '/';}
";"     {return ';';}
"and"    {return AND;}
"or"    {return OR;}
"not"     {return NOT;}
"if"    {return IF;}
"else"  {return ELSE;}
"while" {return WHILE;}
"do"    {return DO;}
"<="    {return SMEQ;}
"<"     {return SM ;}
">"     {return GR;}
">="    {return GREQ;}
"=="    {return EQ;}
"!="    {return NEQ;}
"["     {return '[';}
"]"     {return ']';}
"{"     {return '{';}
"}"     {return '}';}
"("     {return '(';}
")"     {return ')';}
"print" {return PRINT;}
"return" {return RETURN;}

"int"   {return INT;}
"bool"  {return BOOLEAN;}
            
{ID}     {yylval.lexeme = strdup(yytext);
          return ID;}


. { yylval.lexeme = strdup(yytext);
    printf("Symbol \"%s\" not recognized\n", yylval.lexeme);
    yyerror("invalid character");} // error for all not recognized characters

%%

int yywrap(void) {
    return 1;
}