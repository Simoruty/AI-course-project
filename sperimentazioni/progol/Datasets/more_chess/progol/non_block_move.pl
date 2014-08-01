:- set(c,2),set(i,1)?
:- modeh(1,non_block_move(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,move_piece(+int,+piece,+colour,+pos,+pos))?
%:- modeb(*,check(+int,-piece,-colour,-pos,-piece,+colour,-pos))?
:- modeb(*,nott(check(+int,-r,-r)))?
%:- modeb(1,equal_direction(+pos,+pos,+pos))?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


board(2,king,black,pos(d,6)).
board(2,rook,white,pos(a,8)).
board(2,queen,black,pos(d,4)).
board(2,knight,white,pos(b,3)).

board(4,king,white,pos(b,2)).
board(4,rook,black,pos(h,2)).
board(4,knight,white,pos(h,4)).


% pos examples.


non_block_move(2,rook,white,pos(a,8),pos(c,8)).
non_block_move(2,rook,white,pos(a,8),pos(a,4)).
non_block_move(2,queen,black,pos(d,4),pos(f,6)).
non_block_move(2,knight,white,pos(b,3),pos(c,5)).




% neg examples


:- non_block_move(2,rook,white,pos(a,7),pos(a,1)).
:- non_block_move(2,knight,white,pos(b,3),pos(g,5)).
:- non_block_move(4,knight,white,pos(h,4),pos(f,3)).




