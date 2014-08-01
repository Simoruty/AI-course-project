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

% Here move0 has been separated into two for learning.
% The result from move0pawn.


% time taken : 79.28 secs

move0(pawn,white,pos(A,B),pos(A,4)) :- rdist(B,4,2).
move0(pawn,black,pos(A,B),pos(A,5)) :- rdist(B,5,-2).
move0(pawn,white,pos(A,B),pos(A,C)) :- rdist(B,C,1), gt(B,1).
move0(pawn,black,pos(A,B),pos(A,C)) :- rdist(B,C,-1), lt(B,8).

% the result from move0_piece.

% time taken : 17.73 secs

move0(rook,A,pos(B,C),pos(B,D)).
move0(rook,A,pos(B,C),pos(D,C)).
move0(queen,A,pos(B,C),pos(B,D)).
move0(queen,A,pos(B,C),pos(D,C)).
move0(king,A,pos(B,C),pos(B,D)) :- rdiff(C,D,1).
move0(king,A,pos(B,C),pos(D,C)) :- fdiff(B,D,1).
move0(knight,A,pos(B,C),pos(D,E)) :- rdiff(C,E,1), fdiff(B,D,
        2).
move0(knight,A,pos(B,C),pos(D,E)) :- rdiff(C,E,2), fdiff(B,D,
        1).
move0(bishop,A,pos(B,C),pos(D,E)) :- rdiff(C,E,F), fdiff(B,D,
        F).
