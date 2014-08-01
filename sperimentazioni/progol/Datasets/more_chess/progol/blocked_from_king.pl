:- set(c,4),set(i,1)?
:- modeh(1,blocked_from_king(+int,r(+piece,+colour,+pos),
			   r(#piece,+colour,+pos)))?
:- modeb(1,board(+int,#piece,+colour,+pos))?
:- modeb(1,move1(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,colneq(+colour,+colour))?
:- modeb(1,nott(move2(+int,+piece,+colour,+pos,+pos)))?

prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= nott(move2(_,_,_,_)), A2=nott(move2(_,_,_,_)).


board(1,king,black,pos(d,5)).
board(1,rook,white,pos(d,1)).
board(1,queen,white,pos(d,2)).
board(1,rook,white,pos(d,3)).
board(1,queen,white,pos(d,4)).
board(1,bishop,white,pos(e,4)).
board(1,bishop,white,pos(f,3)).
board(1,bishop,black,pos(g,2)).
board(1,queen,black,pos(d,8)).
board(1,knight,black,pos(d,7)).
board(1,bishop,white,pos(h,1)).


blocked_from_king(1,r(rook,white,pos(d,1)),r(king,black,pos(d,5))).
blocked_from_king(1,r(queen,white,pos(d,2)),r(king,black,pos(d,5))).
blocked_from_king(1,r(rook,white,pos(d,3)),r(king,black,pos(d,5))).
blocked_from_king(1,r(bishop,white,pos(f,3)),r(king,black,pos(d,5))).
blocked_from_king(1,r(bishop,white,pos(h,1)),r(king,black,pos(d,5))).


:- blocked_from_king(1,r(rook,white,pos(d,1)),r(king,black,pos(d,3))).
:- blocked_from_king(1,r(knight,white,pos(d,7)),r(king,black,pos(d,5))).
:- blocked_from_king(1,r(queen,white,pos(d,4)),r(king,black,pos(d,5))).
:- blocked_from_king(1,r(queen,black,pos(d,8)),r(king,black,pos(d,5))).
:- blocked_from_king(1,r(bishop,white,pos(e,4)),r(king,black,pos(d,5))).
:- blocked_from_king(1,r(bishop,black,pos(g,2)),r(king,black,pos(d,5))).