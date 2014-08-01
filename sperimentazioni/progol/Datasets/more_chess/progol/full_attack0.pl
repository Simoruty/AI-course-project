:- modeh(1,full_attack(+int,r(+piece,+colour,+pos),
	r(#piece,+colour,+pos)))?

:- modeb(1,attack_piece(+piece))?
:- modeb(1,move2k(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,colneq(+colour,+colour))?

board(1,king,white,pos(d,1)).
board(1,rook,white,pos(e,8)).
board(1,bishop,white,pos(c,3)).
board(1,queen,black,pos(d,8)).
board(1,pawn,black,pos(e,2)).
board(1,rook,black,pos(a,1)).
board(1,bishop,black,pos(b,4)).

full_attack(1,r(queen,black,pos(d,8)),r(king,white,pos(d,1))).
full_attack(1,r(queen,black,pos(d,8)),r(king,white,pos(d,2))).
full_attack(1,r(rook,black,pos(a,1)),r(king,white,pos(d,1))).
full_attack(1,r(rook,black,pos(a,1)),r(king,white,pos(e,1))).

:- full_attack(1,r(rook,white,pos(e,8)),r(king,white,pos(e,2))).
:- full_attack(1,r(pawn,black,pos(e,2)),r(king,white,pos(e,1))).
:- full_attack(1,r(queen,black,pos(d,8)),r(king,white,pos(e,1))).
:- full_attack(1,r(rook,black,pos(a,1)),r(king,white,pos(d,2))).
:- full_attack(1,r(bishop,black,pos(b,4)),r(king,white,pos(e,1))).
