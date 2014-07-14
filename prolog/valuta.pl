:- module( valuta, [
                      simbolo_valuta/1
                    , simbolo_valuta/2
                    , allsimbolo_valuta/1
                    , numero/1  
                    , numero/2
                    , allnumero/1
                    , tipologia/1
                    , tipologia/2
                    , alltipologia/1
                    , valuta/2
                    , valuta/3
                    , allvaluta/1
                    , richiesta_valuta/3
                    , richiesta_valuta/4
                    , allrichiesta_valuta/1
                    , risrichiesta_valuta/0
                    , tag_simbolo_valuta/0
                    , tag_numero/0
                    , tag_tipologia/0
                    , tag_valuta/0
                    , tag_richiesta_valuta/0  
                   ] 
).

:- use_module(lexer).
:- use_module(kb).

%% Trova la prima tipologia di richiesta
tipologia(T) :-
    kb:tag(_, tipologia(T)).

tipologia(IDTag, T) :-
    kb:tag(IDTag, tipologia(T)).

%% Trova il primo numero 
numero(N) :-
    kb:tag(_, numero(N)).

numero(IDTag, N) :-
    kb:tag(IDTag, numero(N)).

%% Trova il primo simbolo di valuta
simbolo_valuta(S) :-
    kb:tag(_, simbolo_valuta(S)).

simbolo_valuta(IDTag, S) :-
    kb:tag(IDTag, simbolo_valuta(S)).

%% Trova la prima valuta
valuta(M,S) :-
    kb:tag(_, valuta(M, S)).

valuta(IDTag, M, S) :-
    kb:tag(IDTag, valuta(M, S)).

%% Trova la prima richiesta di valuta
richiesta_valuta(M,S,T) :-
    kb:tag(_, richiesta_valuta(M,S,T)).

richiesta_valuta(IDTag, M, S, T) :-
    kb:tag(IDTag, richiesta_valuta(M,S,T)).

%% Trova tutte le tipologie di richieste
alltipologia(ListaTipologie) :-
    findall((IDTag, T) ,kb:tag(IDTag, tipologia(T)), ListaTipologie).

%% Trova tutti i numeri
allnumero(ListaNumeri) :-
    findall((IDTag, N) ,kb:tag(IDTag, numero(N)), ListaNumeri).

%% Trova tutti i simboli di valuta
allsimbolo_valuta(ListaSimboliValute) :-
    findall((IDTag, S) ,kb:tag(IDTag, simbolo_valuta(S)), ListaSimboliValute).

%% Trova tutte le valute
allvaluta(ListaValute) :-
    findall((IDTag, M, S) ,kb:tag(IDTag, valuta(M,S)), ListaValute).

%% Trova tutte le richieste di valuta
allrichiesta_valuta(ListaRichieste) :-
    findall((IDTag, M, S, T) ,kb:tag(IDTag, richiesta_valuta(M,S,T)), ListaRichieste).

%% Risultati
risrichiesta_valuta :-
    \+kb:vuole(richiesta_valuta), !.
risrichiesta_valuta :-
    findall(( M, S, T) ,kb:tag(_, richiesta_valuta(M,S,T)), ListaRichieste),
    write('Le richieste di valuta trovate sono: '), 
    write( ListaRichieste ).

%% Tagga le richieste di valuta
tag_richiesta_valuta :-
    \+kb:vuole(richiesta_valuta), !.
tag_richiesta_valuta :-
    kb:fatto(richiesta_valuta), !.
tag_richiesta_valuta :-
    tag_valuta,
    tag_tipologia,
    findall((_,_,_), tag_richiesta_valuta(_,_,_), _),
    asserta(kb:fatto(richiesta_valuta)).

%% Tagga le valute
tag_valuta :-
    kb:fatto(valuta), !.
tag_valuta :-
    tag_simbolo_valuta,
    tag_numero,
    findall((_,_), tag_valuta(_,_), _),
    asserta(kb:fatto(valuta)).

%% Tagga i simboli di valuta
tag_simbolo_valuta :-
    kb:fatto(simbolo_valuta), !.
tag_simbolo_valuta :-
    findall(_, tag_simbolo_valuta(_), _),
    asserta(kb:fatto(simbolo_valuta)).

%% Tagga i numeri
tag_numero :-
    kb:fatto(numero), !.
tag_numero :-
    findall(_, tag_numero(_), _),
    asserta(kb:fatto(numero)).

%% Tagga le tipologie
tag_tipologia :-
    kb:fatto(tipologia), !.
tag_tipologia :-
    findall(_, tag_tipologia(_), _),
    asserta(kb:fatto(tipologia)).

%% Tagga i simboli di valuta
tag_simbolo_valuta(Valuta) :- 
    kb:token(IDToken, Token),
    std_valuta(Token, Valuta),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[SIMBOLO VALUTA] Presenza nel documento del simbolo',Token],' ',Spiegazione),
    assertTag(simbolo_valuta(Valuta), ListaPrecedenti, ListaSuccessivi,Spiegazione, []).

std_valuta('€', 'euro').
std_valuta('euro', 'euro').
std_valuta('eur', 'euro').
std_valuta('$', 'dollari').
std_valuta('£', 'sterline').

%% Tagga i numeri
tag_numero(Num) :- 
    kb:token(IDToken1, Token1),
    atom_is_number(Token1),
    atom_number(Token1, Num),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NUMERO] Presenza nel documento del numero',Num],' ',Spiegazione),
    assertTag(numero(Num), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

%% Tagga le tipologie
tag_tipologia(Tipologia) :- 
    kb:token(IDToken, Token),
    std_tipologia(Token, Tipologia),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TIPOLOGIA] Presenza nel documento del termine',Token],' ',Spiegazione),
    assertTag(tipologia(Tipologia), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

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

%% Tagga le valute
tag_valuta(Moneta, Simbolo) :-
    kb:tag(IDTag1, numero(Moneta)),
    kb:tag(IDTag2, simbolo_valuta(Simbolo)),
    kb:next(IDTag1, IDTag2),    
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[VALUTA] Presenza nel documento del numero',Moneta,'seguito dal simbolo',Simbolo],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    assertTag(valuta(Moneta, Simbolo), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).

tag_valuta(Moneta, Simbolo) :-
    kb:tag(IDTag1, numero(Moneta)),
    kb:tag(IDTag2, simbolo_valuta(Simbolo)),
    kb:next(IDTag2, IDTag1),    
    findall( Precedente, kb:next(Precedente, IDTag2), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[VALUTA] Presenza nel documento del numero',Moneta,'preceduto dal simbolo',Simbolo],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    assertTag(valuta(Moneta, Simbolo), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).

%% Tagga le richieste di valuta
tag_richiesta_valuta(Moneta, Simbolo, Tipologia) :-
    kb:tag(IDTag1, tipologia(Tipologia)),
    kb:tag(IDTag2, valuta(Moneta, Simbolo)),
    stessa_frase(IDTag1, IDTag2),
    atomic_list_concat(['[RICHIESTA VALUTA] Presenza nella stessa frase della valuta',Moneta,Simbolo,'e del termine',Tipologia],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    assertTag(richiesta_valuta(Moneta, Simbolo, Tipologia) , Spiegazione, Dipendenze).
