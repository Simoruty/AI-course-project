:- module( money, [tag_money/2] ).

:- use_module(lexer).


simbolo_valuta('€').
simbolo_valuta('euro').
simbolo_valuta('eur').
simbolo_valuta('$').
simbolo_valuta('£').

chirografario('chirografario').
chirografario('chirografaria').
chirografario('chirografo').
chirografario('chirografa').
chirografario('chiro').
chirografario('chir').

privilegiato('privilegiato').
privilegiato('privilegiata').

totale('totale').
totale('total').
totale('tot').

tag_money(A,F) :- 
	tag_currency(A,B),
	tag_chirografario(B,C),
	tag_privilegiato(C,D),
	tag_totale(D,E),
	tag_richiesta(E,F).



tag_currency( [],[] ).
tag_currency( [A], [A] ).

tag_currency( [A,B,C,D|Xs], [ currency(Val) | Ys ] ) :- 
	check_currency(A,B,C,D, Val),
	!,
	tag_currency(Xs,Ys).

tag_currency( [A,B|Xs],[ currency(Val) |Ys] ) :-
	check_currency(A,B, Val),
	!,
	tag_currency(Xs,Ys).

tag_currency( [A,B|Xs],[A|Ys] ) :-
	tag_currency([B|Xs], Ys).



tag_chirografario( [], [] ).
tag_chirografario( [A|Xs], [chirografario|Ys] ) :-
    chirografario(A),
    !,
    tag_chirografario(Xs,Ys).
tag_chirografario( [A|Xs], [A|Ys] ) :-
    tag_chirografario(Xs,Ys).

tag_privilegiato( [], [] ).
tag_privilegiato( [A|Xs], [privilegiato|Ys] ) :-
    privilegiato(A),
    !,
    tag_privilegiato(Xs,Ys).
tag_privilegiato( [A|Xs], [A|Ys] ) :-
    tag_privilegiato(Xs,Ys).

tag_totale( [], [] ).
tag_totale( [A|Xs], [totale|Ys] ) :-
    totale(A),
    !,
    tag_totale(Xs,Ys).
tag_totale( [A|Xs], [A|Ys] ) :-
    tag_totale(Xs,Ys).



tag_richiesta( [], [] ).
tag_richiesta( [A], [A] ).
tag_richiesta( [ A,B | Xs ], [ richiesta(A,B) | Ys ] ) :-
    A = currency(_),
    check_tipo_richiesta(B),
    !,
    tag_richiesta( Xs, Ys ).
tag_richiesta( [ A,B | Xs ], [ richiesta(B,A) | Ys ]) :-
    check_tipo_richiesta(A),
    B=currency(_),
    !,
    tag_richiesta( Xs, Ys ).

tag_richiesta( [ A,B,C | Xs ], Ys ) :-
    A=currency(_),
    \+ check_tipo_richiesta(B),
    !,
    tag_richiesta( [ B,A | Xs ], Ys ).
tag_richiesta( [ A,B | Xs ], Ys ) :-
    check_tipo_richiesta(A),
    B \= currency(_),
    !,
    tag_richiesta( [ B,A | Xs ], Ys ).
tag_richiesta( [ A,B | Xs ], [ A | Ys ] ) :-
    \+ check_tipo_richiesta(A),
    A \= currency(_),
    !,
    tag_richiesta( [ B | Xs ], Ys ).


% € 50
check_currency(X,Y, Output) :- 
    atom(X),atom(Y), 
    simbolo_valuta(X), 
    atom_is_number(Y), 
    atom_number(Y, Output).

% 50 €
check_currency(Y,X, Output) :- 
    atom(X),atom(Y), 
    simbolo_valuta(X), 
    atom_is_number(Y), 
    atom_number(Y, Output).

% € 26.67
check_currency(A,B,C,D, Output) :- 
    atom(A), atom(B), atom(C), atom(D),
    simbolo_valuta(A), separatore_decimali(C), atom_is_number(B), atom_is_number(D),
    atomic_list_concat([B,D], '.', Out), atom_number(Out,Output).

% 26.67 €
check_currency(A,B,C,D, Output) :- 
    atom(A), atom(B), atom(C), atom(D),
    simbolo_valuta(D), separatore_decimali(B), atom_is_number(A), atom_is_number(C),
    atomic_list_concat([A,C], '.', Out), atom_number(Out,Output).

separatore_decimali(X) :- punto(X).
separatore_decimali(X) :- virgola(X).

check_tipo_richiesta(A) :- chirografario(A), !.
check_tipo_richiesta(A) :- privilegiato(A), !.
check_tipo_richiesta(A) :- totale(A), !.
