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
	$(FLEX) -o $(SRC)/scanner.cpp $(SRC)/scanner.l
	$(BISON) -o $(SRC)/parser.cpp $(SRC)/parser.y
	$(CXX) -g $(SRC)/main.cpp $(SRC)/scanner.cpp $(SRC)/parser.cpp $(SRC)/interpreter.cpp $(SRC)/command.cpp -o $(BLD)/$(APP)

clean:
	rm -rf $(SRC)/scanner.cpp
	rm -rf $(SRC)/parser.cpp $(SRC)/parser.hpp $(SRC)/location.hh $(SRC)/position.hh $(SRC)/stack.hh
	rm -rf $(BLD)/$(APP)
