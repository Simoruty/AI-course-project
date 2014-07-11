:- module(lexer,
          [ to_string/2
          , lexer/2
          , atom_is_number/1
          , string_is_number/1
          , ascii_number/1
          , ascii_char/1
          , ascii_id_char/1
          ]
).

:- use_module(library(apply)).
:- use_module(library(lists)).


to_string(X, Y) :- atom(X), !, atom_codes(X,Y).
to_string(X, X).

lexer(String,ListToken) :-
	strip_useless_chars(String, Temp1),
    separate_useful_chars(Temp1, Temp2),
	strip_spaces(Temp2, Temp3),
	atom_codes(Temp4, Temp3),
	atomic_list_concat(Temp5,' ', Temp4),
	maplist(downcase_atom, Temp5, Temp6),
    strip_sep(Temp6, ListToken).

atom_is_number(X):-
	atom(X),
	atom_codes(X,String),
	string_is_number(String).

ascii_number(X) :-
	number(X),
	X>=48,
	X=<57.
ascii_number(X) :-
	number(X),
	X==46.

ascii_char(X):-
    number(X),
    X>=97,
    X=<122.

ascii_id_char(X) :- ascii_char(X), !.
ascii_id_char(X) :- ascii_number(X), !.
ascii_id_char('_').
ascii_id_char('-').
ascii_id_char('.').

string_is_number(String) :- 
    maplist(ascii_number, String).


%useful_char(46). % punto
useful_char(64). % chiocciola
useful_char(8364). % euro
%useful_char(44). % virgola
useful_char(10). % newline
useful_char(47). % slash
%useful_char(95). % _

useless_char(9). % \t
useless_char(13). % \r
useless_char(33). % !
useless_char(34). % "
useless_char(39). % '
useless_char(40). % (
useless_char(41). % )
useless_char(44). % ,
useless_char(45). % -
useless_char(58). % :
useless_char(59). % ;
useless_char(63).  % ?
useless_char(94). % ^
useless_char(96). % `
useless_char(8217). % ’

separate_useful_chars([],[]).
separate_useful_chars([A|Xs], [32,A,32|Ys]) :-
    useful_char(A),
    !,
    separate_useful_chars(Xs,Ys).
separate_useful_chars([X|Xs], [X|Ys]) :-
    separate_useful_chars(Xs, Ys).


strip_useless_chars([],[]).
strip_useless_chars([X|Xs], [32|Ys]) :-
	useless_char(X),
	!,
	strip_useless_chars(Xs,Ys).
strip_useless_chars([X|Xs], [X|Ys]) :-
	strip_useless_chars(Xs,Ys).

strip_spaces([],[]).
strip_spaces([32,32|Xs], Ys):-
	!,
	strip_spaces([32|Xs],Ys).
strip_spaces([X|Xs],[X|Ys]) :-
	strip_spaces(Xs,Ys).


strip_sep( [], [] ) :- !.
strip_sep( [''|Xs], Ys ) :-
    !,
    strip_sep(Xs, Ys).
strip_sep( ['.'|Xs], Ys ) :-
    !,
    strip_sep(Xs, Ys).
strip_sep( [X|Xs], [Y|Ys] ) :-
    atom_length(X, L),
    L>0,
    Start is L-1,
    sub_atom(X, Start, 1, _, '.'),
    Len is L-1,
    sub_atom(X, 0, Len, _, Y),
    !,
    strip_sep(Xs, Ys).
strip_sep( [X|Xs], [X|Ys] ) :-
    strip_sep(Xs, Ys).
