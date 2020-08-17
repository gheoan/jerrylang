﻿grammar Jerry;

WHITESPACE: [ \n\t\r]+ -> channel(1);

COMMENT: '#' ~ [\r\n]* -> skip;

FN: 'fn';
LET: 'let';

EQUAL: '=';
PLUS: '+';
MINUS: '-';
MULTIPLY: '*';

COLON: ':';
SEMI: ';';
COMMA: ',';

OPEN_PAREN: '(';
CLOSED_PAREN: ')';
OPEN_BRACE: '{';
CLOSED_BRACE: '}';

IDENTIFIER: [a-zA-Z_] [a-zA-Z0-9_]*;
fragment DIGIT: [0-9];
fragment UNDERSCORE: '_';
INTEGER_NORMAL: '-'? DIGIT (DIGIT | UNDERSCORE)*;

number: INTEGER_NORMAL;

literal: number;

function_call:
	name = IDENTIFIER OPEN_PAREN (expression (COMMA expression)*)? COMMA? CLOSED_PAREN;

expression:
	literal
	| IDENTIFIER
	| function_call
	| left = expression binary_op = PLUS right = expression
	| left = expression binary_op = MINUS right = expression
	| left = expression binary_op = MULTIPLY right = expression;

assignment: LET? name = IDENTIFIER EQUAL expression;

stmt: assignment SEMI | expression SEMI | block;

block: OPEN_BRACE stmt* CLOSED_BRACE;

argument: name = IDENTIFIER COLON type = IDENTIFIER;

function:
	FN function_name = IDENTIFIER OPEN_PAREN (
		argument (COMMA argument)*
	)? CLOSED_PAREN (SEMI | body = block);

document: function*; 