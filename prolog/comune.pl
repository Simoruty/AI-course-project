:- module( comune, [comune/1] ).

:- use_module(kb).

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

    kb:next(Precedente, IDToken1),
    kb:next(IDToken6, Successivo),
    assertTag(comune(Comune), Precedente, Successivo),

    assertFact(spiega('Ho trovato la data perché bla bla')).


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

    kb:next(Precedente, IDToken1),
    kb:next(IDToken5, Successivo),
    assertTag(comune(Comune), Precedente, Successivo),

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

    kb:next(Precedente, IDToken1),
    kb:next(IDToken4, Successivo),
    assertTag(comune(Comune), Precedente, Successivo),

    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Comune) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),

    atomic_list_concat([Token1, Token2, Token3], ' ', Comune),
    comune_kb(Comune),

    kb:next(Precedente, IDToken1),
    kb:next(IDToken3, Successivo),
    assertTag(comune(Comune), Precedente, Successivo),

    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Comune) :-
    kb:next(IDToken1,IDToken2),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),

    atomic_list_concat([Token1, Token2], ' ', Comune),
    comune_kb(Comune),

    kb:next(Precedente, IDToken1),
    kb:next(IDToken2, Successivo),
    assertTag(comune(Comune), Precedente, Successivo),

    asserta(spiega('Ho trovato la data perché bla bla')).

comune(Comune) :-
    kb:token(IDToken1, Comune),
    comune_kb(Comune),

    kb:next(Precedente, IDToken1),
    kb:next(IDToken1, Successivo),
    assertTag(comune(Comune), Precedente, Successivo).
