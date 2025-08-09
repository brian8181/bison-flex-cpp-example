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

%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0"
%defines
%define api.parser.class { Parser }

%define api.token.constructor
%define api.value.type variant
%define parse.assert
%define api.namespace { Ez }
%code requires
{
    #include <iostream>
    #include <string>
    #include <vector>
    #include <stdint.h>
    #include "command.h"

    using namespace std;

    namespace Ez {
        class Scanner;
        class Interpreter;
    }
}

// Bison calls yylex() function that must be provided by us to suck tokens
// from the scanner. This block will be placed at the beginning of IMPLEMENTATION file (cpp).
// We define this function here (function! not method).
// This function is called only inside Bison, so we make it static to limit symbol visibility for the linker
// to avoid potential linking conflicts.
%code top
{
    #include <iostream>
    #include "scanner.h"
    #include "parser.hpp"
    #include "interpreter.h"
    #include "location.hh"

    // yylex() arguments are defined in parser.y
    static Ez::Parser::symbol_type yylex(Ez::Scanner &scanner, Ez::Interpreter &driver) {
        return scanner.get_next_token();
    }

    // you can accomplish the same thing by inlining the code using preprocessor
    // x and y are same as in above static function
    // #define yylex(x, y) scanner.get_next_token()

    using namespace Ez;
}

%lex-param { Ez::Scanner &scanner }
%lex-param { Ez::Interpreter &driver }
%parse-param { Ez::Scanner &scanner }
%parse-param { Ez::Interpreter &driver }
%locations
%define parse.trace
%define parse.error verbose

%define api.token.prefix {TOKEN_}
%token LPAREN "lparen";
%token RPAREN "rparen";
%token SEMICOLON "semicolon";
%token COMMA "comma";
%token <std::string> ESCAPE
%token <std::string> INCLUDE DEFINE IFDEF IFNDEF ENDIF PRAGMA
%token <std::string> USING NAMESPACE
%token <std::string> INT FLOAT CHAR VOID
%token <std::string> CLASS STRUCT TEMPLATE TYPENAME
%token <std::string> REFERENCE POINTER
%token <std::string> NUMBER "number"
%token <std::string> ID
%token <std::string> ASSIGNMENT "assignment"
%token <std::string> ARG
%token <std::string> SPACE TAB NEWLINE END_OF_FILE
%token <std::string> LEFT_BRACE RIGHT_BRACE LEFT_CURLY RIGHT_CURLY LEFT_PAREN RIGHT_PAREN
%token <std::string> STATIC CONST UNSIGNED VOLATILE MUTABLE REGISTER RESTRICT INLINE
%token <std::string> SHIFT_LEFT SHIFT_RIGHT MODULUS
%token <std::string> EQUALS LOGICAL_NOT LOGICAL_AND LOGICAL_OR BIT_AND BIT_OR BIT_XOR BIT_NOT
%token <std::string> ADDITION SUBTRACTION MUTIPLICATION DIVISION
%token <std::string> LESS_THAN GREATER_THAN
%token <std::string> COLON DOUBLE_QUOTE SINGLE_QUOTE QUESTION_MARK DOT AT_SYMBOL
%token <std::string> PRIVATE PROTECTED PUBLIC
%token <std::string> ADDRESS_OF SCOPE_RESOLUTION
%token <std::string> DIRECT_TO_POINTER INDIRECT_TO_POINTER
%token <std::string> DIRECT_MEMBER_SELECT INDIRECT_MEMBER_SELECT
%token <std::string> IF ELSE FOR DO WHILE CONTINUE BREAK SWITCH CASE GOTO DEFAULT RETURN
%token <std::string> LSHIFT RSHIFT INCREMENT DECREMENT
%token <std::string> ADD_ASSIGN SUB_ASSIGN MULT_ASSIGN DIV_ASSIGN MOD_ASSIGN
%token <std::string> BIT_AND_ASSIGN BIT_OR_ASSIGN BIT_XOR_ASSIGN BIT_NOT_ASSIGN
%token <std::string> LSHIFT_ASSIGN RSHIFT_ASSIGN
%token <std::string> SIZEOF DELETE CONST_CAST DYNAMIC_CAST STATIC_CAST REINTERPRET_CAST
%type <std::string> files "files"
%type <std::string> file "file"
%type <std::string> function "function"
%type <std::string> scopes "scopes"
%type <std::string> scope "scope"
%type <std::string> lines "lines"
%type <std::string> line "line"
%type <std::string> declaration "declaration"
%type <std::string> params "parmas"
%type <std::string> param "param"
%type <std::string> type "type"
%type <std::string> type_modifier "type_modifier"
%type <std::string> pointer_to_member "pointer_to_member"
%type <std::string> member_select "member_select"
%type <std::string> access_specifier "access_specifier"
%type <std::string> numeric_expr "numeric_expr"
%type <std::string> expr "expr"
%type <std::string> statement "statement"
%type <std::string> preprocess "preprocess"

