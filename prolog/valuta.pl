:- module( valuta, [richiesta/3] ).

:- use_module(lexer).
:- use_module(kb).

separatore_decimali('.').
separatore_decimali(',').

valuta(IDToken) :- token(IDToken, '€').
valuta(IDToken) :- token(IDToken, 'euro').
valuta(IDToken) :- token(IDToken, 'eur').
valuta(IDToken) :- token(IDToken, '$').
valuta(IDToken) :- token(IDToken, '£').
std_valuta('€', '€').
std_valuta('euro', '€').
std_valuta('eur', '€').
std_valuta('$', '$').
std_valuta('£', '£').

tipologia(IDToken) :- token(IDToken, 'chirografario').
tipologia(IDToken) :- token(IDToken, 'chirografaria').
tipologia(IDToken) :- token(IDToken, 'chirografo').
tipologia(IDToken) :- token(IDToken, 'chirografa').
tipologia(IDToken) :- token(IDToken, 'chiro').
tipologia(IDToken) :- token(IDToken, 'chir').
tipologia(IDToken) :- token(IDToken, 'privilegiato').
tipologia(IDToken) :- token(IDToken, 'privilegiata').
tipologia(IDToken) :- token(IDToken, 'privil').
tipologia(IDToken) :- token(IDToken, 'priv').
tipologia(IDToken) :- token(IDToken, 'totale').
tipologia(IDToken) :- token(IDToken, 'total').
tipologia(IDToken) :- token(IDToken, 'tot').

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



