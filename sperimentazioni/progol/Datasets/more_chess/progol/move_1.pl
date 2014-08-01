:- set(c,3),set(i,1)?
:- modeh(1,move1(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,board(+int,+piece,+colour,+pos))?
:- modeb(1,move0(+piece,+colour,+pos,+pos))?
:- modeb(1,newsquare(+pos,+pos))?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

board(1,bishop,white,pos(d,4)).
board(1,rook,black,pos(e,3)).

% positive examples.

move1(1,bishop,white,pos(d,4),pos(b,6)).
move1(1,bishop,white,pos(d,4),pos(e,5)).
move1(1,bishop,white,pos(d,4),pos(f,2)).
move1(1,bishop,white,pos(d,4),pos(c,3)).
move1(1,bishop,white,pos(d,4),pos(a,7)).
move1(1,bishop,white,pos(d,4),pos(g,1)).

move1(1,rook,black,pos(e,3),pos(f,3)).
move1(1,rook,black,pos(e,3),pos(e,5)).

% negative examples.

:- move1(1,bishop,white,pos(a,1),pos(h,8)).
:- move1(1,bishop,white,pos(d,3),pos(b,5)).
:- move1(1,bishop,white,pos(d,4),pos(e,6)).
:- move1(1,bishop,white,pos(d,4),pos(d,4)).

:- move1(1,rook,black,pos(e,3),pos(e,3)).
:- move1(1,rook,black,pos(e,3),pos(d,4)).
:- move1(1,rook,black,pos(h,8),pos(h,1)).