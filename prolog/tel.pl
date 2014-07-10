:- module( tel, [tel/2] ).

:- use_module(kb).
:- use_module(lexer).
:- consult('tel_kb').


tel(X) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),
    kb:next(IDToken4,IDToken5),
    kb:next(IDToken5,IDToken6),
    kb:next(IDToken6,IDToken7),

    check_mail(IDToken1, IDToken2, IDToken3, IDToken4, IDToken5, IDToken6, IDToken7),
   
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    kb:token(IDToken5, Token5),
    kb:token(IDToken6, Token6),
    kb:token(IDToken7, Token7),

    atomic_list_concat([Token1, Token2, Token3, Token4, Token5, Token6, Token7], '', Mail),
    

tag_numero_telefono( [], [] ).

% +39 346 21 00 360
tel(X) :-
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
    atomic_list_concat([Token1, Token2, Token3, Token4, Token5], '', Tel).

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
    atom_length(Token2,Blength), Blength == 3, 
    atom_length(Token3,Clength), Clength == 2,
    atom_length(Token4,Dlength), Dlength == 2,
    atom_length(Token5,Elength), Elength == 3.

% +39 346 210 0360
tel(X) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),
    check_tel(IDToken1, IDToken2, IDToken3, IDToken4),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    atomic_list_concat([Token1, Token2, Token3, Token4], '', Tel).


check_tel(IDToken1, IDToken2, IDToken3, IDToken4) :-
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    prefisso(Token1), 
    atom_is_number(Token2),
    atom_is_number(Token3),
    atom_is_number(Token4),    
    atom_length(Token2,Blength), Blength == 3,
    atom_length(Token3,Clength), Clength == 3,
    atom_length(Token4,Dlength), Dlength == 4.

% 346 21 00 360
tel(X) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),
    check_tel(IDToken1, IDToken2, IDToken3, IDToken4),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    atomic_list_concat([Token1, Token2, Token3, Token4], '', Tel).

check_tel(IDToken1, IDToken2, IDToken3, IDToken4) :-
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    atom_is_number(Token1), 
    atom_is_number(Token2),
    atom_is_number(Token3),
    atom_is_number(Token4),    
    atom_length(Token1,Alength), Alength == 3,
    atom_length(Token2,Blength), Blength == 2, 
    atom_length(Token3,Clength), Clength == 2, 
    atom_length(Token4,Dlength), Dlength == 3.

% +39 346 2100360
tel(X) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    check_tel(IDToken1, IDToken2, IDToken3),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    atomic_list_concat([Token1, Token2, Token3], '', Tel).

check_tel(IDToken1, IDToken2, IDToken3) :-
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    prefisso(Token1), 
    atom_is_number(Token2), 
    atom_is_number(Token3),
    atom_length(Token2,Blength), Blength == 3,
    atom_length(Token3,Clength), Clength == 7.

% 346 210 0360
tel(X) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    check_tel(IDToken1, IDToken2, IDToken3),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    atomic_list_concat([Token1, Token2, Token3], '', Tel).

check_tel(IDToken1, IDToken2, IDToken3) :-
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    atom_is_number(Token1),  
    atom_is_number(Token2),
    atom_is_number(Token3),
    atom_length(Token1,Alength), Alength == 3,
    atom_length(Token2,Blength), Blength == 3,
    atom_length(Token3,Clength), Clength == 4.

%+39 3462100360
tel(X) :-
    kb:next(IDToken1,IDToken2),
    check_tel(IDToken1, IDToken2),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    atomic_list_concat([Token1, Token2], '', Tel).

check_tel(IDToken1, IDToken2) :-
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    prefisso(Token1), 
    atom_is_number(Token2),
    atom_length(Token2,Blength), Blength==10.

























% 346 2100360
tag_numero_telefono( [A,B | Xs], [tel(Tel)|Ys] ) :-
    atom(A),
    atom(B),
    atom_is_number(A),
    atom_is_number(B),
    atom_length(A,Alength), Alength==3,
    atom_length(B,Blength), Blength==7,
    !,
    atomic_list_concat([A,B], '', Tel),
    tag_numero_telefono(Xs, Ys).

% 006703462100360
tag_numero_telefono( [A | Xs], [tel(A)|Ys] ) :-
    atom(A),
    atom_length(A,Alength),
    Alength >= 11, 
    Alength =< 15,
    sub_atom(A,0,5,_,Prefisso),
    prefisso(Prefisso),
    sub_atom(A,5,10,_,Numero),
    atom_is_number(Numero),
    !,
    tag_numero_telefono(Xs, Ys).

% +6703462100360
tag_numero_telefono( [A | Xs], [tel(A)|Ys] ) :-
    atom(A),
    atom_length(A,Alength),
    Alength >= 11, 
    Alength =< 15,
    sub_atom(A,0,4,_,Prefisso),
    prefisso(Prefisso),
    sub_atom(A,4,10,_,Numero),
    atom_is_number(Numero),
    !,
    tag_numero_telefono(Xs, Ys).

% +393462100360
tag_numero_telefono( [A | Xs], [tel(A)|Ys] ) :-
    atom(A),
    atom_length(A,Alength),
    Alength >= 11, 
    Alength =< 15,
    sub_atom(A,0,3,_,Prefisso),
    prefisso(Prefisso),
    sub_atom(A,3,10,_,Numero),
    atom_is_number(Numero),
    !,
    tag_numero_telefono(Xs, Ys).

% +13462100360
tag_numero_telefono( [A | Xs], [tel(A)|Ys] ) :-
    atom(A),
    atom_length(A,Alength),
    Alength >= 11, 
    Alength =< 15,
    sub_atom(A,0,2,_,Prefisso),
    prefisso(Prefisso),
    sub_atom(A,2,10,_,Numero),
    atom_is_number(Numero),
    !,
    tag_numero_telefono(Xs, Ys).

% 3462100360
tag_numero_telefono( [A | Xs], [tel(A)|Ys] ) :-
    atom(A),
    atom_is_number(A),
    atom_length(A,Alength),
    Alength == 10,
    !,
    tag_numero_telefono(Xs, Ys).

%% non numero
%tag_numero_telefono( [A,B,C,D,E | Xs], [A|Ys] ):- 
%    !,    
%    tag_numero_telefono([B,C,D,E|Xs], Ys). 
%% non numero
%tag_numero_telefono( [A,B,C,D | Xs], [A|Ys] ):- 
%    !,
%    tag_numero_telefono([B,C,D|Xs], Ys). 
%% non numero
%tag_numero_telefono( [A,B | Xs], [A|Ys] ):- 
%    !,
%    tag_numero_telefono([B|Xs], Ys). 
% non numero
tag_numero_telefono( [A | Xs], [A|Ys] ):- 
    !,
    tag_numero_telefono(Xs, Ys). 
