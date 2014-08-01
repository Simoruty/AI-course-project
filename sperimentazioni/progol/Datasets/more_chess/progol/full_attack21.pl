:- set(c,4),set(i,1)?

% First a couple of thimgs to note with full_attack...
% 1) fullattack pawn has been learned previously.
% 2) it is only needed for an attack on the king.
% 3) we have learned full_attack_piece when the king is not taking a
% 4) I am not sure what to do with this part...maybe it is satisfactory
% 5) to have repeat answers
% I have to split this up ...it is taking forever.


:- modeh(1,full_attack1(+int,r(+piece,+colour,+pos),
			    r(#piece,+colour,+pos)))?
:- modeb(1,attack_piece(+piece))?
:- modeb(1,colneq(+colour,+colour))?
:- modeb(1,nott(xray2k(+int,r(+piece,+colour,+pos),
			   -r,+pos)))?

prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= nott(xray2k(_,_,_,_)), A2=nott(xray2k(_,_,_,_)).

%%%%%%%%%%%%%%%%%%%%%%


board(2,king,white,pos(g,1)).
board(2,rook,black,pos(g,2)).
board(2,queen,black,pos(g,8)).
board(2,knight,black,pos(f,2)).
board(2,bishop,black,pos(e,3)).
board(2,queen,white,pos(h,2)).
board(2,bishop,black,pos(d,4)).
board(2,rook,black,pos(a,8)).

full_attack1(2,r(queen,black,pos(g,8)),r(king,white,pos(g,2))).
full_attack1(2,r(rook,black,pos(g,2)),r(king,white,pos(f,2))).
full_attack1(2,r(knight,black,pos(f,2)),r(king,white,pos(h,1))).
full_attack1(2,r(bishop,black,pos(e,3)),r(king,white,pos(f,2))).

% the first three of these are for xray.

:- full_attack1(2,r(bishop,black,pos(e,3)),r(king,white,pos(g,1))).
:- full_attack1(2,r(queen,black,pos(g,8)),r(king,white,pos(g,1))).
:- full_attack1(2,r(bishop,black,pos(d,4)),r(king,white,pos(f,2))).


board(3,king,black,pos(d,8)).
board(3,queen,black,pos(d,1)).
board(3,king,white,pos(h,2)).
board(3,pawn,black,pos(h,3)).

:- full_attack1(3,r(queen,black,pos(d,1)),r(king,black,pos(d,8))).
:- full_attack1(3,r(pawn,black,pos(h,3)),r(king,white,pos(h,2))).






