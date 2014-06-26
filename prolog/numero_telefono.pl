:- module( numero_telefono, [tag_numero_telefono/2] ).


:- use_module(syntax).
:- consult('numero_telefono_db').

tag_numero_telefono( [], [] ).

% +39 346 21 00 360
tag_numero_telefono( [A,B,C,D,E | Xs], [tel(Tel)|Ys] ) :-
    atom(B),
    atom(C),
    atom(D),
    atom(E),
    prefisso(A), 
    atom_is_number(B),
    atom_is_number(C),
    atom_is_number(D),
    atom_is_number(E),
    atom_length(B,Blength), Blength == 3, 
    atom_length(C,Clength), Clength == 2,
    atom_length(D,Dlength), Dlength == 2,
    atom_length(E,Elength), Elength == 3,
    !,
    atomic_list_concat([A,B,C,D,E], '', Tel),
    tag_numero_telefono(Xs, Ys).

% +39 346 210 0360
tag_numero_telefono( [A,B,C,D | Xs], [tel(Tel)|Ys] ) :-
    atom(B),
    atom(C),
    atom(D),
    prefisso(A), 
    atom_is_number(B),
    atom_is_number(C),
    atom_is_number(D),    
    atom_length(B,Blength), Blength == 3,
    atom_length(C,Clength), Clength == 3,
    atom_length(D,Dlength), Dlength == 4, 
    !,
    atomic_list_concat([A,B,C,D], '', Tel),
    tag_numero_telefono(Xs, Ys).

% 346 21 00 360
tag_numero_telefono( [A,B,C,D | Xs], [tel(Tel)|Ys] ) :-
    atom(A),
    atom(B),
    atom(C),
    atom(D),
    atom_is_number(A), 
    atom_is_number(B),
    atom_is_number(C),
    atom_is_number(D),    
    atom_length(A,Alength), Alength == 3,
    atom_length(B,Blength), Blength == 2, 
    atom_length(C,Clength), Clength == 2, 
    atom_length(D,Dlength), Dlength == 3, 
    !,
    atomic_list_concat([A,B,C,D], '', Tel),
    tag_numero_telefono(Xs, Ys).

% +39 346 2100360
tag_numero_telefono( [A,B,C | Xs], [tel(Tel)|Ys] ) :-
    atom(B),
    atom(C),
    prefisso(A), 
    atom_is_number(B), 
    atom_is_number(C),
    atom_length(B,Blength), Blength == 3,
    atom_length(C,Clength), Clength == 7,
    !,
    atomic_list_concat([A,B,C], '', Tel),
    tag_numero_telefono(Xs, Ys).

% 346 210 0360
tag_numero_telefono( [A,B,C | Xs], [tel(Tel)|Ys] ) :-
    atom(A),
    atom(B),
    atom(C),
    atom_is_number(A),  
    atom_is_number(B),
    atom_is_number(C),
    atom_length(A,Alength), Alength == 3,
    atom_length(B,Blength), Blength == 3,
    atom_length(C,Clength), Clength == 4,
    !,
    atomic_list_concat([A,B,C], '', Tel),
    tag_numero_telefono(Xs, Ys).

%+39 3462100360
tag_numero_telefono( [A,B | Xs], [tel(Tel)|Ys] ) :-
    atom(A),
    atom(B),
    prefisso(A), 
    atom_is_number(B),
    atom_length(B,Blength), Blength==10,
    !,
    atomic_list_concat([A,B], '', Tel),
    tag_numero_telefono(Xs, Ys).

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
