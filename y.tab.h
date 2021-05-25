/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    NUM = 258,
    BOOL = 259,
    ID = 260,
    CHAR = 261,
    BREAK = 262,
    AND = 263,
    OR = 264,
    NOT = 265,
    IF = 266,
    ELSE = 267,
    WHILE = 268,
    DO = 269,
    EQ = 270,
    NEQ = 271,
    GREQ = 272,
    GR = 273,
    SM = 274,
    SMEQ = 275,
    TRUE = 276,
    FALSE = 277,
    INT = 278,
    BOOLEAN = 279,
    UMINUS = 280
  };
#endif
/* Tokens.  */
#define NUM 258
#define BOOL 259
#define ID 260
#define CHAR 261
#define BREAK 262
#define AND 263
#define OR 264
#define NOT 265
#define IF 266
#define ELSE 267
#define WHILE 268
#define DO 269
#define EQ 270
#define NEQ 271
#define GREQ 272
#define GR 273
#define SM 274
#define SMEQ 275
#define TRUE 276
#define FALSE 277
#define INT 278
#define BOOLEAN 279
#define UMINUS 280

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 17 "Parser.y"

       char* lexeme;			//identifier
       int integer;			//value of an identifier of type int
       bool boolean;
       

#line 114 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
