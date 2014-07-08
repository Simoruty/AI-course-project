:- module(lexer,
          [ to_string/2
          , lexer/2
          , clean_dots/2
          , atom_is_number/1
          , string_is_number/1
          , ascii_number/1
          , ascii_char/1
          , chiocciola/1
          , punto/1
          , virgola/1
          ]
).

:- use_module(library(apply)).
:- use_module(library(lists)).


to_string(X, Y) :- atom(X), !, atom_codes(X,Y).
to_string(X, X).

lexer(String,ListToken) :-
	filter_useless_char(String, A),
    clean_chiocciola(A,B),
    clean_newline(B,B1),
    clean_punto(B1,C),
    clean_virgola(C,D),
    clean_euro(D,E),
	strip_spaces(E, F),
	atom_codes(G, F),
	atomic_list_concat(H,' ', G),
	maplist(downcase_atom, H, ListToken).


atom_is_number(X):-
	atom(X),
	atom_codes(X,String),
	string_is_number(String).

ascii_number(X) :-
	number(X),
	X>=48,
	X=<57.

ascii_char(X):-
    number(X),
    X>=97,
    X=<122.

%chiocciola(X) :-
%    number(X),
%    X=:=64.
%chiocciola(X) :-
%    atom(X),
%    atom_codes(X,[A]),
%    A=:=64.

%punto(X) :-
%    number(X),
%    X=:=46.
%punto(X) :-
%    atom(X),
%    atom_codes(X,[A]),
%    A=:=46.

%virgola(X) :-
%    number(X),
%    X=:=44.
%virgola(X) :-
%    atom(X),
%    atom_codes(X,[A]),
%    A=:=44.

%piu(X) :-
%    number(X),
%    X=:=43.
%piu(X) :-
%    atom(X),
%    atom_codes(X,[A]),
%    A=:=43.


atom_is_number(X):-
	atom(X),
	atom_codes(X,String),
	string_is_number(String).

string_is_number(String) :- 
    maplist(ascii_number, String).

useful_char(46). % Punto
useful_char(64). % Chiocciola
useful_char(8364). % Euro
useful_char(44). % Virgola
useful_char(10). % newline

useless_char(94).
useless_char(63).
useless_char(33).
useless_char(95).
useless_char(13).
useless_char(9).
useless_char(34).
useless_char(39).
useless_char(8217).
useless_char(59).
useless_char(58).
useless_char(40).
useless_char(41).


separate_useful_chars([],[]).
separate_useful_chars([A|Xs], [32,A,32|Ys]) :-
    useful_char(A),
    !,
    separate_useful_chars(Xs,Ys).
separate_useful_chars([X|Xs], [X|Ys]) :-
    separate_useful_chars(Xs, Ys).


filter_useless_char([],[]).
filter_useless_char([X|Xs], [32|Ys]) :-
	useless_char(X),
	!,
	filter_useless_char(Xs,Ys).
filter_useless_char([X|Xs], [X|Ys]) :-
	filter_useless_char(Xs,Ys).


strip_spaces([],[]).
strip_spaces([32,32|Xs], Ys):-
	!,
	strip_spaces([32|Xs],Ys).
strip_spaces([X|Xs],[X|Ys]) :-
	strip_spaces(Xs,Ys).
