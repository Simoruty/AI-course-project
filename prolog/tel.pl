:- module( tel, 
            [ tag_tel/0
            , alltel/1
            , ristel/0
            ] 
).

:- use_module(kb).
:- use_module(lexer).
:- consult('tel_kb').

%% Trova tutti i numeri di telefono
alltel(ListaTel) :-
    findall((IDTag, Tel) ,kb:tag(IDTag, tel(Tel)), ListaTel).

%% Risultati
ristel :-
    \+kb:vuole(tel), !.
ristel :-
    alltel( ListaTel ),
    write('I numeri di telefoni trovati sono: '), 
    write( ListaTel ).

%% Tagga i prefissi
tag_prefisso :- 
    kb:fatto(prefisso),!.
tag_prefisso :-
    findall(_, tag_prefisso(_), _),
    kb:assertFact(kb:fatto(prefisso)).

tag_prefisso(Token) :-
    kb:token(IDToken, Token),
    prefisso(Token),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[PREFISSO] Presenza nel documento di ',Token],' ',Spiegazione),
    kb:appartiene(IDToken, IDDoc),
    assertTag(prefisso(Token), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDToken]). 
    

%% Tagga tutti i numeri di telefono
tag_tel :-     
    \+kb:vuole(tel),!.

tag_tel :-     
    kb:fatto(tel),!.

tag_tel :- 
    tag_prefisso,
    findall(_, tag_tel(_), _), 
    kb:assertFact(kb:fatto(tel)).
 
%% Controlla che il numero di telefono sia di questo formato +39 346 21 00 360   
tag_tel(Tel):-
    kb:tag(IDTag1, prefisso(Pref)),
    kb:next(IDTag1,IDTag2),
    kb:next(IDTag2,IDTag3),
    kb:next(IDTag3,IDTag4),
    kb:next(IDTag4,IDTag5),
    kb:tag(IDTag2, numero(Num2)),
    kb:tag(IDTag3, numero(Num3)),
    kb:tag(IDTag4, numero(Num4)),
    kb:tag(IDTag5, numero(Num5)),
    atom_length(Num2,Num2length), Num2length == 3, 
    atom_length(Num3,Num3length), Num3length == 2,
    atom_length(Num4,Num4length), Num4length == 2,
    atom_length(Num5,Num5length), Num5length == 3.
    atomic_list_concat([Pref, Num2, Num3, Num4, Num5], '', Tel),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag5, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Pref, Num2, Num3, Num4, Num5],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),    
    kb:appartiene(IDTag2, IDDoc),    
    kb:appartiene(IDTag3, IDDoc),
    kb:appartiene(IDTag4, IDDoc),    
    kb:appartiene(IDTag5, IDDoc),  
    assertTag(tel(Tel), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1,IDTag2,IDTag3,IDTag4,IDTag5]).


%% Controlla che il numero di telefono sia di questo formato +39 346 210 0360 
tag_tel(Tel):-
    kb:tag(IDTag1, prefisso(Pref)),
    kb:next(IDTag1,IDTag2),
    kb:next(IDTag2,IDTag3),
    kb:next(IDTag3,IDTag4),
    kb:tag(IDTag2, numero(Num2)),
    kb:tag(IDTag3, numero(Num3)),
    kb:tag(IDTag4, numero(Num4)),
    atom_length(Num2,Num2length), Num2length == 3, 
    atom_length(Num3,Num3length), Num3length == 3,
    atom_length(Num4,Num4length), Num4length == 4,
    atomic_list_concat([Pref, Num2, Num3, Num4], '', Tel),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag4, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Pref, Num2, Num3, Num4],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),    
    kb:appartiene(IDTag2, IDDoc),    
    kb:appartiene(IDTag3, IDDoc),
    kb:appartiene(IDTag4, IDDoc),    
    assertTag(tel(Tel), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1,IDTag2,IDTag3,IDTag4]).

