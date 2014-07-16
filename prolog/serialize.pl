:- module( serialize, [ serialize/0 ]).

:- use_module(kb).
:- use_module(lexer).
:- use_module(valuta).
:- use_module(library(lists)).


serialize :-    
    tell('aserializzazione'),
    s_base,
    s_livello1,
    s_livello2,
    s_livello3,
    s_depends,
    told.

s_base :- 
    %tutti i token
    findall(ID, (kb:token(ID)), ListaToken1),
    forall( member(T, ListaToken1), (write('token('),write(T),write(').'),nl) ),

    %tutti i next fra token
    %findall((ID1,ID2), (kb:next(ID1, ID2), kb:token(ID1), kb:token(ID2)), ListaToken2),
    %forall( member((T1,T2), ListaToken2), (write('next('),write(T1),write(','),write(T2),write(').'),nl) ),

    %tutti i next
    findall((ID1,ID2), kb:next(ID1, ID2), ListaToken2),
    forall( member((T1,T2), ListaToken2), (write('next('),write(T1),write(','),write(T2),write(').'),nl) ),
    true.

s_livello1 :-
    findall( (ID,Num), kb:tag(ID, numero(Num)), ListaTag1),
    forall( member((ID,Num), ListaTag1), (
        write('tag('),write(ID),write(').'),nl,
        write('numero('),write(ID),write(').'),nl,
        write('val('),write(ID),write(','),write(Num),write(').'),nl
    ) ),

    s_tag( cf(_), cf ),
    s_tag( mail(_), mail ),
    s_tag( chiro(_), chiro ),
    s_tag( totale(_), totale ),
    s_tag( privilegiato(_), privilegiato ),
    s_tag( simbolo_soggetto(_), simbolo_soggetto ),
    s_tag( simbolo_curatore(_), simbolo_curatore ),    
    s_tag( simbolo_giudice(_), simbolo_giudice ),
    s_tag( euro(_), euro ),
    s_tag( dollaro(_), dollaro ),

%    findall(ID, kb:token(ID), ListaToken),
%    forall( member(T, ListaToken), (write('token('),write(T),write(').'),nl) )
    true.

s_tag(Goal, Atom) :-
    findall( ID, kb:tag(ID, Goal), ListaTag),
    forall( member( ID, ListaTag ), (
        write('tag('), write(ID), write(').'),nl,
        write(Atom),write('('),write(ID),write(').'),nl
    ) ).
