:- module( tel, 
            [ tag_tel/0
            , tel/1
            , tel/2
            , alltel/1
            , ristel/0
            ] 
).

:- use_module(kb).
:- use_module(lexer).
:- consult('tel_kb').

%% Trova il primo numero di telefono
tel(Tel) :-
    kb:tag(_, tel(Tel)).

tel(IDTag, Tel) :-
    kb:tag(IDTag, tel(Tel)).

%% Trova tutti i numeri di telefono
alltel(ListaTel) :-
    findall((IDTag, Tel) ,kb:tag(IDTag, tel(Tel)), ListaTel).

%% Risultati
ristel :-
    \+kb:vuole(tel), !.
ristel :-
    findall( Tel ,kb:tag(_, tel(Tel)), ListaTel),
    write('I numeri di telefoni trovati sono: '), 
    write( ListaTel ).

%% Tagga tutti i numeri di telefono
tag_tel :-     
    \+kb:vuole(tel),!.

tag_tel :-     
    kb:fatto(tel),!.

tag_tel :- 
    findall(_, tag_tel(_), _), 
    asserta(kb:fatto(tel)).
    
tag_tel(Tel):-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),
    kb:next(IDToken4,IDToken5),
    check_tel(IDToken1, IDToken2, IDToken3, IDToken4, IDToken5),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    kb:token(IDToken5, Token5),
    atomic_list_concat([Token1, Token2, Token3, Token4, Token5], '', Tel),
    
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken5, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Token1,Token2,Token3,Token4,Token5],' ',Spiegazione),
    assertTag(tel(Tel), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).


tag_tel(Tel):-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),
    check_tel(IDToken1, IDToken2, IDToken3, IDToken4),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    atomic_list_concat([Token1, Token2, Token3, Token4], '', Tel),
    
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken4, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Token1,Token2,Token3,Token4],' ',Spiegazione),
    assertTag(tel(Tel), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).


tag_tel(Tel):-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    check_tel(IDToken1, IDToken2, IDToken3),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    atomic_list_concat([Token1, Token2, Token3], '', Tel),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken3, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Token1,Token2,Token3],' ',Spiegazione),
    assertTag(tel(Tel), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_tel(Tel):-
    kb:next(IDToken1,IDToken2),
    check_tel(IDToken1, IDToken2),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    atomic_list_concat([Token1, Token2], '', Tel),
    
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Token1,Token2],' ',Spiegazione),
    assertTag(tel(Tel), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_tel(Tel):-
    check_tel(IDTel),
    kb:token(IDTel, Tel),
    
    findall( Precedente, kb:next(Precedente, IDTel), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTel, Successivo), ListaSuccessivi ),

    atomic_list_concat(['[TELEFONO] Presenza nel documento di : ',Tel],' ',Spiegazione),
    assertTag(tel(Tel), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

%% Controlla che il numero di telefono sia di questo formato +39 346 21 00 360
check_tel(IDToken1, IDToken2, IDToken3, IDToken4, IDToken5) :-
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    kb:token(IDToken5, Token5),
    prefisso(Token1), 
    atom_is_number(Token2),
    atom_is_number(Token3),
    atom_is_number(Token4),
    atom_is_number(Token5),
    atom_length(Token2,Token2length), Token2length == 3, 
    atom_length(Token3,Token3length), Token3length == 2,
    atom_length(Token4,Token4length), Token4length == 2,
    atom_length(Token5,Token5length), Token5length == 3.

%% Controlla che il numero di telefono sia di questo formato +39 346 210 0360
check_tel(IDToken1, IDToken2, IDToken3, IDToken4) :-
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    prefisso(Token1), 
    atom_is_number(Token2),
    atom_is_number(Token3),
    atom_is_number(Token4),    
    atom_length(Token2,Token2length), Token2length == 3,
    atom_length(Token3,Token3length), Token3length == 3,
    atom_length(Token4,Token4length), Token4length == 4.

%% Controlla che il numero di telefono sia di questo formato 346 21 00 360
check_tel(IDToken1, IDToken2, IDToken3, IDToken4) :-
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    atom_is_number(Token1), 
    atom_is_number(Token2),
    atom_is_number(Token3),
    atom_is_number(Token4),    
    atom_length(Token1,Token1length), Token1length == 3,
    atom_length(Token2,Token2length), Token2length == 2, 
    atom_length(Token3,Token3length), Token3length == 2, 
    atom_length(Token4,Token4length), Token4length == 3.

%% Controlla che il numero di telefono sia di questo formato +39 346 2100360
check_tel(IDToken1, IDToken2, IDToken3) :-
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    prefisso(Token1), 
    atom_is_number(Token2), 
    atom_is_number(Token3),
    atom_length(Token2,Token2length), Token2length == 3,
    atom_length(Token3,Token3length), Token3length == 7.

%% Controlla che il numero di telefono sia di questo formato 346 210 0360
check_tel(IDToken1, IDToken2, IDToken3) :-
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    atom_is_number(Token1),  
    atom_is_number(Token2),
    atom_is_number(Token3),
    atom_length(Token1,Token1length), Token1length == 3,
    atom_length(Token2,Token2length), Token2length == 3,
    atom_length(Token3,Token3length), Token3length == 4.

%% Controlla che il numero di telefono sia di questo formato +39 3462100360
check_tel(IDToken1, IDToken2) :-
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    prefisso(Token1), 
    atom_is_number(Token2),
    atom_length(Token2,Token2length), Token2length==10.

%% Controlla che il numero di telefono sia di questo formato 346 2100360
check_tel(IDToken1, IDToken2) :-
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    atom_is_number(Token1),
    atom_is_number(Token2),
    atom_length(Token1,Token1length), Token1length==3,
    atom_length(Token2,Token2length), Token2length==7.

%% Controlla che il numero di telefono sia di questo formato 006703462100360
check_tel(IDTel) :-
    kb:token(IDTel, Tel),
    atom_length(Tel,Token1length),
    Token1length >= 11, 
    Token1length =< 15,
    sub_atom(Tel,0,5,_,Prefisso),
    prefisso(Prefisso),
    sub_atom(Tel,5,10,_,Numero),
    atom_is_number(Numero).

%% Controlla che il numero di telefono sia di questo formato +6703462100360
check_tel(IDTel) :-
    kb:token(IDTel, Tel),
    atom_length(Tel,Token1length),
    Token1length >= 11, 
    Token1length =< 15,
    sub_atom(Tel,0,4,_,Prefisso),
    prefisso(Prefisso),
    sub_atom(Tel,4,10,_,Numero),
    atom_is_number(Numero).

%% Controlla che il numero di telefono sia di questo formato +393462100360
check_tel(IDTel) :-
    kb:token(IDTel, Tel),
    atom_length(Tel,Token1length),
    Token1length >= 11, 
    Token1length =< 15,
    sub_atom(Tel,0,3,_,Prefisso),
    prefisso(Prefisso),
    sub_atom(Tel,3,10,_,Numero),
    atom_is_number(Numero).

%% Controlla che il numero di telefono sia di questo formato +13462100360
check_tel(IDTel) :-
    kb:token(IDTel, Tel),
    atom_length(Tel,Token1length),
    Token1length >= 11, 
    Token1length =< 15,
    sub_atom(Tel,0,2,_,Prefisso),
    prefisso(Prefisso),
    sub_atom(Tel,2,10,_,Numero),
    atom_is_number(Numero).

%% Controlla che il numero di telefono sia di questo formato 3462100360
check_tel(IDTel) :-
    kb:token(IDTel, Tel),
    atom_is_number(Tel),
    atom_length(Tel,Token1length),
    Token1length == 10.
