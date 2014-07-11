:- module( numero_pratica, [
                             numero_pratica/1
                           , tag_numero_pratica/0
                           ] ).

:- use_module(kb).


numero_pratica(Num) :-
    kb:tag(_, numero_pratica(Num)).

tag_numero_pratica :- kb:fatto(numero_pratica), !.
tag_numero_pratica :-
    tag_numero,
    tag_anno,
    findall(_X, tag_numero_pratica(_X), _),
    asserta(kb:fatto(numero_pratica)).


tag_numero_pratica(X) :-
    kb:token(IDToken1, 'n'),
    kb:tag(IDTag1, numero(N)),
    kb:token(IDToken2, '/'),
    kb:tag(IDTag2, anno(A)),
    kb:next(IDToken1, IDTag1),
    kb:next(IDTag1, IDToken2),
    kb:next(IDToken2, IDTag2),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag2, Successivo), ListaSuccessivi ),

    atomic_list_concat([N,'/',A], '', X),

    atomic_list_concat(['[NUMERO PRATICA] Nel documento è presente `n` ', N, '/', A],'',Spiegazione),
    Dipendenze = [IDTag1, IDTag2],
    kb:assertTag(numero_pratica(X), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).    
