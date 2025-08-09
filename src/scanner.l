/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Krzysztof Narkiewicz <krzysztof.narkiewicz@ezaquarii.com>
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 */

%{
    // todo c libs
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

	#include <iostream>
	#include <cstdlib>
	#include "scanner.h"
	#include "interpreter.h"
	#include "parser.hpp"
	#include "location.hh"



	using namespace std;

	// Original yyterminate() macro returns int. Since we're using Bison 3 variants
	// as tokens, we must redefine it to change type from `int` to `Parser::semantic_type`
	#define yyterminate() EzAquarii::Parser::make_END(EzAquarii::location());

	// This will track current scanner location.
	// Action is called when length of the token is known.
	#define YY_USER_ACTION m_driver.increaseLocation(yyleng);

	// !!!WARNING!!!
	// Location API is used, but the location is not initialized, 'cause I'm lazy. When making
	// a token with make_{something} method you can pass detailed token location. Current location
	// is accessible with m_driver.location() method. All puzzle elements are there - just
	// pass location value in every action code block below. I'm going to waste more time writing
	// this excuse than putting this boilerplate below...
	//
	// Location class can be found in location.hh and posistion.hh files. It's just a bit too much
	// boilerplate for this small example. Bummer.


%}

 // bkp
    /* %{
        static void print_token (yytoken_kind_t token, YYSTYPE val);
    %} */



%option nodefault
%option noyywrap
%option c++
%option yyclass="Scanner"
%option prefix="EzAquarii_"

VOID void
INT int
FLOAT float
CHAR char
RETURN return
IF if
type int|float|char
digit   [0-9]
NUMBER  [0-9]+
ID      [a-zA-Z_][a-zA-Z0-9_]*

%%

!           {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"=="        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"&&"        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"||"        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"="         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
";"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
\+          {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
-           {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"{"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"}"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"["         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"]"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"<"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
">"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"#"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
\$          {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
%           {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
\^          {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"\""        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"'"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"\\"        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"/"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"~"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"_"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
":"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
&           {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
\*          {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"::"        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
\.          {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"->"        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
".*"        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
"->*"       {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
{INT}      {
                cout << "Scanner: 'void'" << endl;
                return EzAquarii::Parser::make_INT(yytext, EzAquarii::location());
            }
{FLOAT}      {
                cout << "Scanner: 'void'" << endl;
                return EzAquarii::Parser::make_FLOAT(yytext, EzAquarii::location());
            }
{CHAR}      {
                cout << "Scanner: 'void'" << endl;
                return EzAquarii::Parser::make_CHAR(yytext, EzAquarii::location());
            }
{VOID}      {
                cout << "Scanner: 'void'" << endl;
                return EzAquarii::Parser::make_VOID(yytext, EzAquarii::location());
            }
{RETURN}    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
{type}      {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
{IF}        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
else        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
do          {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
while       {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
for         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
continue    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
switch      {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
case        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
break       {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
goto        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
default     {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
private     {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
protected   {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
public      {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
inline      {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
static      {  cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
const       {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
unsigned    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
volatile    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
register    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
restrict    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
[a-z]+      {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_STRING(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
\(          {
                cout << "Scanner: '('" << endl;
                return EzAquarii::Parser::make_LEFTPAR(EzAquarii::location());
            }
\)          {
                cout << "Scanner: ')'" << endl;
                return EzAquarii::Parser::make_RIGHTPAR(EzAquarii::location());
            }
;           {
                cout << "Scanner: ';'" << endl;
                return EzAquarii::Parser::make_SEMICOLON(EzAquarii::location());
            }
,           {
                cout << "Scanner: ','" << endl;
                return EzAquarii::Parser::make_COMMA(EzAquarii::location());
            }
{NUMBER}    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return EzAquarii::Parser::make_NUMBER(yytext, EzAquarii::location( /* put location data here if you want */ ));
            }
[\n\t ]     {
                //cout << "Scanner: whitechar (ignored)" << endl;
            }
[abc][abc][1-9][0-9]* {
                // cout << "Scanner: decimal number: " << yytext << endl;
                // uint64_t number = strtoull(yytext, 0, 10);
                // return EzAquarii::Parser::make_NUMBER(number, EzAquarii::location());
            }
.           {
                cout << "Scanner: unknown character [" << yytext << "]" << endl;
            }
<<EOF>>     { return yyterminate(); }


%%