%token END 0 "end of file"
%token <std::string> STRING  "string";

%start program

%%

program :
        files                          { cout << "program:  files" << endl; exit(0); }
            | STRING | NUMBER | END | LPAREN | RPAREN | flow_control | member_select | space | operator | access_specifier | pointer_to_member | scope_resolution | preprocess
    ;
files:
    file
    | files file                        { cout << "files: files file\n"; };
    ;
file:
    scopes                              { cout << "file: scopes END_OF_FILE\n"; }
    ;
scopes:
    scope                               { cout << "scopes: scope\n"; }
    | scopes scope                      { printf("scopes: scopes scope\n"); }
    ;
scope:
    lines                               { /*printf("scope: lines=\"%s\"\n", $1);*/ }
    | '{' lines '}'                     { /*printf("scope: '{' lines=\"%s\" '}'\n", $2); */ }
    ;
lines:
    line                                { /*printf("lines: line=\"%s\"\n", $1);*/ }
    | lines line                        { /*printf("lines: lines=\"%s\" line\"%s\"\n", $1, $2);*/ }
    ;
line:
    statement ';'                       { printf("line: statement=\"%s\"\n", $1); }
    ;
statement:
    expr                                { printf("statement: expr=\"%s\"\n", $1); }
    ;
expr:
    declaration                         { printf("expr: declaration=\"%s\"\n", $1); }
    | function                          { printf("expr: function=\"%s\"\n", $1); }
    | ID '=' expr                       { printf("expr: ID '=' expr\n"); }
    | numeric_expr                      { printf("expr: numeric_expr=\"%s\"\n", $1); }
    | IF '(' expr ')' expr              { printf("expr: IF '(' expr=\"%s\" ')' expr=\"%s\"\n", $3, $5); }
    | IF '(' expr ')' '{' expr ';' '}'  { printf("expr: IF '(' expr=\"%s\" ')' '{' expr=\"%s\" ';' '}'\n", $3, $6); }
    ;
numeric_expr:
    NUMBER                              { printf("binary_op: NUMBER=\"%s\"\n", $1); }
    | numeric_expr '+' numeric_expr     {
                                            char buffer[64];
                                            sprintf(buffer, "%s + %s", $1, $3);
                                            printf("%s\n", buffer);
                                        }
    | numeric_expr '-' numeric_expr     {
                                            char buffer[64];
                                            sprintf(buffer, "%s - %s", $1, $3);
                                            printf("%s\n", buffer);
                                        }
    ;
function:
    declaration '(' ')'                 { printf("function: declaration '(' ')'\n"); }
    | declaration '(' params ')'        { printf("function: declaration '(' params ')' )\n"); }
    ;
declaration:
    type ID                             { printf("declaration: type=\"%s\" ID=\"%s\"\n", $1, $2); }
    | type_modifier type ID             { printf("declaration: type_modifier=\"%s\" type=\"%s\" ID=\"%s\"\n", $1, $2, $3); }
    ;
