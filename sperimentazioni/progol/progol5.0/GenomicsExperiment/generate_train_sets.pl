
:- set(r,10000)?
:- set(h,10000)?

generate_train_sets:-
	number_of_examples(No_of_examples),
	name('train_', L1),
	name(No_of_examples, L2),
	append(L1, L2, L3),
	name('_exs.pl', L4),
	append(L3, L4, L5),
	name(Filename, L5),
	tell(Filename),
	randomseed,
	permute('examples.pl'),
	system(surround_exs_with_quotes),
	see('examples_quoted.pl'),
	write_first_N_lines(No_of_examples),
	seen,
	told,
	fail.

generate_train_sets:-
	write('Finished.').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

write_first_N_lines(0):- !.

write_first_N_lines(N):-
	N_dec is N - 1,
	read(X),
	write(X),
	write('.'),
	nl,
	write_first_N_lines(N_dec).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

append([],L,L).
append([H|T],L,[H|Z]) :- append(T,L,Z).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

number_of_examples(23).
number_of_examples(45).
number_of_examples(68).
%%%% number_of_examples(91).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- generate_train_sets?
