
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% general case

phenotypic_effect(G, Medium):- 
	nutrient_in(Nutrient, Medium),
	metabolic_path(Nutrient, Mi),
	enzyme(E, Mi, Mj),
	codes(G,E),
	metabolic_path(Mj, Mn),
	essential_molecule(Mn),
	not(path_without_enzyme(Medium, Mn, E)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nutrient_in(Nutrient, Medium):-
	element(Nutrient, Medium).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

metabolic_path(A, A).

metabolic_path(A, B):-
	enzyme(_, A, B).

metabolic_path(A, B):-
	enzyme(_, A, X),
	metabolic_path(X, B).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path_without_enzyme(Medium, Mn, E):-
	nutrient_in(Nutrient, Medium),
	path_without_enzyme(Nutrient, Mn, E).

path_without_enzyme(A, A, _).

path_without_enzyme(A, B, E):-
	enzyme(E2, A, B),
	not(E = E2).

path_without_enzyme(A, B, E):-
	enzyme(E2, A, X),
	not(E = E2),
	path_without_enzyme(X, B, E).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

essential_molecule(ess_mol_1).
essential_molecule(ess_mol_2).
essential_molecule(ess_mol_3).
essential_molecule(ess_mol_4).

enzyme(enzyme_a, nut_1, metabolite_1).
enzyme(enzyme_b, nut_2, metabolite_2).
enzyme(enzyme_c, nut_3, metabolite_3).

enzyme(enzyme_d, metabolite_1, metabolite_4).
enzyme(enzyme_e, metabolite_1, metabolite_5).
enzyme(enzyme_f, metabolite_1, metabolite_6).
enzyme(enzyme_g, metabolite_2, metabolite_6).
enzyme(enzyme_l, metabolite_6, metabolite_7).

enzyme(enzyme_h, metabolite_2, ess_mol_4).
enzyme(enzyme_i, metabolite_3, ess_mol_4).
enzyme(enzyme_j, metabolite_4, ess_mol_1).
enzyme(enzyme_k, metabolite_5, ess_mol_2).
enzyme(enzyme_m, metabolite_7, ess_mol_3).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
