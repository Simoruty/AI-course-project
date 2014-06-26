:- use_module(library(lists)).
:- use_module(library(apply)).

:- op(800, xfy, cat).
:- op(800,xfx,i).



cat(Atom1,Atom2,Res) :- atom_concat(Atom1,Atom2,Res).
i(X,Y, Z) :-  Z=[X,Y].

R is A i B :- i(A, B, R).
Res is Atom1 cat Atom2 :- cat(Atom1, Atom2, Res).






main:-
   RESULT is 9 i 4, write(RESULT).
