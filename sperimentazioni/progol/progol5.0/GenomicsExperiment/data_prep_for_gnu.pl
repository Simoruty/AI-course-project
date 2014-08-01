
:- set(r,100000)?
:- set(h,100000)?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

generate_table(File_in, No_of_codes_facts_in_model, File_out):-
	tell(File_out),
	consult(File_in),
	header,
	rows(No_of_codes_facts_in_model),
	told.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

header:-
	nl,
	write('# N is the number of the orginal 13 codes/2 facts remaining'),
	nl,
	write('# prior to theory recovery.'),
	nl,
	nl,
	write_column('#  N',5),
	write_column('(100*N)/13', 15),
	write_column('Before',20),
	write_column('After',20),
	nl,
	write('#'),
	tab(19),
	write_column('Mu',10),
	write_column('Sg',10),
	write_column('Mu',10),
	write_column('Sg',10),
	nl,
	nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rows(No_of_codes_facts_in_model):-
	no_of_codes_facts(N),
	write_column(N,5),
	X is ( (100 * N) / No_of_codes_facts_in_model),
	write_column(X, 15),
	bagof(Acc_before, result(_, N, Acc_before, _), L_before),
	mean(L_before, Mu_before, Sigma_before),
	write_column(Mu_before,10),
	write_column(Sigma_before,10),
	bagof(Acc_after, result(_, N, _, Acc_after), L_after),
	mean(L_after, Mu_after, Sigma_after),
	write_column(Mu_after,10),
	write_column(Sigma_after,10),
	nl,
	fail.

rows(_).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

write_column(T, Width):-
        size(T, Size),
        Space is Width-Size,
        write(T), 
        tab(Space).

size([],2):-!.
size(List,Size) :-
        List = [_|_],
        !,
        length(List, L),
        Size is 2*L + 1.

size(T,Size) :-
        name(T,L),
        length(L,Size), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mean(List, Mu, Sigma):-
	length(List, L),
	sum_elements(List, Sum),
	Mu is Sum / L,
	sum_of_squares_of_distances_from_mean(List, Mu, Sum2),
	Sigma is ((Sum2 / (L - 1) ) ^ 0.5).

sum_elements([], 0).
sum_elements([H|T], Sum):-
	sum_elements(T, Sum_tail),
	Sum is H + Sum_tail.

sum_of_squares_of_distances_from_mean([], _, 0).
sum_of_squares_of_distances_from_mean([H|T], Mu, Sum):-
	sum_of_squares_of_distances_from_mean(T, Mu, Sum_tail),
	Sum is ( ( (H - Mu) *  (H - Mu) ) + Sum_tail ).

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

%%% :-generate_table('result_train_23_exs.pl', 13, 'result_train_23_exs.gp')?
%%% :-generate_table('result_train_45_exs.pl', 13, 'result_train_45_exs.gp')?
:-generate_table('result_train_68_exs.pl', 13, 'result_train_68_exs.gp')?
%%% :-generate_table('result_train_91_exs.pl', 13, 'result_train_91_exs.gp')?


