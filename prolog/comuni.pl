:- module( comuni, [tag_comune/2] ).

:- consult('comuni_db.pl').

comune(A,B,C,D,E,F) :-
    atom(A),atom(B),atom(C),atom(D),atom(E),atom(F), 
    atomic_list_concat([A,B,C,D,E,F], ' ', X),
    comune(X).
comune(A,B,C,D,E) :-
    atom(A),atom(B),atom(C),atom(D),atom(E), 
    atomic_list_concat([A,B,C,D,E], ' ', X),
    comune(X).
comune(A,B,C,D) :- 
    atom(A),atom(B),atom(C),atom(D),
    atomic_list_concat([A,B,C,D], ' ', X),
    comune(X).
comune(A,B,C) :- 
    atom(A),atom(B),atom(C),
    atomic_list_concat([A,B,C], ' ', X),
    comune(X).
comune(A,B) :- 
    atom(A),atom(B),
    atomic_list_concat([A,B], ' ', X),
    comune(X).


tag_comune([],[]).
tag_comune([A,B,C,D,E,F|Xs], [cComune(X)|Ys]) :-
    atom(A),atom(B),atom(C),atom(D),atom(E),atom(F),
    comune(A,B,C,D,E,F),
    atomic_list_concat([A,B,C,D,E,F], ' ', X),
    !,
    tag_comune(Xs,Ys).
tag_comune([A,B,C,D,E|Xs], [cComune(X)|Ys]) :-
    atom(A),atom(B),atom(C),atom(D),atom(E),
    comune(A,B,C,D,E),
    atomic_list_concat([A,B,C,D,E], ' ', X),
    !,
    tag_comune(Xs,Ys).
tag_comune([A,B,C,D|Xs], [cComune(X)|Ys]) :-
    atom(A),atom(B),atom(C),atom(D),
    comune(A,B,C,D),
    atomic_list_concat([A,B,C,D], ' ', X),
    !,
    tag_comune(Xs,Ys).
tag_comune([A,B,C|Xs], [cComune(X)|Ys]) :-
    atom(A),atom(B),atom(C),
    comune(A,B,C),
    atomic_list_concat([A,B,C], ' ', X),
    !,
    tag_comune(Xs,Ys).
tag_comune([A,B|Xs], [cComune(X)|Ys]) :-
    atom(A),atom(B),
    comune(A,B),
    atomic_list_concat([A,B], ' ', X),
    !,
    tag_comune(Xs,Ys).
tag_comune([A|Xs], [cComune(A)|Ys]) :-
    atom(A),
    comune(A),
    !,
    tag_comune(Xs,Ys).
tag_comune([A|Xs], [A|Ys]) :-
    tag_comune(Xs,Ys).
