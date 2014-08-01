stats(A,B,C,Bef,Aft) :-
	D = 9999,
	Bef is 100*(A/D+1)/2,
	Aft is 100*C*(1/D+1/B)/2.


% The following are the standard definitions for mean and s.d.
%
%	mu = (Sum x)/n
%	sd^2 = (Sum (x-mu)^2)/n
%
% From this it can be shown that sd can be computed incrementally as follows.
%
%	sd^2 = ((Sum x^2)/n-((Sum x)/n)^2)
%
% eg. Let x1=3, x2=4, x3=8  then
%
%	(Sum x)=16, mu=5, sd^2=14/3, (Sum x^2)=89, 

:- set(h,10000)?

stats(L,Mu,Sg) :-
	stats(L,0,0,0,Mu,Sg).

stats([],N,SumN,SumN2,Mu,Sg) :-
	Mu is SumN/N,
	Sg is (SumN2/N-Mu^2)^0.5.
stats([X|Xs],N,SumN,SumN2,Mu,Sg) :-
	stats(Xs,N+1,SumN+X,SumN2+X^2,Mu,Sg).
