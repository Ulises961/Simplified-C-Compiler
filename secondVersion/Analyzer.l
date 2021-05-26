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

{INT}    {yylval.integer = atoi(yytext);
          return NUM;}

"true"  {return TRUE;}
"false" {return FALSE;}
":"     {return ':';}
"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';}

"break" {return BREAK;}
"and"    {return AND;}
"or"    {yylval.lexeme = strdup(yytext); return OR;}
"not"    {yylval.lexeme = strdup(yytext); return NOT;}
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
\n      {return '\n';}

"int"  {yylval.lexeme = strdup(yytext);
        return INT;}
{ID}     {yylval.lexeme = strdup(yytext);
          return ID;}


. yyerror("invalid character"); // error for all not recognized characters

%%

int yywrap(void) {
    return 1;
}
