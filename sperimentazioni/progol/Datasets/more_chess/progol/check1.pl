:- set(c,3),set(i,1)?

:- modeh(1,check(+int,r(+piece,+colour,+pos),r(#piece,+colour,+pos)))?
:- modeb(1,attack_piece(+piece))?
:- modeb(1,board(+int,#piece,+colour,+pos))?
:- modeb(1,move2(+int,+piece,+colour,+pos,+pos))?
%:- modeb(1,colneq(+colour,+colour))?

board(1,king,white,pos(d,4)).
board(1,bishop,black,pos(b,2)).
board(1,knight,black,pos(c,6)).

board(1,king,black,pos(g,7)).
board(1,queen,white,pos(g,4)).
board(1,rook,white,pos(h,7)).
board(1,rook,black,pos(d,7)).
board(1,pawn,black,pos(c,5)).


check(1,r(bishop,black,pos(b,2)),r(king,white,pos(d,4))).
check(1,r(knight,black,pos(c,6)),r(king,white,pos(d,4))).
check(1,r(queen,white,pos(g,4)),r(king,black,pos(g,7))).
check(1,r(rook,white,pos(h,7)),r(king,black,pos(g,7))).

:- check(1,r(rook,black,pos(d,7)),r(king,black,pos(g,7))).
:- check(1,r(pawn,black,pos(c,5)),r(king,white,pos(d,4))).
:- check(1,r(queen,white,pos(g,8)),r(king,black,pos(g,7))).
:- check(1,r(bishop,black,pos(b,2)),r(king,white,pos(a,3))).