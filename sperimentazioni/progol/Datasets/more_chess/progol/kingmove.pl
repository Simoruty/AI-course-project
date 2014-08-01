:- set(c,2),set(i,1)?

:- modeh(1,kingmove(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,kingmove_with_block(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,nott(full_attack(+int,r(-piece,-colour,-pos),
	r(+piece,+colour,+pos))))?


prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= nott(full_attack(_,_,_)), A2=nott(full_attack(_,_,_)).

board(1,king,white,pos(d,2)).
board(1,queen,black,pos(d,8)).
board(1,knight,black,pos(b,5)).

kingmove(1,king,white,pos(d,2),pos(c,1)).
kingmove(1,king,white,pos(d,2),pos(c,2)).
kingmove(1,king,white,pos(d,2),pos(e,3)).
kingmove(1,king,white,pos(d,2),pos(e,1)).


:- kingmove(1,king,white,pos(d,2),pos(d,1)).
:- kingmove(1,king,white,pos(d,2),pos(c,3)).
:- kingmove(1,king,white,pos(d,2),pos(d,3)).
:- kingmove(1,king,white,pos(d,2),pos(a,1)).