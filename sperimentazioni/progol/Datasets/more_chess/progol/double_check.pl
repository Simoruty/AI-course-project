:- set(c,3),set(i,1)?

:- modeh(1,double_check(+int,r(+piece,+colour,+pos),
			r(+piece,+colour,+pos),
			r(#piece,+colour,+pos)))?

:- modeb(1,check(+int,r(+piece,+colour,+pos),r(#piece,+colour,+pos)))?
:- modeb(1,newsquare(+pos,+pos))?

board(1,rook,white,pos(a,1)).
board(1,queen,white,pos(c,4)).
board(1,king,black,pos(a,4)).
board(1,bishop,white,pos(b,3)).
board(1,queen,white,pos(f,7)).
board(1,king,black,pos(g,4)).
board(1,king,black,pos(c,6)).

double_check(1,r(rook,white,pos(a,1)),r(bishop,white,pos(b,3)),
	     r(king,black,pos(a,4))).
double_check(1,r(rook,white,pos(a,1)),r(queen,white,pos(c,4)),
	     r(king,black,pos(a,4))).
double_check(1,r(bishop,white,pos(b,3)),r(queen,white,pos(c,4)),
	     r(king,black,pos(a,4))).
double_check(1,r(queen,white,pos(c,4)),r(bishop,white,pos(b,3)),
	     r(king,black,pos(a,4))).
double_check(1,r(queen,white,pos(c,4)),r(rook,white,pos(a,1)),
	     r(king,black,pos(a,4))).


:- double_check(1,r(rook,white,pos(a,1)),r(queen,white,pos(c,4)),
	    r(king,black,pos(a,6))).
:- double_check(1,r(rook,white,pos(a,1)),r(queen,white,pos(c,4)),
	    r(king,black,pos(c,6))).
:- double_check(1,r(queen,white,pos(c,4)),r(queen,white,pos(f,7)),
	    r(king,black,pos(c,6))).
:- double_check(1,r(queen,white,pos(c,4)),r(queen,white,pos(f,7)),
	    r(king,black,pos(g,4))).
:- double_check(1,r(queen,white,pos(c,4)),r(queen,white,pos(c,4)),
	    r(king,black,pos(a,4))).