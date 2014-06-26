:- use_module(syntax).
:- use_module(tagger).
:- consult('dataset.pl').

maint :-
    domanda(Documento),
    clean_string(Documento,ListToken),
    tagger(ListToken,ListTagged),
    clean_dots(ListTagged, ListCleaned),
    write(ListCleaned), nl.


main :-
    domanda(Documento),
    clean_string(Documento,ListToken),
    tagger(ListToken,ListTagged),
    clean_dots(ListTagged, ListCleaned ),
    write(ListCleaned), nl,
    false.


mainCorrect :-
    repeat,
        domanda(Documento),
        clean_string(Documento,ListToken),
        tagger(ListToken,ListTagged),
        clean_dots(ListTagged, ListCleaned ),
        write(ListCleaned), nl,
        write('Continue? '),
        read(RIS),nl,
        RIS == n,
    !,
    write('Bye'),nl.

