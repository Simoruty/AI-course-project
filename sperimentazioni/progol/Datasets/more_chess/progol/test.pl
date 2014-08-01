% some test boards for the reader to experiment with.



board(1,rook,white,pos(d,4)).
board(1,queen,black,pos(d,6)).
board(1,rook,white,pos(f,4)).
board(1,pawn,white,pos(a,2)).
board(1,queen,white,pos(d,2)).

board(2,pawn,white,pos(a,2)).
board(2,pawn,white,pos(b,2)).
board(2,pawn,white,pos(c,2)).
board(2,pawn,white,pos(b,2)).
board(2,pawn,white,pos(d,2)).
board(2,pawn,white,pos(e,2)).
board(2,pawn,white,pos(f,2)).
board(2,pawn,white,pos(g,2)).
board(2,pawn,white,pos(h,2)).
board(2,pawn,black,pos(a,7)).
board(2,pawn,black,pos(b,7)).
board(2,pawn,black,pos(c,7)).
board(2,pawn,black,pos(d,7)).
board(2,pawn,black,pos(e,7)).
board(2,pawn,black,pos(f,7)).
board(2,pawn,black,pos(g,7)).
board(2,pawn,black,pos(h,7)).
board(2,rook,black,pos(a,8)).
board(2,rook,black,pos(h,8)).
board(2,rook,white,pos(a,1)).
board(2,rook,white,pos(h,1)).
board(2,knight,white,pos(b,1)).
board(2,knight,white,pos(g,1)).
board(2,knight,black,pos(b,8)).
board(2,knight,black,pos(g,8)).
board(2,bishop,white,pos(c,1)).
board(2,bishop,white,pos(f,1)).
board(2,bishop,black,pos(c,8)).
board(2,bishop,black,pos(f,8)).
board(2,queen,white,pos(d,1)).
board(2,queen,black,pos(d,8)).
board(2,king,white,pos(e,1)).
board(2,king,black,pos(e,8)).
board(3,king,white,pos(d,4)).
board(3,rook,white,pos(e,4)).
board(3,queen,black,pos(h,4)).
board(3,rook,black,pos(g,4)).
board(3,king,black,pos(d,6)).
board(3,knight,black,pos(d,5)).
board(3,queen,white,pos(b,8)).
board(3,bishop,black,pos(c,7)).


% gives repeat answers for pin on the white rook.
board(4,king,white,pos(d,4)).
board(4,king,black,pos(c,6)).
board(4,queen,black,pos(d,1)).
board(4,bishop,black,pos(d,2)).
board(4,queen,white,pos(e,2)).
board(4,rook,black,pos(d,3)).

board(5,king,white,pos(d,4)).
board(5,bishop,black,pos(a,1)).
board(5,queen,white,pos(a,2)).
board(5,queen,black,pos(d,5)).


board(6,pawn,white,pos(d,4)).
board(6,pawn,black,pos(c,4)).
board(6,pawn,black,pos(c,5)).
board(6,king,white,pos(c,3)).
board(6,bishop,white,pos(d,3)).
board(6,bishop,black,pos(b,3)).
board(6,queen,white,pos(e,5)).

%board(7,rook,black,pos(a,5)).
board(7,queen,black,pos(e,1)).
board(7,bishop,black,pos(h,2)).
%board(7,knight,black,pos(d,7)).
board(7,pawn,black,pos(e,7)).
board(7,pawn,black,pos(g,5)).
%board(7,bishop,black,pos(g,7)).


board(7,king,white,pos(e,5)).
board(7,rook,white,pos(f,4)).
board(7,queen,white,pos(e,4)).
board(7,bishop,white,pos(d,3)).
board(7,pawn,white,pos(d,4)).
board(7,knight,white,pos(d,5)).

board(8,queen,white,pos(f,1)).
board(8,rook,white,pos(f,4)).
board(8,queen,black,pos(f,7)).
board(8,king,black,pos(f,8)).
