:- module(date,
          [ tag_date/2
          ]
).

:- use_module(syntax).

tag_date( [],[] ).
tag_date( [A], [A] ).
tag_date( [A,B], [A,B] ).
tag_date( [A,B,C|Xs],[ date(Aa,Bb,Cc) |Ys] ) :-
	data(A,B,C),
	!,
	atom_number(A, Aa),
	mese(B, Bb),
	atom_number(C, Cc),
	tag_date(Xs,Ys).
tag_date( [A,B,C|Xs],[A|Ys] ) :-
	tag_date([B,C|Xs], Ys).


data(A,B,C) :-
    giorno(A), mese(B), anno(C).

giorno(Gg) :-
    atom(Gg),
    atom_is_number(Gg),
    atom_number(Gg, G),
    G>0,
	G<32,
    !.

anno(Aa) :-
    atom(Aa),
    atom_is_number(Aa),
    atom_number(Aa, A),
    A>1900,
	A<2050,
    !.

anno(Aa) :-
    atom(Aa),
    atom_is_number(Aa),
    atom_number(Aa, A),
    A>=0,
	A<100,
    !.

mese(Mm) :-
    atom(Mm),
    atom_is_number(Mm),
    atom_number(Mm, M),
    M>0,
	M<13.

mese('gennaio').
mese('febbraio').
mese('marzo').
mese('aprile').
mese('maggio').
mese('giugno').
mese('luglio').
mese('agosto').
mese('settembre').
mese('ottobre').
mese('novembre').
mese('dicembre').
mese('gen').
mese('feb').
mese('mar').
mese('apr').
mese('mag').
mese('giu').
mese('lug').
mese('ago').
mese('set').
mese('ott').
mese('nov').
mese('dic').
mese('1', 1).
mese('2', 2).
mese('3', 3).
mese('4', 4).
mese('5', 5).
mese('6', 6).
mese('7', 7).
mese('8', 8).
mese('9', 9).
mese('10', 10).
mese('11', 11).
mese('12', 12).
mese('gennaio', 1).
mese('febbraio', 2).
mese('marzo', 3).
mese('aprile', 4).
mese('maggio', 5).
mese('giugno', 6).
mese('luglio', 7).
mese('agosto', 8).
mese('settembre', 9).
mese('ottobre', 10).
mese('novembre', 11).
mese('dicembre', 12).
mese('gen', 1).
mese('feb', 2).
mese('mar', 3).
mese('apr', 4).
mese('mag', 5).
mese('giu', 6).
mese('lug', 7).
mese('ago', 8).
mese('set', 9).
mese('ott', 10).
mese('nov', 11).
mese('dic', 12).
