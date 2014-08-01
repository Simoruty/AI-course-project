:- set(h,1000000)?

:- modeh(1,codes(#gene,#enzyme))?

:- observable(phenotypic_effect/2)?

% Types

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

enzyme(enzyme_a).
enzyme(enzyme_b).
enzyme(enzyme_c).
enzyme(enzyme_d).
enzyme(enzyme_e).
enzyme(enzyme_f).
enzyme(enzyme_g).
enzyme(enzyme_h).
enzyme(enzyme_i).
enzyme(enzyme_k).
enzyme(enzyme_l).
enzyme(enzyme_m).

% Constraints

% codes(gene, enzyme) is a one-to-one mapping. Thus a gene can appear
% in only one codes/2 fact. Similarly, an enzyme can appear in only
% one codes/2 fact.

:- codes(Gene, Enzyme1), 
   codes(Gene, Enzyme2), 
   not (Enzyme1 = Enzyme2).

:- codes(Gene1, Enzyme), 
   codes(Gene2, Enzyme), 
   not (Gene1 = Gene2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


