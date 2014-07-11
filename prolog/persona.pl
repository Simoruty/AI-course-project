:- module( persona, [ nome/1
                    , cognome/1
                    , persona/2
                    , soggetto/2
                    , giudice/2
                    , curatore/2
                   ] 
).

:- consult('persona_kb.pl').

nome(Nome) :- 
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

nome(Nome) :- 
    kb:next(IDToken1, IDToken2),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    nome_kb(Token1, Token2),
    atomic_list_concat([Token1, Token2], ' ', Nome),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NOME] Nel documento e’ presente',Nome],' ',Spiegazione),
    kb:assertTag(nome(Nome), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

nome(Nome) :- 
    kb:token(IDToken1, Nome),
    nome_kb(Nome),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NOME] Nel documento e’ presente',Nome],' ',Spiegazione),
    kb:assertTag(nome(Nome), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).


cognome(Cognome) :- 
    kb:next(IDToken1, IDToken2),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    cognome_kb(Token1, Token2),
    atomic_list_concat([Token1, Token2], ' ', Cognome),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COGNOME] Nel documento e’ presente',Cognome],' ',Spiegazione),
    kb:assertTag(cognome(Cognome), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

cognome(Cognome) :- 
    kb:token(IDToken1, Cognome),
    cognome_kb(Cognome),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COGNOME] Nel documento e’ presente',Cognome],' ',Spiegazione),
    kb:assertTag(cognome(Cognome), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

persona(C, N) :-
    kb:tag(IDTag1, cognome(C)),
    kb:tag(IDTag2, nome(N)),
    kb:next(IDTag1, IDTag2),
    
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[PERSONA] Nel documento e’ presente',C,N],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    kb:assertTag(persona(C, N), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).

persona(C, N) :-
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


soggetto(C,N) :-
    kb:tag(IDTag, persona(C,N)),
    kb:token(IDToken, Token),
    soggetto(Token),
    kb:stessa_frase(IDToken, IDTag),
%    !,    
    atomic_list_concat(['[SOGGETTO] Nel documento e’ presente il termine',Token,'e la persona',C,N,'all’interno della stessa frase'],' ',Spiegazione),
    kb:assertTag(soggetto(C,N), Spiegazione, [IDTag]).

curatore(C,N) :-
    kb:tag(IDTag, persona(C,N)),
    kb:token(IDToken, Token),
    curatore(Token),
    kb:stessa_frase(IDToken, IDTag),
%    !,
    atomic_list_concat(['[CURATORE] Nel documento e’ presente il termine',Token,'e la persona',C,N,'all’interno della stessa frase'],' ',Spiegazione),
    kb:assertTag(curatore(C,N), Spiegazione, [IDTag]).

giudice(C,N) :-
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

