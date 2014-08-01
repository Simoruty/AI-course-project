:- set(c,2), set(i,1)?
:- modeh(1,move0(#piece,+colour,pos(+file,+rank),pos(+file,+rank)))?
:- modeb(1,rdiff(+rank,+rank,-nat))?
:- modeb(1,fdiff(+file,+file,-nat))?
:- modeb(1,rdiff(+rank,+rank,#nat))?
:- modeb(1,fdiff(+file,+file,#nat))?

:- commutative(rdiff/3)?
:- commutative(fdiff/3)?

% Attempt to generate nice random examples.







% pos examples.


move0(knight,white,pos(b,2),pos(c,4)).
move0(knight,white,pos(b,2),pos(d,3)).
move0(knight,white,pos(c,4),pos(b,6)).
move0(knight,white,pos(c,4),pos(a,5)).
move0(knight,white,pos(f,1),pos(g,3)).
move0(knight,white,pos(f,1),pos(h,2)).



move0(bishop,white,pos(f,1),pos(c,4)).
move0(bishop,white,pos(c,4),pos(e,6)).
move0(bishop,white,pos(e,6),pos(a,2)).



move0(rook,white,pos(b,2),pos(e,2)).
move0(rook,white,pos(a,5),pos(h,5)).
move0(rook,white,pos(d,2),pos(d,5)).
move0(rook,white,pos(a,4),pos(a,5)).



move0(queen,white,pos(f,1),pos(c,4)).
move0(queen,white,pos(c,4),pos(e,6)).
move0(queen,white,pos(e,6),pos(a,2)).
move0(queen,white,pos(b,2),pos(e,2)).
move0(queen,white,pos(a,5),pos(h,5)).
move0(queen,white,pos(d,2),pos(d,5)).
move0(queen,white,pos(a,4),pos(a,5)).

move0(king,white,pos(a,4),pos(a,5)).
move0(king,white,pos(d,5),pos(d,6)).
move0(king,white,pos(b,5),pos(c,5)).
move0(king,white,pos(d,3),pos(e,3)).
move0(king,white,pos(d,4),pos(e,3)).
move0(king,white,pos(f,6),pos(g,7)).
move0(king,white,pos(b,2),pos(c,3)).

% negative examples.

:- move0(knight,white,pos(f,1),pos(g,4)).
:- move0(knight,white,pos(f,1),pos(c,2)).
:- move0(knight,white,pos(f,1),pos(h,3)).

:- move0(bishop,white,pos(f,1),pos(b,3)).

:- move0(rook,white,pos(f,1),pos(b,3)).

:- move0(queen,white,pos(f,1),pos(b,3)).
:- move0(queen,white,pos(f,1),pos(b,4)).
:- move0(queen,white,pos(e,1),pos(b,8)).

:- move0(king,white,pos(b,2),pos(d,3)).
:- move0(king,white,pos(b,2),pos(c,4)).
:- move0(king,white,pos(b,2),pos(b,4)).
:- move0(king,white,pos(b,2),pos(d,2)).