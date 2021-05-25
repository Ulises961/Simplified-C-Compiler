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

[ \t] {/* skip blanks */}
{INT}    {yylval.value = atoi(yytext);
          return INT;}

":"     {return ':';}
"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';}

"bool"  {return BOOL;}
"break" {return BREAK;}
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
"true"  {return TRUE;}
"false" {return FALSE;}
"["     {return '[';}
"]"     {return ']';}
"{"     {return '{';}
"}"     {return '}';}
"("     {return '(';}
")"     {return ')';}
\n      {return '\n';}

{ID}     {yylval.lexeme = strdup(yytext);
          return ID;}


. yyerror("invalid character"); // error for all not recognized characters

%%

int yywrap(void) {
    return 1;
}
