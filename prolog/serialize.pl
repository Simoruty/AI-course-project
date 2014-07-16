:- module( serialize, [ serialize/0 ]).

:- use_module(kb).
:- use_module(lexer).
:- use_module(valuta).
:- use_module(library(lists)).


serialize :-    
    tell('aserializzazione'),
    s_base,
    s_livello1,
    %s_livello2,
    %s_livello3,
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

%    findall( ID, kb:tag(ID, cf(_)), ListaTag2),
%    forall( member((ID,Cf), ListaTag2), (
%        write('tag('),write(ID),write(').'),nl,
%        write('cf('),write(ID),write(').'),nl
%    ) ),


    findall( ID, kb:tag(ID, mail(_)), ListaTag3),
    forall( member(ID, ListaTag3), (
        write('tag('),write(ID),write(').'),nl,
        write('mail('),write(ID),write(').'),nl
    ) ),

    findall( ID, kb:tag(ID, chiro(Token)), ListaTag4),
    forall( member((ID,Mail), ListaTag4), (
        write('tag('),write(ID),write(').'),nl,
        write('chiro('),write(ID),write(').'),nl
    ) ),

    findall( ID, kb:tag(ID, totale(Token)), ListaTag5),
    forall( member((ID,Mail), ListaTag5), (
        write('tag('),write(ID),write(').'),nl,
        write('totale('),write(ID),write(').'),nl
    ) ),

    findall( ID, kb:tag(ID, privilegiato(Token)), ListaTag6),
    forall( member((ID,Mail), ListaTag6), (
        write('tag('),write(ID),write(').'),nl,
        write('privilegiato('),write(ID),write(').'),nl
    ) ),

    findall( ID, kb:tag(ID, privilegiato(Token)), ListaTag6),
    forall( member((ID,Mail), ListaTag6), (
        write('tag('),write(ID),write(').'),nl,
        write('privilegiato('),write(ID),write(').'),nl
    ) ),

%    findall(ID, kb:token(ID), ListaToken),
%    forall( member(T, ListaToken), (write('token('),write(T),write(').'),nl) )
    true.

s_tag(Goal, Atom) :-
    findall( ID, kb:tag(ID, Goal), ListaTag),
    forall( member( ID, ListaTag ), (
        write('tag('), write(ID), write(').'),nl,
        write(Atom),write('('),write(ID),write(').'),nl
    ) ).
