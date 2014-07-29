:- module( serialize, [ serialize/0 ]).

:- use_module(kb).
:- use_module(lexer).
:- use_module(library(lists)).


serialize :- 
    NomeFile='sperimentazioni/ius.db',
    tell(NomeFile),
    %s_docs,
    s_base,
    s_livello1,
    s_livello2,
    s_livello3,
    s_livello4,
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
    forall( member(T, ListaDoc), (
        write('documento('),write(T),write(').'),nl,
        %write('NOTtoken('),write(T),write(').'),nl,
        %write('NOTtag('),write(T),write(').'),nl,
        %write('NOTparola('),write(T),write(').'),nl,
        %write('NOTnumero('),write(T),write(').'),nl,
        %TODO
        true
    )),
    
    %tutti i token
    findall(ID, (kb:token(ID,_)), ListaToken),
    forall( member(T, ListaToken), (
        write('token('),write(T),write(').'),nl,
        write('NOTdocumento('),write(T),write(').'),nl,
        write('NOTtag('),write(T),write(').'),nl,
        write('NOTnumero('),write(T),write(').'),nl,
        write('NOTparola('),write(T),write(').'),nl,
        write('NOTnewline('),write(T),write(').'),nl,
        write('NOTseparatore_data('),write(T),write(').'),nl,
        write('NOTgiorno('),write(T),write(').'),nl,
        write('NOTmese('),write(T),write(').'),nl,
        write('NOTanno('),write(T),write(').'),nl,
        write('NOTdata('),write(T),write(').'),nl,
        true
        %TODO
    )),

    %tutti i tag
    findall(ID, (kb:tag(ID,_)), ListaTag),
    forall( member(T, ListaTag), (
        write('tag('),write(T),write(').'),nl,
        write('NOTtoken('),write(T),write(').'),nl,
        true
    )),

    %tutti gli appartiene
    findall((ID1,ID2), (kb:appartiene(ID1,ID2)), ListaApp),
    forall( member((T1, T2), ListaApp), (write('appartiene('),write(T1), write(','),write(T2),write(').'),nl) ),

    %tutti i next
    findall((ID1,ID2), kb:next(ID1, ID2), ListaNext),
    forall( member((T1,T2), ListaNext), (
        write('next('),write(T1),write(','),write(T2),write(').'),nl,
        write('NOTdepends('),write(T1),write(','),write(T2),write(').'),nl
    )),

    %tutti i depends
    findall((ID1,ID2), kb:depends(ID1, ID2), ListaToken2),
    forall( member((T1,T2), ListaToken2), (
        write('depends('),write(T1),write(','),write(T2),write(').'),nl,
        write('NOTnext('),write(T1),write(','),write(T2),write(').'),nl
    )),
    true.


s_livello1 :-
    findall(
        (IDn,Num),
        (
            kb:tag( IDn, numero(_) ),
            kb:val( IDn, Num )
        ),
        ListaNum
    ),
    forall(
        member((IDn,Num), ListaNum),
        (
            write('numero('),write(IDn),
            write(').'),nl,
            write('val('),write(IDn),write(','),
            write(Num),write(').'),nl,
            true
        )
    ),

    findall(
        (IDp,Par),
        (
            kb:tag( IDp, parola(Par) )
        ),
        ListaParole
    ),
    forall(
        member((IDp,Par), ListaParole),
        (
            write('parola('),write(IDp),
            write(').'),nl,
            write('tax('),write(IDp),write(','),
            write(Par),write(').'),nl,
            true
        )
    ),

    s_tag( newline(_), newline ),
%    s_tag( euro(_), euro ),
%    s_tag( dollaro(_), dollaro ),
%    s_tag( mail(_), mail ),
%    s_tag( cf(_), cf ),
    s_tag( separatore_data(_), separatore_data ),
%    s_tag( prefisso(_), prefisso ),
    true.


s_livello2 :-
%    s_tag( chiro(_), chiro ),
%    s_tag( totale(_), totale ),
%    s_tag( privilegiato(_), privilegiato ),
%    s_tag( simbolo_soggetto(_), simbolo_soggetto ),
%    s_tag( simbolo_curatore(_), simbolo_curatore ),    
%    s_tag( simbolo_giudice(_), simbolo_giudice ),
%    s_tag( cognome(_), cognome ),
%    s_tag( nome(_), nome ),
%    s_tag( valuta(_,_), valuta ),
%    s_tag( comune(_), comune ),
    s_tag( giorno(_), giorno ),
    s_tag( mese(_), mese ),
    s_tag( anno(_), anno ),
%    s_tag( tel(_), tel ),
    true.

s_livello3 :-
%    s_tag( persona(_,_), persona ),
    s_tag( data(_,_,_), data ),
%    s_tag( numero_pratica(_), numero_pratica ),
    true.

s_livello4 :-
%    s_tag( soggetto(_,_), soggetto ),
%    s_tag( curatore(_,_), curatore ),
%    s_tag( giudice(_,_), giudice ),
%    s_tag( richiesta_valuta(_,_,_), richiesta_valuta ),
    true.


s_tag(Goal, Atom) :-
    findall( ID, kb:tag(ID, Goal), ListaTag),
    forall( member( ID, ListaTag ), (
        write(Atom),write('('),write(ID),write(').'),nl
    ) ).

