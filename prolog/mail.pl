:- module( mail, 
            [ tag_mail/0
            , allmail/1
            , rismail/0
            ] 
).

:- use_module(kb).
:- use_module(lexer).

%% Trova tutte le mail
allmail(ListaMail) :-
    findall((IDTag,Mail) ,kb:tag(IDTag, mail(Mail)), ListaMail).

%% Risultati
rismail :-
    \+kb:vuole(mail), !.
rismail :-
    allmail( ListaMail ),
    write('Le mail trovate sono: '), 
    write( ListaMail ).

%% Tagga tutte le mail
tag_mail :- 
    \+kb:vuole(mail),!.

tag_mail :- 
    kb:fatto(mail),!.

tag_mail :- 
    findall(_Mail, tag_mail(_), _), 
    kb:assertFact(kb:fatto(mail)).

tag_mail(Mail) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, '@'),
    kb:token(IDToken3, Token3),

    atomic_list_concat([Token1, Token3], '@', Mail),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken3, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[MAIL] Presenza nel documento di : ',Mail],' ',Spiegazione),
    kb:appartiene(IDToken1, IDDoc),    
    kb:appartiene(IDToken2, IDDoc),
    kb:appartiene(IDToken3, IDDoc),  
    assertTag(mail(Mail), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDToken1, IDToken2, IDToken3]).