move0(queen,A,pos(B,C),pos(D,E)) :- rdiff(C,E,F), fdiff(B,D,F).
move0(king,A,pos(B,C),pos(D,E)) :- rdiff(C,E,1), fdiff(B,D,1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% from move_1.pl

% time taken : 2.66 secs

move1(A,B,C,D,E) :- board(A,B,C,D), move0(B,C,D,E), newsquare(D,E).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% from kinginone.pl

% time taken : 0.25 secs

kinginone(A,r(king,B,C),r(king,D,E)) :- board(A,king,D,E), colneq(B,
        D), move0(king,B,C,E).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% using equal_direction.pl we learn

% time taken : 0.86 secs

equal_direction(A,B,C) :- direction(A,B,D), direction(B,C,D).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% same_line.pl

% time taken : 0.43 secs.

same_line(A,B,C) :- equal_direction(A,B,C).
same_line(A,B,C) :- equal_direction(A,C,B).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fromland_on.pl

% time taken : 0.20 secs

land_on2(A,r(B,C,D),r(E,F,G)) :- board(A,E,F,G), move1(A,B,C,
        D,G).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from defend.pl

% time taken : 0.13 secs.

defend2(A,r(B,C,D),r(E,C,F)) :- land_on2(A,r(B,C,D),r(E,C,F)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Attack2 has been split up 4 times...

% from attack1.pl

% time taken : 6.14 secs

attack2(A,r(pawn,black,pos(B,C)),r(D,white,pos(E,F))) :- board(A,
        pawn,black,pos(B,C)), board(A,D,white,pos(E,F)), rdist(C,
        F,-1), fdiff(B,E,1).

% from attack2.pl

% time taken : 0.42secs.

attack2(A,r(B,C,D),r(E,F,G)) :- colneq(C,F), attack_piece(B),
        land_on2(A,r(B,C,D),r(E,F,G)).


% from attack3.pl

% time taken : 16.80 secs.

attack2(A,r(pawn,white,pos(B,C)),r(D,black,pos(E,F))) :- board(A,
        pawn,white,pos(B,C)), board(A,D,black,pos(E,F)), rdist(C,
        F,1), fdiff(B,E,1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from xray.pl

% time taken : 3.62 secs.

xray2(A,r(B,C,D),r(E,F,G),H) :- move1(A,B,C,D,H), land_on2(A,
        r(B,C,D),r(E,F,G)), equal_direction(D,G,H).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from move_23.pl

% use made of pruning...
% time taken : 78.52 secs
 
move2(A,B,C,D,E) :- attack_piece(B), move1(A,B,C,D,E), nott(defend2(A,
        r(B,C,D),r(F,C,E))), nott(xray2(A,r(B,C,D),G,E)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from move_21.pl

% use made of pruning ...
% time taken : 102.52

move2pawn(A,B,C,D,E) :- move1(A,B,C,D,E), nott(land_on2(A,r(B,
        C,D),r(F,G,E))), nott(xray2(A,r(B,C,D),r(H,I,J),E)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from move_22.pl

% time taken : 0.37 secs

move2(A,pawn,B,C,D) :- move2pawn(A,pawn,B,C,D).
move2(A,pawn,B,C,D) :- attack2(A,r(pawn,B,C),r(E,F,D)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

% from checknoboard.pl

% time taken : 8.12 secs

checknoboard(A,r(pawn,white,pos(B,C)),r(king,black,pos(D,E))) 
        :- fdiff(B,D,1), rdist(C,E,1).
checknoboard(A,r(pawn,black,pos(B,C)),r(king,white,pos(D,E))) 
        :- fdiff(B,D,1), rdist(C,E,-1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from full_attack4.pl 

% time taken : 0.15 secs.

full_attackpawn(A,r(pawn,B,C),r(king,D,E)) :- board(A,pawn,B,
        C), checknoboard(A,r(pawn,B,C),r(king,D,E)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% xray2k.pl gives...

% time taken : 1.54 secs.

xray2k(A,r(B,C,D),r(E,C,F),G) :- xray2(A,r(B,C,D),r(E,C,F),G).
xray2k(A,r(B,C,D),r(E,F,G),H) :- all_pieces(E), xray2(A,r(B,C,
        D),r(E,F,G),H).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from full_attack21.pl

% use made of pruning...
% time taken : 22.76 secs.


full_attack1(A,r(B,C,D),r(king,E,F)) :- attack_piece(B), colneq(C,
        E), nott(xray2k(A,r(B,C,D),G,F)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from full_attack31.pl

% use was made of pruning...
% time taken : 24.58 secs.


full_attack(A,r(B,C,D),r(king,E,F)) :- full_attackpawn(A,r(B,
        C,D),r(king,E,F)).
full_attack(A,r(B,C,D),r(king,E,F)) :- move1(A,B,C,D,F), board(A,
        G,C,F), full_attack1(A,r(B,C,D),r(king,E,F)).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% move2k.pl gives

% use was made of pruning ...
% time taken : 47.39 secs

move2k(A,B,C,D,E) :- attack_piece(B), move1(A,B,C,D,E), nott(defend2(A,
        r(B,C,D),r(F,C,E))), nott(xray2k(A,r(B,C,D),G,E)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% full_attack0.pl gives

% time taken : 2.47 secs.

full_attack(A,r(B,C,D),r(king,E,F)) :- move2k(A,B,C,D,F), colneq(C,
        E).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kingmove_with_block.pl gives...

% use was made of pruning...
% time taken : 3.72 secs.


kingmove_with_block(A,king,B,C,D) :- move1(A,king,B,C,D), nott(defend2(A,
        r(king,B,C),r(E,B,D))), nott(kinginone(A,r(king,B,D),
        r(king,F,G))).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kingmove.pl gives

% use was made of pruning...
% time taken : 0.93 secs.


kingmove(A,B,C,D,E) :- kingmove_with_block(A,B,C,D,E), nott(full_attack(A,
        r(F,G,H),r(B,C,E))).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Piece movements here...

% time taken : 0.17 secs

% checkpawn.pl 

check(A,r(pawn,B,C),r(king,D,E)) :- board(A,king,D,E), full_attackpawn(A,
        r(pawn,B,C),r(king,D,E)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from check1.pl note that check pawn is attached to this...

% time taken : 0.56 secs

check(A,r(B,C,D),r(king,E,F)) :- board(A,king,E,F), attack_piece(B),
        move2(A,B,C,D,F).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% double_check.pl

% time taken : 15.49 secs.

double_check(A,r(B,C,D),r(E,C,F),r(king,G,H)) :- check(A,r(B,
        C,D),r(king,G,H)), check(A,r(E,C,F),r(king,G,H)), newsquare(D,
        F).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from move_piece1.pl 

% use was made of pruning...
% time taken : 1,20 secs.

move_piece(A,B,C,D,E) :- move2(A,B,C,D,E), nott(double_check(A,
        F,G,H)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% block_check_move1.pl


% time taken : 6.69  secs.


block_check_move(A,B,C,D,E) :- check(A,r(F,G,E),r(H,C,I)), move_piece(A,
        B,C,D,E).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% block_check_move2.pl

% time taken : 16.07 secs

block_check_move(A,B,C,D,E) :- move_piece(A,B,C,D,E), check(A,
        r(F,G,H),r(I,C,J)), equal_direction(J,E,H).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% non_block_move.pl

% time taken : 1.11 secs


non_block_move(A,B,C,D,E) :- move_piece(A,B,C,D,E), nott(check(A,
        F,G)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% move_piece_check.pl

% time taken : 4.10 secs

move_piece_check(A,B,C,D,E) :- block_check_move(A,B,C,D,E).
move_piece_check(A,B,C,D,E) :- non_block_move(A,B,C,D,E).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% blocked_from_king.pl

% pruning was used ...

% time taken : 247.11


blocked_from_king(A,r(B,C,D),r(king,E,F)) :- board(A,king,E,F),
        move1(A,B,C,D,F), colneq(C,E), nott(move2(A,B,C,D,F)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pin_blocker.pl

% time taken : 48.47 secs

pin_blocker(A,r(B,C,D),r(E,F,G),r(king,H,I)) :- blocked_from_king(A,
        r(B,C,D),r(king,H,I)), long_range_piece(B), board(A,E,
        F,G), equal_direction(D,G,I).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% from pseudo_pin.pl note we don't need the colneq part...in blocked from
% king.

% time taken : 3.30 secs.

pseudo_pin(A,r(B,C,D),r(E,F,G),r(king,F,H)) :- pin_blocker(A,
        r(B,C,D),r(E,F,G),r(king,F,H)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% from two_blockers.pl

% using pruning...
% time taken...3280.18 secs

two_blockers(A,r(B,C,D),r(E,F,G),r(H,I,J),r(king,I,K)) :- pseudo_pin(A,
        r(B,C,D),r(H,I,J),r(king,I,K)), board(A,E,F,G), equal_direction(D,
        G,J).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% from pin1.pl 

% usimg pruning...
% time taken...12.80 seconds



pin(A,B,C,D) :- pseudo_pin(A,B,C,D), nott(two_blockers(A,B,E,
        F,D)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% pinning_piece_move0.pl gives...

% time taken ...274.15 secs

pinning_piece_move(A,B,C,D,E) :- pin(A,r(F,G,H),r(B,C,D),r(I,
        C,J)), move_piece_check(A,B,C,D,E), same_line(J,D,E).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% from move_piece_with_pin.pl

% time taken : 2.74 secs.
 
move_piece_with_pin(A,B,C,D,E) :- pinning_piece_move(A,B,C,D,
        E).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from move_piece_with_pin1.pl

% time taken : 3.75 secs.

move_piece_with_pin(A,B,C,D,E) :- move_piece_check(A,B,C,D,E),
        nott(pin(A,F,r(B,C,D),G)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% finally from move.pl 

% time taken : 3.59 secs.

move(A,B,C,D,E) :- move_piece_with_pin(A,B,C,D,E).
move(A,B,C,D,E) :- kingmove(A,B,C,D,E), nott(check(A,r(F,C,G),
        H)).


