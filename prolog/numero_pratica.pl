:- module( numero_pratica, 
            [ numero_pratica/1
            , numero_pratica/2
            , allnumero_pratica/1
            , risnumero_pratica/0
            , tag_numero_pratica/0
            ] 
).

:- use_module(kb).
:- use_module(data).
:- use_module(valuta).

%% Trova il primo numero di pratica
numero_pratica(Num) :-
    kb:tag(_, numero_pratica(Num)).

numero_pratica(IDTag, Num) :-
    kb:tag(IDTag, numero_pratica(Num)).

%% Trova tutti i numeri di pratica
allnumero_pratica(ListaNumeri_pratica) :-
    findall((IDTag,Num) ,kb:tag(IDTag, numero_pratica(Num)), ListaNumeri_pratica).

%% Risultati
risnumero_pratica :-
    \+kb:vuole(numero_pratica), !.
risnumero_pratica :-
    allnumero_pratica( ListaNumeri_pratica ),
    write('I numeri di pratica trovati sono: '), 
    write( ListaNumeri_pratica ).

%% Tagga i numeri di pratica
tag_numero_pratica :-
    \+kb:vuole(numero_pratica), !.

tag_numero_pratica :-
    kb:fatto(numero_pratica), !.

tag_numero_pratica :-
    tag_numero,
    tag_anno,
    findall(_, tag_numero_pratica(_), _),
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

    atomic_list_concat(['[NUMERO PRATICA] Presenza nel documento di `n` ', N, '/', A],'',Spiegazione),
    Dipendenze = [IDTag1, IDTag2],
    kb:appartiene(IDTag1, IDDoc),  
    kb:appartiene(IDTag2, IDDoc),    
    assertTag(numero_pratica(X), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).    
