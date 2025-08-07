APP = bcc
CXX = g++
BISON = bison
FLEX = flex

CXXFLAGS?=
FLEX_FLAGS?=
BISONFLAGS?=

ROOT = .
BLD = build
OBJ = build
SRC = src


all:
	flex -o $(SRC)/scanner.cpp $(SRC)/scanner.l
	bison -o $(SRC)/parser.cpp $(SRC)/parser.y
	g++ -g $(SRC)/main.cpp $(SRC)/scanner.cpp $(SRC)/parser.cpp $(SRC)/interpreter.cpp $(SRC)/command.cpp -o $(BLD)/bcc

clean:
	rm -rf $(SRC)/scanner.cpp
	rm -rf $(SRC)/parser.cpp $(SRC)/parser.hpp $(SRC)/location.hh $(SRC)/position.hh $(SRC)/stack.hh
	rm -rf $(BLD)/bcc
