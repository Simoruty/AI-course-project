:- module( cf, 
            [ tag_cf/0
            , cf/1
            , cf/2
            , allcf/1
            , riscf/0
            ] 
).

:- use_module(kb).
:- use_module(lexer).

%% Trova il primo codice fiscale
cf(CF) :-
    kb:tag(_, cf(CF)).

cf(IDTag,CF) :-
    kb:tag(IDTag, cf(CF)).

%% Trova tutti i codici fiscali
allcf(ListaCF) :-
    findall((IDTag,CF) ,kb:tag(IDTag, cf(CF)), ListaCF).

%% Risultati
riscf :-
    \+kb:vuole(cf), !.
riscf :-
    allcf( ListaCf ),
    write('I codici fiscali trovati sono: '), 
    write( ListaCf ).

%% Tagga i codici fiscali
tag_cf :-
    \+kb:vuole(cf),!.
tag_cf :- 
    kb:fatto(cf),!.
tag_cf :- 
    findall(_, tag_cf(_), _),
    asserta(kb:fatto(cf)).

tag_cf(CF) :- 
    kb:token(IDToken, CF),
    check_cf(CF),

    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[CODICE FISCALE] Presenza nel documento di : ',CF],' ',Spiegazione),
    assertTag(cf(CF), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

check_cf(CF) :-
    atom(CF),
    atom_codes(CF,CFString),
    length(CFString,16),
    CFString=[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16],
    ascii_char(C1),
    ascii_char(C2),
    ascii_char(C3),
    ascii_char(C4),
    ascii_char(C5),
    ascii_char(C6),
    ascii_number(C7),
    ascii_number(C8),
    ascii_char(C9),
    ascii_number(C10),
    ascii_number(C11),
    ascii_char(C12),
    ascii_number(C13),
    ascii_number(C14),
    ascii_number(C15),
    ascii_char(C16).
