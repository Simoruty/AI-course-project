:- module( valuta, [numero_pratica(X)] ).

numero_pratica(X) :-
    kb:tag(IDTag1, Tag1),
    kb:token(IDToken1, '/'),
    anno
