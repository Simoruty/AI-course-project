:- set(c,2),set(i,1)?

:- modeh(1,pseudo_pin(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos),
		      r(#piece,+colour,+pos)))?
:- modeb(1,pin_blocker(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos),
		      r(#piece,+colour,+pos)))?
:- modeb(1,colneq(+colour,+colour))?

board(1,rook,white,pos(d,1)).
board(1,rook,black,pos(d,2)).
board(1,king,black,pos(d,8)).
board(1,queen,white,pos(d,6)).
board(1,knight,black,pos(d,7)).
board(1,bishop,white,pos(h,4)).
board(1,queen,black,pos(e,7)).


%pseudo_pin(1,r(rook,white,pos(d,1)),r(rook,black,pos(d,2)),
%	r(king,black,pos(d,8))).
pseudo_pin(1,r(rook,white,pos(d,1)),r(knight,black,pos(d,7)),
	r(king,black,pos(d,8))).
pseudo_pin(1,r(queen,white,pos(d,6)),r(knight,black,pos(d,7)),
	r(king,black,pos(d,8))).
pseudo_pin(1,r(bishop,white,pos(h,4)),r(queen,black,pos(e,7)),
	r(king,black,pos(d,8))).



:- pseudo_pin(1,r(rook,white,pos(d,1)),r(queen,white,pos(d,6)),
	r(king,black,pos(d,8))).
:- pseudo_pin(1,r(queen,white,pos(d,6)),r(rook,black,pos(d,7)),
	r(king,black,pos(d,8))).