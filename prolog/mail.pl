:- module( mail, [mail/1] ).

:- use_module(lexer).
:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(kb).

dominio('com').
dominio('it').
dominio('net').
dominio('org').
dominio('tv').
dominio('ac').
dominio('jp').
dominio('fr').
dominio('de').
dominio('us').


mail(Mail) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),
    kb:next(IDToken4,IDToken5),
    kb:next(IDToken5,IDToken6),
    kb:next(IDToken6,IDToken7),

    check_mail(IDToken1, IDToken2, IDToken3, IDToken4, IDToken5, IDToken6, IDToken7),
   
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    kb:token(IDToken5, Token5),
    kb:token(IDToken6, Token6),
    kb:token(IDToken7, Token7),

    atomic_list_concat([Token1, Token2, Token3, Token4, Token5, Token6, Token7], '', Mail),

    asserta(spiega('Ho trovato la mail perché bla bla')).

mail(Mail) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),
    kb:next(IDToken4,IDToken5),

    check_mail(IDToken1, IDToken2, IDToken3, IDToken4, IDToken5),
    
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    kb:token(IDToken5, Token5),

    atomic_list_concat([Token1, Token2, Token3, Token4, Token5], '', Mail),

    asserta(spiega('Ho trovato la mail perché bla bla')).

identificatore(Id) :-
    atom_codes(Id, String),
    maplist(ascii_id_char, String).

% nome@mail.it
check_mail(IDToken1, IDToken2, IDToken3, IDToken4, IDToken5) :-
    kb:token(IDToken1, Username),
    kb:token(IDToken2, '@'),
    kb:token(IDToken3, Sito),
    kb:token(IDToken4, '.'),
    kb:token(IDToken5, Dominio),
    dominio(Dominio),
    identificatore(Username),
    identificatore(Sito).

% nome.cognome@mail.it
check_mail(IDToken1, IDToken2, IDToken3, IDToken4, IDToken5, IDToken6, IDToken7) :-
    kb:token(IDToken1, Username),
    kb:token(IDToken2, '.'),
    kb:token(IDToken3, Username2),
    kb:token(IDToken4, '@'),
    kb:token(IDToken5, Sito),
    kb:token(IDToken6, '.'),
    kb:token(IDToken7, Dominio),
    dominio(Dominio),
    identificatore(Username),
    identificatore(Username2),
    identificatore(Sito).

