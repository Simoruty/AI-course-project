:- module( mail, [mail/1] ).

:- use_module(lexer).
:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(conoscenza).

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
    next(IDToken1,IDToken2),
    next(IDToken2,IDToken3),
    next(IDToken3,IDToken4),
    next(IDToken4,IDToken5),
    next(IDToken5,IDToken6),
    next(IDToken6,IDToken7),

    check_mail(IDToken1, IDToken2, IDToken3, IDToken4, IDToken5, IDToken6, IDToken7),
   
    token(IDToken1, Token1),
    token(IDToken2, Token2),
    token(IDToken3, Token3),
    token(IDToken4, Token4),
    token(IDToken5, Token5),
    token(IDToken6, Token6),
    token(IDToken7, Token7),

    atomic_list_concat([Token1, Token2, Token3, Token4, Token5, Token6, Token7], '', Mail),

    asserta(spiega('Ho trovato la mail perché bla bla')).

mail(Mail) :-
    next(IDToken1,IDToken2),
    next(IDToken2,IDToken3),
    next(IDToken3,IDToken4),
    next(IDToken4,IDToken5),

    check_mail(IDToken1, IDToken2, IDToken3, IDToken4, IDToken5),
    
    token(IDToken1, Token1),
    token(IDToken2, Token2),
    token(IDToken3, Token3),
    token(IDToken4, Token4),
    token(IDToken5, Token5),

    atomic_list_concat([Token1, Token2, Token3, Token4, Token5], '', Mail),

    asserta(spiega('Ho trovato la mail perché bla bla')).

identificatore(Id) :-
    atom_codes(Id, String),
    maplist(ascii_id_char, String).

% nome@mail.it
check_mail(IDToken1, IDToken2, IDToken3, IDToken4, IDToken5) :-
    token(IDToken1, Username),
    token(IDToken2, '@'),
    token(IDToken3, Sito),
    token(IDToken4, '.'),
    token(IDToken5, Dominio),
    dominio(Dominio),
    identificatore(Username),
    identificatore(Sito).

% nome.cognome@mail.it
check_mail(IDToken1, IDToken2, IDToken3, IDToken4, IDToken5, IDToken6, IDToken7) :-
    token(IDToken1, Username),
    token(IDToken2, '.'),
    token(IDToken3, Username2),
    token(IDToken4, '@'),
    token(IDToken5, Sito),
    token(IDToken6, '.'),
    token(IDToken7, Dominio),
    dominio(Dominio),
    identificatore(Username),
    identificatore(Username2),
    identificatore(Sito).

