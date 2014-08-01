:- set(c,3),set(i,1)?

:- modeh(1,two_blockers(+int,r(+piece,+colour,+pos),
			r(+piece,+colour,+pos),
			r(+piece,+colour,+pos),
			r(#piece,+colour,+pos)))?
:- modeb(1,pseudo_pin(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos),
			r(#piece,+colour,+pos)))?
:- modeb(1,board(+int,+piece,+colour,+pos))?
:- modeb(1,equal_direction(+pos,+pos,+pos))?


prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= pseudo_pin(_,_,_,_), A2=pseudo_pin(_,_,_,_).
prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= equal_direction(_,_,_), A2=equal_direction(_,_,_).
prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= board(_,_,_,_), A2=board(_,_,_,_).

board(1,queen,white,pos(d,1)).
board(1,rook,white,pos(d,2)).
board(1,bishop,white,pos(g,5)).
board(1,rook,white,pos(f,8)).
board(1,rook,black,pos(d,4)).
board(1,rook,black,pos(d,6)).
board(1,knight,black,pos(e,7)).
board(1,pawn,black,pos(f,6)).
board(1,queen,black,pos(h,8)).
board(1,rook,white,pos(d,5)).
board(1,rook,white,pos(e,8)).
board(1,bishop,white,pos(h,4)).
board(1,knight,white,pos(d,3)).
board(1,queen,white,pos(a,8)).
board(1,bishop,white,pos(b,8)).
board(1,knight,black,pos(c,8)).
board(1,king,black,pos(d,8)).



two_blockers(1,r(queen,white,pos(d,1)),r(rook,black,pos(d,4)),
	r(rook,black,pos(d,6)),
	r(king,black,pos(d,8))).
two_blockers(1,r(rook,white,pos(d,2)),r(rook,black,pos(d,4)),
	r(rook,black,pos(d,6)),
	r(king,black,pos(d,8))).
two_blockers(1,r(bishop,white,pos(g,5)),r(pawn,black,pos(f,6)),
	r(knight,black,pos(e,7)),
	r(king,black,pos(d,8))).
two_blockers(1,r(bishop,white,pos(h,4)),r(pawn,black,pos(f,6)),
	r(knight,black,pos(e,7)),
	r(king,black,pos(d,8))).
two_blockers(1,r(queen,white,pos(a,8)),r(bishop,white,pos(b,8)),
	r(knight,black,pos(c,8)),
	r(king,black,pos(d,8))).


:- two_blockers(1,r(queen,white,pos(d,1)),r(rook,black,pos(d,4)),
	r(knight,black,pos(d,7)),
	r(king,black,pos(d,8))).
:- two_blockers(1,r(queen,white,pos(d,1)),r(rook,black,pos(d,4)),
	r(rook,white,pos(d,5)),
	r(king,black,pos(d,8))).
:- two_blockers(1,r(rook,white,pos(d,2)),r(rook,black,pos(d,6)),
	r(knight,black,pos(e,7)),
	r(king,black,pos(d,8))).
:- two_blockers(1,r(queen,black,pos(h,8)),r(rook,white,pos(f,8)),
	r(rook,white,pos(e,8)),
	r(king,black,pos(d,8))).
:- two_blockers(1,r(bishop,white,pos(g,5)),r(knight,black,pos(f,6)),
	r(knight,black,pos(e,7)),
	r(king,black,pos(d,8))).
:- two_blockers(1,r(bishop,white,pos(g,5)),r(rook,black,pos(d,4)),
	r(rook,black,pos(d,6)),
	r(king,black,pos(d,8))).
:- two_blockers(1,r(rook,white,pos(d,2)),r(rook,black,pos(d,4)),
	r(rook,black,pos(d,5)),
	r(king,black,pos(d,8))).
:- two_blockers(1,r(knight,white,pos(d,3)),r(rook,black,pos(d,4)),
	r(rook,black,pos(d,6)),
	r(king,black,pos(d,8))).
:- two_blockers(1,r(queen,white,pos(d,1)),r(rook,black,pos(d,4)),
	r(rook,black,pos(d,4)),
	r(king,black,pos(d,8))).