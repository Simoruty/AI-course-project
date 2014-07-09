:- module( comune, [comune/1] ).

:- use_module(conoscenza).

:- consult('comune_kb.pl').

comune(Comune) :-
    next(IDToken1,IDToken2),
    next(IDToken2,IDToken3),
    next(IDToken3,IDToken4),
    next(IDToken4,IDToken5),
    next(IDToken5,IDToken6),

    token(IDToken1, Token1),
    token(IDToken2, Token2),
    token(IDToken3, Token3),
    token(IDToken4, Token4),
    token(IDToken5, Token5),
    token(IDToken6, Token6),

    atomic_list_concat([Token1, Token2, Token3, Token4, Token5, Token6], ' ', Comune),
    comune_kb(Comune),
    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Comune) :-
    next(IDToken1,IDToken2),
    next(IDToken2,IDToken3),
    next(IDToken3,IDToken4),
    next(IDToken4,IDToken5),

    token(IDToken1, Token1),
    token(IDToken2, Token2),
    token(IDToken3, Token3),
    token(IDToken4, Token4),
    token(IDToken5, Token5),

    atomic_list_concat([Token1, Token2, Token3, Token4, Token5], ' ', Comune),
    comune_kb(Comune),
    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Comune) :-
    next(IDToken1,IDToken2),
    next(IDToken2,IDToken3),
    next(IDToken3,IDToken4),

    token(IDToken1, Token1),
    token(IDToken2, Token2),
    token(IDToken3, Token3),
    token(IDToken4, Token4),

    atomic_list_concat([Token1, Token2, Token3, Token4], ' ', Comune),
    comune_kb(Comune),
    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Comune) :-
    next(IDToken1,IDToken2),
    next(IDToken2,IDToken3),

    token(IDToken1, Token1),
    token(IDToken2, Token2),
    token(IDToken3, Token3),

    atomic_list_concat([Token1, Token2, Token3], ' ', Comune),
    comune_kb(Comune),
    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Comune) :-
    next(IDToken1,IDToken2),

    token(IDToken1, Token1),
    token(IDToken2, Token2),

    atomic_list_concat([Token1, Token2], ' ', Comune),
    comune_kb(Comune),
    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Token) :-
    token(_, Token),
    comune_kb(Token).
