:- set(c,4),set(i,1)?

:- modeh(1,move2k(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,attack_piece(+piece))?
:- modeb(1,move1(+int,+piece,+colour,+pos,+pos))?
:- modeb(*,nott(defend2(+int,r(+piece,+colour,+pos),r(-piece,+colour,+pos))))?
:- modeb(*,nott(xray2k(+int,r(+piece,+colour,+pos),-r,+pos)))?

prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= nott(xray2k(_,_,_,_)), A2=nott(xray2k(_,_,_,_)).
prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= nott(defend2(_,_,_)), A2=nott(defend2(_,_,_)).

board(1,rook,white,pos(d,4)).
board(1,queen,black,pos(d,6)).
board(1,rook,white,pos(f,4)).
board(1,pawn,white,pos(a,2)).
board(1,queen,white,pos(d,2)).

% pos examples.

move2k(1,rook,white,pos(d,4),pos(d,5)).
move2k(1,rook,white,pos(d,4),pos(e,4)).
move2k(1,rook,white,pos(d,4),pos(d,6)).
move2k(1,queen,black,pos(d,6),pos(d,4)).
move2k(1,queen,black,pos(d,6),pos(f,4)).
move2k(1,queen,white,pos(d,2),pos(b,2)).


% neg examples

:- move2k(1,pawn,white,pos(a,2),pos(a,3)).
:- move2k(1,rook,white,pos(d,4),pos(e,5)).
:- move2k(1,rook,white,pos(d,4),pos(d,7)).
:- move2k(1,rook,white,pos(d,4),pos(d,8)).
:- move2k(1,rook,white,pos(d,4),pos(f,4)).
:- move2k(1,rook,white,pos(f,4),pos(d,4)).
:- move2k(1,queen,white,pos(d,2),pos(d,4)).
:- move2k(1,queen,white,pos(d,2),pos(f,4)).
:- move2k(1,rook,white,pos(d,4),pos(d,2)).
:- move2k(1,queen,black,pos(d,6),pos(d,1)).
:- move2k(1,queen,black,pos(d,6),pos(g,3)).
