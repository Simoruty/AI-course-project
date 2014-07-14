:- module( mail, 
            [ tag_mail/0
            , mail/1
            , mail/2
            , allmail/1
            , rismail/0
            ] 
).

:- use_module(kb).
:- use_module(lexer).

%% Trova la prima mail
mail(Mail) :-
    kb:tag(_, mail(Mail)).

mail(IDTag, Mail) :-
    kb:tag(IDTag, mail(Mail)).

%% Trova tutte le mail
allmail(ListaMail) :-
    findall((IDTag,Mail) ,kb:tag(IDTag, mail(Mail)), ListaMail).

%% Risultati
rismail :-
    \+kb:vuole(mail), !.
rismail :-
    findall(Mail ,kb:tag(_, mail(Mail)), ListaMail),
    write('Le mail trovate sono: '), 
    write( ListaMail ).

%% Tagga tutte le mail
tag_mail :- 
    \+kb:vuole(mail),!.

tag_mail :- 
    kb:fatto(mail),!.

tag_mail :- 
    findall(_Mail, tag_mail(_), _), 
    asserta(kb:fatto(mail)).

tag_mail(Mail) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, '@'),
    kb:token(IDToken3, Token3),

    atomic_list_concat([Token1, Token3], '@', Mail),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken3, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[MAIL] Nel documento e’ presente',Mail],' ',Spiegazione),
    assertTag(mail(Mail), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).
