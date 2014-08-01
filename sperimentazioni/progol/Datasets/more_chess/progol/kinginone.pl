:- set(c,3),set(i,1)?



:- modeh(1,kinginone(+int,r(#piece,+colour,+pos),r(#piece,+colour,+pos)))?
:- modeb(1,board(+int,#piece,+colour,+pos))?
:- modeb(1,colneq(+colour,+colour))?
:- modeb(*,move0(#piece,+colour,+pos,+pos))?

board(1,king,white,pos(d,4)).

% positives

kinginone(1,r(king,black,pos(e,5)),r(king,white,pos(d,4))).
kinginone(1,r(king,black,pos(d,3)),r(king,white,pos(d,4))).
kinginone(1,r(king,black,pos(d,5)),r(king,white,pos(d,4))).
kinginone(1,r(king,black,pos(e,3)),r(king,white,pos(d,4))).
kinginone(1,r(king,black,pos(c,5)),r(king,white,pos(d,4))).


% negatives

:- kinginone(1,r(king,black,pos(b,2)),r(king,white,pos(b,3))).
:- kinginone(1,r(king,black,pos(c,2)),r(king,white,pos(d,4))).
:- kinginone(1,r(king,black,pos(h,7)),r(king,white,pos(d,4))).
:- kinginone(1,r(king,black,pos(b,6)),r(king,white,pos(d,4))).
:- kinginone(1,r(king,white,pos(c,4)),r(king,white,pos(d,4))).
