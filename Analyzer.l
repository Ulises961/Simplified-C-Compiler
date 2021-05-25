%{
#include <stdlib.h>
#include <string.h>
void yyerror(char *);
#include "y.tab.h"
%}

DIGIT       [0-9]
INT         {DIGIT}+
BOOLEAN  (true|false)
LETTER      [a-zA-Z]
ID          {LETTER}({LETTER}|{DIGIT})*

%%

[ \t] {/* skip blanks */}

{INT}    {yylval.integer = atoi(yytext);
          return NUM;}

{BOOLEAN} {if (strcmp("true",strdup(yytext)) == 0)
                yylval.integer = 1;
            else
                yylval.integer = 0;
          return BOOL;}

":"     {return ':';}
";"     {return ';';}
\n      {return '\n';}


"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';}

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
"["     {return '[';}
"]"     {return ']';}
"{"     {return '{';}
"}"     {return '}';}
"("     {return '(';}
")"     {return ')';}
"return" {return RETURN;}


"int"  {yylval.lexeme = strdup(yytext);
        return INT;}
"bool"  {yylval.lexeme = strdup(yytext);
            return BOOLEAN;}

{ID}     {yylval.lexeme = strdup(yytext);
          return ID;}


. yyerror("Parsing error, invalid character"); // error for all not recognized characters

%%

int yywrap(void) {
    return 1;
}
