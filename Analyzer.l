%option noyywrap
%{
#include <stdlib.h>
#include <string.h>
%}

DIGIT       [0-9]
INT         {DIGIT}+
LETTER      [a-zA-Z]
ID          {LETTER}({LETTER}|{DIGIT})*

%%

[ \t\n] {/* skip blanks */}
{INT}    {yylval.value = atoi(yytext);
          return INT;}
{ID}     {yylval.lexeme = strdup(yytext);
          return ID;}
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
"true"  {return 'true';}
"false" {return 'false';}
"["     {return '[';}
"]"     {return ']';}
"{"     {return '{';}
"}"     {return '}';}
"("     {return '(';}
")"     {return ')';}
"return" {return RETURN;}
%%

main(){

}