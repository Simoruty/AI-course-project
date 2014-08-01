The datasets below were used for one part of a Masters thesis (John
Goodacre, The Inductive Learning of Chess Rules Using Progol, 1996).
involving the use of Progol to learn a chess move generator. The
general method used was to write a prototype move generator and use
this as a design document to guide my hand when defining mode
declarations and choosing examples for Progol to learn from.
	The generator was learned using two methods, one using trainer
selected examples and the second using stratified random sampling. The
datasets below show the first part of the project where the generator
was learned in a structured manner using trainer selected examples.

	The input to the move generator would be expected to be a legal
board position and the output using move/5 would be all the legal
moves available in that position. The form of the inputs would be
expected to be of the form of a series of ground clauses using the
predicate board/4 e.g. board(1,king,white,pos(d,4)). This would say
that on board 1 there is a white king at square d,4. The number one is
needed because it is impossible to learn such predicates as
double_check using my design without using multiple boards at once. It
has to be said that error conditions are not included in the learned
program so that should an illegal board position be entered then the
behaviour of the learned program would have to be given as undefined.
	Test boards are to be found in the file test.pl.

	It should be mentioned that there is no form of board update
nor do we cater for castling or the en-passant rule. These would of
course require some history of the game up to that point which is
rather more than the information that board/4 could ever give.

	The method of structured learning involves using background
knowledge to learn various clauses and then including the clauses
learned within the existing background knowledge for the learning of
subsequent clauses. 

	The background knowledge needed for learning is contained within
background.pl, and attempted to use the sort of pattern information
that could be gained just by a glance at a chess board (i.e. squares,
colours, pieces, distances and directions). The more alert reader may
notice a redefintion of negation nott/1 which uses skolemisation. This
was necessary due to my wishing to combine -type modeb declarations
with not/1. If I used not rather than nott then Progol would create
non-ground clauses during its learning process and the predicates
could not be learned.

	It should also be mentioned that it was not possible to use
constructive negation in this project (see the thesis for an
explantion as to why). What this means in practice is that the order
of literals in the body of clauses learned is extremely important.
When building the generator the reader should always read in the .pl
file containing the mode declarations first and then the background.
For example on entering Progol one would write
[move0pawn.pl,background.pl]? and not [background.pl,move0pawn.pl]?.
The reader may see the finished product in whatitlearned.pl.

The order in which predicates should be learned is as follows...

move0pawn.pl           
move0_piece.pl
move_1.pl
kinginone.pl
equal_direction.pl
same_line.pl
land_on.pl
defend.pl
attack1.pl
attack2.pl
attack3.pl
xray.pl
move_23.pl
move_21.pl
move_22.pl
checknoboard.pl
full_attack4.pl
xray2k.pl
full_attack21.pl
full_attack31.pl
move2k.pl
full_attack0.pl
kingmove_with_block.pl
kingmove.pl
checkpawn.pl
check1.pl
double_check.pl
move_piece1.pl
block_check_move1.pl
block_check_move2.pl
non_block_move.pl
move_piece_check.pl
blocked_from_king.pl
pin_blocker.pl
pseudo_pin.pl
two_blockers.pl
pin1.pl
pinning_piece_move0.pl
move_piece_with_pin.pl
move_piece_with_pin1.pl
move.pl

Each of the above files contain mode declarations a few trainer
selected examples and some simple trainer selected board positions.

Now in some cases the different .pl files learn different aspects of
the same predicate (this was done in some cases to simplify the
clauses for learning purposes. Of course it is not entirely
satisfactory and the perfect solution would  have a separate
clause to be learned with each .pl file).


The reason that we have to be careful with the above using structured
learning is that we must hide these shared predicates from one another
when learning.
	 For example if we were to learn move0/4 we would first
learn from background knowledge and move0pawn.pl...whatever is then
learned could be copied in to the background file but would have to be
commented out (using % at the beginning of each line) while we use the
background and move0_piece.pl to learn the other part of move0/4. 
	Otherwise we would have clauses defining some of move0/4
while we are learning the other parts of move0/4 which is entirely
unsatisfactory. After we have learned using both move0pawn.pl and
move0_piece.pl we then include the full definitions of move0/4 into
our background knowledge for learning the next stage (in this case move1/5).

The .pl files which learn the same predicate are as follows...

move0pawn.pl and move0_piece.pl learn move0/4.
attack1.pl ,attack2.pl, attack3.pl learn attack2/3.
move_23.pl, move_22.pl, learn move2/5 (note not move23.pl).
full_attack31.pl and full_attack0.pl learn full_attack/3.
checkpawn.pl and check1.pl learn check/3.
block_check_move.pl and block_check_move1.pl learn block_check_move/5.
move_piece_with_pin.pl and move_piece_with_pin1.pl learn
move_piece_with_pin/5.

I have two suggestions for those who wish to build the move generator.

The first is to use background.pl and then go through each of the .pl
files mentioned above each time adding what is learned to
background.pl (of course remembering to hide shared predicates and
also when they are learned to uncomment them !!). The final product
will be a full chess move generator which will look like my
whatitlearned.pl file.

The other way is to actually use whatitlearned.pl as background
knowledge and comment out the clauses defining the predicate we wish
to learn.

For example we could use whatitlearned.pl combined with move0pawn.pl
for learning move0/4 as long as we remember to comment out all
occurrences of move0/4 in whatitlearned.pl.

Unfortunately the english explanation showing how to build the
generator sounds much more comlicated than it really is. If there are
any problems then compare the clauses you have learned with the
finished product which is as I said in whatitlearned.pl. 

A final point should note that use is made of pruning in some cases to
speed the learning process. To use pruning the reader will need Progol
version 4.3.


