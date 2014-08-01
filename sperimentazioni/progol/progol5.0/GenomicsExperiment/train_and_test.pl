
:- set(r,10)?
:- set(h,1000000)?
:- set(verbose,0)?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run_N_times(0,_):-
	listing(result/4),
	system(bell).

run_N_times(N, Training_exs_file):-
	consult(background),
	vary_no_of_codes_facts(N, Training_exs_file),
	N_dec is N - 1,
	run_N_times(N_dec, Training_exs_file).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vary_no_of_codes_facts(Run_no, Training_exs_file):-
	nl,
	write('==========================================='),
	nl,
	write('Starting run '),
	write(Run_no),
	nl,
 	no_of_codes_facts(No_of_codes_facts),
	do_testing(Run_no, No_of_codes_facts, Training_exs_file),
	fail.

vary_no_of_codes_facts(Run_no, _):-
	write('Finished run '),
	write(Run_no),
	nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

do_testing(Run_no, No_of_codes_facts, Training_exs_file):-
	nl,
	write(No_of_codes_facts),
	write(' codes/2 facts.'),
	nl,
	write('================'),
	nl,
	randomseed,
	permute('codes.pl'),
	see('codes.plO'),
	assert_first_N_lines(No_of_codes_facts),
	seen,
	nl,
	write('The codes/2 facts before training are'),
	nl,
	listing(codes/2),
	nl,
	write('Testing before training gives'),
	nl,
	write('============================='),
	nl,
	test(examples),
	test(examples, [[phenotypic_effect/2 ,Before_AP, Before_aP, Before_Ap, Before_ap]]),
	calc_acc(Before_AP, Before_aP, Before_Ap, Before_ap, Before_Acc),
	nl,
	write('Starting training on the example file: '),
	write(Training_exs_file),
	nl,
	nl,
	consult(Training_exs_file),
%%%	listing(phenotypic_effect/2),
%%%	listing(false),
	consult(learning),
	(generalise(phenotypic_effect/2) ; true),
	abolish_exs,
%%%	listing(phenotypic_effect/2),
%%%	listing(false),
	nl,
	write('The codes/2 facts AFTER training are'),
	nl,
	listing(codes/2),
	nl,
	write('Testing AFTER training gives'),
	nl,
	write('============================='),
	nl,
	test(examples),
	test(examples, [[phenotypic_effect/2 ,After_AP, After_aP, After_Ap, After_ap]]),
	calc_acc(After_AP, After_aP, After_Ap, After_ap, After_Acc),
	abolish(codes, 2),
	asserta(result(Run_no, No_of_codes_facts, Before_Acc, After_Acc)),
	!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

calc_acc(No_of_AP, No_of_aP, No_of_Ap, No_of_ap, Acc):-
	
	Acc is ( ( No_of_AP + No_of_ap ) / (No_of_AP + No_of_aP + No_of_Ap + No_of_ap) ) * 100.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assert_first_N_lines(0).

assert_first_N_lines(N):-
	N_dec is N - 1,
	read(X),
	asserta(X),
	assert_first_N_lines(N_dec).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

abolish(Predicate, Arity):-
        functor(Head, Predicate, Arity),
        clause(Head, Body, N),
        retract(Head,N),
        fail.

abolish(_,_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

abolish_exs:-
        clause(phenotypic_effect(G,M), true, N),
        retract(phenotypic_effect(G,M), N),
        fail.

abolish_exs:-
        clause(false, phenotypic_effect(G,M), N),
        retract(false, N),
        fail.

abolish_exs.

%%%
%%%abolish_facts(Predicate, Arity):-
%%%        functor(Head, Predicate, Arity),
%%%        clause(Head, true, N),
%%%        retract(Head,N),
%%%        fail.
%%%
%%%abolish_facts(_,_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% These values will correspond to the points on the x axis on the
% graph

no_of_codes_facts(13).
no_of_codes_facts(12).
no_of_codes_facts(10).
no_of_codes_facts(7).
no_of_codes_facts(4).
no_of_codes_facts(1).
no_of_codes_facts(0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% :- run_N_times(10, 'train_23_exs.pl')?
% :- run_N_times(10, 'train_45_exs.pl')?
:- run_N_times(10, 'train_68_exs.pl')?
% :- run_N_times(10, 'examples.pl')?
