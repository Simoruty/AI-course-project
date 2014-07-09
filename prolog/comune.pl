:- module( comune, [comune/1] ).

:- use_module(conoscenza).

:- consult('comune_kb.pl').

comune(Comune) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),
    kb:next(IDToken4,IDToken5),
    kb:next(IDToken5,IDToken6),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    kb:token(IDToken5, Token5),
    kb:token(IDToken6, Token6),

    atomic_list_concat([Token1, Token2, Token3, Token4, Token5, Token6], ' ', Comune),
    comune_kb(Comune),
    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Comune) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),
    kb:next(IDToken4,IDToken5),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    kb:token(IDToken5, Token5),

    atomic_list_concat([Token1, Token2, Token3, Token4, Token5], ' ', Comune),
    comune_kb(Comune),
    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Comune) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),

    atomic_list_concat([Token1, Token2, Token3, Token4], ' ', Comune),
    comune_kb(Comune),
    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Comune) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),

    atomic_list_concat([Token1, Token2, Token3], ' ', Comune),
    comune_kb(Comune),
    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Comune) :-
    kb:next(IDToken1,IDToken2),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),

    atomic_list_concat([Token1, Token2], ' ', Comune),
    comune_kb(Comune),
    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Token) :-
    kb:token(_, Token),
    comune_kb(Token).
