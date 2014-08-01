
:- set(r,100000)?
:- set(h,100000)?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

generate_exs:-
	tell('examples.pl'),
	consult('background.pl'),
	gene(G),
	medium(M),
	generate_exs_b(G,M),
	fail.

generate_exs:- 
	told,
	write('Finished').

generate_exs_b(G,M):-
        decide_class(G,M),
	write('phenotypic_effect('),
	write(G),
	write(', '),
	write(M),
	write(').'),
	nl,
	!.

decide_class(G,M):-
	phenotypic_effect(G,M),
	!.

decide_class(_,_):-
	write(':- ').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% genes

gene(gene_a).
gene(gene_b).
gene(gene_c).
gene(gene_d).
gene(gene_e).
gene(gene_f).
gene(gene_g).
gene(gene_h).
gene(gene_i).
gene(gene_j).
gene(gene_k).
gene(gene_l).
gene(gene_m).

% growth media

medium([nut_1]).
medium([nut_2]).
medium([nut_3]).

medium([nut_1, nut_2]).
medium([nut_1, nut_3]).
medium([nut_2, nut_3]).

medium([nut_1, nut_2, nut_3]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

codes(gene_a, enzyme_a).
codes(gene_b, enzyme_b).
codes(gene_c, enzyme_c).
codes(gene_d, enzyme_d).
codes(gene_e, enzyme_e).
codes(gene_f, enzyme_f).
codes(gene_g, enzyme_g).
codes(gene_h, enzyme_h).
codes(gene_i, enzyme_i).
codes(gene_j, enzyme_j).
codes(gene_k, enzyme_k).
codes(gene_l, enzyme_l).
codes(gene_m, enzyme_m).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- generate_exs?
