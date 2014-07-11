:- module( persona, [ nome/1
                    , cognome/1
                    , persona/2
                    , soggetto/2
                    , giudice/2
                    , curatore/2
                    , tag_nome/0
                    , tag_cognome/0
                    , tag_persona/0
                    , tag_soggetto/0
                    , tag_giudice/0
                    , tag_curatore/0
                   ] 
).

:- consult('persona_kb.pl').


tag_persona :- kb:fatto(persona), !.
tag_persona :-
    tag_cognome,
    tag_nome,
    findall((X,Y), tag_persona(X,Y), _),
    asserta(fatto(persona)).

tag_cognome :- kb:fatto(cognome), !.
tag_cognome :- 
    findall(X, tag_cognome(X), _),
    asserta(fatto(cognome)).

tag_nome :- kb:fatto(nome), !.
tag_nome :- 
    findall(X, tag_nome(X), _),
    asserta(fatto(nome)).


tag_soggetto :- kb:fatto(soggetto), !.
tag_soggetto :- 
    tag_persona,
    findall((C,N), tag_soggetto(C,N), _),
    asserta(fatto(soggetto)).

tag_curatore
tag_curatore :- kb:fatto(curatore), !.
tag_curatore :- 
    tag_persona,
    findall((C,N), tag_curatore(C,N), _),
    asserta(fatto(curatore)).


tag_giudice
tag_giudice :- kb:fatto(giudice), !.
tag_giudice :- 
    tag_persona,
    findall((C,N), tag_giudice(C,N), _),
    asserta(fatto(giudice)).


persona(Cognome, Nome) :-
    kb:tag(_, persona(Cognome, Nome)).
cognome(X) :-
    kb:tag(_, cognome(X)).
nome(X) :-
    kb:tag(_, nome(X)).    
soggetto(Cognome, Nome) :-
    kb:tag(_, soggetto(Cognome, Nome)).
giudice(Cognome, Nome) :-
    kb:tag(_, giudice(Cognome, Nome)).
curatore(Cognome, Nome) :-
    kb:tag(_, curatore(Cognome, Nome)).


tag_nome(Nome) :- 
    kb:next(IDToken1, IDToken2),
    kb:next(IDToken2, IDToken3),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    nome_kb(Token1, Token2, Token3),
    atomic_list_concat([Token1, Token2, Token3], ' ', Nome),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken3, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NOME] Nel documento e’ presente',Nome],' ',Spiegazione),
    kb:assertTag(nome(Nome), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_nome(Nome) :- 
    kb:next(IDToken1, IDToken2),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    nome_kb(Token1, Token2),
    atomic_list_concat([Token1, Token2], ' ', Nome),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NOME] Nel documento e’ presente',Nome],' ',Spiegazione),
    kb:assertTag(nome(Nome), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_nome(Nome) :- 
    kb:token(IDToken1, Nome),
    nome_kb(Nome),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NOME] Nel documento e’ presente',Nome],' ',Spiegazione),
    kb:assertTag(nome(Nome), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).


tag_cognome(Cognome) :- 
    kb:next(IDToken1, IDToken2),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    cognome_kb(Token1, Token2),
    atomic_list_concat([Token1, Token2], ' ', Cognome),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COGNOME] Nel documento e’ presente',Cognome],' ',Spiegazione),
    kb:assertTag(cognome(Cognome), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_cognome(Cognome) :- 
    kb:token(IDToken1, Cognome),
    cognome_kb(Cognome),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COGNOME] Nel documento e’ presente',Cognome],' ',Spiegazione),
    kb:assertTag(cognome(Cognome), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_persona(C, N) :-
    kb:tag(IDTag1, cognome(C)),
    kb:tag(IDTag2, nome(N)),
    kb:next(IDTag1, IDTag2),
    
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[PERSONA] Nel documento e’ presente',C,N],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    kb:assertTag(persona(C, N), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).

tag_persona(C, N) :-
    kb:tag(IDTag1, cognome(C)),
    kb:tag(IDTag2, nome(N)),
    kb:next(IDTag2, IDTag1),
    
    findall( Precedente, kb:next(Precedente, IDTag2), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[PERSONA] Nel documento e’ presente',C,N],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    kb:assertTag(persona(C, N), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).


nome_kb(A,B,C) :- 
    nome_kb(A),
    nome_kb(B),
    nome_kb(C).

nome_kb(A,B) :-
    nome_kb(A),
    nome_kb(B).


cognome_kb(A, B) :-
	cognome_kb(A),
	cognome_kb(B).

cognome_kb(A, B) :-
    atomic_list_concat([A, B], ' ', C),
    cognome_kb(C).


tag_soggetto(C,N) :-
    kb:tag(IDTag, persona(C,N)),
    kb:token(IDToken, Token),
    soggetto(Token),
    kb:stessa_frase(IDToken, IDTag),
%    !,    
    atomic_list_concat(['[SOGGETTO] Nel documento e’ presente il termine',Token,'e la persona',C,N,'all’interno della stessa frase'],' ',Spiegazione),
    kb:assertTag(soggetto(C,N), Spiegazione, [IDTag]).

tag_curatore(C,N) :-
    kb:tag(IDTag, persona(C,N)),
    kb:token(IDToken, Token),
    curatore(Token),
    kb:stessa_frase(IDToken, IDTag),
%    !,
    atomic_list_concat(['[CURATORE] Nel documento e’ presente il termine',Token,'e la persona',C,N,'all’interno della stessa frase'],' ',Spiegazione),
    kb:assertTag(curatore(C,N), Spiegazione, [IDTag]).

tag_giudice(C,N) :-
    kb:tag(IDTag, persona(C,N)),
    kb:token(IDToken, Token),
    giudice(Token),
    kb:stessa_frase(IDToken, IDTag),
%    !,
    atomic_list_concat(['[GIUDICE] Nel documento e’ presente il termine',Token,'e la persona',C,N,'all’interno della stessa frase'],' ',Spiegazione),
    kb:assertTag(giudice(C,N), Spiegazione, [IDTag]).

soggetto('sottoscritto').
soggetto('sottoscritta').
curatore('curatore').
curatore('commissario').
giudice('giudice').

