:- set(c,3),set(i,1)?

:- modeh(1,full_attack(+int,r(+piece,+colour,+pos),
				  r(#piece,+colour,+pos)))?
:- modeb(1,move1(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,board(+int,-piece,+colour,+pos))?
:- modeb(1,full_attack1(+int,r(+piece,+colour,+pos),
				   r(#piece,+colour,+pos)))?


:- modeb(1,full_attackpawn(+int,r(+piece,+colour,+pos),
				r(#piece,+colour,+pos)))?

prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= full_attack1(_,_,_), A2=full_attack1(_,_,_).


% This uses our split up full attack piece and gives us the rest 
% of the clause. We are learning the case for full attack when a king
% is taking an opponents piece.

board(1,king,white,pos(d,4)).
board(1,rook,black,pos(d,5)).
board(1,queen,black,pos(d,8)).
board(1,knight,black,pos(e,5)).
board(1,bishop,black,pos(c,4)).
board(1,bishop,black,pos(d,3)).

full_attack(1,r(queen,black,pos(d,8)),r(king,white,pos(d,5))).
full_attack(1,r(rook,black,pos(d,5)),r(king,white,pos(e,5))).
full_attack(1,r(knight,black,pos(e,5)),r(king,white,pos(c,4))).
full_attack(1,r(bishop,black,pos(c,4)),r(king,white,pos(d,5))).
full_attack(1,r(bishop,black,pos(d,3)),r(king,white,pos(c,4))).

:- full_attack(1,r(rook,black,pos(d,5)),r(king,white,pos(c,4))).
:- full_attack(1,r(rook,black,pos(d,5)),r(king,white,pos(c,5))).
:- full_attack(1,r(queen,black,pos(d,8)),r(king,white,pos(d,3))).

board(1,pawn,white,pos(g,7)).
board(1,king,black,pos(f,8)).
board(1,pawn,white,pos(h,5)).

full_attack(1,r(pawn,white,pos(g,7)),r(king,black,pos(f,8))).
full_attack(1,r(pawn,white,pos(g,7)),r(king,black,pos(h,8))).
full_attack(1,r(pawn,white,pos(h,5)),r(king,black,pos(g,6))).