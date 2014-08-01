:- set(c,2), set(i,1)?
:- modeh(1,move0(#piece,#colour,pos(+file,+rank),pos(+file,+rank)))?
:- modeb(1,rdist(+rank,+rank,-int))?
:- modeb(1,fdist(+file,+file,-int))?
:- modeb(1,rdist(+rank,+rank,#int))?
:- modeb(1,fdist(+file,+file,#int))?
:- modeb(1,((+rank)=(#rank)))?
:- modeb(1,rne(+rank,#rank))?
:- modeb(1,fne(+file,#file))?
:- modeb(*,gt(+rank,#rank))?
:- modeb(*,lt(+int,#int))?




% pos examples.

move0(pawn,white,pos(a,2),pos(a,3)).
move0(pawn,white,pos(b,4),pos(b,5)).
move0(pawn,white,pos(f,6),pos(f,7)).
move0(pawn,white,pos(b,2),pos(b,4)).
move0(pawn,white,pos(g,2),pos(g,4)).
move0(pawn,white,pos(d,2),pos(d,4)).
move0(pawn,white,pos(a,2),pos(a,4)).

% now black examples

move0(pawn,black,pos(h,7),pos(h,6)).
move0(pawn,black,pos(g,5),pos(g,4)).
move0(pawn,black,pos(c,3),pos(c,2)).
move0(pawn,black,pos(g,7),pos(g,5)).
move0(pawn,black,pos(e,7),pos(e,5)).
move0(pawn,black,pos(h,7),pos(h,5)).



% negative examples.

:- move0(pawn,white,pos(f,2),pos(f,5)).
:- move0(pawn,white,pos(f,2),pos(f,1)).
:- move0(pawn,white,pos(g,4),pos(g,6)).
:- move0(pawn,white,pos(c,4),pos(d,4)).
:- move0(pawn,white,pos(c,1),pos(c,4)).
:- move0(pawn,white,pos(c,1),pos(c,2)).

:- move0(pawn,black,pos(c,7),pos(c,4)).
:- move0(pawn,black,pos(c,7),pos(c,8)).
:- move0(pawn,black,pos(b,5),pos(b,3)).
:- move0(pawn,black,pos(f,5),pos(e,5)).
:- move0(pawn,black,pos(f,8),pos(f,5)).
:- move0(pawn,black,pos(f,8),pos(f,7)).
:- move0(pawn,black,pos(f,8),pos(f,6)).
