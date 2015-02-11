/*
 * Copyright 2004-2015 Cray Inc.
 * Other additional copyright holders may be indicated within.
 *
 * The entirety of this work is licensed under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 *
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _YY_H_
#define _YY_H_

// These support YYSTYPE in chapel.tab.h
class ArgSymbol;
class BlockStmt;
class CallExpr;
class DefExpr;
class EnumType;
class Expr;
class FnSymbol;
class Type;

enum ProcIter {
  ProcIter_PROC,
  ProcIter_ITER
};

#include "symbol.h"

#include <cstdio>


extern int         captureTokens;
extern char        captureString[1024];

extern BlockStmt*  yyblock;
extern int         yydebug;
extern const char* yyfilename;
extern FILE*       yyin;
extern int         yystartlineno;
extern char*       yytext;

extern int         chplLineno;

int                yylex();
void               lexerScanString(const char* string);
void               lexerResetFile();
void               processNewline();

int                yyparse();
void               yyerror(const char* str);

#endif

