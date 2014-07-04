:- use_module(lexer).
:- use_module(tagger).
:- use_module(library(lists)).
%:- consult('dataset.pl').

main :-
    write('Benvenuto!'),nl,nl,
    write('Inserisci testo del documento: '),nl,
    read(Documento),
    to_string(Documento, Stringa), % lets user be free to write atom or strings
    %asserta(domanda(Stringa)),
    %findall(Tag, nextTag(Tag), ListaTag),

    extract(Stringa, ListaTag),

    nl,write('Informazioni estratte: '), nl,
    write(ListaTag),nl.


extract( String, ListaTag ) :-
    lexer( String, ListaToken ),
    tagger( ListaToken,ListaTag ).


% Restituisce il tag successivo estratto dalla domanda
nextTag(Tag) :-
    main(X), member(Tag, X), \+atom(Tag).
