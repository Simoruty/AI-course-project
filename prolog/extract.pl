:- module(extract,
          [ extract_request/2
          ]
).


:- use_module(library(lists)).



extract_request(ListToken,Request) :-
	extract_name(ListToken, Names),
	extract_currency(ListToken,Currency),
	extract_date(ListToken,Dates),
	append(Names,Currency,A),
	append(A,Dates, Request).	

extract_name(ListToken, NamesList) :- 
	findall(X, member(name(X),ListToken), NamesList).

extract_currency(ListToken, CurrencyList) :-
	findall((X,'€'), member(currency(X),ListToken), CurrencyList).

extract_date(ListToken, DateList) :-
	findall((X,Y,Z), member(date(X,Y,Z),ListToken), DateList).