%% Controlla che il numero di telefono sia di questo formato 346 21 00 360
tag_tel(Tel):-
    kb:tag(IDTag1, numero(Num1)),
    kb:next(IDTag1,IDTag2),
    kb:next(IDTag2,IDTag3),
    kb:next(IDTag3,IDTag4),
    kb:tag(IDTag2, numero(Num2)),
    kb:tag(IDTag3, numero(Num3)),
    kb:tag(IDTag4, numero(Num4)),
    atom_length(Num1,Num1length), Num1length == 3,
    atom_length(Num2,Num2length), Num2length == 2, 
    atom_length(Num3,Num3length), Num3length == 2,
    atom_length(Num4,Num4length), Num4length == 3,
    atomic_list_concat([Num1, Num2, Num3, Num4], '', Tel),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag4, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Num1, Num2, Num3, Num4],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),    
    kb:appartiene(IDTag2, IDDoc),    
    kb:appartiene(IDTag3, IDDoc),
    kb:appartiene(IDTag4, IDDoc),    
    assertTag(tel(Tel), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1,IDTag2,IDTag3,IDTag4]).

%% Controlla che il numero di telefono sia di questo formato +39 346 2100360
tag_tel(Tel):-
    kb:tag(IDTag1, prefisso(Pref)),
    kb:next(IDTag1,IDTag2),
    kb:next(IDTag2,IDTag3),
    kb:tag(IDTag2, numero(Num2)),
    kb:tag(IDTag3, numero(Num3)),
    atom_length(Num2,Num2length), Num2length == 3, 
    atom_length(Num3,Num3length), Num3length == 7,
    atomic_list_concat([Pref, Num2, Num3], '', Tel),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag3, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Pref, Num2, Num3],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),    
    kb:appartiene(IDTag2, IDDoc),    
    kb:appartiene(IDTag3, IDDoc),
    assertTag(tel(Tel), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1,IDTag2,IDTag3]).

%% Controlla che il numero di telefono sia di questo formato 346 210 0360
tag_tel(Tel):-
    kb:tag(IDTag1, numero(Num1)),
    kb:next(IDTag1,IDTag2),
    kb:next(IDTag2,IDTag3),
    kb:tag(IDTag2, numero(Num2)),
    kb:tag(IDTag3, numero(Num3)),
    atom_length(Num1,Num1length), Num1length == 3,
    atom_length(Num2,Num2length), Num2length == 3, 
    atom_length(Num3,Num3length), Num3length == 4,
    atomic_list_concat([Num1, Num2, Num3], '', Tel),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag3, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Num1, Num2, Num3],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),    
    kb:appartiene(IDTag2, IDDoc),    
    kb:appartiene(IDTag3, IDDoc),
    assertTag(tel(Tel), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1,IDTag2,IDTag3]).

%% Controlla che il numero di telefono sia di questo formato +39 3462100360
tag_tel(Tel):-
    kb:tag(IDTag1, prefisso(Pref)),
    kb:next(IDTag1,IDTag2),
    kb:tag(IDTag2, numero(Num2)),
    atom_length(Num2,Num2length), Num2length == 10, 
    atomic_list_concat([Pref, Num2], '', Tel),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Pref, Num2],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),    
    kb:appartiene(IDTag2, IDDoc),    
    assertTag(tel(Tel), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1,IDTag2]).

%% Controlla che il numero di telefono sia di questo formato 346 2100360
tag_tel(Tel):-
    kb:tag(IDTag1, numero(Num1)),
    kb:next(IDTag1,IDTag2),
    kb:tag(IDTag2, numero(Num2)),
    atom_length(Num1,Num1length), Num1length == 3,
    atom_length(Num2,Num2length), Num2length == 7, 
    atomic_list_concat([Num1, Num2], '', Tel),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Num1, Num2],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),    
    kb:appartiene(IDTag2, IDDoc),    
    assertTag(tel(Tel), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1,IDTag2]).


%% Controlla che il numero di telefono sia di questo formato 006703462100360
tag_tel(Tel):-
    kb:tag(IDTag1, numero(Tel)),
    atom_length(Tel,Token1length),
    Token1length >= 12, 
    Token1length =< 16,
    PrefissoLength is Token1length - 10,
    sub_atom(Tel,0,PrefissoLength,_,Prefisso),
    prefisso(Prefisso),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Tel],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),    
    assertTag(tel(Tel), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1]).

%% Controlla che il numero di telefono sia di questo formato 3462100360
tag_tel(Tel):-
    kb:tag(IDTag1, numero(Tel)),
    atom_length(Tel,Token1length),
    Token1length == 10, 
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Tel],' ',Spiegazione),
    kb:appartiene(IDTag1, IDDoc),    
    assertTag(tel(Tel), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDTag1]).
