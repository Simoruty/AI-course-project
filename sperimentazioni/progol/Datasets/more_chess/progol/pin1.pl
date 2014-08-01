:- set(c,2),set(i,1)?

:- modeh(1,pin(+int,+r,
		    +r,
		    +r))?
:- modeb(1,pseudo_pin(+int,+r,
			   +r,
			   +r))?
:- modeb(1,nott(two_blockers(+int,+r,
				  -r,
				  -r,
				  +r)))?




prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= pseudo_pin(_,_,_,_), A2=pseudo_pin(_,_,_,_).

prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= nott(two_blockers(_,_,_,_,_)), A2=nott(two_blockers(_,_,_,_,_)).
%%%%%%%%%%%%%%%%%%%%%%%

board(1,king,white,pos(d,1)).
board(1,queen,white,pos(d,2)).
board(1,queen,black,pos(d,8)).
board(1,rook,black,pos(a,1)).
board(1,knight,white,pos(c,1)).
board(1,bishop,black,pos(a,4)).
board(1,rook,white,pos(c,2)).

pin(1,r(queen,black,pos(d,8)),r(queen,white,pos(d,2)),r(king,white,pos(d,1))).
pin(1,r(rook,black,pos(a,1)),r(knight,white,pos(c,1)),r(king,white,pos(d,1))).
pin(1,r(bishop,black,pos(a,4)),r(rook,white,pos(c,2)),r(king,white,pos(d,1))).

% This clause stopped us learning nott two blockers ...now 
% now do we learn pseudo pin ??

:- pin(1,r(queen,black,pos(d,8)),r(rook,white,pos(c,2)),r(king,white,pos(d,1))).

% This much gives what we want with pseudo_pin ...now the most
% specific clause is enourmous so how do we include not two blockers??

board(2,king,white,pos(e,1)).
board(2,rook,black,pos(a,1)).
board(2,queen,white,pos(b,1)).
board(2,knight,white,pos(d,1)).
board(2,queen,black,pos(c,1)).

pin(2,r(queen,black,pos(c,1)),r(knight,white,pos(d,1)),r(king,white,pos(e,1))).

:- pin(2,r(rook,black,pos(a,1)),r(knight,white,pos(d,1)),r(king,white,pos(e,1))).

board(3,king,black,pos(e,8)).
board(3,rook,white,pos(h,8)).
board(3,knight,black,pos(f,8)).
board(3,queen,white,pos(a,8)).
board(3,bishop,black,pos(b,8)).
board(3,rook,white,pos(c,8)).
board(3,knight,black,pos(d,8)).

board(3,bishop,white,pos(c,6)).
board(3,rook,black,pos(d,7)).

pin(3,r(rook,white,pos(h,8)),r(knight,black,pos(f,8)),r(king,black,pos(e,8))).
pin(3,r(bishop,white,pos(c,6)),r(rook,black,pos(d,7)),r(king,black,pos(e,8))).
pin(3,r(rook,white,pos(c,8)),r(knight,black,pos(d,8)),r(king,black,pos(e,8))).

:- pin(3,r(queen,white,pos(a,8)),r(knight,black,pos(d,8)),r(king,black,pos(e,8))).