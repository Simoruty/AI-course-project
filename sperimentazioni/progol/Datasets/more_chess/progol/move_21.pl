
:- set(c,3),set(i,1)?
:- modeh(1,move2pawn(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,move1(+int,+piece,+colour,+pos,+pos))?
:- modeb(*,nott(land_on2(+int,r(+piece,+colour,+pos),r(-piece,-colour,+pos))))?
:- modeb(*,nott(xray2(+int,r(+piece,+colour,+pos),
	r(-piece,-colour,-pos),+pos)))?

prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= nott(xray2(_,_,_,_)), A2=nott(xray2(_,_,_,_)).
prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= nott(land_on2(_,_,_)), A2=nott(land_on2(_,_,_)).



board(1,pawn,white,pos(a,2)).


board(1,pawn,white,pos(d,2)).
board(1,pawn,white,pos(h,2)).
board(1,pawn,black,pos(h,7)).
board(1,pawn,black,pos(d,5)).

board(1,rook,white,pos(a,4)).
board(1,queen,black,pos(h,4)).

board(1,pawn,white,pos(b,2)).
board(1,knight,black,pos(b,3)).

board(1,pawn,black,pos(b,7)).
board(1,queen,black,pos(b,6)).





% pos examples.

move2pawn(1,pawn,white,pos(a,2),pos(a,3)).
move2pawn(1,pawn,white,pos(d,2),pos(d,3)).
move2pawn(1,pawn,white,pos(h,2),pos(h,3)).
move2pawn(1,pawn,black,pos(h,7),pos(h,5)).



% neg examples.

:- move2pawn(1,pawn,white,pos(a,2),pos(d,5)).
:- move2pawn(1,pawn,white,pos(a,2),pos(a,4)).
:- move2pawn(1,pawn,white,pos(h,2),pos(h,4)).
:- move2pawn(1,pawn,white,pos(b,2),pos(b,4)).
:- move2pawn(1,pawn,black,pos(b,7),pos(b,5)).