:- set(c,4),set(i,1)?

:- modeh(1,kingmove_with_block(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,move1(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,nott(defend2(+int,r(+piece,+colour,+pos),r(-piece,+colour,+pos))))?
:- modeb(1,nott(kinginone(+int,r(+piece,+colour,+pos),
	r(+piece,-colour,-pos))))?
:- modeb(1,((+piece)=(#piece)))?


prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= nott(defend2(_,_,_)), A2=nott(defend2(_,_,_)).
prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= nott(kinginone(_,_,_)), A2=nott(kinginone(_,_,_)).


board(1,king,white,pos(d,4)).
board(1,king,black,pos(e,6)).
board(1,queen,white,pos(d,3)).

kingmove_with_block(1,king,white,pos(d,4),pos(c,4)).
kingmove_with_block(1,king,white,pos(d,4),pos(c,3)).
kingmove_with_block(1,king,white,pos(d,4),pos(e,4)).
kingmove_with_block(1,king,black,pos(e,6),pos(e,7)).
kingmove_with_block(1,king,black,pos(e,6),pos(d,6)).


:- kingmove_with_block(1,king,white,pos(d,4),pos(b,4)).
:- kingmove_with_block(1,king,white,pos(d,4),pos(d,3)).
:- kingmove_with_block(1,king,white,pos(d,4),pos(e,5)).
:- kingmove_with_block(1,king,black,pos(e,6),pos(d,5)).
:- kingmove_with_block(1,queen,white,pos(d,3),pos(d,1)).