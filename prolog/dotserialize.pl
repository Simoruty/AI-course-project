:- module( dotserialize, [ dotserialize/0 ]).

:- use_module(kb).
:- use_module(lexer).
:- use_module(library(lists)).


dotserialize :-    
    tell('dotserialization'),
    s_init,    
    s_base,
    s_end,
    told.

s_init :-
    write('digraph{'),nl,
    write('rankdir="LR";'),nl.

s_end :-
    write('{rank=same; '), alltoken, write('}'),nl,
    write('{rank=same; '), allnewline, write('}'),
    write('}').


allnewline :-
    s_tag( newline(_) ),
    true.

s_tag(Goal) :-
    findall( ID, kb:tag(ID, Goal), ListaTag),
    forall( member( ID, ListaTag ), (
        write(ID),write(' ')
    ) ).


alltoken :-
    findall(ID, (kb:token(ID,_)), ListaToken),
    forall( member(T, ListaToken), (
        write(T), write(' ')
    ) ).

s_base :- 

    %tutti i token
    findall(ID, (kb:token(ID,_)), ListaToken),
    forall( member(T, ListaToken), (write(T),write(' [shape=box];'),nl) ),

    %tutti i tag
    findall(ID, (kb:tag(ID,_)), ListaTag),
    forall( member(T, ListaTag), (write(T),write(' [shape=circle];'),nl) ),

    %tutti gli appartiene
%    findall((ID1,ID2), (kb:appartiene(ID1,ID2)), ListaApp),
%    forall( member((T1, T2), ListaApp), (write('appartiene('),write(T1), write(','),write(T2),write(').'),nl) ),

    %tutti i next
    findall((ID1,ID2), kb:next(ID1, ID2), ListaNext),
    forall( member((T1,T2), ListaNext), (write(T1),write(' -> '),write(T2),write(';'),nl) ),

    true.
