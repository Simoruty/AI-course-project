:- module( valuta, [
                    simbolo_valuta/1
                    , numero/1  
                    , tipologia/1
                    , valuta/2
                    , richiesta_valuta/3 
                   ] 
).

:- use_module(lexer).
:- use_module(kb).

simbolo_valuta(Valuta) :- 
    kb:token(IDToken, Token),
    std_valuta(Token, Valuta),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NUMERO] Nel documento e’ presente il simbolo',Token],' ',Spiegazione),
    kb:assertTag(simbolo_valuta(Valuta), ListaPrecedenti, ListaSuccessivi,Spiegazione, []).

std_valuta('€', '€').
std_valuta('euro', '€').
std_valuta('eur', '€').
std_valuta('$', '$').
std_valuta('£', '£').

numero(Num) :- 
    kb:token(IDToken1, Token1),
    atom_is_number(Token1),
    atom_number(Token1, Num),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NUMERO] Nel documento e’ presente il numero',Num],' ',Spiegazione),
    kb:assertTag(numero(Num), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tipologia(Tipologia) :- 
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

valuta(Moneta, Simbolo) :-
    kb:tag(IDTag1, numero(Moneta)),
    kb:tag(IDTag2, simbolo_valuta(Simbolo)),
    kb:next(IDTag1, IDTag2),    
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[VALUTA] Nel documento e’ presente il numero',Moneta,'seguito dal simbolo',Simbolo],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    kb:assertTag(valuta(Moneta, Simbolo), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).

valuta(Moneta, Simbolo) :-
    kb:tag(IDTag1, numero(Moneta)),
    kb:tag(IDTag2, simbolo_valuta(Simbolo)),
    kb:next(IDTag2, IDTag1),    
    findall( Precedente, kb:next(Precedente, IDTag2), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[VALUTA] Nel documento e’ presente il numero',Moneta,'preceduto dal simbolo',Simbolo],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    kb:assertTag(valuta(Moneta, Simbolo), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).

richiesta_valuta(Moneta, Simbolo, Tipologia) :-
    kb:tag(IDTag1, tipologia(Tipologia)),
    kb:tag(IDTag2, valuta(Moneta, Simbolo)),
    kb:stessa_frase(IDTag1, IDTag2),
    atomic_list_concat(['[RICHIESTA VALUTA] Nel documento e’ presente nella stessa frase la valuta',Moneta,Simbolo,'e il termine',Tipologia],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    kb:assertTag(richiesta_valuta(Moneta, Simbolo, Tipologia) , Spiegazione, Dipendenze).
