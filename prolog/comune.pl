:- module( comune, 
            [ tag_comune/0
            , allcomune/1
            , riscomune/0
            ] 
).

:- use_module(kb).

:- consult('comune_kb.pl').

%% Trova tutti i comuni
allcomune(ListaComuni) :-
    findall((IDTag,Comune) ,kb:tag(IDTag, comune(Comune)), ListaComuni).

%% Risultati
riscomune :-
    \+kb:vuole(comune), !.
riscomune :-
    allcomune( ListaComuni ),
    write('I comuni trovati sono: '), 
    write( ListaComuni ).

%% Tagga tutti i comuni
tag_comune :-
    \+kb:vuole(comune), !.
tag_comune :- 
    kb:fatto(comune), !.
tag_comune :-
    findall(X, tag_comune(X), _),
    kb:assertFact(kb:fatto(comune)).

tag_comune(Comune) :-
    kb:tag(IDTag1, parola(Tag1)),
    kb:next(IDTag1,IDTag2),
    kb:next(IDTag2,IDTag3),
    kb:next(IDTag3,IDTag4),
    kb:next(IDTag4,IDTag5),
    kb:next(IDTag5,IDTag6),
    kb:tag(IDTag2, parola(Tag2)),
    kb:tag(IDTag3, parola(Tag3)),
    kb:tag(IDTag4, parola(Tag4)),
    kb:tag(IDTag5, parola(Tag5)),
    kb:tag(IDTag6, parola(Tag6)),
    atomic_list_concat([Tag1, Tag2, Tag3, Tag4, Tag5, Tag6], ' ', Comune),
    comune_kb(Comune),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag6, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COMUNE] Presenza nel documento di : ',Comune],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),
    kb:appartiene(IDTag2, IDDoc),
    kb:appartiene(IDTag3, IDDoc),
    kb:appartiene(IDTag4, IDDoc),
    kb:appartiene(IDTag5, IDDoc),
    kb:appartiene(IDTag6, IDDoc),
    assertTag(comune(Comune), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1, IDTag2, IDTag3, IDTag4, IDTag5,IDTag6]).

tag_comune(Comune) :-
    kb:tag(IDTag1, parola(Tag1)),
    kb:next(IDTag1,IDTag2),
    kb:next(IDTag2,IDTag3),
    kb:next(IDTag3,IDTag4),
    kb:next(IDTag4,IDTag5),
    kb:tag(IDTag2, parola(Tag2)),
    kb:tag(IDTag3, parola(Tag3)),
    kb:tag(IDTag4, parola(Tag4)),
    kb:tag(IDTag5, parola(Tag5)),
    atomic_list_concat([Tag1, Tag2, Tag3, Tag4, Tag5], ' ', Comune),
    comune_kb(Comune),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag5, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COMUNE] Presenza nel documento di : ',Comune],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),
    kb:appartiene(IDTag2, IDDoc),
    kb:appartiene(IDTag3, IDDoc),
    kb:appartiene(IDTag4, IDDoc),
    kb:appartiene(IDTag5, IDDoc),
    assertTag(comune(Comune), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1, IDTag2, IDTag3, IDTag4, IDTag5]).

tag_comune(Comune) :-
    kb:tag(IDTag1, parola(Tag1)),
    kb:next(IDTag1,IDTag2),
    kb:next(IDTag2,IDTag3),
    kb:next(IDTag3,IDTag4),
    kb:tag(IDTag2, parola(Tag2)),
    kb:tag(IDTag3, parola(Tag3)),
    kb:tag(IDTag4, parola(Tag4)),
    atomic_list_concat([Tag1, Tag2, Tag3, Tag4], ' ', Comune),
    comune_kb(Comune),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag4, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COMUNE] Presenza nel documento di : ',Comune],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),
    kb:appartiene(IDTag2, IDDoc),
    kb:appartiene(IDTag3, IDDoc),
    kb:appartiene(IDTag4, IDDoc),
    assertTag(comune(Comune), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1, IDTag2, IDTag3, IDTag4]).

tag_comune(Comune) :-
    kb:tag(IDTag1, parola(Tag1)),
    kb:next(IDTag1,IDTag2),
    kb:next(IDTag2,IDTag3),
    kb:tag(IDTag2, parola(Tag2)),
    kb:tag(IDTag3, parola(Tag3)),
    atomic_list_concat([Tag1, Tag2, Tag3], ' ', Comune),
    comune_kb(Comune),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag3, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COMUNE] Presenza nel documento di : ',Comune],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),
    kb:appartiene(IDTag2, IDDoc),
    kb:appartiene(IDTag3, IDDoc),
    assertTag(comune(Comune), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1, IDTag2, IDTag3]).

tag_comune(Comune) :-
    kb:tag(IDTag1, parola(Tag1)),
    kb:next(IDTag1,IDTag2),
    kb:tag(IDTag2, parola(Tag2)),
    atomic_list_concat([Tag1, Tag2], ' ', Comune),
    comune_kb(Comune),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COMUNE] Presenza nel documento di : ',Comune],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),
    kb:appartiene(IDTag2, IDDoc),
    assertTag(comune(Comune), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1, IDTag2]).

tag_comune(Comune) :-
    kb:tag(IDTag1, parola(Comune)),
    comune_kb(Comune),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COMUNE] Presenza nel documento di : ',Comune],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),
    assertTag(comune(Comune), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1]).