params:
    param                               { printf("params: param=\"%s\" \n", $1); }
    | params ',' param                  { printf("params: params=\"%s\" , param=\"%s\"\n", $1, $3); }
    ;
param:
    ARG                                 { printf("param: ARG=\"%s\"\n", $1); }
    ;
access_specifier:
        PUBLIC
        | PROTECTED
        | PRIVATE
        ;
type_modifier:
    STATIC                              { printf("type_modifier: STATIC\n"); }
    | CONST                             { printf("type_modifier: CONST\n"); }
    | UNSIGNED                          { printf("type_modifier: VOID\n"); }
    | VOLATILE                          { printf("type_modifier: VOLATILE\n"); }
    | MUTABLE                           { printf("type_modifier: MUTABLE\n"); }
    | REGISTER                          { printf("type_modifier: REGISTER\n"); }
    | RESTRICT                          { printf("type_modifier: RESTRICT\n"); }
    | INLINE                            { printf("type_modifier: INLINE\n"); }
    ;
type:
    INT                                 { printf("type: INT\n"); }
    | FLOAT                             { printf("type: FLOAT\n"); }
    | CHAR                              { printf("type: CHAR\n"); }
    | VOID                              { printf("type: VOID\n"); }
    | type REFERENCE                    { printf("type: type REFERENCE\n"); }
    | type POINTER                      { printf("type: type POINTER\n"); }
    | CLASS                             { printf("type: CLASS\n"); }
    | STRUCT                            { printf("type: STRUCT\n"); }
    ;
flow_control:
    FOR                                 { printf("flow_control: FOR\n"); }
    | WHILE                             { printf("flow_control: WHILE\n"); }
    | DO                                { printf("flow_control: DO\n"); }
    | BREAK                             { printf("flow_control: BREAK\n"); }
    | CONTINUE                          { printf("flow_control: CONTINUE\n"); }
    | IF                                { printf("flow_control: IF\n"); }
    | ELSE                              { printf("flow_control: ELSE\n"); }
    | SWITCH                            { printf("flow_control: SWITCH\n"); }
    | CASE                              { printf("flow_control: CASE\n"); }
    | GOTO                              { printf("flow_control: GOTO\n"); }
    | DEFAULT                           { printf("flow_control: DEFAULT\n"); }
    | RETURN                            { printf("flow_control: RETURN\n"); }
    ;
space:
    SPACE                               { printf("space:\n"); }
    | TAB                               { printf("space:\n"); }
    | NEWLINE                           { printf("space:\n"); }
    | END_OF_FILE                       { printf("space:\n"); }
    ;
