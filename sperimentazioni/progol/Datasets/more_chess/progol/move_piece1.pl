:- set(c,2),set(i,1)?

:- modeh(1,move_piece(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,move2(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,nott(double_check(+int,-r,
			          -r,
				  -r)))?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prune(Head,Body) :- atomof(A1,Body), atomof(A2,Body), not(A1==A2),
	A1= nott(double_check(_,_,_,_)), A2=nott(double_check(_,_,_,_)).

board(1,rook,white,pos(d,4)).
board(1,queen,black,pos(e,5)).
board(1,king,white,pos(a,4)).
board(1,king,black,pos(a,6)).

board(2,rook,white,pos(a,4)).
board(2,queen,white,pos(d,2)).
board(2,king,black,pos(d,4)).
board(2,queen,black,pos(e,7)).


% pos examples.

move_piece(1,rook,white,pos(d,4),pos(d,6)).
move_piece(1,queen,black,pos(e,5),pos(e,1)).
move_piece(1,queen,black,pos(e,5),pos(h,8)).

% neg examples.

:- move_piece(1,rook,white,pos(d,4),pos(e,6)).
:- move_piece(2,king,black,pos(d,4),pos(c,4)).
:- move_piece(2,queen,black,pos(e,7),pos(c,7)).
:- move_piece(2,queen,black,pos(e,7),pos(e,1)).