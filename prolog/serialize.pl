:- module( serialize, [ serialize/0 ]).

:- use_module(kb).
:- use_module(lexer).
:- use_module(valuta).
:- use_module(library(lists)).


serialize :-    
    tell('aserializzazione'),
    s_token,
    s_token2,
    s_token3,
    s_token4,
    told.


s_token :-
    findall(ID, kb:token(ID), ListaToken),
    forall( member(T, ListaToken), (
        write('token('),
        write(T),
        write(').'),nl
    ) ).


s_token2 :-
    findall(ID, (kb:token(ID, Token),valuta:std_valuta(Token, 'euro')), ListaToken),
    forall( member(T, ListaToken), (
        write('euro('),
        write(T),
        write(').'),nl
    ) ).

s_token3 :-
    findall(ID, (kb:token(ID, Token),valuta:std_valuta(Token, 'dollari')), ListaToken),
    forall( member(T, ListaToken), (
        write('dollari('),
        write(T),
        write(').'),nl
    ) ).


s_token4 :-
    findall(
        ID,
        ( kb:token(ID, Token), lexer:atom_is_number(Token) ),
        ListaToken ),
    forall( member(T, ListaToken), (
        write('number('),
        write(T),
        write(').'),nl
    ) ).
