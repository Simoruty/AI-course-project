:- module( serialize, [ serialize/1 ]).

:- use_module(kb).
:- use_module(lexer).
:- use_module(library(lists)).


serialize(Path) :- 
    atom_concat(Path,'serialized', NomeFile),    
    tell(NomeFile),
    s_docs,
    s_base,
    s_livello1,
    s_livello2,
    s_livello3,
    s_depends,
    told.

s_docs :-
    findall((ID,Doc), (kb:documento(ID,Doc)), ListaDoc),
    forall( member((ID,Doc), ListaDoc), (
        write('testoDoc('),
        write(ID),
        write(',"'),
        atom_codes(X,Doc),
        write(X),
        write('").'),nl)
        ),
    true.

s_base :- 

    %tutti i documenti
    findall(ID, (kb:documento(ID,_)), ListaDoc),
    forall( member(T, ListaDoc), (write('documento('),write(T),write(').'),nl) ),
    
    %tutti i token
    findall(ID, (kb:token(ID,_)), ListaToken),
    forall( member(T, ListaToken), (write('token('),write(T),write(').'),nl) ),

    %tutti i tag
    findall(ID, (kb:tag(ID,_)), ListaTag),
    forall( member(T, ListaTag), (write('tag('),write(T),write(').'),nl) ),

    %tutti gli appartiene
    findall((ID1,ID2), (kb:appartiene(ID1,ID2)), ListaApp),
    forall( member((T1, T2), ListaApp), (write('appartiene('),write(T1), write(','),write(T2),write(').'),nl) ),

    %tutti i next
    findall((ID1,ID2), kb:next(ID1, ID2), ListaNext),
    forall( member((T1,T2), ListaNext), (write('next('),write(T1),write(','),write(T2),write(').'),nl) ),

    
    true.

s_livello1 :-
    findall( (ID,Num), ( kb:tag(ID, numero(_)) , kb:val(ID, Num) ), ListaTag1),
    forall( member((ID,Num), ListaTag1), (
        write('numero('),write(ID),write(').'),nl,
        write('val('),write(ID),write(','),write(Num),write(').'),nl
    ) ),

    s_tag( cf(_), cf ),
    s_tag( mail(_), mail ),
    s_tag( chiro(_), chiro ),
    s_tag( totale(_), totale ),
    s_tag( privilegiato(_), privilegiato ),
    s_tag( simbolo_soggetto(_), simbolo_soggetto ),
    s_tag( simbolo_curatore(_), simbolo_curatore ),    
    s_tag( simbolo_giudice(_), simbolo_giudice ),
    s_tag( euro(_), euro ),
    s_tag( dollaro(_), dollaro ),
    s_tag( newline(_), newline ),
    true.

s_tag(Goal, Atom) :-
    findall( ID, kb:tag(ID, Goal), ListaTag),
    forall( member( ID, ListaTag ), (
        write(Atom),write('('),write(ID),write(').'),nl
    ) ).

s_livello2 :-
    s_tag( cognome(_), cognome ),
    s_tag( nome(_), nome ),
    s_tag( comune(_), comune ),
    s_tag( giorno(_), giorno ),
    s_tag( mese(_), mese ),
    s_tag( anno(_), anno ),
    s_tag( persona(_,_), persona ),
    s_tag( data(_,_,_), data ),
    s_tag( valuta(_,_), valuta ),
    true.

s_livello3 :-
    s_tag( soggetto(_,_), soggetto ),
    s_tag( curatore(_,_), curatore ),
    s_tag( giudice(_,_), giudice ),
    s_tag( richiesta_valuta(_,_,_), richiesta_valuta ),
    s_tag( numero_pratica(_), numero_pratica ),
    true.

s_depends :-
    findall((ID1,ID2), kb:depends(ID1, ID2), ListaToken2),
    forall( member((T1,T2), ListaToken2), (write('depends('),write(T1),write(','),write(T2),write(').'),nl) ),
    true.
