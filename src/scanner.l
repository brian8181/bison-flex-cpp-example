/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Krzysztof Narkiewicz <krzysztof.narkiewicz@Ez.com>
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
	#define yyterminate() Ez::Parser::make_END(Ez::location());

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
%option prefix="Ez_"

VOID void
INT int
FLOAT float
CHAR char
RETURN return
IF if
SEMICOLON ;
ASSIGNMENT =
NUMBER  [0-9]+
ID      [a-zA-Z_][a-zA-Z0-9_]*

%%

{SEMICOLON}  {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_SEMICOLON(Ez::location( /* put location data here if you want */ ));
             }
{ASSIGNMENT} {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_ASSIGNMENT(yytext, Ez::location( /* put location data here if you want */ ));
             }
\+          {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
-           {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
,           {
                cout << "Scanner: ','" << endl;
                return Ez::Parser::make_COMMA(Ez::location());
            }
!           {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"{"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"}"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"["         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"]"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"<"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
">"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"#"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
\$          {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
%           {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
\^          {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"\""        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"'"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"\\"        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"/"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"\("          {
                cout << "Scanner: '('" << endl;
                return Ez::Parser::make_LPAREN(Ez::location());
            }
"\)"          {
                cout << "Scanner: ')'" << endl;
                return Ez::Parser::make_RPAREN(Ez::location());
            }

"~"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"_"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
":"         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
&           {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
\*          {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"::"        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
\.          {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"->"        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
".*"        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"->*"       {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"=="        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"&&"        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
"||"        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
{INT}      {
                cout << "Scanner: 'void'" << endl;
                return Ez::Parser::make_INT(yytext, Ez::location());
            }
{FLOAT}      {
                cout << "Scanner: 'void'" << endl;
                return Ez::Parser::make_FLOAT(yytext, Ez::location());
            }
{CHAR}      {
                cout << "Scanner: 'void'" << endl;
                return Ez::Parser::make_CHAR(yytext, Ez::location());
            }
{VOID}      {
                cout << "Scanner: 'void'" << endl;
                return Ez::Parser::make_VOID(yytext, Ez::location());
            }
{RETURN}    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
{IF}        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
else        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
do          {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
while       {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
for         {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
continue    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
switch      {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
case        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
break       {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
goto        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
default     {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
private     {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
protected   {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
public      {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
inline      {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
static      {  cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
const       {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
unsigned    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
volatile    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
register    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
restrict    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_STRING(yytext, Ez::location( /* put location data here if you want */ ));
            }
{NUMBER}    {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_NUMBER(yytext, Ez::location( /* put location data here if you want */ ));
            }
{ID}        {
                cout << "Scanner: identifier [" << yytext << "]" << endl;
                return Ez::Parser::make_ID(yytext, Ez::location( /* put location data here if you want */ ));
            }
[\n\t ]     {
                //cout << "Scanner: whitechar (ignored)" << endl;
            }
.           {
                cout << "Scanner: unknown character [" << yytext << "]" << endl;
            }
<<EOF>>     { return yyterminate(); }


%%
