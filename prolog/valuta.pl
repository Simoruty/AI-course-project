:- module( valuta, [simbolo_valuta/1, numero_decimale/1, numero/1, tipologia/1, richiesta_valuta/3 ] ).

:- use_module(lexer).
:- use_module(kb).

simbolo_valuta(Valuta) :- 
    kb:token(IDToken, Token),
    std_valuta(Token, Valuta),

    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    kb:assertTag(simbolo_valuta(Valuta), ListaPrecedenti, ListaSuccessivi)
    %TODO spiegazione.
    .

std_valuta('€', '€').
std_valuta('euro', '€').
std_valuta('eur', '€').
std_valuta('$', '$').
std_valuta('£', '£').

numero_decimale(Num) :- 
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:next(IDToken1, IDToken2),
    kb:next(IDToken2, IDToken3),    
    
    atom_is_number(Token1),
    separatore(Token2),
    atom_is_number(Token3),
    atomic_list_concat([Token1, Token3], '.', AtomNumero),    

    atom_number(AtomNumero, Num),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken3, Successivo), ListaSuccessivi ),
    kb:assertTag(numero_decimale(Num), ListaPrecedenti, ListaSuccessivi).
    %TODO spiegazione.

numero(Num) :- 
    kb:token(IDToken1, Token1),
    
    atom_is_number(Token1),
    atom_number(Token1, Num),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    kb:assertTag(numero(Num), ListaPrecedenti, ListaSuccessivi).
    %TODO spiegazione.

numero(Num) :-
    kb:tag(IDTag, numero_decimale(Num)),
    
    findall( Precedente, kb:next(Precedente, IDTag), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag, Successivo), ListaSuccessivi ),
    kb:assertTag(numero(Num), ListaPrecedenti, ListaSuccessivi).
    %TODO spiegazione.

separatore('.').
separatore(',').


tipologia(Tipologia) :- 
    kb:token(IDToken, Token),
    std_tipologia(Token, Tipologia),

    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    kb:assertTag(tipologia(Tipologia), ListaPrecedenti, ListaSuccessivi)
    %TODO spiegazione.
    .

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



richiesta_valuta(Moneta, Simbolo, Tipologia) :-
    kb:tag(IDTag1, numero(Moneta)),
    kb:tag(IDTag2, simbolo_valuta(Simbolo)),
%    kb:tag(IDTag3, tipologia(Tipologia)),
    kb:next(IDTag1, IDTag2),
%    kb:stessa_frase(IDTag1, IDTag3),
%    kb:stessa_frase(IDTag2, IDTag3),
    
    kb:assertTag(richiesta_valuta(Moneta, Simbolo, tipologia)).
    %TODO spiegazione.   

richiesta_valuta(Moneta, Simbolo, Tipologia) :-
    kb:tag(IDTag1, numero(Moneta)),
    kb:tag(IDTag2, simbolo_valuta(Simbolo)),
%    kb:tag(IDTag3, tipologia(Tipologia)),
    kb:next(IDTag2, IDTag1),
%    kb:stessa_frase(IDTag1, IDTag3),
%    kb:stessa_frase(IDTag2, IDTag3),
    
    kb:assertTag(richiesta_valuta(Moneta, Simbolo, tipologia)).
    %TODO spiegazione.   

    

% € 50
% 50 €
% € 26.67
% 26.67 €

% 50.25 €
%richiesta(Quantita, Valuta, Tipologia) :-
%    next(IDToken1, IDToken2),
%    next(IDToken2, IDToken3),
%    next(IDToken3, IDToken4),
%    token(IDToken1, Token1),
%    token(IDToken2, Token2),
%    token(IDToken3, Token3),
%    token(IDToken4, Token4),
%    numero(IDToken1),
%    separatore_decimali(Token2), 
%    numero(IDToken3),
%    valuta(IDToken4),
%    stessa_frase(IDToken1,IDTokenTipo),
%    tipologia(IDTokenTipo),
%    IDTokenTipo\=IDToken1, IDTokenTipo\=IDToken2, IDTokenTipo\=IDToken3, IDTokenTipo\=IDToken4,
%    token(IDTokenTipo, TokenTipo),
%    atomic_list_concat([Token1, Token3], Token2, Quantita),
%    std_valuta( Token4, Valuta)
%    std_tipologia( TokenTipo, Tipologia ).