operator:
    ASSIGNMENT                          { printf("operator:\n"); }
    | ADDITION                          { printf("operator:\n"); }
    | SUBTRACTION                       { printf("operator:\n"); }
    | MUTIPLICATION                     { printf("operator:\n"); }
    | DIVISION                          { printf("operator:\n"); }
    | LESS_THAN                         { printf("operator:\n"); }
    | EQUALS                            { printf("operator:\n"); }
    | GREATER_THAN                      { printf("operator:\n"); }
    | BIT_AND                           { printf("operator:\n"); }
    | BIT_OR                            { printf("operator:\n"); }
    | BIT_XOR                           { printf("operator:\n"); }
    | BIT_NOT                           { printf("operator:\n"); }
    | LOGICAL_NOT                       { printf("operator:\n"); }
    | LOGICAL_AND                       { printf("operator:\n"); }
    | LOGICAL_OR                        { printf("operator:\n"); }
    | SHIFT_LEFT                        { printf("operator:\n"); }
    | SHIFT_RIGHT                       { printf("operator:\n"); }
    | MODULUS                           { printf("operator:\n"); }
    | LEFT_BRACE                        { printf("operator:\n"); }
    | LEFT_CURLY                        { printf("operator:\n"); }
    | LEFT_PAREN                        { printf("operator:\n"); }
    | RIGHT_BRACE                       { printf("operator:\n"); }
    | RIGHT_CURLY                       { printf("operator:\n"); }
    | RIGHT_PAREN                       { printf("operator:\n"); }
    | COMMA                             { printf("operator:\n"); }
    | COLON                             { printf("operator:\n"); }
    | SEMICOLON                         { printf("operator:\n"); }
    | DOUBLE_QUOTE                      { printf("operator:\n"); }
    | SINGLE_QUOTE                      { printf("operator:\n"); }
    | QUESTION_MARK                     { printf("operator:\n"); }
    | DOT                               { printf("operator:\n"); }
    | AT_SYMBOL                         { printf("operator:\n"); }
    | ADDRESS_OF                        { printf("operator:\n"); }
    | SCOPE_RESOLUTION                  { printf("operator:\n"); }
    | LSHIFT                            { printf("operator:\n"); }
    | RSHIFT                            { printf("operator:\n"); }
    | INCREMENT                         { printf("operator:\n"); }
    | DECREMENT                         { printf("operator:\n"); }
    | ADD_ASSIGN                        { printf("operator:\n"); }
    | SUB_ASSIGN                        { printf("operator:\n"); }
    | MULT_ASSIGN                       { printf("operator:\n"); }
    | DIV_ASSIGN                        { printf("operator:\n"); }
    | MOD_ASSIGN                        { printf("operator:\n"); }
    | BIT_AND_ASSIGN                    { printf("operator:\n"); }
    | BIT_OR_ASSIGN                     { printf("operator:\n"); }
    | BIT_XOR_ASSIGN                    { printf("operator:\n"); }
    | BIT_NOT_ASSIGN                    { printf("operator:\n"); }
    | LSHIFT_ASSIGN                     { printf("operator:\n"); }
    | RSHIFT_ASSIGN                     { printf("operator:\n"); }
    | TEMPLATE                          { printf("operator: TEMPLATE\n"); }
    | TYPENAME                          { printf("operator: TYPENAME\n"); }
    | SIZEOF                            { printf("operator:\n"); }
    | DELETE                            { printf("operator:\n"); }
    | STATIC_CAST                       { printf("operator:\n"); }
    | CONST_CAST                        { printf("operator:\n"); }
    | DYNAMIC_CAST                      { printf("operator:\n"); }
    | REINTERPRET_CAST                  { printf("operator:\n"); }
    ;
member_select:
    DIRECT_MEMBER_SELECT                { printf("member_select: DIRECT_MEMBER_SELECT\n"); }
    | INDIRECT_MEMBER_SELECT            { printf("member_select: INDIRECT_MEMBER_SELECT\n"); }
    ;
pointer_to_member:
    INDIRECT_TO_POINTER                 { printf("pointer_to_member: INDIRECT_TO_POINTER\n"); }
    | DIRECT_TO_POINTER                 { printf("pointer_to_member: DIRECT_TO_POINTER\n"); }
    ;
scope_resolution:
    USING                               { printf("scope_resolution: USING\n"); }
    | NAMESPACE                         { printf("scope_resolution: NAMESPACE\n"); }
    ;
preprocess:
    INCLUDE                             { printf("preprocess: include\n"); }
    | DEFINE                            { printf("preprocess: DEFINE\n"); }
    | IFDEF                             { printf("preprocess: IFDEF\n"); }
    | IFNDEF                            { printf("preprocess: IFNDEF\n"); }
    | ENDIF                             { printf("preprocess: ENDIF\n"); }
    | PRAGMA                            { printf("preprocess: PRAGMA\n"); }
    | ESCAPE
    ;

%%

// Bison expects us to provide implementation - otherwise linker complains
void Ez::Parser::error(const location &loc , const std::string &message) {

        // Location should be initialized inside scanner action, but is not in this example.
        // Let's grab location directly from driver class.
	// cout << "Error: " << message << endl << "Location: " << loc << endl;

        cout << "Error: " << message << endl << "Error location: " << driver.location() << endl;
}
