:- module(lexer,
          [ clean_string/2
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


clean_string(String,ListToken) :-
	filter_stopchars(String, A),
    clean_chiocciola(A,B),
    clean_punto(B,C),
    clean_virgola(C,D),
    clean_euro(D,E),
	strip_spaces(E, F),
	atom_codes(G, F),
	atomic_list_concat(H,' ', G),
	maplist(downcase_atom, H, ListToken).


list_stopchars(X) :- X = "^?!_\n\r\t-\\/\"'’;:(){}".

ascii_number(X) :-
	number(X),
	X>=48,
	X=<57.

ascii_char(X):-
    number(X),
    X>=97,
    X=<122.

chiocciola(X) :-
    number(X),
    X=:=64.
chiocciola(X) :-
    atom(X),
    atom_codes(X,[A]),
    A=:=64.

punto(X) :-
    number(X),
    X=:=46.
punto(X) :-
    atom(X),
    atom_codes(X,[A]),
    A=:=46.

virgola(X) :-
    number(X),
    X=:=44.
virgola(X) :-
    atom(X),
    atom_codes(X,[A]),
    A=:=44.

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


clean_dots([],[]).
clean_dots([A|Xs], Ys) :- 
    atom(A), 
    punto(A), 
    !, 
    clean_dots(Xs,Ys).
clean_dots([A|Xs], Ys) :- 
    atom(A), 
    virgola(A), 
    !, 
    clean_dots(Xs,Ys).
clean_dots([A|Xs], [A|Ys]) :- 
    clean_dots(Xs,Ys).

clean_chiocciola([], []).
clean_chiocciola([64|Xs], [32,64,32|Ys]) :-
    !,
    clean_chiocciola(Xs, Ys).
clean_chiocciola([X|Xs], [X|Ys] ) :-
    clean_chiocciola(Xs, Ys).

clean_punto([], []).
clean_punto([46|Xs], [32,46,32|Ys]) :-
    !,
    clean_punto(Xs, Ys).
clean_punto([X|Xs], [X|Ys] ) :-
    clean_punto(Xs, Ys).

clean_euro( [], [] ).
clean_euro( [8364|Xs], [32,8364,32|Ys]) :-
    !,
    clean_euro(Xs, Ys).
clean_euro( [X|Xs], [X|Ys] ) :-
    clean_euro(Xs, Ys).

clean_virgola([], []).
clean_virgola([44|Xs], [32,44,32|Ys]) :-
    !,
    clean_virgola(Xs, Ys).
clean_virgola([X|Xs], [X|Ys] ) :-
    clean_virgola(Xs, Ys).


filter_stopchars([],[]).
filter_stopchars([X|Xs], [32|Ys]) :-
	list_stopchars(StopC),
	member(X,StopC),
	!,
	filter_stopchars(Xs,Ys).

filter_stopchars([X|Xs], [X|Ys]) :-
	filter_stopchars(Xs,Ys).


strip_spaces([],[]).
strip_spaces([32,32|Xs], Ys):-
	!,
	strip_spaces([32|Xs],Ys).
strip_spaces([X|Xs],[X|Ys]) :-
	strip_spaces(Xs,Ys).
