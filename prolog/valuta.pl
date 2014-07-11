:- module( valuta, [
                      simbolo_valuta/1
                    , numero/1  
                    , tipologia/1
                    , valuta/2
                    , richiesta_valuta/3
                    ,  tag_simbolo_valuta/0
                    , tag_numero/0
                    , tag_tipologia/0
                    , tag_valuta/0
                    , tag_richiesta_valuta/0  
                   ] 
).

:- use_module(lexer).
:- use_module(kb).


tag_richiesta_valuta :- kb:fatto(richiesta_valuta), !.
tag_richiesta_valuta :-
    tag_valuta,
    tag_tipologia,
    findall((_A,_B,_C), tag_richiesta_valuta(_A,_B,_C), _),
    asserta(fatto(richiesta_valuta)).


tag_valuta :- kb:fatto(valuta), !.
tag_valuta :-
    tag_simbolo_valuta,
    tag_numero,
    findall((_X,_Y), tag_valuta(_X,_Y), _),
    asserta(fatto(valuta)).


tag_simbolo_valuta :- kb:fatto(simbolo_valuta), !.
tag_simbolo_valuta :-
    findall(_X, tag_simbolo_valuta(_X), _),
    asserta(fatto(simbolo_valuta)).

tag_numero :- kb:fatto(numero), !.
tag_numero :-
    findall(_X, tag_numero(_X), _),
    asserta(fatto(numero)).

tag_tipologia :- kb:fatto(tipologia), !.
tag_tipologia :-
    findall(_X, tag_tipologia(_X), _),
    asserta(fatto(tipologia)).

tipologia(T) :-
    kb:tag(_, tipologia(T)).
numero(N) :-
    kb:tag(_, numero(N)).
simbolo_valuta(S) :-
    kb:tag(_, simbolo_valuta(S)).
valuta(M,S) :-
    kb:tag(_, valuta(M, S)).
richiesta_valuta(M,S,T) :-
    kb:tag(_, tipologia(M,S,T)).



tag_simbolo_valuta(Valuta) :- 
    kb:token(IDToken, Token),
    std_valuta(Token, Valuta),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[SIMBOLO VALUTA] Nel documento e’ presente il simbolo',Token],' ',Spiegazione),
    kb:assertTag(simbolo_valuta(Valuta), ListaPrecedenti, ListaSuccessivi,Spiegazione, []).

std_valuta('€', '€').
std_valuta('euro', '€').
std_valuta('eur', '€').
std_valuta('$', '$').
std_valuta('£', '£').

tag_numero(Num) :- 
    kb:token(IDToken1, Token1),
    atom_is_number(Token1),
    atom_number(Token1, Num),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NUMERO] Nel documento e’ presente il numero',Num],' ',Spiegazione),
    kb:assertTag(numero(Num), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_tipologia(Tipologia) :- 
    kb:token(IDToken, Token),
    std_tipologia(Token, Tipologia),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TIPOLOGIA] Nel documento e’ presente il termine',Token],' ',Spiegazione),
    kb:assertTag(tipologia(Tipologia), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

std_tipologia('chirografario', 'chirografario').
std_tipologia('chirografaria', 'chirografario').
std_tipologia('chirografo', 'chirografario').
std_tipologia('chirografa', 'chirografario').
std_tipologia('chiro', 'chirografario').
std_tipologia('chir', 'chirografario').
std_tipologia('privilegiato', 'privilegiato').
std_tipologia('privilegiata', 'privilegiato').
std_tipologia('privil', 'privilegiato').
std_tipologia('priv', 'privilegiato').
std_tipologia('totale', 'totale').
std_tipologia('total', 'totale').
std_tipologia('tot', 'totale').

tag_valuta(Moneta, Simbolo) :-
    kb:tag(IDTag1, numero(Moneta)),
    kb:tag(IDTag2, simbolo_valuta(Simbolo)),
    kb:next(IDTag1, IDTag2),    
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[VALUTA] Nel documento e’ presente il numero',Moneta,'seguito dal simbolo',Simbolo],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    kb:assertTag(valuta(Moneta, Simbolo), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).

tag_valuta(Moneta, Simbolo) :-
    kb:tag(IDTag1, numero(Moneta)),
    kb:tag(IDTag2, simbolo_valuta(Simbolo)),
    kb:next(IDTag2, IDTag1),    
    findall( Precedente, kb:next(Precedente, IDTag2), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[VALUTA] Nel documento e’ presente il numero',Moneta,'preceduto dal simbolo',Simbolo],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    kb:assertTag(valuta(Moneta, Simbolo), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).

tag_richiesta_valuta(Moneta, Simbolo, Tipologia) :-
    kb:tag(IDTag1, tipologia(Tipologia)),
    kb:tag(IDTag2, valuta(Moneta, Simbolo)),
    kb:stessa_frase(IDTag1, IDTag2),
    atomic_list_concat(['[RICHIESTA VALUTA] Nel documento e’ presente nella stessa frase la valuta',Moneta,Simbolo,'e il termine',Tipologia],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    kb:assertTag(richiesta_valuta(Moneta, Simbolo, Tipologia) , Spiegazione, Dipendenze).
