:- module( mail, [mail/1] ).

:- use_module(lexer).
:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(kb).

mail(Mail) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, '@'),
    kb:token(IDToken3, Token3),

    atomic_list_concat([Token1, Token3], '@', Mail),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken3, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[MAIL] Nel documento e’ presente',Mail],' ',Spiegazione),
    kb:assertTag(mail(Mail), ListaPrecedenti, ListaSuccessivi, Spiegazione).
