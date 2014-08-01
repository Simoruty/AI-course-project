:- set(h,100000000)?

:- commutative(col_equal)?

atomof(Atom,Atom) :- Atom=..[F|_], F\= ','.
atomof(Atom,(Atom,_)).
atomof(Atom,(_,Atoms)) :- atomof(Atom,Atoms).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Background knowledge.
%The idea with the background knowledge is to include as little
% as possible but to imagine a child who has for example already learned
% visual skills such as recognising colours, directions,squares and pieces.



piece(pawn). piece(knight). piece(bishop).
piece(rook). piece(queen). piece(king).

% We also give as background knowledge which pieces are long_range ...

long_range_piece(bishop).
long_range_piece(rook).
long_range_piece(queen).

attack_piece(knight).
attack_piece(X) :- long_range_piece(X).



all_pieces(pawn).
all_pieces(Piece) :- attack_piece(Piece).


rank(1). rank(2). rank(3). rank(4).
rank(5). rank(6). rank(7). rank(8).

file(a). file(b). file(c). file(d).
file(e). file(f). file(g). file(h).

project(a,1). project(b,2). project(c,3). project(d,4).
project(e,5). project(f,6). project(g,7). project(h,8).

colour(white). colour(black).

rdist(Rank1,Rank2,Dist) :- rank(Rank1),
                           rank(Rank2),
                           Dist is Rank2- Rank1.

fdist(File1,File2,Dist) :- file(File1),file(File2),
                           project(File1,Rank1),
                           project(File2,Rank2),
                           Dist is Rank2-Rank1.

rdiff(Rank1,Rank2,Diff) :- rank(Rank1),rank(Rank2),
                           Diff1 is Rank1-Rank2,
                           abs(Diff1,Diff).

fdiff(File1,File2,Diff) :- file(File1), file(File2),
                           project(File1,Rank1),project(File2,Rank2),
                           Diff1 is Rank1-Rank2,abs(Diff1,Diff).

abs(X,X) :- X>=0.
abs(X,Y) :- X<0, Y is -X.

gt(A,B) :- rank(A),rank(B),A>B.
lt(A,B) :- rank(A),rank(B),A<B.

rne(A,B) :- rank(A),rank(B),A\=B.
fne(A,B) :- file(A),file(B),A\=B.

colneq(A,B) :- colour(A),colour(B),not(col_equal(A,B)).
col_equal(A,A) :- colour(A).

samesquare(pos(A,B),pos(A,B)):- rank(B),file(A).
newsquare(pos(A,B),pos(C,D)) :- rank(B),rank(D),file(A),file(C),
                                not(samesquare(pos(A,B),pos(C,D))).


% We will put in some direction predicates.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

direction(pos(A,B),pos(A,C),north) :- rank(B),rank(C),file(A),B<C.
direction(pos(A,B),pos(A,C),south) :- rank(B),rank(C),file(A),B>C.
direction(pos(A,B),pos(C,B),east) :- rank(B),project(A,A1),project(C,C1),
                                     A1<C1.
direction(pos(A,B),pos(C,B),west) :- rank(B),project(A,A1),project(C,C1),
                                     A1>C1.
direction(pos(A,B),pos(C,D),northwest) :- rank(B),rank(D),
                                          B<D,
                                          project(A,A1),project(C,C1),A1>C1,
                                          Z1 is D-B,Z2 is A1-C1,Z1=Z2.
direction(pos(A,B),pos(C,D),southwest) :- rank(B),rank(D),
                                          B>D,
                                          project(A,A1),project(C,C1),A1>C1,
                                          Z1 is B-D,Z2 is A1-C1,
                                          Z1=Z2.
direction(pos(A,B),pos(C,D),northeast) :- rank(B),rank(D),
                                          B<D,
                                          project(A,A1),project(C,C1),A1<C1,
                                          Z1 is D-B,Z2 is C1-A1,
                                          Z1=Z2.
direction(pos(A,B),pos(C,D),southeast) :- rank(B),rank(D),
                                          B>D,
                                          project(A,A1),project(C,C1),A1<C1,
                                          Z1 is B-D,Z2 is C1-A1,
                                          Z1=Z2.


% These preicates are to simplify the mode declarations when learning.

pos(pos(F,R)) :- file(F),rank(R).
r(r(Piece,Colour,Pos)) :- piece(Piece),colour(Colour),pos(Pos).



%%%%%%%%%%%%%%
% from xray2.pl  we need to use nott...use the new def that steve gave.
% nott is necessary compared to prolog's own not definition as use of 
% not combined with a -declaration in the modeb will generate a non ground
% clause.



nott(G) :- G, !, fail.
nott(G) :- skol(G).

skol(G) :- skol([G],0,_).

skol([],N,N).
skol([var(N)|T],N,M) :- !,
	N1 is N+1,
	skol(T,N1,M).
skol([H|T],N,M) :-
	H=..[F|Args],
	skol(Args,N,N1),
	skol(T,N1,M).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
