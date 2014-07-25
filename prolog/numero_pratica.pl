:- module( numero_pratica, 
            [ 
              allnumero_pratica/1
            , risnumero_pratica/0
            , tag_numero_pratica/0
            ] 
).

:- use_module(kb).

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
    base:tag_numero,
    data:tag_anno,
    findall(_, tag_numero_pratica(_), _),
    kb:assertFact(kb:fatto(numero_pratica)).

tag_numero_pratica(X) :-
    kb:tag(IDTag2, anno(A)),
    kb:appartiene(IDTag2, IDDoc),
    kb:next(IDToken2, IDTag2),
    kb:tag(IDToken2, separatore_data('/')),
    kb:appartiene(IDToken2, IDDoc),
    kb:next(IDTag1, IDToken2),
    kb:tag(IDTag1, numero(_)),
    kb:val(IDTag1, N),
    kb:appartiene(IDTag1, IDDoc),
    kb:appartiene(IDTagn, IDDoc),
    kb:tag(IDTagn, parola('n')),    
    kb:stessa_frase(IDTagn, IDTag1),

    findall( Precedente, kb:next(Precedente, IDTagn), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag2, Successivo), ListaSuccessivi ),

    atomic_list_concat([N,'/',A], '', X),

    atomic_list_concat(['[NUMERO PRATICA] Presenza nel documento di `n` ', N, '/', A],'',Spiegazione),
    Dipendenze = [IDTag1, IDTag2, IDTagn, IDToken2],
    kb:appartiene(IDTag1, IDDoc),  
    kb:appartiene(IDTag2, IDDoc),    
    assertTag(numero_pratica(X), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).    
