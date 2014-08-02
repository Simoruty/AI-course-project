%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                                                                         %
% P - P R O G O L                                                         %
% Version 2.7.5 (last modified: Thu Jul  1 09:57:44 BST 1999)             %
%                                                                         %
% This is the source for P-Progol written and maintained                  %
% by Ashwin Srinivasan at Oxford (ashwin@comlab.ox.ac.uk)                 %
%                                                                         % 
% It runs under the Yap Prolog system (version 4.1.15 and above).         %
% Yap can be found at: http://www.ncc.up.pt/~vsc/Yap/                     %
% Yap must be compiled with -DDEPTH_LIMIT=1                               %
%                                                                         %
% If you obtain this version of P-Progol, then please                     %
% inform Ashwin Srinivasan by email.                                      %
%                                                                         %
% P-Progol is freely available for academic purposes.                     %
% If you intend to use it for commercial purposes then                    %
% please contact Ashwin Srinivasan first.                                 %
%                                                                         %
% A simple on-line manual is available on the Web at                      %
% www.comlab.ox.ac.uk/oucl/research/areas/machlearn/PProgol/ppman_toc.html%
%                                                                         %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- source.
:- system_predicate(false,false), hide(false).

progol_version('2.7.5').
progol_manual('http://www.comlab.ox.ac.uk/oucl/groups/machlearn/PProgol/ppman_toc.html').

:-
	nl, nl,
	print('P - P R O G O L'), nl,
	progol_version(Version), print('Version '), print(Version), nl,
	progol_manual(Man),
	print('On-line manual at: '),
	print(Man), nl.

:- op(500,fy,#).
:- op(500,fy,*).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C O N S T R U C T

% layered generation of atoms to add to clause body
get_atoms([],_,_,Last,Last):- !.
get_atoms(Preds,Depth,MaxDepth,Last,LastLit):-
	Depth =< MaxDepth,
	Depth0 is Depth - 1,
	recorded(terms,terms(_,Depth0,_,_),_),	% new terms generated ?
	add_types(Depth0),		% add types to new terms
	!,
	get_atoms1(Preds,Depth,MaxDepth,Last,Last1),
	Depth1 is Depth + 1,
	get_atoms(Preds,Depth1,MaxDepth,Last1,LastLit).
get_atoms(_,_,_,Last,Last).

get_atoms1([],_,_,Last,Last).
get_atoms1([PSym/NSucc/I/O/C|Preds],Depth,MaxDepth,Last,LastLit):-
	gen_layer(PSym/NSucc/I/O/C,Depth),
	flatten(Depth,MaxDepth,I/O/C,Last,Last1),
	get_atoms1(Preds,Depth,MaxDepth,Last1,LastLit).

flatten(Depth,MaxDepth,In/Out/Const,Last,_):-
	retractall(progol_dyn,flatten_num(_)),
	recorda(progol_dyn,flatten_num(Last),_),
	get_next_atom(Lit1),
	recorded(progol_dyn,flatten_num(LastSoFar),DbRef1),
	(Lit1 = not(Lit) -> Negated = true; Lit = Lit1, Negated = false),
	functor(Lit,Name,Arity),
	flatten_atom(Name/Arity,Depth,MaxDepth,Lit,Negated,In,Out,Const,LastSoFar,Last1),
	erase(DbRef1),
	recorda(progol_dyn,flatten_num(Last1),_),
	fail.
flatten(_,_,_,_,Last):-
	recorded(progol_dyn,flatten_num(Last),DbRef2),
	erase(DbRef2), !.

get_next_atom(Lit1):-
	recorded(atoms,Lit1,DbRef), 
	erase(DbRef).

flatten_atom('='/2,Depth,_,Lit,Negated,In,Out,Const,Last,Last1):-
	!,
	integrate_args(Depth,Lit,Out,_),	% recursively unwrap terms in o/p
	integrate_args(Depth,Lit,Const),
	flatten_eq(Lit,Negated,In,Out,Const,Last,Last1).
flatten_atom(Name/Arity,Depth,Depth1,Lit,Negated,In,Out,Const,Last,Last1):-
	!,
	integrate_args(Depth,Lit,Out),
	integrate_args(Depth,Lit,Const),
	(Depth = Depth1 -> CheckOArgs = true; CheckOArgs = false),
	flatten_lits(Name/Arity,Lit,CheckOArgs,Depth,Lit,Negated,In,Out,Const,Last,Last1).

flatten_eq(Lit,Negated,In,[],Const,Last,LitNum):-
	!,
	functor(FAtom,'=',2),
	flatten_lit(Lit,2,In,[],Const,FAtom,IList,_),
	sort(IList,IVars),
	add_lit(Last,Negated,FAtom,In,[],IVars,[],LitNum).
flatten_eq(Lit,Negated,In,Out,[],Last,Last1):-
	get_argterms(Lit,Out,[],OTerm),
	get_eqs(OTerm,Negated,In,Out,Last,Last1).

% get a list of equalities for output terms produced by a literal
% also update dependency graph for the equalities
get_eqs([],_,_,_,Last,Last).
get_eqs([Term|Terms],Neg,In,Out,Last,LastLit):-
	Term =.. [Name|Args],
	(Args = [] -> get_eqs(Terms,Neg,In,Out,Last,LastLit);
			flatten_terms(Args,NewArgs),
			recorded(terms,terms(TNo,_,Term,_),_),
			recorded(vars,vars(VarNum,TNo,_,_),_),
			FlatTerm =.. [Name|NewArgs],
			add_lit(Last,Neg,(VarNum=FlatTerm),In,Out,[VarNum],NewArgs,LitNum)),
	get_eqs(Terms,Neg,In,Out,LitNum,LastLit).

flatten_terms([],[]).
flatten_terms([Term|Terms],[Var|Vars]):-
	recorded(terms,terms(TNo,_,Term,_),_),
	recorded(vars,vars(Var,TNo,_,_),_),
	flatten_terms(Terms,Vars).

% flatten literals by replacing terms with variables
% if variable splitting is on then new equalities are introduced into bottom clause
% if at final i-layer, then literals with o/p args that do not contain at least
% 	one output var from head are discarded
flatten_lits(Name/Arity,Lit,CheckOArgs,Depth,Lit,Negated,In,Out,Const,Last,Last1):-
	recorda(progol_dyn,flatten_lits(Last),_),
	Depth1 is Depth - 1,
	functor(OldFAtom,Name,Arity),
	functor(FAtom,Name,Arity),
	flatten_lit(Lit,Arity,In,Out,Const,OldFAtom,_,_),
	apply_equivs(Depth1,Arity,In,Out,OldFAtom,FAtom),
	recorded(progol_dyn,flatten_lits(OldLast),DbRef),
	(CheckOArgs = true -> 
		get_vars(FAtom,Out,OVars),
		(in_path(OVars) ->
			add_new_lit(Depth,FAtom,In,Out,Const,OldLast,Negated,NewLast);
			NewLast = OldLast) ;
		add_new_lit(Depth,FAtom,In,Out,Const,OldLast,Negated,NewLast)),
	erase(DbRef),
	recorda(progol_dyn,flatten_lits(NewLast),_),
	fail.
flatten_lits(_,_,_,_,_,_,_,_,_,_,Last1):-
	recorded(progol_dyn,flatten_lits(Last1),DbRef),
	erase(DbRef).


% return a flattened literal with variable numbers replacing
% ground terms with variables
% variable numbers arising from variable splits are not allowed
flatten_lit(_,0,_,_,_,_,[],[]):-  !.
flatten_lit(Lit,ArgNo,In,Out,Const,FAtom,IVars,OVars):-
	member1(ArgNo/_,Const), !,
	arg(ArgNo,Lit,Term),
	arg(ArgNo,FAtom,progol_const(Term)),
	NextArg is ArgNo - 1,
	flatten_lit(Lit,NextArg,In,Out,Const,FAtom,IVars,OVars).
flatten_lit(Lit,ArgNo,In,Out,Const,FAtom,[Var|IVars],OVars):-
	member1(ArgNo/Type,In), !,
	arg(ArgNo,Lit,Term),
	recorded(terms,terms(TNo,_,Term,Type),_),
	recorded(vars,vars(Var,TNo,_,_),_),
	not(recorded(vars,copy(Var,_,_),_)),
	arg(ArgNo,FAtom,Var),
	NextArg is ArgNo - 1,
	flatten_lit(Lit,NextArg,In,Out,Const,FAtom,IVars,OVars).
flatten_lit(Lit,ArgNo,In,Out,Const,FAtom,IVars,[Var|OVars]):-
	member1(ArgNo/Type,Out), !,
	arg(ArgNo,Lit,Term),
	recorded(terms,terms(TNo,_,Term,Type),_),
	recorded(vars,vars(Var,TNo,_,_),_),
	not(recorded(vars,copy(Var,_,_),_)),
	arg(ArgNo,FAtom,Var),
	NextArg is ArgNo - 1,
	flatten_lit(Lit,NextArg,In,Out,Const,FAtom,IVars,OVars).
	

% check to avoid generating useless literals in the last i layer
in_path(OVars):-
	recorded(sat,head_ovars(Vars),_), !,
	(Vars=[];OVars=[];intersects(Vars,OVars)).
in_path(_).

% update variable equivalences created at a particular i-depth
% is non-empty only if variable splitting is allowed

update_equivs([],_):- !.
update_equivs(Equivs,Depth):-
	recorded(vars,equivs(Depth,Eq1),DbRef), !,
	erase(DbRef),
	update_equiv_lists(Equivs,Eq1,Eq2),
	recorda(vars,equivs(Depth,Eq2),_).
update_equivs(Equivs,Depth):-
	Depth1 is Depth - 1,
	get_equivs(Depth1,Eq1),
	update_equiv_lists(Equivs,Eq1,Eq2),
	recorda(vars,equivs(Depth,Eq2),_).

update_equiv_lists([],E,E):- !.
update_equiv_lists([Var/E1|Equivs],ESoFar,E):-
	delete(Var/E2,ESoFar,ELeft), !,
	update_list(E1,E2,E3),
	update_equiv_lists(Equivs,[Var/E3|ELeft],E).
update_equiv_lists([Equiv|Equivs],ESoFar,E):-
	update_equiv_lists(Equivs,[Equiv|ESoFar],E).

% get variable equivalences at a particular depth
% recursively descend to greatest depth below this for which equivs exist
% also returns the database reference of entry
get_equivs(Depth,[]):-
	Depth < 0, !.
get_equivs(Depth,Equivs):-
	recorded(vars,equivs(Depth,Equivs),_), !.
get_equivs(Depth,E):-
	Depth1 is Depth - 1,
	get_equivs(Depth1,E).

% apply equivalences inherited from Depth to a flattened literal
% if no variable splitting, then succeeds only once
apply_equivs(Depth,Arity,In,Out,Old,New):-
	get_equivs(Depth,Equivs),
	rename(Arity,Equivs,[],Old,New).

% rename args using list of Var/Equivalences
rename(_,[],_,L,L):- !.
rename(0,_,_,_,_):- !.
rename(Pos,Equivs,Subst0,Old,New):-
        arg(Pos,Old,OldVar),
        member(OldVar/Equiv,Equivs), !,
        member(NewVar,Equiv),
        arg(Pos,New,NewVar),
        Pos1 is Pos - 1,
        rename(Pos1,Equivs,[OldVar/NewVar|Subst0],Old,New).
rename(Pos,Equivs,Subst0,Old,New):-
        arg(Pos,Old,OldVar),
        (member(OldVar/NewVar,Subst0) ->
                arg(Pos,New,NewVar);
                arg(Pos,New,OldVar)),
        Pos1 is Pos - 1,
        rename(Pos1,Equivs,Subst0,Old,New).


% add a new literal to lits database
% performs variable splitting if splitvars is set to true
add_new_lit(Depth,FAtom,In,Out,Const,OldLast,Negated,NewLast):-
        split_vars(Depth,FAtom,In,Out,Const,SplitAtom,IVars,OVars,Equivs),
        update_equivs(Equivs,Depth),
        add_lit(OldLast,Negated,SplitAtom,In,Out,IVars,OVars,LitNum),
        insert_eqs(Equivs,LitNum,NewLast), !.

% modify the literal database: check if performing lazy evaluation
% of bottom clause, and update input and output terms in literal
add_lit(Last,Negated,FAtom,I,O,_,_,Last):-
	(recorded(progol,set(lazy_bottom,true),_);
		recorded(progol,set(construct_bottom,false),_)),
	(Negated = true -> Lit = not(FAtom); Lit = FAtom),
	recorded(lits,lit_info(_,0,Lit,I,O,_),_), !.
add_lit(Last,Negated,FAtom,In,Out,IVars,OVars,LitNum):-
	LitNum is Last + 1,
	update_iterms(LitNum,IVars),
	update_oterms(LitNum,OVars,[],Dependents),
	add_litinfo(LitNum,Negated,FAtom,In,Out,Dependents),
	recordz(ivars,ivars(LitNum,IVars),_),
	recordz(ovars,ovars(LitNum,OVars),_), !.


% update lits database after checking that the atom does not exist
% used during updates of lit database by lazy evaluation
update_lit(LitNum,true,FAtom,I,O,D):-
	recorded(lits,lit_info(LitNum,0,not(FAtom),I,O,D),_), !.
update_lit(LitNum,false,FAtom,I,O,D):-
	recorded(lits,lit_info(LitNum,0,FAtom,I,O,D),_), !.
update_lit(LitNum,Negated,FAtom,I,O,D):-
	gen_lit(LitNum),
	add_litinfo(LitNum,Negated,FAtom,I,O,D), 
	get_vars(FAtom,I,IVars),
	get_vars(FAtom,O,OVars),
	recordz(ivars,ivars(LitNum,IVars),_),
	recordz(ovars,ovars(LitNum,OVars),_), !.

% add a literal to lits database without checking
add_litinfo(LitNum,true,FAtom,I,O,D):-
	!,
	recordz(lits,lit_info(LitNum,0,not(FAtom),I,O,D),_).
add_litinfo(LitNum,_,FAtom,I,O,D):-
	recordz(lits,lit_info(LitNum,0,FAtom,I,O,D),_).
	
% update database with input terms of literal
update_iterms(_,[]).
update_iterms(LitNum,[VarNum|Vars]):-
	recorded(vars,vars(VarNum,TNo,I,O),DbRef),
	erase(DbRef),
	update(LitNum,I,NewI),
	recorda(vars,vars(VarNum,TNo,NewI,O),_),
	update_dependents(LitNum,O),
	update_iterms(LitNum,Vars).

% update database with output terms of literal
% return list of dependent literals
update_oterms(_,[],Dependents,Dependents).
update_oterms(LitNum,[VarNum|Vars],DSoFar,Dependents):-
	recorded(vars,vars(VarNum,TNo,I,O),DbRef),
	erase(DbRef),
	update(LitNum,O,NewO),
	recorda(vars,vars(VarNum,TNo,I,NewO),_),
	update_list(I,DSoFar,D1),
	update_oterms(LitNum,Vars,D1,Dependents).

% update Dependent list of literals with LitNum
update_dependents(_,[]).
update_dependents(LitNum,[Lit|Lits]):-
	recorded(lits,lit_info(Lit,Depth,Atom,ITerms,OTerms,Dependents),DbRef),
	erase(DbRef),
	update(LitNum,Dependents,NewD),
	recorda(lits,lit_info(Lit,Depth,Atom,ITerms,OTerms,NewD),_),
	update_dependents(LitNum,Lits).

% recursively mark literals with minimum depth to bind output vars in head
mark_lits([],_,_).
mark_lits(Lits,OldVars,Depth):-
	mark_lits(Lits,Depth,true,[],Predecessors,OldVars,NewVars),
	delete_list(Lits,Predecessors,P1),
	Depth1 is Depth + 1,
	mark_lits(P1,NewVars,Depth1).

mark_lits([],_,_,P,P,V,V).
mark_lits([Lit|Lits],Depth,GetPreds,PSoFar,P,VSoFar,V):-
	recorded(progol_dyn,marked(Lit/Depth0),DbRef), !,
	(Depth < Depth0 ->
		erase(DbRef),
		mark_lit(Lit,Depth,GetPreds,VSoFar,P1,V2),
		update_list(P1,PSoFar,P2),
		mark_lits(Lits,Depth,GetPreds,P2,P,V2,V);
		mark_lits(Lits,Depth,GetPreds,PSoFar,P,VSoFar,V)).
mark_lits([Lit|Lits],Depth,GetPreds,PSoFar,P,VSoFar,V):-
	mark_lit(Lit,Depth,GetPreds,VSoFar,P1,V2), !,
	update_list(P1,PSoFar,P2),
	mark_lits(Lits,Depth,GetPreds,P2,P,V2,V).
mark_lits([_|Lits],Depth,GetPreds,PSoFar,P,VSoFar,V):-
	mark_lits(Lits,Depth,GetPreds,PSoFar,P,VSoFar,V).

mark_lit(Lit,Depth,GetPreds,VSoFar,P1,V1):-
	recorded(lits,lit_info(Lit,_,Atom,I,O,D),DbRef),
	erase(DbRef),
	recorda(progol_dyn,marked(Lit/Depth),_),
	recorda(lits,lit_info(Lit,Depth,Atom,I,O,D),_),
	(GetPreds = false ->
		P1 = [],
		V1 = VSoFar;
		get_vars(Atom,O,OVars),
		update_list(OVars,VSoFar,V1),
		get_predicates(D,V1,D1),
		mark_lits(D1,Depth,false,[],_,VSoFar,_),
		get_vars(Atom,I,IVars),
		get_predecessors(IVars,[],P1)).
	
% get literals that are linked and do not link to any others (ie predicates)
get_predicates([],_,[]).
get_predicates([Lit|Lits],Vars,[Lit|T]):-
	recorded(lits,lit_info(Lit,_,Atom,I,O,[]),_), 
	get_vars(Atom,I,IVars),
	subset1(IVars,Vars), !,
	get_predicates(Lits,Vars,T).
get_predicates([_|Lits],Vars,T):-
	get_predicates(Lits,Vars,T).

get_predecessors([],P,P).
get_predecessors([Var|Vars],PSoFar,P):-
	recorded(vars,vars(Var,_,_,O),_),
	update_list(O,PSoFar,P1),
	get_predecessors(Vars,P1,P).

% removal of literals that are repeated because of mode differences
rm_moderepeats(_,_):-
	recorded(lits,lit_info(Lit1,_,Pred1,_,_,_),_),
	recorded(lits,lit_info(Lit2,_,Pred1,_,_,_),DbRef),
	Lit1 > 1, Lit2 > Lit1,
	erase(DbRef),
	recorda(progol_dyn,marked(Lit2/0),_),
	fail.
rm_moderepeats(Last,N):-
	recorded(progol_dyn,marked(_),_), !,
	get_marked(1,Last,Lits),
	length(Lits,N),
	p1_message('repeated literals'), p_message(N/Last),
	remove_lits(Lits).
rm_moderepeats(_,0).
	
% removal of symmetric literals
rm_symmetric(_,_):-
	recorded(progol,set(check_symmetry,true),_),
	recorded(lits,lit_info(Lit1,_,Pred1,[I1|T1],_,_),_),
	is_symmetric(Pred1,Name,Arity),
	get_vars(Pred1,[I1|T1],S1),
	recorded(lits,lit_info(Lit2,_,Pred2,[I2|T2],_,_),DbRef),
	not(Lit1=Lit2),
	is_symmetric(Pred2,Name,Arity),
	get_vars(Pred2,[I2|T2],S2),
	equal_set(S1,S2),
	recorda(progol_dyn,marked(Lit2/0),_),
	erase(DbRef),
	fail.
rm_symmetric(Last,N):-
	recorded(progol_dyn,marked(_),_), !,
	get_marked(1,Last,Lits),
	length(Lits,N),
	p1_message('symmetric literals'), p_message(N/Last),
	remove_lits(Lits).
rm_symmetric(_,0).

is_symmetric(not(Pred),not(Name),Arity):-
	!,
	functor(Pred,Name,Arity),
	recorded(progol,symmetric(Name/Arity),_).
is_symmetric(Pred,Name,Arity):-
	functor(Pred,Name,Arity),
	recorded(progol,symmetric(Name/Arity),_).
	
% removal of literals that are repeated because of commutativity
rm_commutative(_,_):-
	recorded(progol,commutative(Name/Arity),_),
	p1_message('checking commutative literals'), p_message(Name/Arity),
	functor(Pred,Name,Arity), functor(Pred1,Name,Arity),
	recorded(lits,lit_info(Lit1,_,Pred,[I1|T1],_,_),_),
	get_vars(Pred,[I1|T1],S1),
	recorded(lits,lit_info(Lit2,_,Pred1,[I2|T2],_,_),DbRef),
	not(Lit1=Lit2),
	get_vars(Pred1,[I2|T2],S2),
	equal_set(S1,S2),
	recorda(progol_dyn,marked(Lit2/0),_),
	erase(DbRef),
	fail.
rm_commutative(Last,N):-
	recorded(progol_dyn,marked(_),_), !,
	get_marked(1,Last,Lits),
	length(Lits,N),
	p1_message('commutative literals'), p_message(N/Last),
	remove_lits(Lits).
rm_commutative(_,0).

% recursive marking of literals that do not contribute to establishing
% variable chains to output vars in the head
rm_uselesslits(_,0):-
	recorded(sat,head_ovars([]),_), !.
rm_uselesslits(Last,N):-
	recorded(sat,head_ovars(OVars),_),
	get_predecessors(OVars,[],P),
	recorded(sat,head_ivars(IVars),_),
	mark_lits(P,IVars,0),
	get_unmarked(1,Last,Lits),
	length(Lits,N),
	p1_message('useless literals'), p_message(N/Last),
	remove_lits(Lits).

% implication map of body literals based on rewrites in
% background knowledge
get_implied:-
	recorded(progol,check_implication(Name/Arity),_),
	functor(Pred1,Name,Arity),
	functor(Pred2,Name,Arity),
	recorded(lits,lit_info(Lit1,_,Pred1,_,_,_),_),
	get_flatatom(Pred1,[],Atom1,TV1),
	skolemize(Atom1/TV1,SAtom/TV),
	asserta(SAtom),
	get_implied(Lit1,TV,Pred2),
	retract(SAtom),
	fail.
get_implied.

get_implied(Lit1,TV,Pred2):-
	recorded(progol,set(depth,Depth),_),
	recorded(lits,lit_info(Lit2,_,Pred2,_,_,_),_),
	not(Lit1=Lit2),
	get_flatatom(Pred2,TV,Atom2,_),
	skolemize(Atom2,SAtom2),
	once(depth_bound_call(SAtom2,Depth)),
	update_implied(Lit2,Lit1),
	fail.
get_implied(_,_,_).

update_implied(Lit2,Lit1):-
	(recorded(sat,implied_by(Lit2,L2),DbRef1)->
		erase(DbRef1),
		recorda(sat,implied_by(Lit2,[Lit1|L2]),_);
		recorda(sat,implied_by(Lit2,[Lit1]),_)),
	(recorded(sat,implies(Lit1,L1),DbRef2)->
		erase(DbRef2),
		recorda(sat,implies(Lit1,[Lit2|L1]),_);
		recorda(sat,implies(Lit1,[Lit2]),_)).

% get a list of unmarked literals
get_unmarked(Lit,Last,[]):-
	Lit > Last, !.
get_unmarked(Lit,Last,Lits):-
	recorded(progol_dyn,marked(Lit/_),DbRef), !,
	erase(DbRef),
	Next is Lit + 1,
	get_unmarked(Next,Last,Lits).
get_unmarked(Lit,Last,[Lit|Lits]):-
	recorded(lits,lit_info(Lit,_,_,_,_,_),DbRef), !,
	erase(DbRef),
	Next is Lit + 1,
	get_unmarked(Next,Last,Lits).
get_unmarked(Lit,Last,Lits):-
	Next is Lit + 1,
	get_unmarked(Next,Last,Lits).

% get a list of marked literals
get_marked(Lit,Last,[]):-
	Lit > Last, !.
get_marked(Lit,Last,[Lit|Lits]):-
	recorded(progol_dyn,marked(Lit/_),DbRef), !,
	erase(DbRef),
	(recorded(lits,lit_info(Lit,_,_,_,_,_),DbRef1)->
		erase(DbRef1);
		true),
	Next is Lit + 1,
	get_marked(Next,Last,Lits).
get_marked(Lit,Last,Lits):-
	Next is Lit + 1,
	get_marked(Next,Last,Lits).

% update descendent lists of literals by removing useless literals
remove_lits(L):-
	recorded(lits,lit_info(Lit,Depth,A,I,O,D),DbRef),
	erase(DbRef),
	delete_list(L,D,D1),
	recorda(lits,lit_info(Lit,Depth,A,I,O,D1),_),
	fail.
remove_lits(_).

% generate a new literal at depth Depth: forced backtracking will give all lits
gen_layer(PSym/NSucc/Input/_/_,Depth):-
	(PSym = not(Pred) ->
		functor(Pred,Name,Arity),
		functor(Lit1,Name,Arity),
		Lit = not(Lit1);
		functor(PSym,Name,Arity),
		functor(Lit,Name,Arity)),
	(Input = [] -> Call1 = true, Call2 = true;
		delete(Arg/Type,Input,OtherInputs),
		Depth1 is Depth - 1,
		construct_incall(Lit,Depth1,[Arg/Type],Call1),
		construct_call(Lit,Depth,OtherInputs,Call2)),
	Call1,
	Call2,
	get_successes(Lit,NSucc),
	fail.
gen_layer(_,_).

get_successes(Literal,1):-
	depth_bound_call(Literal), 
	update_atoms(Literal), !.
get_successes(Literal,*):-
	depth_bound_call(Literal), 
	update_atoms(Literal).
get_successes(Literal,N):-
	integer(N),
	N > 1,
	reset_succ,
	get_nsuccesses(Literal,N).

% get at most N matches for a literal
get_nsuccesses(Literal,N):-
	depth_bound_call(Literal), 
	recorded(progol_dyn,last_success(Succ0),DbRef),
	erase(DbRef),
	Succ0 < N,
	Succ1 is Succ0 + 1,
	update_atoms(Literal),
	recorda(progol_dyn,last_success(Succ1),_),
	(Succ1 >= N -> !; true).

update_atoms(Atom):-
	recorded(atoms,Atom,_), !.
update_atoms(Atom):-
	recorda(atoms,Atom,_).

% call with input term that is an ouput of a previous literal
construct_incall(_,_,[],true):- !.
construct_incall(not(Lit),Depth,Args,Call):-
	!,
	construct_incall(Lit,Depth,Args,Call).
construct_incall(Lit,Depth,[Arg/Type],Call):-
	!,
	Call = legal_term(exact,Depth,Type,Term),
	arg(Arg,Lit,Term).
construct_incall(Lit,Depth,[Arg/Type|Args],(Call,Calls)):-
	arg(Arg,Lit,Term),
	Call = legal_term(exact,Depth,Type,Term),
	(var(Depth)-> construct_incall(Lit,_,Args,Calls);
		construct_incall(Lit,Depth,Args,Calls)).

construct_call(_,_,[],true):- !.
construct_call(not(Lit),Depth,Args,Call):-
	!,
	construct_call(Lit,Depth,Args,Call).
construct_call(Lit,Depth,[Arg/Type],Call):-
	!,
	Call = legal_term(upper,Depth,Type,Term),
	arg(Arg,Lit,Term).
construct_call(Lit,Depth,[Arg/Type|Args],(Call,Calls)):-
	arg(Arg,Lit,Term),
	Call = legal_term(upper,Depth,Type,Term),
	construct_call(Lit,Depth,Args,Calls).

% generator of legal terms seen so far
legal_term(exact,Depth,Type,Term):-
	recorded(terms,terms(TNo,Depth,Term,Type),_),
	once(recorded(vars,vars(_,TNo,_,[_|_]),_)).
% legal_term(exact,Depth,Type,Term):-
	% recorded(vars,copy(NewVar,OldVar,Depth),_),
	% once(recorded(vars,vars(NewVar,TNo,_,_),_)),
	% recorded(terms,terms(TNo,_,Term,Type),_).
legal_term(upper,Depth,Type,Term):-
	recorded(terms,terms(TNo,Depth1,Term,Type),_),
	Depth1 \= unknown,
	Depth1 < Depth,
	once(recorded(vars,vars(_,TNo,_,[_|_]),_)).
% legal_term(upper,Depth,Type,Term):-
	% recorded(vars,copy(NewVar,OldVar,Depth),_),
	% once(recorded(vars,vars(NewVar,TNo,_,_),_)),
	% recorded(terms,terms(TNo,Depth1,Term,Type),_),
	% Depth1 \= unknown.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% V A R I A B L E  -- S P L I T T I N G


split_vars(Depth,FAtom,I,O,C,SplitAtom,IVars,OVars,Equivs):-
	setting(splitvars,true), !,
        get_args(FAtom,I,[],IVarList),
        get_args(FAtom,O,[],OVarList),
	get_var_equivs(Depth,IVarList,OVarList,IVars,OVars0,Equivs0),
	(Equivs0 = [] ->
		OVars = OVars0, SplitAtom = FAtom, Equivs = Equivs0;
		functor(FAtom,Name,Arity),
		functor(SplitAtom,Name,Arity),
		copy_args(FAtom,SplitAtom,I),
		copy_args(FAtom,SplitAtom,C),
		rename_ovars(O,Depth,FAtom,SplitAtom,Equivs0,Equivs),
		get_argterms(SplitAtom,O,[],OVars)).
	% write('splitting: '), write(FAtom), write(' to: '), write(SplitAtom), nl.
split_vars(_,FAtom,I,O,_,FAtom,IVars,OVars,[]):-
	get_vars(FAtom,I,IVars),
	get_vars(FAtom,O,OVars).

% get equivalent classes of variables from co-references 
get_var_equivs(Depth,IVarList,OVarList,IVars,OVars,Equivs):-
	sort(IVarList,IVars),
	sort(OVarList,OVars),
	(Depth = 0 ->
		get_repeats(IVarList,[],ICoRefs);
		intersect1(IVars,OVarList,ICoRefs,_)),
	get_repeats(OVarList,ICoRefs,CoRefs),
	add_equivalences(CoRefs,Depth,Equivs).

add_equivalences([],_,[]).
add_equivalences([Var|Vars],Depth,[Var/E|Rest]):-
	(Depth = 0 -> E = []; E = [Var]),
	add_equivalences(Vars,Depth,Rest).


get_repeats([],L,L).
get_repeats([Var|Vars],Ref1,L):-
	member1(Var,Vars), !,
	update(Var,Ref1,Ref2),
	get_repeats(Vars,Ref2,L).
get_repeats([_|Vars],Ref,L):-
	get_repeats(Vars,Ref,L).

% rename all output vars that are co-references
% updates vars database and return equivalent class of variables
rename_ovars([],_,_,_,L,L).
rename_ovars([ArgNo|Args],Depth,Old,New,CoRefs,Equivalences):-
        val(ArgNo,Pos),
	arg(Pos,Old,OldVar),
	delete(OldVar/Equiv,CoRefs,Rest), !,
	copy_var(OldVar,NewVar,Depth),
	arg(Pos,New,NewVar),
	rename_ovars(Args,Depth,Old,New,[OldVar/[NewVar|Equiv]|Rest],Equivalences).
rename_ovars([ArgNo|Args],Depth,Old,New,CoRefs,Equivalences):-
        val(ArgNo,Pos),
	arg(Pos,Old,OldVar),
	arg(Pos,New,OldVar),
	rename_ovars(Args,Depth,Old,New,CoRefs,Equivalences).

% create new  equalities to  allow co-references to re-appear in search
insert_eqs([],L,L).
insert_eqs([OldVar/Equivs|Rest],Last,NewLast):-
	recorded(vars,vars(OldVar,TNo,I,O),_),
	recorded(terms,terms(TNo,_,_,Type),_),
	add_eqs(Equivs,Type,Last,Last1),
	insert_eqs(Rest,Last1,NewLast).

add_eqs([],_,L,L).
add_eqs([V1|Rest],Type,Last,NewLast):-
	add_eqs(Rest,V1,Type,Last,Last1),
	add_eqs(Rest,Type,Last1,NewLast).

add_eqs([],_,_,L,L).
add_eqs([Var2|Rest],Var1,Type,Last,NewLast):-
	add_lit(Last,false,(Var1=Var2),[1/Type,2/Type],[],[Var1,Var2],[],Last1),
	add_eqs(Rest,Var1,Type,Last1,NewLast).
	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% utilities used to generate most specific inverse resolvent

% integrate a list of arguments of a Literal: returns terms integrated
% terms in argument are recursively unwrapped and integrated
integrate_args(_,_,[],[]).
integrate_args(Depth,Literal,[ArgPos/Type|T],TermList):-
        arg(ArgPos,Literal,Term),
        integrate_term(Depth,Term,TL1),
        (recorded(terms,terms(TNo,Depth,Term,unknown),DbRef)->
                        erase(DbRef),
                        recorda(terms,terms(TNo,Depth,Term,Type),_);
                        true),
        integrate_args(Depth,Literal,T,TL2),
        update_list(TL2,TL1,TermList).


% integrate a list of arguments of a Literal
% terms in argument are not recursively unwrapped
integrate_args(_,_,[]).
integrate_args(Depth,Literal,[ArgPos/Type|T]):-
        arg(ArgPos,Literal,Term),
        integrate_term(Depth,Term/Type),
        (recorded(terms,terms(TNo,Depth,Term,unknown),DbRef)->
                        erase(DbRef),
                        recorda(terms,terms(TNo,Depth,Term,Type),_);
                        true),
        integrate_args(Depth,Literal,T).


% integrate list of terms into database of terms: return terms integrated
integrate_terms(_,[],[]).
integrate_terms(Depth,[Term|Terms],TermList):-
	integrate_term(Depth,Term,TL1),
	integrate_terms(Depth,Terms,TL2),
	append(TL2,TL1,TermList).

% integrate a term into database of terms: return terms integrated
% recursively unwraps terms
% 
% term is the output at current level
integrate_term(Depth,Term,[]):-
	recorded(terms,terms(TNo,Depth,Term,_),_),
	recorded(vars,vars(_,TNo,_,[_|_]),_), !.
% term is not the output of any literal
integrate_term(Depth,Term,[TNo|Terms]):-
	recorded(terms,terms(TNo,Depth1,Term,Type),DbRef),
	(Type = unknown ; recorded(vars,vars(_,TNo,_,[]),_)), !,
	(Depth1 = unknown ->
		erase(DbRef),
		recorda(terms,terms(TNo,Depth,Term,Type),_);
		true),
	Term =.. [_|Args],
	integrate_terms(Depth,Args,Terms).
integrate_term(Depth,Term,Terms):-
	recorded(terms,terms(_,_,Term,Type),_),
	not(Type = unknown),
	Term =.. [_|Args],
	integrate_terms(Depth,Args,Terms),
	!.
integrate_term(Depth,Term,[TNo|Terms]):-
	recorded(sat,last_term(Num),DbRef),
	erase(DbRef),
	recorded(sat,last_var(Var0),DbRef1),
	erase(DbRef1),
	TNo is Num + 1,
	Var is Var0 + 1,
	recorda(terms,terms(TNo,Depth,Term,unknown),_),
	recorda(vars,vars(Var,TNo,[],[]),_),
	Term =.. [_|Args],
	recorda(sat,last_term(TNo),_),
	recorda(sat,last_var(Var),_),
	integrate_terms(Depth,Args,Terms).

% integrate a term without recursive unwrapping 
integrate_term(Depth,Term/Type):-
        recorded(terms,terms(TNo,Depth,Term,Type),_),
        recorded(vars,vars(_,TNo,_,[_|_]),_), !.
integrate_term(Depth,Term/Type):-
        recorded(terms,terms(TNo,Depth1,Term,Type),DbRef),
        (Type = unknown ; recorded(vars,vars(_,TNo,_,[]),_)), !,
	(Depth1 = unknown ->
        	erase(DbRef),
		recorda(terms,terms(TNo,Depth,Term,Type),_);
                true).
integrate_term(_,Term/Type):-
        recorded(terms,terms(_,_,Term,Type),_),
        not(Type = unknown),
        !.
integrate_term(Depth,Term/Type):-
	recorded(sat,last_term(Num),DbRef),
	erase(DbRef),
	recorded(sat,last_var(Var0),DbRef1),
	erase(DbRef1),
	TNo is Num + 1,
	Var is Var0 + 1,
	recorda(sat,last_term(TNo),_),
	recorda(sat,last_var(Var),_),
	recorda(vars,vars(Var,TNo,[],[]),_),
	recorda(terms,terms(TNo,Depth,Term,Type),_).
	% recorda(terms,terms(TNo,Depth,Term,unknown),_).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% obtain types required from mode declarations
update_modetypes([],[]).
update_modetypes([PSym/NSucc|Preds],[PSym/NSucc/Input/Output/Constants|T]):-
	(PSym = not(Pred) -> true; Pred = PSym),
	functor(Pred,_,Arity),
	split_args1(Pred,Arity,Input,Output,Constants),
	update_argtypes(Input),
	update_argtypes(Output),
	update_argtypes(Constants),
	update_modetypes(Preds,T).

update_argtypes([]).
update_argtypes([_/Type|T]):-
	update_types(type(Type)),
	update_argtypes(T).

% update types required
update_types(Type):-
	recorded(progol_dyn,Type,_), !.
update_types(Type):-
	recorda(progol_dyn,Type,_).

% split argument positions into +/-/#
split_args(Lit,Input,Output,Constants):-
	functor(Lit,Psym,Arity),
	functor(Pred,Psym,Arity),
	recorded(progol,mode(_,Pred),_),
	split_args1(Pred,Arity,Input,Output,Constants).

split_args1(_,0,[],[],[]):- !.
split_args1(Literal,Argno,[Argno/Type|Input1],Output,Constants):-
	arg(Argno,Literal,+Type), !,
	Argno1 is Argno - 1,
	split_args1(Literal,Argno1,Input1,Output,Constants).
split_args1(Literal,Argno,Input,[Argno/Type|Output1],Constants):-
	arg(Argno,Literal,-Type), !,
	Argno1 is Argno - 1,
	split_args1(Literal,Argno1,Input,Output1,Constants).
split_args1(Literal,Argno,Input,Output,[Argno/Type|Constants1]):-
	arg(Argno,Literal,#Type), !,
	Argno1 is Argno - 1,
	split_args1(Literal,Argno1,Input,Output,Constants1).
split_args1(Literal,Argno,Input,Output,Constants):-
	Argno1 is Argno - 1,
	split_args1(Literal,Argno1,Input,Output,Constants).

% add type info for terms
add_types(Depth):-
	recorded(terms,terms(TNo,Depth,Term,unknown),DbRef),
	recorded(progol_dyn,type(Type),_),
	Fact =.. [Type,Term],
	Fact,
	erase(DbRef),
	recorda(terms,terms(TNo,Depth,Term,Type),_),
	fail.
add_types(_).

get_determs(PSym/Arity,L):-
	findall(Lit/NSucc,
		(recorded(progol,determination(PSym/Arity,PSym1/Arity1),_),
		functor(Lit,PSym1,Arity1),recorded(progol,mode(NSucc,Lit),_)),L).

get_modes(PSym/Arity,L):-
	functor(Lit,PSym,Arity),
	findall(Lit,recorded(progol,mode(_,Lit),_),L).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% S E A R C H

search(S,Nodes):-
	next_node(_,_), !,
	arg(23,S,LazyPreds),
        arg(3,S,RefineOp),
        repeat,
	next_node(NodeRef,DbRef),
	erase(DbRef),
        once(recorded(search,current(LastE,Last,BestSoFar),DbRef1)),
        expand(S,NodeRef,Node,Path,MinLength,Succ,PosCover,NegCover,OVars,
		PrefixClause,PrefixTV,PrefixLength),
        ((LazyPreds = []; RefineOp = true)  -> Succ1 = Succ;
		lazy_evaluate(Succ,LazyPreds,Path,PosCover,NegCover,Succ1)),
	NextE is LastE + 1,
        get_gains(S,Last,BestSoFar,Path,PrefixClause,PrefixTV,PrefixLength,
                MinLength,Succ1,PosCover,NegCover,OVars,NextE,Last0,NextBest0),
	(RefineOp = true -> Last1 = Last0, NextBest = NextBest0;
        	get_sibgains(S,Node,Last0,NextBest0,Path,PrefixClause,
			PrefixTV,PrefixLength,MinLength,PosCover,NegCover,
			OVars,NextE,Last1,NextBest)),
        recorda(search,current(NextE,Last1,NextBest),_),
        (continue_search(S,NextBest,Last1) ->
                erase(DbRef1),
		recorda(nodes,expansion(NextE,Last,Last1),_), 
                prune_open(S,BestSoFar,NextBest),
                get_nextbest(Next),
		Next = none,
		recorded(search,current(_,Nodes,_),_);
                recorded(search,current(_,Nodes,_),_)), !.
search(_,Nodes):-
	recorded(search,current(_,Nodes,_),_).

next_node(NodeRef,DbRef):-
	once(recorded(search,nextnode(NodeRef),DbRef)), !.

get_search_settings(S):-
        functor(S,set,34),
	(setting(nodes,MaxNodes)-> arg(1,S,MaxNodes); arg(1,S,0)),
	(setting(explore,Explore)-> arg(2,S,Explore); arg(2,S,false)),
	(setting(refineop,RefineOp)-> arg(3,S,RefineOp); arg(3,S,false)),
	(setting(search,Search)->true; Search=bf),
	(setting(evalfn,EvalFn)->true; EvalFn=coverage),
	arg(4,S,Search/EvalFn),
	(setting(greedy,Greedy)-> arg(5,S,Greedy); arg(5,S,false)),
	(setting(verbosity,Verbose)-> arg(6,S,Verbose); arg(6,S,1)),
	(setting(clauselength,CLength)-> arg(7,S,CLength); arg(7,S,4)),
	(setting(caching,Cache)-> arg(8,S,Cache); arg(8,S,false)),
	(setting(prune_defs,Prune)-> arg(9,S,Prune); arg(9,S,false)),
	(setting(lazy_on_cost,LCost)-> arg(10,S,LCost); arg(10,S,false)),
	(setting(lazy_on_contradiction,LContra)-> arg(11,S,LContra); arg(11,S,false)),
	(setting(lazy_negs,LNegs)-> arg(12,S,LNegs); arg(12,S,false)),
	(setting(minpos,MinPos)-> arg(13,S,MinPos); arg(13,S,1)),
	(setting(depth,Depth)-> arg(14,S,Depth); arg(14,S,10)),
	(setting(cache_clauselength,CCLim) -> arg(15,S,CCLim); arg(15,S,3)),
        (recorded(progol,size(pos,PSize),_)-> arg(16,S,PSize); arg(16,S,0)),
	(setting(noise,Noise)-> arg(17,S,Noise); arg(17,S,false)),
	(setting(minacc,MinAcc)-> arg(18,S,MinAcc); arg(18,S,false)),
        (recorded(progol_dyn,base(Base),_)-> arg(19,S,Base); arg(19,S,1000)),
        (recorded(progol,size(rand,RSize),_)-> arg(20,S,RSize); arg(20,S,0)),
	(setting(lazy_bottom,LBot)-> arg(21,S,LBot); arg(21,S,false)),
	(setting(refine,Refine)-> arg(22,S,Refine); arg(22,S,false)),
	findall(PN/PA,recorded(progol,lazy_evaluate(PN/PA),_),LazyPreds),
	arg(23,S,LazyPreds),
        (recorded(progol,size(neg,NSize),_)-> arg(24,S,NSize); arg(24,S,0)),
	(setting(openlist,OSize)-> arg(25,S,OSize); arg(25,S,inf)),
        (recorded(progol,check_implication(_),_)-> arg(26,S,true); arg(26,S,false)),
        (recorded(sat,set(eq,true),_)-> arg(27,S,true); arg(27,S,false)),
        (recorded(sat,head_ovars(HOVars),_)-> arg(28,S,HOVars); arg(28,S,HOVars)),
	(setting(store_cover,true) -> arg(29,S,true); arg(29,S,false)),
	(setting(construct_bottom,CBott) -> arg(30,S,CBott); arg(30,S,saturation)),
	(get_ovars1(1,HIVars) ->  arg(31,S,HIVars); arg(31,S,[])),
	(setting(language,Lang) -> arg(32,S,Lang); arg(32,S,false)),
	(setting(splitvars,Split) -> arg(33,S,Split);arg(33,S,false)),
	(setting(proof_strategy,Proof) -> arg(34,S,Proof);arg(34,S,restricted_sld)).

continue_search(S,_,Nodes):-
        arg(1,S,MaxNodes),
        Nodes >= MaxNodes, !,
	p_message('node limit exceeded'),
        fail.
continue_search(S,_,_):-
        arg(2,S,Explore),
        Explore = true, !.
continue_search(S,_,_):-
        arg(4,S,_/Evalfn),
        (Evalfn = cost; Evalfn = posonly), !.
continue_search(S,Best,_):-
	Best = [P|_]/_,
	arg(16,S,P1),
	P < P1.


update_max_head_count(N,0):-
	retractall(progol_dyn,max_head_count(_)),
	recorda(progol_dyn,max_head_count(N),_), !.
update_max_head_count(Count,Last):-
	recorded(nodes,node(Last,LitNum,_,_,PosCover,_,_,_),_), !,
	recorda(progol_dyn,head_lit(LitNum),_),
	interval_count(PosCover,N),
	Next is Last - 1,
	(N > Count -> update_max_head_count(N,Next);
		update_max_head_count(Count,Next)).
update_max_head_count(Count,Last):-
	Next is Last - 1,
	update_max_head_count(Count,Next).

expand(S,DbRef,NodeNum,Path,Length,[Clause],PosCover,NegCover,OVars,[Clause],[],CL):-
        arg(3,S,RefineOp),
        RefineOp = true, !,
        instance(DbRef,node(NodeNum,Clause,Path,Length/CL,_,_,OVars,E)),
        erase(DbRef),
        arg(5,S,Greedy),
        (Greedy = true ->
                recorded(progol,atoms_left(pos,PosCover),_);
                arg(16,S,PSize),
                PosCover = [1-PSize]),
        arg(4,S,_/Evalfn),
	(Evalfn = posonly -> 
                arg(20,S,RSize),
                NegCover = [1-RSize];
                arg(24,S,NSize),
                NegCover = [1-NSize]).
expand(S,DbRef,NodeNum,Path1,Length,Descendents,PCover,NCover,OVars,C,TV,CL):-
        instance(DbRef,node(NodeNum,LitNum,Path,Length/_,PCover,NCover,OVars,E)),
        append([LitNum],Path,Path1),
	get_pclause(Path1,[],C,TV,CL,_),
        arg(26,S,ICheck),
        recorded(lits,lit_info(LitNum,_,Atom,_,_,Dependents),_),
        intersect1(Dependents,Path1,_,Succ),
        check_parents(Succ,OVars,D1,_),
        (ICheck = true ->
                (recorded(sat,implies(LitNum,Implied),_)->
                        delete_list(Implied,D1,Descendents);
                        Descendents = D1);
                Descendents = D1).

get_ovars([],V,V).
get_ovars([LitNum|Lits],VarsSoFar,Vars):-
	get_ovars1(LitNum,OVars),
	append(VarsSoFar,OVars,Vars1),
	get_ovars(Lits,Vars1,Vars).

get_ovars1(LitNum,OVars):-
	recorded(ovars,ovars(LitNum,OVars),_), !.
get_ovars1(LitNum,OVars):-
	recorded(lits,lit_info(LitNum,_,Atom,_,O,_),_),
	get_vars(Atom,O,OVars).


% get set of vars at arg positions specified
get_vars(not(Literal),Args,Vars):-
	!,
	get_vars(Literal,Args,Vars).
get_vars(_,[],[]).
get_vars(Literal,[ArgNo|Args],Vars):-
	val(ArgNo,Pos), arg(Pos,Literal,Term),
	get_vars_in_term([Term],TV1),
	get_vars(Literal,Args,TV2),
	update_list(TV2,TV1,Vars).

get_vars_in_term([],[]).
get_vars_in_term([Var|Terms],[Var|TVars]):-
	integer(Var), !,
	get_vars_in_term(Terms,TVars).
get_vars_in_term([Term|Terms],TVars):-
	Term =.. [_|Terms1],
	get_vars_in_term(Terms1,TV1),
	get_vars_in_term(Terms,TV2),
	update_list(TV2,TV1,TVars).

% get terms at arg positions specified
% need not be variables
get_argterms(not(Literal),Args,TermsSoFar,Terms):-
        !,
        get_argterms(Literal,Args,TermsSoFar,Terms).
get_argterms(_,[],Terms,Terms).
get_argterms(Literal,[ArgNo|Args],TermsSoFar,Terms):-
        val(ArgNo,Pos),
        arg(Pos,Literal,Term),
        update(Term,TermsSoFar,T1),
        get_argterms(Literal,Args,T1,Terms).

% get list of terms at arg positions specified
get_args(not(Literal),Args,TermsSoFar,Terms):-
        !,
        get_args(Literal,Args,TermsSoFar,Terms).
get_args(_,[],Terms,Terms).
get_args(Literal,[ArgNo|Args],TermsSoFar,Terms):-
        val(ArgNo,Pos),
        arg(Pos,Literal,Term),
        get_args(Literal,Args,[Term|TermsSoFar],Terms).



get_ivars([],V,V).
get_ivars([LitNum|Lits],VarsSoFar,Vars):-
	get_ivars1(LitNum,IVars),
	append(VarsSoFar,IVars,Vars1),
	get_ivars(Lits,Vars1,Vars).

get_ivars1(LitNum,IVars):-
	recorded(ivars,ivars(LitNum,IVars),_), !.
get_ivars1(LitNum,IVars):-
	recorded(lits,lit_info(LitNum,_,Atom,I,_,_),_),
	get_vars(Atom,I,IVars).

check_parents([],_,[],[]).
check_parents([LitNum|Lits],OutputVars,[LitNum|DLits],Rest):-
	get_ivars1(LitNum,IVars),
	subset1(IVars,OutputVars), !,
	check_parents(Lits,OutputVars,DLits,Rest).
check_parents([LitNum|Lits],OutputVars,DLits,[LitNum|Rest]):-
	check_parents(Lits,OutputVars,DLits,Rest), !.


get_gains(S,Last,Best,_,_,_,_,_,_,_,_,_,_,Last,Best):-
        not(continue_search(S,Best,Last)), !.
get_gains(_,Last,Best,_,_,_,_,_,[],_,_,_,_,Last,Best):- !.
get_gains(S,Last,Best,Path,C,TV,L,Min,[L1|Succ],Pos,Neg,OVars,E,Last1,NextBest):-
        get_gain(S,upper,Last,Best,Path,C,TV,L,Min,L1,Pos,Neg,OVars,E,Best1,Node1), !,
        get_gains(S,Node1,Best1,Path,C,TV,L,Min,Succ,Pos,Neg,OVars,E,Last1,NextBest).
get_gains(S,Last,BestSoFar,Path,C,TV,L,Min,[_|Succ],Pos,Neg,OVars,E,Last1,NextBest):-
        get_gains(S,Last,BestSoFar,Path,C,TV,L,Min,Succ,Pos,Neg,OVars,E,Last1,NextBest),
        !.

get_sibgains(S,Node,Last,Best,Path,C,TV,L,Min,Pos,Neg,OVars,E,Last1,NextBest):-
        recorded(nodes,node(Node,LitNum,_,_,_,_,_,OldE),DbRef),
	recorded(nodes,expansion(OldE,_,LastSib),_),
	Node1 is Node + 1,
        arg(31,S,HIVars),
	delete_list(HIVars,OVars,LVars),
        get_sibgain(S,LVars,LitNum,Node1,LastSib,Last,Best,Path,C,TV,L,Min,Pos,Neg,OVars,
			E,NextBest,Last1).

get_sibgain(S,_,_,Node,Node1,Last,Best,_,_,_,_,_,_,_,_,_,Best,Last):-
	(Node > Node1;
	not(continue_search(S,Best,Last))), !.
get_sibgain(S,LVars,LitNum,Node,LastSib,Last,Best,Path,C,TV,L,Min,Pos,Neg,OVars,E,LBest,LNode):-
        arg(23,S,Lazy),
        arg(26,S,ICheck),
        get_sibpncover(Lazy,Node,Pos,Neg,Sib1,PC,NC),
       	lazy_evaluate([Sib1],Lazy,Path,PC,NC,[Sib]),
        (ICheck = true ->
                (recorded(sat,implies(LitNum,Implied),_)->
			not(member(Sib,Implied));	
                        true);
                true),
	get_ivars1(Sib,SibIVars),
	(intersects(SibIVars,LVars) -> Flag = upper;
		get_ovars1(Sib,SibOVars),
		(intersects(SibOVars,LVars) -> Flag = upper; Flag = exact)),
        get_gain(S,Flag,Last,Best,Path,C,TV,L,Min,Sib,PC,NC,OVars,E,Best1,Node1), !,
	NextNode is Node + 1,
	get_sibgain(S,LVars,LitNum,NextNode,LastSib,Node1,Best1,Path,C,TV,L,Min,Pos,Neg,
			OVars,E,LBest,LNode), !.
get_sibgain(S,LVars,LitNum,Node,LastSib,Last,Best,Path,C,TV,L,Min,Pos,Neg,OVars,E,Best1,Node1):-
	NextNode is Node + 1,
	get_sibgain(S,LVars,LitNum,NextNode,LastSib,Last,Best,Path,C,TV,L,Min,Pos,Neg,
			OVars,E,Best1,Node1), !.

get_sibpncover(Lazy,NodeNum,Pos,Neg,Sib,PC,NC):-
        recorded(nodes,node(NodeNum,Sib,_,_,Pos1,Neg1,_,_),_),
        recorded(lits,lit_info(Sib,_,Atom,_,_,_),_),
	functor(Atom,Name,Arity),
	(member1(Name/Arity,Lazy) ->
		PC = Pos, NC = Neg;
		calc_intersection(Pos,Pos1,PC),
		calc_intersection(Neg,Neg1,NC)).

% in some cases, it is possible to simply use the intersection of
% covers cached. The conditions under which this is possible was developed
% in discussions with James Cussens
calc_intersection(A1/[B1-L1],A2/[B2-L2],A/[B-L]):-
	!,
	intervals_intersection(A1,A2,A),
	B3 is max(B1,B2),
	(intervals_intersects(A1,[B2-L2],X3-_) -> true; X3 = B3),
	(intervals_intersects(A2,[B1-L1],X4-_) -> true; X4 = B3),
	B4 is min(X3,B3),
	B is min(X4,B4),
	L is max(L1,L2).
calc_intersection(A1/B1,A2,A):-
	!,
	intervals_intersection(A1,A2,A).
calc_intersection(A1,A2/B2,A):-
	!,
	intervals_intersection(A1,A2,A).
calc_intersection(A1,A2,A):-
	intervals_intersection(A1,A2,A).
	

get_gain(S,_,Last,Best,Path,_,_,_,MinLength,L1,Pos,Neg,OVars,E,Best1,NewLast):-
        arg(3,S,RefineOp),
        RefineOp = true , !,
	get_refine_gain(S,Last,Best,Path,MinLength,L1,Pos,Neg,OVars,E,Best1,NewLast).
get_gain(S,Flag,Last,Best/Node,Path,C,TV,Len1,MinLen,L1,Pos,Neg,OVars,E,Best1,Last1):-
        arg(29,S,CCheck),
	arg(33,S,SplitVars),
        (CCheck = true ->
                retractall(progol_dyn,covers(_,_)),
                retractall(progol_dyn,coversn(_,_));
                true),
        get_pclause([L1],TV,Lit1,_,Len2,LastD),
	split_ok(SplitVars,C,Lit1), !,
        extend_clause(C,Lit1,Clause),
        CLen is Len1 + Len2,
        length_ok(S,MinLen,CLen,LastD,EMin,ELength),
        split_clause(Clause,Head,Body),
        recordz(pclause,pclause(Head,Body),DbRef),
        arg(6,S,Verbosity),
        (Verbosity >= 1 -> pp_dclause(Clause); true),
        get_gain1(S,Flag,DbRef,Clause,CLen,EMin/ELength,Last,Best/Node,
                        Path,L1,Pos,Neg,OVars,E,Best1),
        erase(DbRef),
        Last1 is Last + 1.
get_gain(_,_,Last,Best,_,_,_,_,_,_,_,_,_,_,Best,Last).

get_refine_gain(S,Last,Best/Node,Path,MinLength,Parent,Pos,Neg,OVars,E,Best1,NewLast):-
        arg(22,S,RefineType),
        arg(23,S,LazyPreds),
        retractall(progol_dyn,best_refinement(_)),
        retractall(progol_dyn,last_refinement(_)),
	recorda(progol_dyn,best_refinement(Best/Node),_),
	recorda(progol_dyn,last_refinement(Last),_),
	arg(21,S,LazyBottom),
	arg(30,S,ConstructBottom),
	get_user_refinement(RefineType,Parent,Refinement,Id),
	match_bot(ConstructBottom,Refinement,Refinement1),
	(LazyPreds = [] -> Clause = Refinement1;
		lazy_evaluate_refinement(Refinement1,LazyPreds,Pos,Neg,Clause)),
        arg(29,S,CCheck),
        (CCheck = true ->
                retractall(progol_dyn,covers(_,_)),
                retractall(progol_dyn,coversn(_,_));
                true),
	split_clause(Clause,Head,Body),
	nlits(Body,CLength0),
	CLength is CLength0 + 1,
	length_ok(S,MinLength,CLength,0,EMin,ELength),
	recordz(pclause,pclause(Head,Body),DbRef),
	recorded(progol_dyn,best_refinement(OldBest),DbRef1),
	recorded(progol_dyn,last_refinement(OldLast),DbRef2),
        arg(6,S,Verbosity),
        (Verbosity >= 1 ->
		p_message('new refinement'),
		pp_dclause(Clause);
	true),
	get_gain1(S,upper,DbRef,Clause,CLength,EMin/ELength,OldLast,OldBest,
		[Id|Path],[],Pos,Neg,OVars,E,Best1),
	erase(DbRef),
	erase(DbRef2),
	NewLast is OldLast + 1,
	recorda(progol_dyn,last_refinement(NewLast),DbRef3),
	erase(DbRef1),
	recorda(progol_dyn,best_refinement(Best1),DbRef4),
	(continue_search(S,Best1,NewLast) ->
		fail;
		erase(DbRef3),
		erase(DbRef4)), !.
get_refine_gain(_,_,_,_,_,_,_,_,_,_,Best,Last):-
	recorded(progol_dyn,best_refinement(Best),DbRef),
	recorded(progol_dyn,last_refinement(Last),DbRef1),
	erase(DbRef),
	erase(DbRef1).

get_gain1(S,_,DbRef,C,CL,_,Last,Best,Path,_,Pos,Neg,_,E,Best):-
        abandon_branch(S,DbRef), !,
        Node1 is Last + 1,
        arg(7,S,ClauseLength),
        (ClauseLength = CL -> true;
                arg(3,S,RefineOp),
                (RefineOp = true  -> true;
                        recorda(nodes,node(Node1,C,0,0,Pos,Neg,[],E),_))),
	arg(22,S,Refine),
	(Refine = probabilistic -> inc_beta_counts(Path,beta); true).
get_gain1(S,_,DbRef,_,_,_,_,Best,Path,_,_,_,_,_,Best):-
        arg(8,S,Caching),
        Caching = true,
        instance(DbRef,pclause(Head,Body)),
        skolemize((Head:-Body),SHead,SBody,0,_),
        recorded(prune_cache,prune([SHead|SBody]),_), !,
        p_message('in prune cache'),
	arg(22,S,Refine),
	(Refine = probabilistic -> inc_beta_counts(Path,beta); true), !.
get_gain1(S,Flag,DbRef,C,CL,EMin/EL,Last,Best/Node,Path,L1,Pos,Neg,OVars,E,Best1):-
        (false -> p_message('constraint violated'),
                Contradiction = true;
                Contradiction = false),
        arg(8,S,Caching),
        (Caching = true -> arg(15,S,CCLim),
		get_cache_entry(CCLim,C,Entry);
		Entry = false),
        arg(3,S,RefineOp),
	(RefineOp = false -> true ; refinement_ok(Entry,RefineOp)),
	instance(DbRef,pclause(Head,Body)),
	arg(32,S,Lang),
	(Lang = false -> true; lang_ok((Head:-Body),Lang)),
	arg(34,S,Proof),
	(Proof = restricted_sld ->
		Head1 = Head, Body1 = Body;
		functor(Head,Name,Arity),
		functor(Head1,Name,Arity),
		Body1 = Head1),
        prove_examples(S,Flag,Path,Contradiction,Entry,Best,CL,EL,(Head1:-Body1),Pos,Neg,
			PCvr,NCvr,Label),
        arg(4,S,Search/Evalfn),
	complete_clause_label(Evalfn,C,Label,Label1),
	compression_ok(Evalfn,Label1),
        get_search_keys(Search,Label1,SearchKeys),
        arg(6,S,Verbosity),
        (Verbosity >= 1 -> Label = [A,B|_], p_message(A/B); true),
        Node1 is Last + 1,
        arg(7,S,ClauseLength),
	(RefineOp = true -> true;
		get_ovars1(L1,OVars1),
		append(OVars1,OVars,OVars2)),
        (ClauseLength = CL -> true;
		(RefineOp = true ->
                	recorda(nodes,node(Node1,C,Path,EMin/EL,[],[],[],E),NodeRef);
                	recorda(nodes,node(Node1,L1,Path,EMin/EL,PCvr,
				NCvr,OVars2,E),NodeRef)),
		arg(19,S,Base),
                update_open_list(Base,SearchKeys,Label1,NodeRef)),
        ((RefineOp = true; (arg(28,S,HOVars),clause_ok(Contradiction,HOVars,OVars2))) ->
                update_best(S,C,PCvr,NCvr,Best/Node,Label1/Node1,Best1);
                Best1=Best/Node),
	arg(22,S,RefineType),
	(RefineType = probabilistic -> 
		update_probabilistic_refinement(S,Path,Best/Node,Best1,Label1,
			ClauseLength,CL);
		true), !.
get_gain1(_,_,_,_,_,_,_,Best,_,_,_,_,_,_,Best).


abandon_branch(S,DbRef):-
        arg(9,S,PruneDefined),
        PruneDefined = true,
        instance(DbRef,pclause(Head,Body)),
        prune((Head:-Body)), !,
        arg(6,S,Verbosity),
        (Verbosity >= 1 -> p_message(pruned); true).


clause_ok(false,V1,V2):-
        subset1(V1,V2).

% check to see if refinement has been produced before
refinement_ok(false,_):- !.
refinement_ok(_,false):- !.
refinement_ok(Entry,true):-
	(check_cache(Entry,pos,_); check_cache(Entry,neg,_)), !,
	p_message('redundant refinement'),
	fail.
refinement_ok(_,_).


% specialised redundancy check with equality theory
% used only to check if equalities introduced by splitting vars make
% literal to be added redundant
split_ok(false,_,_):- !.
split_ok(_,Clause,Lit):-
	functor(Lit,Name,_),
	not(Name = '='), 
	copy_term(Clause/Lit,Clause1/Lit1),
	lit_redun(Lit1,Clause1), !,
	p_message('redundant literal'), nl,
	fail.
split_ok(_,_,_).

lit_redun(Lit,(Head:-Body)):-
	!,
	lit_redun(Lit,(Head,Body)).
lit_redun(Lit,(L1,L2)):-
	Lit == L1, !.
lit_redun(Lit,(L1,L2)):-
	!,
	execute_equality(L1),
	lit_redun(Lit,L2).
lit_redun(Lit,L):-
	Lit == L.

execute_equality(Lit):-
	functor(Lit,'=',2), !,
	Lit.
execute_equality(_).
	
lang_ok((Head:-Body),N):-
	get_psyms((Head,Body),PSymList),
	(lang_ok1(PSymList,N) -> true;
		p_message('outside language bound'),
		fail).

get_psyms((L,B),[N/A|Syms]):-
	!,
	functor(L,N,A),
	get_psyms(B,Syms).
get_psyms(true,[]):- !.
get_psyms(L,[N/A]):-
	functor(L,N,A).

lang_ok1([],_).
lang_ok1([Pred|Preds],N):-
        length(Preds,N0),
        delete_all(Pred,Preds,Preds1),
        length(Preds1,N1),
        PredOccurs is N0 - N1 + 1,
	PredOccurs =< N,
	lang_ok1(Preds1,N).

get_user_refinement(Flag,Clause,Template,0):-
	Flag \= probabilistic,
	!,
	refine(Clause,Template).
get_user_refinement(probabilistic,Clause,Template,Id):-
	findall(P/R,(refine(Clause,R),find_beta_prob(refine(Clause,R),P),P>0),R1),
	probabilistic_extensions(Clause,R2),
	append(R1,R2,Refinements),
	quicksort(descending,Refinements,Sorted),
	member(_/Template,Sorted),
	(Template= (Head:-true) -> Clause1 = Head; Clause1 = Template),
	get_refine_id(refine(Clause,Clause1),Id).

find_beta_prob(Refinement,P):-
	beta(Refinement,A,B), !,
	P is A/(A+B).
find_beta_prob(_,0.5).

% find all clauses that can be reached using 
% refinements that can be reached from the current clause
% using beta counts only. These are available from previous runsa.
probabilistic_extensions(C,L):-
	findall(P/C1,(beta(refine(C,C1),A,B),nonvar(C1),P is A/(A+B),P>0),L1),
	probabilistic_extend(L1,L1,L).

% find extensions of all clauses in a list of prob/clause pairs
probabilistic_extend([],L,L).
probabilistic_extend([_/Clause|T],LSoFar,L):-
	probabilistic_extensions(Clause,L1),
	append(L1,LSoFar,L2),
	probabilistic_extend(T,L2,L).

get_refine_id(Refinement,Id):-
	recorded(refine,refine_id(Refinement,Id),_), !.
get_refine_id(Refinement,Id):-
	gen_refine_id(Id),
	recorda(refine,refine_id(Refinement,Id),_).

match_bot(false,Clause,Clause).
match_bot(reduction,Clause,Clause1):-
	match_lazy_bottom(Clause,Lits),
	get_pclause(Lits,[],Clause1,_,_,_).
match_bot(saturation,Clause,Clause1):-
	once(get_progol_clause(Clause,ProgolClause)),
	match_bot_lits(ProgolClause,[],Lits),
	get_pclause(Lits,[],Clause1,_,_,_).

match_bot_lits((Lit,Lits),SoFar,[LitNum|LitNums]):-
	!,
	match_bot_lit(Lit,LitNum),
	not(member(LitNum,SoFar)),
	match_bot_lits(Lits,[LitNum|SoFar],LitNums).
match_bot_lits(Lit,SoFar,[LitNum]):-
	match_bot_lit(Lit,LitNum),
	not(member(LitNum,SoFar)).

match_bot_lit(Lit,LitNum):-
	recorded(lits,lit_info(LitNum,_,Lit,_,_,_),_), 
	recorded(sat,bot_size(Last),_),
	LitNum =< Last.

match_lazy_bottom(Clause,SLits):-
	once(get_progol_clause(Clause,ProgolClause)),
	copy_term(Clause,CClause),
	split_clause(CClause,CHead,CBody),
	example_saturated(CHead),
	store(stage),
	set(stage,saturation),
	match_lazy_bottom1(CBody),
	reinstate(stage),
	match_bot_lits(ProgolClause,[],Lits),
	quicksort(ascending,Lits,SLits).


match_lazy_bottom1(Body):-
	Body,
	match_body_modes(Body),
	fail.
match_lazy_bottom1(_).

match_body_modes((CLit,CLits)):-
        !,
        match_mode(body,CLit),
        match_body_modes(CLits).
match_body_modes(CLit):-
        match_mode(body,CLit).

match_mode(_,true):- !.
match_mode(Loc,CLit):-
	functor(CLit,Name,Arity),
        functor(Mode,Name,Arity),
        setting(i,IVal),
	(Loc=head ->
		recorded(progol,modeh(_,Mode),_);
		recorded(progol,modeb(_,Mode),_)),
        split_args1(Mode,Arity,I,O,C),
        (recorded(sat,bot_size(BSize),DbRef)-> erase(DbRef); BSize = 0),
        (recorded(sat,last_lit(Last),DbRef1)-> erase(DbRef1); Last = 0),
        recorda(atoms,CLit,_),
        (Loc = head ->
                flatten(0,IVal,O/I/C,BSize,BSize1);
                flatten(0,IVal,I/O/C,BSize,BSize1)),
        recorda(sat,bot_size(BSize1),_),
        recorda(sat,last_lit(BSize1),_),
	fail.
match_mode(_,_).

% integrate head literal into lits database
% used during lazy evaluation of bottom clause
integrate_head_lit(HeadOVars):-
	ConstructBottom = true,
        example_saturated(Example),
	split_args(Example,Input,Output,Constants),
	integrate_args(unknown,Example,Output),
        match_mode(head,Example),
        get_ivars1(1,HeadOVars), !.
integrate_head_lit([]).


get_progol_clause((Lit:-true),PLit):-
	!,
	get_progol_lit(Lit,PLit).
get_progol_clause((Lit:-Lits),(PLit,PLits)):-
	!,
	get_progol_lit(Lit,PLit),
	get_progol_lits(Lits,PLits).
get_progol_clause(Lit,PLit):-
	get_progol_lit(Lit,PLit).

get_progol_lits((Lit,Lits),(PLit,PLits)):-
	!,
	get_progol_lit(Lit,PLit),
	get_progol_lits(Lits,PLits).
get_progol_lits(Lit,PLit):-
	get_progol_lit(Lit,PLit).

get_progol_lit(Lit,PLit):-
	functor(Lit,Name,Arity),
	functor(PLit,Name,Arity),
	get_progol_lit(Lit,PLit,Arity).

get_progol_lit(_,_,0):- !.
get_progol_lit(Lit,PLit,Arg):-
	arg(Arg,Lit,Term),
	(var(Term) -> arg(Arg,PLit,Term);arg(Arg,PLit,progol_const(Term))),
	NextArg is Arg - 1,
	get_progol_lit(Lit,PLit,NextArg), !.
	
% update hyperparameters of beta distrib for probabilistic refinement
update_probabilistic_refinement(_,Path,Best/_,Best1/_,Best1,_,_):-
	Best \= Best1,
	inc_beta_counts(Path,alpha), !.
update_probabilistic_refinement(S,Path,Label/_,Label/_,Label1,LMax,L):-
	Label = [_,_,_,Gain|_],
	Label1 = [_,_,_,Gain1|_],
        (Gain1 = Gain ->
		inc_beta_counts(Path,alpha);
		(LMax = L -> inc_beta_counts(Path,beta); true)).
	

% increment hyperparameters of beta distribution for each refinement
% only used if performing probabilistic refinements
inc_beta_counts([],_):- !.
inc_beta_counts([R1|R],Parameter):-
	inc_beta_count(R1,Parameter),
	inc_beta_counts(R,Parameter), !.

inc_beta_count(RefineId,Parameter):-
	recorded(refine,beta(RefineId,A,B),DbRef), !,
	erase(DbRef),
	(Parameter = beta -> A1 is A, B1 is B+1; A1 is A+1, B1 is B),
	recorda(refine,beta(RefineId,A1,B1),_).
inc_beta_count(RefineId,Parameter):-
	recorded(refine,refine_id(Clause,RefineId),_),
	beta(Clause,A,B), !,
	(Parameter = beta -> A1 is A, B1 is B+1; A1 is A+1, B1 is B),
	recorda(refine,beta(RefineId,A1,B1),_).
inc_beta_count(RefineId,Parameter):-
	(Parameter = beta -> A1 is 1, B1 is 2; A1 is 2, B1 is 1),
	recorda(refine,beta(RefineId,A1,B1),_), !.


% posonly formula as described by Muggleton, ILP-96
prove_examples(S,Flag,_,_,Entry,Best,CL,L2,Clause,Pos,Rand,PCover,RCover,[P,B,CL,I,G]):-
	arg(4,S,_/Evalfn),
	Evalfn = posonly, !,
        prove_pos(S,Flag,Entry,Best,[PC,L2],Clause,Pos,PCover,PC),
	prove_rand(S,Flag,Entry,Clause,Rand,RCover,RC),
	find_posgain(PCover,P),
	arg(16,S,M), arg(20,S,N),
	GC is (RC+1.0)/(N+2.0), % Laplace correction for small numbers
	A is log(P),
	B is log(GC),
	G is GC*M/P,
	C is CL/P,
	% Sz is CL*M/P,
	% D is M*G,
	%  I is M - D - Sz,
	I is A - B - C.
prove_examples(S,_,_,_,Entry,_,CL,_,_,Pos,Neg,Pos,Neg,[PC,NC,CL]):-
        arg(10,S,LazyOnCost),
        LazyOnCost = true, !,
        prove_lazy_cached(S,Entry,Pos,Neg,Pos1,Neg1),
        interval_count(Pos1,PC),
        interval_count(Neg1,NC).
prove_examples(S,_,_,true,Entry,_,CL,_,_,Pos,Neg,Pos,Neg,[PC,NC,CL]):-
        arg(11,S,LazyOnContra),
        LazyOnContra = true, !,
        prove_lazy_cached(S,Entry,Pos,Neg,Pos1,Neg1),
        interval_count(Pos1,PC),
        interval_count(Neg1,NC).
prove_examples(S,Flag,Path,_,Ent,Best,CL,L2,Clause,Pos,Neg,PCover,NCover,[PC,NC,CL]):-
        arg(7,S,ClauseLength),
        ClauseLength = CL,
	arg(22,S,Refine),
	interval_count(Pos,MaxPCount),
        (prove_neg(S,Flag,Ent,Best,[MaxPCount,CL],Clause,Neg,NCover,NC)-> true;
		(Refine = probabilistic ->
			Best \= [MaxPCount|_],
			inc_beta_counts(Path,beta);
			true),
		fail),
        arg(17,S,Noise), arg(18,S,MinAcc),
        (maxlength_neg_ok(Noise/MinAcc,Ent,MaxPCount,NC)-> true;
		arg(22,S,Refine),
		(Refine=probabilistic -> inc_beta_counts(Path,beta); true),
		fail), 
        prove_pos(S,Flag,Ent,Best,[PC,L2],Clause,Pos,PCover,PC),
        (maxlength_neg_ok(Noise/MinAcc,Ent,PC,NC)-> true;
		(Refine=probabilistic -> inc_beta_counts(Path,beta); true),
		fail), !.
prove_examples(S,Flag,_,_,Ent,Best,CL,L2,Clause,Pos,Neg,PCover,NCover,[PC,NC,CL]):-
        arg(7,S,ClauseLength),
        ClauseLength > CL,
        prove_pos(S,Flag,Ent,Best,[PC,L2],Clause,Pos,PCover,PC),
        prove_neg(S,Flag,Ent,Best,[PC,CL],Clause,Neg,NCover,NC),
	!.

prove_lazy_cached(S,Entry,Pos,Neg,Pos1,Neg1):-
        arg(8,S,Caching),
	Caching = true, !,
	(check_cache(Entry,pos,Pos1)->
		true;
		add_cache(Entry,pos,Pos),
		Pos1 = Pos),
	(check_cache(Entry,neg,Neg1)->
		true;
		add_cache(Entry,neg,Neg),
		Neg1 = Neg).
prove_lazy_cached(_,_,Pos,Neg,Pos,Neg).

complete_clause_label(posonly,_,L,L):- !.
complete_clause_label(user,Clause,[P,N,L],[P,N,L,Val]):-
        cost(Clause,[P,N,L],Cost), !,
        (Cost = inf -> Val is -10000; (Cost = -inf -> Val is 10000; Val is -Cost)).
complete_clause_label(EvalFn,Clause,[P,N,L],[P,N,L,Val]):-
	evalfn(EvalFn,[P,N,L],Val), !.
complete_clause_label(_,_,_,_):-
	p_message1('error'), p_message('incorrect evaluation/cost function'),
	fail.

get_search_keys(bf,[P,N,L,F|T],[L1,F]):-
	L1 is -1*L.
get_search_keys(df,[P,N,L,F|T],[L,F]).
get_search_keys(heuristic,[P,N,L,F|T],[F,L1]):-
	L1 is -1*L.

prove_pos(_,_,_,_,_,_,[],[],0):- !.
prove_pos(S,Flag,Entry,BestSoFar,PosSoFar,Clause,_,PCover,PCount):-
        arg(29,S,CCheck),
        CCheck = true,
        recorded(progol_dyn,covers(PCover,PCount),_), 
        pos_ok(S,Entry,BestSoFar,PosSoFar,Clause,PCover), !.
prove_pos(S,Flag,Entry,BestSoFar,PosSoFar,Clause,Pos,PCover,PCount):-
        prove_cache(Flag,S,pos,Entry,Clause,Pos,PCover,PCount),
        pos_ok(S,Entry,BestSoFar,PosSoFar,Clause,PCover), !.

prove_neg(S,_,Entry,_,_,_,[],[],0):-
	arg(8,S,Caching),
	(Caching = true -> add_cache(Entry,neg,[]); true), !.
prove_neg(S,_,_,_,_,_,_,NCover,NCount):-
        arg(29,S,CCheck),
        CCheck = true,
        recorded(progol_dyn,coversn(NCover,NCount),_), !.
prove_neg(S,Flag,Entry,BestSoFar,PosSoFar,Clause,Neg,NCover,NCount):-
        arg(12,S,LazyNegs),
        LazyNegs = true, !,
        lazy_prove_neg(S,Flag,Entry,BestSoFar,PosSoFar,Clause,Neg,NCover,NCount).
prove_neg(S,Flag,Entry,[P,0,L1|_],[P,L2],Clause,Neg,[],0):-
	arg(4,S,bf/coverage),
        L2 is L1 - 1,
	!,
        prove_cache(Flag,S,neg,Entry,Clause,Neg,0,[],0), !.
prove_neg(S,Flag,Entry,[P,N|_],[P,L1],Clause,Neg,NCover,NCount):-
	arg(4,S,bf/coverage),
        !,
        arg(7,S,ClauseLength),
        (ClauseLength = L1 ->
		arg(2,S,Explore),
		(Explore = true -> MaxNegs is N; MaxNegs is N - 1),
                MaxNegs >= 0,
                prove_cache(Flag,S,neg,Entry,Clause,Neg,MaxNegs,NCover,NCount),
		NCount =< MaxNegs;
                prove_cache(Flag,S,neg,Entry,Clause,Neg,NCover,NCount)),
        !.
prove_neg(S,Flag,Entry,_,[P1,L1],Clause,Neg,NCover,NCount):-
        arg(7,S,ClauseLength),
        ClauseLength = L1, !,
        arg(17,S,Noise), arg(18,S,MinAcc),
        get_max_negs(Noise/MinAcc,P1,N1),
        prove_cache(Flag,S,neg,Entry,Clause,Neg,N1,NCover,NCount),
	NCount =< N1,
        !.
prove_neg(S,Flag,Entry,_,_,Clause,Neg,NCover,NCount):-
        prove_cache(Flag,S,neg,Entry,Clause,Neg,NCover,NCount),
        !.

prove_rand(S,Flag,Entry,Clause,Rand,RCover,RCount):-
        prove_cache(Flag,S,rand,Entry,Clause,Rand,RCover,RCount),
        !.

lazy_prove_neg(S,Flag,Entry,[P,N|_],[P,_],Clause,Neg,NCover,NCount):-
	arg(4,S,bf/coverage),
        !,
        MaxNegs is N + 1,
        prove_cache(Flag,S,neg,Entry,Clause,Neg,MaxNegs,NCover,NCount),
        !.
lazy_prove_neg(S,Flag,Entry,_,[P1,_],Clause,Neg,NCover,NCount):-
        arg(17,S,Noise), arg(18,S,MinAcc),
        get_max_negs(Noise/MinAcc,P1,N1),
        MaxNegs is N1 + 1,
        prove_cache(Flag,S,neg,Entry,Clause,Neg,MaxNegs,NCover,NCount),
        !.

get_max_negs(N/_,_,N):- number(N), !.
get_max_negs(false/A,_,0):-
        A \= false,
        A >= 0.999, !.
get_max_negs(false/MinAcc,P1,N):-
        MinAcc \= false,
        number(P1),
        !,
        NR is (1-MinAcc)*P1/MinAcc,
	N1 is integer(NR),
        N is N1 + 1.
get_max_negs(_,_,0).


update_open_list(Base,[K1,K2],Label,NodeRef):-
	GainVal is K1*Base + K2,
	recordz(gains,gain(GainVal,Label,NodeRef),_),
	recorded(openlist,OpenList,DbRef),
	erase(DbRef),
	uniq_insert(descending,GainVal,OpenList,List1),
	recorda(openlist,List1,_).


fix_base(LastPos,LastNeg):-
	recorded(progol,set(clauselength,L),_),
        B1 is LastNeg + L + 1,
        ((LastPos =< B1) -> Base = B1; Base = LastPos),
        recorda(progol_dyn,base(Base),_).


pos_ok(S,Entry,_,[P,_],_,_):-
        arg(13,S,MinPos),
        P < MinPos, !,
        arg(8,S,Caching),
        (Caching = true ->
                add_prune_cache(Entry);
                true),
        fail.
pos_ok(S,_,_,_,_,_):-
        arg(4,S,_/Evalfn),
        not((Evalfn = coverage; Evalfn = compression)), !.
pos_ok(S,_,[_,_,_,C1|_],[P,L],_,_):-
        arg(4,S,_/Evalfn),
        evalfn(Evalfn,[P,0,L],C2),
        (C2 > C1;
	(arg(2,S,Explore),Explore=true,explore_eq(C1,C2))), !.


maxlength_neg_ok(Noise/false,Entry,_,N):-
        !,
        (N =< Noise -> true; add_prune_cache(Entry), fail).
maxlength_neg_ok(false/Acc,Entry,P,N):-
        !,
        A is P/(P+N),
        (A >= Acc -> true; add_prune_cache(Entry), fail).
maxlength_neg_ok(_,_,_,_).

compression_ok(compression,[P,_,L|_]):-
	!,
	P - L + 1 > 0.
compression_ok(_,_).

length_ok(S,MinLen,ClauseLen,LastD,ExpectedMin,ExpectedCLen):-
        arg(3,S,RefineOp),
        (RefineOp = true  -> L1 = 0; L1 = LastD),
        (L1 < MinLen->ExpectedMin = L1;ExpectedMin = MinLen),
        ExpectedCLen is ClauseLen + ExpectedMin,
        arg(7,S,CLength),
        ExpectedCLen =< CLength, !.

update_best(S,_,_,_,Best,[_,N|_]/_,Best):-
        arg(17,S,Noise),
        Noise \= false,
        N > Noise, !.
update_best(S,_,_,_,Best,[P,N|_]/_,Best):-
        arg(18,S,MinAcc),
        MinAcc \= false,
        Accuracy is P/(P + N),
        Accuracy < MinAcc, !.
update_best(S,_,_,_,Best,[_,_,_,Compr|_]/_,Best):-
        arg(4,S,_/compression),
        Compr =< 0, !.
update_best(S,Clause,PCover,NCover,Label/_,Label1/Node1,Label1/Node1):-
	Label = [_,_,_,Gain|_],
	Label1 = [_,_,_,Gain1|_],
	Gain1 > Gain, !,
        recorded(search,selected(_,_,_,_),DbRef),
        erase(DbRef),
        recorda(search,selected(Label1,Clause,PCover,NCover),_),
        show_clause(Label1,Clause,Node1,false),
        record_clause(Label1,Clause,Node1,false).
update_best(S,Clause,_,_,Label/Node,Label1/Node1,Label/Node):-
        arg(2,S,Explore),
        Explore = true,
	Label = [_,_,_,Gain|_],
	Label1 = [_,_,_,Gain1|_],
        explore_eq(Gain1,Gain), !,
	arg(6,S,Verbosity),
	(Verbosity >= 2 ->
        	show_clause(Label1,Clause,Node1,explore),
        	record_clause(Label1,Clause,Node1,explore);
		true).
update_best(_,_,_,_,Best,_,Best).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P R U N I N G

get_node([Gain|_],DbRef,Gain,Node):-
        recorded(gains,gain(Gain,_,Node),DbRef).
get_node([_|Gains],DbRef,Gain,Node):-
	get_node(Gains,DbRef,Gain,Node).

prune_open(S,_,_):-
	arg(25,S,OSize),
	OSize \= inf,
        retractall(progol_dyn,in_beam(_)),
        recorda(progol_dyn,in_beam(0),_),
        recorded(openlist,Gains,_),
        get_node(Gains,DbRef,Gain,NodeNum),
        recorded(progol_dyn,in_beam(N),DbRef1),
        (N < OSize->
                erase(DbRef1),
                N1 is N + 1,
                recorda(progol_dyn,in_beam(N1),_);
                erase(DbRef),
                p1_message('non-admissible removal'), p_message(NodeNum),
        	recorded(gains,gain(Gain,_,NodeNum),DbRef3),
                erase(DbRef3)),
        fail.
prune_open(S,_,_):-
        arg(4,S,Search),
        arg(2,S,Explore),
	(Explore = true; not(built_in_prune(Search))), !.
prune_open(_,_/N,_/N):- !.
prune_open(S,_,[_,_,L,Best|_]/_):-
        arg(4,S,_/Evalfn),
	Evalfn = coverage, !,
	arg(27,S,Eq),
        (Eq = true -> MaxLength is L; MaxLength is L - 1),
        remove1(MaxLength,Best),
        !.
prune_open(S,_,[_,_,_,Best|_]/_):-
        arg(4,S,heuristic/Evalfn),
        (Evalfn = compression ; Evalfn = posonly), !,
        remove2(S,Best).
% pruning for laplace and m-estimates devised by James Cussens
prune_open(S,_,[_,_,L,Best|_]/_):-
        arg(4,S,_/Evalfn),
        Evalfn = laplace, !,
        arg(27,S,Eq),
        (Eq = true -> MaxLength is L; MaxLength is L - 1),
        MinPos is (Best/(1-Best))-1,
        remove1(MaxLength,MinPos).
prune_open(S,_,[_,_,L,Best|_]/_):-
        arg(4,S,_/Evalfn),
        (Evalfn = auto_m; Evalfn = mestimate), !,
        arg(27,S,Eq),
        (Eq = true -> MaxLength is L; MaxLength is L - 1),
        setting(prior,Prior),
        ((Evalfn = mestimate,setting(m,M)) ->
            MinPos is M*(Best-Prior)/(1-Best);
            MinPos is ((Best-Prior)/(1-Best))^2),
        remove1(MaxLength,MinPos).
prune_open(_,_,_).


built_in_prune(heuristic/E):-
	(E = compression; E = posonly).
built_in_prune(_/E):-
	(E = coverage; E = laplace; E = auto_m; E = mestimate).

remove1(MaxLength,Best):-
        recorded(gains,gain(_,[P,_,L1|_],Node1),DbRef),
        (P < Best; (P=Best,L1 >= MaxLength)),
        erase(DbRef),
        fail.
remove1(_,_).

% pruning for posonly developed in discussions with James Cussens
remove2(S,Best):-
	arg(4,S,_/Evalfn),
        recorded(gains,gain(_,[P,_,L|_],Node1),DbRef),
	(Evalfn = posonly ->
		arg(20,S,RSize),
		Max is log(P) + log(RSize+2.0) - (L+1)/P;
		Max is P - L + 1),
	Best >= Max,
        erase(DbRef),
        fail.
remove2(_,_).

get_nextbest(NodeRef):-
        recorded(openlist,[Gain|T],DbRef),
        recorded(gains,gain(Gain,_,NodeRef),DbRef1), !,
        erase(DbRef1),
        recordz(search,nextnode(NodeRef),_).
get_nextbest(NodeRef):-
        recorded(openlist,[_|T],DbRef),
        erase(DbRef),
        recorda(openlist,T,_),
        get_nextbest(NodeRef), !.
get_nextbest(none).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P R O V E

% prove with caching
% if entry exists in cache, then return it
% otherwise find and cache cover 
% if ``exact'' flag is set then only check proof for examples
% in the part left over due to lazy theorem-proving
% ideas in caching developed in discussions with James Cussens

prove_cache(exact,S,Type,Entry,Clause,Intervals,IList,Count):-
	!,
	(Intervals = Exact/Left ->
        	arg(14,S,Depth),
        	prove(Depth,Type,Clause,Left,IList1,Count1),
		append(IList1,Exact,IList),
		interval_count(Exact,Count0),
		Count is Count0 + Count1;
		IList = Intervals,
		interval_count(IList,Count)),
        arg(8,S,Caching),
        (Caching = true -> add_cache(Entry,Type,IList); true).
prove_cache(upper,S,Type,Entry,Clause,Intervals,IList,Count):-
        arg(8,S,Caching),
        Caching = true, !,
        arg(14,S,Depth),
        (check_cache(Entry,Type,Cached)->
                prove_cached(S,Type,Entry,Cached,Clause,Intervals,IList,Count);
                prove_intervals(Depth,Type,Clause,Intervals,IList,Count),
                add_cache(Entry,Type,IList)).
prove_cache(upper,S,Type,_,Clause,Intervals,IList,Count):-
        arg(14,S,Depth),
	(Intervals = Exact/Left ->
		append(Left,Exact,IList1),
        	prove(Depth,Type,Clause,IList1,IList,Count);
        	prove(Depth,Type,Clause,Intervals,IList,Count)).

prove_intervals(Depth,Type,Clause,I1/Left,IList,Count):- 
	!,
	append(Left,I1,Intervals),
	prove(Depth,Type,Clause,Intervals,IList,Count).
prove_intervals(Depth,Type,Clause,Intervals,IList,Count):- 
	prove(Depth,Type,Clause,Intervals,IList,Count).

prove_cached(S,Type,Entry,I1/Left,Clause,Intervals,IList,Count):-
        !,
        arg(14,S,Depth),
        prove(Depth,Type,Clause,Left,I2,_),
        append(I2,I1,I),
        (Type = pos ->
                arg(5,S,Greedy),
                (Greedy = true ->
                        intervals_intersection(I,Intervals,IList);
                        IList = I);
                IList = I),
        interval_count(IList,Count),
        update_cache(Entry,Type,IList).
prove_cached(S,Type,Entry,I1,_,Intervals,IList,Count):-
	(Type = pos -> arg(5,S,Greedy),
		(Greedy = true ->
			intervals_intersection(I1,Intervals,IList);
			IList = I1);
		IList = I1),
	interval_count(IList,Count),
	update_cache(Entry,Type,IList).

% prove at most Max atoms
prove_cache(exact,S,Type,Entry,Clause,Intervals,Max,IList,Count):-
	!,
	(Intervals = Exact/Left ->
		interval_count(Exact,Count0),
		Max1 is Max - Count0,
        	arg(12,S,LNegs),
        	arg(14,S,Depth),
        	prove(LNegs/false,Depth,Type,Clause,Left,Max1,IList1,Count1),
		append(IList1,Exact,Exact1),
		find_lazy_left(S,Type,Exact1,Left1),
		IList = Exact1/Left1,
		Count is Count0 + Count1;
		IList = Intervals,
		interval_count(Intervals,Count)),
        arg(8,S,Caching),
        (Caching = true -> add_cache(Entry,Type,IList); true).
prove_cache(upper,S,Type,Entry,Clause,Intervals,Max,IList,Count):-
        arg(8,S,Caching),
        Caching = true, !,
        (check_cache(Entry,Type,Cached)->
                prove_cached(S,Type,Entry,Cached,Clause,Intervals,Max,IList,Count);
                (prove_intervals(S,Type,Clause,Intervals,Max,IList1,Count)->
                        find_lazy_left(S,Type,IList1,Left1),
                        add_cache(Entry,Type,IList1/Left1),
			IList = IList1/Left1,
                        retractall(progol_dyn,example_cache(_));
                        collect_example_cache(IList),
                        add_cache(Entry,Type,IList),
                        fail)).
prove_cache(upper,S,Type,_,Clause,Intervals,Max,IList/Left1,Count):-
        arg(8,S,Caching),
        arg(12,S,LNegs),
        arg(14,S,Depth),
	(Intervals = Exact/Left ->
		append(Left,Exact,IList1),
        	prove(LNegs/Caching,Depth,Type,Clause,IList1,Max,IList,Count);
        	prove(LNegs/Caching,Depth,Type,Clause,Intervals,Max,IList,Count)),
	find_lazy_left(S,Type,IList,Left1).

prove_intervals(S,Type,Clause,I1/Left,Max,IList,Count):-
        !,
        arg(8,S,Caching),
        arg(12,S,LNegs),
        arg(14,S,Depth),
        append(Left,I1,Intervals),
        prove(LNegs/Caching,Depth,Type,Clause,Intervals,Max,IList,Count).
prove_intervals(S,Type,Clause,Intervals,Max,IList,Count):-
        arg(8,S,Caching),
        arg(12,S,LNegs),
        arg(14,S,Depth),
        prove(LNegs/Caching,Depth,Type,Clause,Intervals,Max,IList,Count).


prove_cached(S,Type,Entry, I1/Left,Clause,_,Max,IList/Left1,Count):-
        !,
        arg(8,S,Caching),
        arg(12,S,LNegs),
        arg(14,S,Depth),
        interval_count(I1,C1),
        Max1 is Max - C1,
        Max1 >= 0,
        (prove(LNegs/Caching,Depth,Type,Clause,Left,Max1,I2,C2)->
                append(I2,I1,IList),
                Count is C2 + C1,
                find_lazy_left(S,Type,IList,Left1),
                update_cache(Entry,Type,IList/Left1),
                retractall(progol_dyn,example_cache(_));
                collect_example_cache(I2/Left1),
                append(I2,I1,IList),
                update_cache(Entry,Type,IList/Left1),
                fail).
prove_cached(_,neg,_, I1/L1,_,_,_,I1/L1,C1):-
	!,
	interval_count(I1,C1).
prove_cached(S,_,_,I1,_,_,Max,I1,C1):-
	interval_count(I1,C1),
	arg(12,S,LNegs),
	(LNegs = true ->true; C1 =< Max).

collect_example_cache(Intervals/Left):-
	recorded(progol_dyn,example_cache([Last|Rest]),DbRef), 
	erase(DbRef),
	reverse([Last|Rest],IList),
	list_to_intervals1(IList,Intervals),
	Next is Last + 1,
	recorded(progol,size(neg,LastN),_),
	(Next > LastN -> Left = []; Left = [Next-LastN]).

find_lazy_left(S,_,_,[]):-
        arg(12,S,LazyNegs),
        LazyNegs = false, !.
find_lazy_left(_,_,[],[]).
find_lazy_left(S,Type,[_-F],Left):-
        !,
        F1 is F + 1,
	(Type = pos -> arg(16,S,Last);
		(Type = neg -> arg(24,S,Last);
			(Type = rand -> arg(20,S,Last); Last = F))),
        (F1 > Last -> Left = []; Left = [F1-Last]).
find_lazy_left(S,Type,[_|T1],Left):-
        find_lazy_left(S,Type,T1,Left).


% prove atoms specified by Type and index set using Clause.
% dependent on data structure used for index set:
% currently index set is a list of intervals
% return atoms proved and their count
% added depth argument from Progol 2.4 onwards
% if tail-recursive version is needed see below

prove(_,_,_,[],[],0).
prove(Depth,Type,Clause,[Interval|Intervals],IList,Count):-
	index_prove(Depth,Type,Clause,Interval,I1,C1),
	prove(Depth,Type,Clause,Intervals,I2,C2),
	append(I2,I1,IList),
	Count is C1 + C2.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T A I L - R E C U R S I V E  P R O V E/6
 
% use this rather than the prove/6 above for tail recursion
% written by James Cussens
 
% prove(Depth,Type,Clause,Intervals,IList,Count):-
       % prove2(Intervals,Depth,Type,Clause,0,IList,Count).
 
% code for tail recursive cover testing
% starts here

%prove(Depth,Type,Clause,Intervals,IList,Count):-
%       prove2(Intervals,Depth,Type,Clause,0,IList,Count).
 
% code for tail recursive cover testing
% starts here

% when we know that Sofar is a variable.
prove2([],_,_,_,Count,[],Count).
prove2([Current-Finish|Intervals],Depth,Type,(Head:-Body),InCount,Sofar,OutCount) :-
        \+ ((example(Current,Type,Head),depth_bound_call(Body,Depth))), %uncovered
        !,
        (Current>=Finish ->
            prove2(Intervals,Depth,Type,(Head:-Body),InCount,Sofar,OutCount);
            Next is Current+1,!,
            prove2([Next-Finish|Intervals],Depth,Type,(Head:-Body),InCount,Sofar,OutCount)
        ).
prove2([Current-Finish|Intervals],Depth,Type,Clause,InCount,Sofar,OutCount) :-
        (Current>=Finish ->
            Sofar=[Current-Current|Rest],
            MidCount is InCount+1,!,
            prove2(Intervals,Depth,Type,Clause,MidCount,Rest,OutCount);
            Next is Current+1,
            Sofar=[Current-_Last|_Rest],!,
            prove3([Next-Finish|Intervals],Depth,Type,Clause,InCount,Sofar,OutCount)
        ).
 
 
%when Sofar is not a variable
prove3([Current-Finish|Intervals],Depth,Type,(Head:-Body),InCount,Sofar,OutCount) :-
        \+ ((example(Current,Type,Head),depth_bound_call(Body,Depth))), %uncovered
        !,
        Last is Current-1, %found some previously
        Sofar=[Start-Last|Rest], %complete found interval
        MidCount is InCount+Current-Start,
        (Current>=Finish ->
            prove2(Intervals,Depth,Type,(Head:-Body),MidCount,Rest,OutCount);
            Next is Current+1,!,
            prove2([Next-Finish|Intervals],Depth,Type,(Head:-Body),MidCount,Rest,OutCount)
        ).
prove3([Current-Finish|Intervals],Depth,Type,Clause,InCount,Sofar,OutCount) :-
        (Current>=Finish ->
            Sofar=[Start-Finish|Rest],
            MidCount is InCount+Finish-Start+1,!,
            prove2(Intervals,Depth,Type,Clause,MidCount,Rest,OutCount);
            Next is Current+1,!,
            prove3([Next-Finish|Intervals],Depth,Type,Clause,InCount,Sofar,OutCount)
        ).
 
 
% code for tail recursive cover testing
% ends here

 

index_prove(_,_,_,Start-Finish,[],0):-
	Start > Finish, !.
index_prove(Depth,Type,Clause,Start-Finish,IList,Count):-
	index_prove1(Depth,Type,Clause,Start,Finish,Last),
	Last0 is Last - 1 ,
	Last1 is Last + 1,
	(Last0 >= Start->
		index_prove(Depth,Type,Clause,Last1-Finish,Rest,Count1),
		IList = [Start-Last0|Rest],
		Count is Last - Start + Count1;
		index_prove(Depth,Type,Clause,Last1-Finish,IList,Count)).

prove1(G):-
	depth_bound_call(G), !.
	
index_prove1(_,_,_,Num,Last,Num):-
	Num > Last, !.
index_prove1(Depth,Type,(Head:-Body),Num,Finish,Last):-
	\+((\+((example(Num,Type,Head),depth_bound_call(Body,Depth))))), !,
	Num1 is Num + 1,
	index_prove1(Depth,Type,(Head:-Body),Num1,Finish,Last).
index_prove1(_,_,_,Last,_,Last).


% proves at most Max atoms using Clause.

prove(_,_,_,_,[],_,[],0).
prove(Flags,Depth,Type,Clause,[Interval|Intervals],Max,IList,Count):-
        index_prove(Flags,Depth,Type,Clause,Interval,Max,I1,C1), !,
        Max1 is Max - C1,
        prove(Flags,Depth,Type,Clause,Intervals,Max1,I2,C2),
        append(I2,I1,IList),
        Count is C1 + C2.


index_prove(_,_,_,_,Start-Finish,_,[],0):-
        Start > Finish, !.
index_prove(Flags,Depth,Type,Clause,Start-Finish,Max,IList,Count):-
        index_prove1(Flags,Depth,Type,Clause,Start,Finish,0,Max,Last),
        Last0 is Last - 1 ,
        Last1 is Last + 1,
        (Last0 >= Start->
                Max1 is Max - Last + Start,
		((Max1 = 0, Flags = true/_) ->
                        Rest = [], Count1 = 0;
                	index_prove(Flags,Depth,Type,Clause,Last1-Finish,
					Max1,Rest,Count1)),
                IList = [Start-Last0|Rest],
                Count is Last - Start + Count1;
                index_prove(Flags,Depth,Type,Clause,Last1-Finish,Max,IList,Count)).

index_prove1(false/_,_,_,_,_,_,Proved,Allowed,_):-
        Proved > Allowed, !, fail.
index_prove1(_,_,_,_,Num,Last,_,_,Num):-
        Num > Last, !.
index_prove1(true/_,_,_,_,Num,_,Allowed,Allowed,Num):- !.
index_prove1(LNegs/Caching,Depth,Type,(Head:-Body),Num,Finish,Proved,Allowed,Last):-
        \+((\+((example(Num,Type,Head),depth_bound_call(Body,Depth))))), !,
        Num1 is Num + 1,
        Proved1 is Proved + 1,
        (Caching = true ->
                (recorded(progol_dyn,example_cache(L),DbRef)->
                        erase(DbRef),
                        recorda(progol_dyn,example_cache([Num|L]),_);
                        recorda(progol_dyn,example_cache([Num]),_));
                true),
        index_prove1(LNegs/Caching,Depth,Type,(Head:-Body),Num1,Finish,Proved1,Allowed,Last).
index_prove1(_,_,_,_,Last,_,_,_,Last).

% general prove at least Min atoms using Clause.
prove_at_least(Type,Clause,Min,Cover,C):-
        split_clause(Clause,Head,Body),
        recordz(pclause,pclause(Head,Body),DbRef),
        recorded(progol,atoms(Type,Atoms),_),
        recorded(progol,set(depth,Depth),_),
        prove(Depth,Type,(Head:-Body),Atoms,Cover,C),
        erase(DbRef),
        C >= Min.

% general prove at most Max atoms using Clause.
prove_at_most(Type,Clause,Max,Cover,C):-
        split_clause(Clause,Head,Body),
        recordz(pclause,pclause(Head,Body),DbRef),
        recorded(progol,atoms(Type,Atoms),_),
        N1 is Max + 1,
        recorded(progol,set(depth,Depth),_),
        prove(Depth,Type,(Head:-Body),Atoms,N1,Cover,C),
        erase(DbRef),
        C =< Max.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C A C H I N G

clear_cache:-
	retractall(cache,_),
	retractall(prune_cache,_).

check_cache(Entry,Type,I):-
	Entry \= false,
        recorded(cache,Entry,_), !,
        functor(Entry,_,Arity),
        (Type = pos -> Arg is Arity - 1; Arg is Arity),
        arg(Arg,Entry,I),
        not(var(I)).

add_cache(false,_,_):- !.
add_cache(Entry,Type,I):-
        (recorded(cache,Entry,DbRef)-> erase(DbRef); true),
        functor(Entry,_,Arity),
        (Type = pos -> Arg is Arity - 1; Arg is Arity),
        (arg(Arg,Entry,I)-> recorda(cache,Entry,_);
                        true), !.

update_cache(Entry,Type,I):-
	Entry \= false,
	functor(Entry,Name,Arity),
	(Type = pos -> Arg is Arity - 1; Arg is Arity),
	arg(Arg,Entry,OldI),
	OldI = _/_,
	recorded(cache,Entry,DbRef), 
	erase(DbRef),
	functor(NewEntry,Name,Arity),
	Arg0 is Arg - 1,
	copy_args(Entry,NewEntry,1,Arg0),
	arg(Arg,NewEntry,I), 
	Arg1 is Arg + 1,
	copy_args(Entry,NewEntry,Arg1,Arity),
	recorda(cache,NewEntry,_), !.
update_cache(_,_,_).

	
add_prune_cache(false):- !.
add_prune_cache(Entry):-
	(recorded(progol,set(caching,true),_)->
		functor(Entry,_,Arity),
		A1 is Arity - 2,
		arg(A1,Entry,Clause),
		recorda(prune_cache,prune(Clause),_);
		true).

get_cache_entry(Max,Clause,Entry):-
        skolemize(Clause,Head,Body,0,_),
	length(Body,L1),
	Max >= L1 + 1,
        hash_term([Head|Body],Entry), !.
get_cache_entry(_,_,false).

% upto 3-argument indexing using predicate names in a clause
hash_term([L0,L1,L2,L3,L4|T],Entry):-
        !,
        functor(L1,P1,_), functor(L2,P2,_),
        functor(L3,P3,_), functor(L4,P4,_),
        functor(Entry,P4,6),
        arg(1,Entry,P2), arg(2,Entry,P3),
        arg(3,Entry,P1), arg(4,Entry,[L0,L1,L2,L3,L4|T]).
hash_term([L0,L1,L2,L3],Entry):-
        !,
        functor(L1,P1,_), functor(L2,P2,_),
        functor(L3,P3,_),
        functor(Entry,P3,5),
        arg(1,Entry,P2), arg(2,Entry,P1),
        arg(3,Entry,[L0,L1,L2,L3]).
hash_term([L0,L1,L2],Entry):-
        !,
        functor(L1,P1,_), functor(L2,P2,_),
        functor(Entry,P2,4),
        arg(1,Entry,P1), arg(2,Entry,[L0,L1,L2]).
hash_term([L0,L1],Entry):-
        !,
        functor(L1,P1,_),
        functor(Entry,P1,3),
        arg(1,Entry,[L0,L1]).
hash_term([L0],Entry):-
        functor(L0,P0,_),
        functor(Entry,P0,3),
        arg(1,Entry,[L0]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C O M M A N D S

sat(Num):-
	example(Num,pos,_),
	sat(pos,Num), !.

sat(Type,Num):-
        setting(construct_bottom,false), !,
        sat_prelims,
	example(Num,Type,Example),
	p1_message('sat'), p_message(Num), p_message(Example),
	record_sat_example(Num),
	recorda(sat,sat(Num,Type),_),
	recorda(sat,head_ovars([]),_).
sat(Type,Num):-
	setting(lazy_bottom,true), !,
	sat_prelims,
	example(Num,Type,Example),
	p1_message('sat'), p_message(Num), p_message(Example),
	record_sat_example(Num),
	recorda(sat,sat(Num,Type),_),
	integrate_head_lit(HeadOVars),
	recorda(sat,head_ovars(HeadOVars),_).
sat(Type,Num):-
	set(stage,saturation),
	sat_prelims,
	example(Num,Type,Example),
	p1_message('sat'), p_message(Num), p_message(Example),
	record_sat_example(Num),
	recorda(sat,sat(Num,Type),_),
	split_args(Example,Input,Output,Constants),
	integrate_args(unknown,Example,Output),
	StartClock is cputime,
	recordz(atoms,Example,_),
	recorded(progol,set(i,Ival),_),
	flatten(0,Ival,Output/Input/Constants,0,Last1),
	recorded(lits,lit_info(1,_,Atom,_,_,_),_),
	get_vars(Atom,Output,HeadOVars),
	recorda(sat,head_ovars(HeadOVars),_),
	get_vars(Atom,Input,HeadIVars),
	recorda(sat,head_ivars(HeadIVars),_),
	functor(Example,Name,Arity), 
	get_determs(Name/Arity,L),
	(recorded(progol,determination(Name/Arity,'='/2),_)->
		recorda(sat,set(eq,true),_);
		true),
	update_modetypes(L,L1),
	get_atoms(L1,1,Ival,Last1,Last),
	StopClock is cputime,
	Time is StopClock - StartClock,
	recorda(sat,last_lit(Last),_),
	recorda(sat,bot_size(Last),_),
	rm_moderepeats(Last,Repeats),
	rm_uselesslits(Last,NotConnected),
	rm_commutative(Last,Commutative),
	rm_symmetric(Last,Symmetric),
	get_implied,
	TotalLiterals is Last - Repeats - NotConnected - Commutative - Symmetric,
	show(bottom),
	p1_message('literals'), p_message(TotalLiterals),
	p1_message('saturation time'), p_message(Time),
	noset(stage).
sat(_,_):-
	noset(stage).

reduce:-
	setting(search,Search), 
	reduce(Search), !.

% iterative beam search as described by Ross Quinlan + MikeCameron-Jones, IJCAI-95
reduce(ibs):-
	!,
	retractall(ibs,_),
	setting(evalfn,Evalfn),
	store(search),
	store(openlist),
	store(caching),
	store(explore),
	set(openlist,1),
	set(explore,true),
	set(caching,true),
	set(search,bf),
	recorda(ibs,rval(1.0),_),
	recorda(ibs,nodes(0),_),
	recorded(sat,sat(Num,Type),_),
	example(Num,Type,Example),
	get_start_label(Evalfn,Label),
	recorda(ibs,selected(Label,(Example:-true),[Num-Num],[]),_),
	Start is cputime,
	repeat,
	setting(openlist,OldOpen),
	p1_message('ibs beam width'), p_message(OldOpen),
	reduce(bf),
	recorded(search,current(_,Nodes0,[PC,NC|_]/_),_),
	N is NC + PC,
	estimate_error_rate(Nodes0,0.5,N,NC,NewR),
	p1_message('ibs estimated error'), p_message(NewR),
	recorded(ibs,rval(OldR),DbRef1),
	recorded(ibs,nodes(Nodes1),DbRef2),
        recorded(search,selected(BL,RCl,PCov,NCov),_),
	erase(DbRef1),
	erase(DbRef2),
	NewOpen is 2*OldOpen,
	Nodes2 is Nodes0 + Nodes1,
	set(openlist,NewOpen),
	recorda(ibs,rval(NewR),_),
	recorda(ibs,nodes(Nodes2),_),
	((NewR >= OldR; NewOpen > 512) -> true;
		recorded(ibs,selected(_,_,_,_),DbRef3),
		erase(DbRef3),
		recorda(ibs,selected(BL,RCl,PCov,NCov),_),
		fail),
	!,
	Stop is cputime,
	Time is Stop - Start,
	recorded(ibs,nodes(Nodes),_),
        recorded(ibs,selected(BestLabel,RClause,PCover,NCover),_),
	add_hyp(BestLabel,RClause,PCover,NCover),
	p1_message('ibs clauses constructed'), p_message(Nodes),
	p1_message('ibs search time'), p_message(Time),
	p_message('ibs best clause'),
	pp_dclause(RClause),
	show_stats(Evalfn,BestLabel),
	record_search_stats(RClause,Nodes,Time),
	reinstate(search),
	reinstate(openlist),
	reinstate(caching),
	reinstate(explore).

% iterative language search as described by Rui Camacho, 1996
reduce(ils):-
	retractall(ils,_),
	setting(evalfn,Evalfn),
	store(search),
	store(caching),
	store(language),
	set(language,1),
	set(search,bf),
	set(caching,true),
	recorda(ils,nodes(0),_),
	recorded(sat,sat(Num,Type),_),
	example(Num,Type,Example),
	get_start_label(Evalfn,Label),
	recorda(ils,selected(Label,(Example:-true),[Num-Num],[]),_),
	Start is cputime,
	repeat,
	setting(language,OldLang),
	p1_message('ils language setting'), p_message(OldLang),
	reduce(bf),
	recorded(search,current(_,Nodes0,_),_),
	recorded(ils,nodes(Nodes1),DbRef1),
        recorded(search,selected([P,N,L,F|T],RCl,PCov,NCov),_),
	recorded(ils,selected([_,_,_,F1|_],_,_,_),DbRef2),
	erase(DbRef1),
	NewLang is OldLang + 1,
	Nodes2 is Nodes0 + Nodes1,
	set(language,NewLang),
	recorda(ils,nodes(Nodes2),_),
	(F1 >= F -> true;
		erase(DbRef2),
		recorda(ils,selected([P,N,L,F|T],RCl,PCov,NCov),_),
		set(best,[P,N,L,F|T]),
		fail),
	!,
	Stop is cputime,
	Time is Stop - Start,
	recorded(ils,nodes(Nodes),_),
        recorded(ils,selected(BestLabel,RClause,PCover,NCover),_),
	add_hyp(BestLabel,RClause,PCover,NCover),
	p1_message('ils clauses constructed'), p_message(Nodes),
	p1_message('ils search time'), p_message(Time),
	p_message('ils best clause'),
	pp_dclause(RClause),
	show_stats(Evalfn,BestLabel),
	record_search_stats(RClause,Nodes,Time),
	reinstate(search),
	reinstate(language),
	reinstate(caching).

reduce(_):-
	set(stage,reduction),
	p_message('reduce'),
	reduce_prelims(L,P,N),
	recorda(openlist,[],_),
	get_search_settings(S),
	arg(4,S,Search/Evalfn),
	get_start_label(Evalfn,Label),
	recorded(sat,sat(Num,Type),_),
	example(Num,Type,Example),
	recorda(search,selected(Label,(Example:-true),[Num-Num],[]),_),
	arg(13,S,MinPos),
	interval_count(P,PosLeft),
	PosLeft >= MinPos, !,
	add_hyp(Label,(Example:-true),[Num-Num],[]),
        (recorded(progol,max_set(Type,Num,Label1,ClauseNum),_)->
		BestSoFar = Label1/ClauseNum;
		(recorded(progol,set(best,Label2),_)->
			BestSoFar = Label2/0;
			BestSoFar = Label/0)),
        recorda(search,best_label(BestSoFar),_),
	p1_message('best label so far'), p_message(BestSoFar),
        arg(3,S,RefineOp),
	StartClock is cputime,
        (RefineOp = true ->
		clear_cache,
		interval_count(P,MaxPC),
		recorda(progol_dyn,max_head_count(MaxPC),_),
                get_gains(S,0,BestSoFar,[],false,[],0,L,[false],P,N,[],1,Last,NextBest);
                get_gains(S,0,BestSoFar,[],false,[],0,L,[1],P,N,[],1,Last,NextBest),
		update_max_head_count(0,Last)),
	recorda(nodes,expansion(1,1,Last),_),
	get_nextbest(_),
	recorda(search,current(1,Last,NextBest),_),
	search(S,Nodes),
	StopClock is cputime,
	Time is StopClock - StartClock,
        recorded(search,selected(BestLabel,RClause,PCover,NCover),_),
	recorded(openlist,_,DbRef),
	erase(DbRef),
	add_hyp(BestLabel,RClause,PCover,NCover),
	p1_message('clauses constructed'), p_message(Nodes),
	p1_message('search time'), p_message(Time),
	p_message('best clause'),
	pp_dclause(RClause),
	show_stats(Evalfn,BestLabel),
	record_search_stats(RClause,Nodes,Time),
	noset(stage),
	!.
reduce(_):-
        recorded(search,selected(BestLabel,RClause,PCover,NCover),_),
	recorded(openlist,_,DbRef),
	erase(DbRef),
	add_hyp(BestLabel,RClause,PCover,NCover),
	p_message('best clause'),
	pp_dclause(RClause),
	(setting(evalfn,Evalfn) -> true; Evalfn = coverage),
	show_stats(Evalfn,BestLabel),
	noset(stage),
	!.


estimate_error_rate(H,Del,N,E,R):-
	TargetProb is 1-exp(log(1-Del)/H),
	estimate_error(1.0/0.0,0.0/1.0,TargetProb,N,E,R).

estimate_error(L/P1,U/P2,P,N,E,R):-
	M is (L+U)/2,
	binom_lte(N,M,E,P3),
	ADiff is abs(P - P3),
	(ADiff < 0.001 ->
		R is M;
		(P3 > P ->
			estimate_error(L/P1,M/P3,P,N,E,R);
			estimate_error(M/P3,U/P2,P,N,E,R)
		)
	).
		
		
	

sat_prelims:-
	clean_up_sat,
	clean_up_reduce,
	clear_hyp,
	reset_counts,
	set_up_builtins.

reduce_prelims(L,P,N):-
	clean_up_reduce,
	check_posonly,
	check_auto_refine,
	(recorded(sat,last_lit(L),_)-> true;
		L = 0, recorda(sat,last_lit(L),_)),
	(recorded(sat,bot_size(B),_)-> true;
		B = 0, recorda(sat,bot_size(B),_)),
        ((recorded(progol,lazy_evaluate(_),_);setting(greedy,true))->
                recorded(progol,atoms_left(pos,P),_);
                recorded(progol,atoms(pos,P),_)),
	recorded(progol,size(pos,PSize),_),
	set(evalfn,E),
	(E = posonly -> NType = rand; NType = neg),
	recorded(progol,size(NType,NSize),_),
	recorded(progol,atoms_left(NType,N),_),
	fix_base(PSize,NSize).

set_up_builtins:-
	recorda(lits,lit_info(-1,0,'!',[],[],[]),_).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C O N T R O L

% this finds the unique max cover set solution
induce_max:-
	recorded(progol,atoms(pos,PosSet),_),
	PosSet \= [],
	record_settings,
	StartClock is cputime,
	set(maxcover,true),
	induce_max(PosSet),
	StopClock is cputime,
	Time is StopClock - StartClock,
	show(theory),
	record_theory(Time),
	noset(maxcover),
	p1_message('time taken'), p_message(Time), !.
induce_max.

induce_max([]).
induce_max([Start-Finish|Intervals]):-
	recorda(progol_dyn,counter(Start),_),
	induce_max1(Finish),
	induce_max(Intervals).

induce_max1(Finish):-
        recorded(progol_dyn,counter(S),_),
        S =< Finish, !,
        repeat,
        recorded(progol_dyn,counter(Start),DbRef),
        erase(DbRef),
        recorda(progol,example_selected(pos,Start),DbRef1),
        sat(Start),
        reduce,
        update_coverset(pos,Start),
        erase(DbRef1),
        Next is Start+1,
        recordz(progol_dyn,counter(Next),DbRef2),
        Next > Finish, !,
        erase(DbRef2).
induce_max1(_).

% this implements induction by random sampling
% does not perform greedy cover removal after each reduction
induce_cover:-
	recorded(progol,atoms_left(pos,PosSet),_),
	not(PosSet = []),
	setting(samplesize,S),
	record_settings,
	StartClock is cputime,
        repeat,
	gen_sample(pos,S),
	recorda(progol,besthyp([-10000,0,1,-10000],0,(false),[],[]),_),
	get_besthyp,
	rm_seeds,
        recorded(progol,atoms_left(pos,[]),_),
	StopClock is cputime,
	Time is StopClock - StartClock,
        show(theory), 
	record_theory(Time),
	p1_message('time taken'), p_message(Time), !.
induce_cover.

% this implements induction by random sampling
% performs greedy cover removal after each reduction
induce:-
        set(greedy,true),
        recorded(progol,atoms_left(pos,PosSet),_),
        not(PosSet = []),
        setting(samplesize,S),
	record_settings,
        StartClock is cputime,
        repeat,
        gen_sample(pos,S),
	retractall(progol,besthyp(_,_,_,_,_)),
        recorda(progol,besthyp([-10000,0,1,-10000],0,(false),[],[]),_),
        get_besthyp,
        rm_seeds,
        recorded(progol,atoms_left(pos,[]),_),
        StopClock is cputime,
        Time is StopClock - StartClock,
        show(theory),
        record_theory(Time),
	noset(greedy),
        p1_message('time taken'), p_message(Time), !.
induce.

rsat:-
        recorded(progol,atoms_left(pos,PosSet),_),
        not(PosSet = []),
        gen_sample(pos,1),
	recorded(progol,example_selected(pos,Num),DbRef),
	erase(DbRef),
	sat(Num).


get_besthyp:-
	recorded(progol,example_selected(pos,Num),DbRef),
	erase(DbRef),
	sat(Num),
	reset_best_label,	 % set-up target to beat
	reduce,
	update_besthyp(Num),
	fail.
get_besthyp:-
        recorded(progol,besthyp(L,Num,H,PC,NC),DbRef),
        erase(DbRef),
	H \= false, !,
	((setting(samplesize,S),S>1)->
		set(nodes,Nodes),
		show_clause(L,H,Nodes,sample),
		record_clause(L,H,Nodes,sample);
		true),
        add_hyp(L,H,PC,NC),
        recorda(progol,example_selected(pos,Num),_), !.
get_besthyp.


reset_best_label:-
	recorded(progol,besthyp(Label1,_,Clause,P,N),_),
	recorded(search,best_label(Label/_),DbRef),
	Label = [_,_,_,Gain|_],
	Label1 = [_,_,_,Gain1|_],
	Gain1 > Gain, !,
	erase(DbRef),
	recorda(search,best_label(Label1/0),_),
	recorded(search,selected(_,_,_,_),DbRef2),
	erase(DbRef2),
	recorda(search,selected(Label1,Clause,P,N),_).
reset_best_label.


update_besthyp(Num):-
	recorded(progol,hypothesis(Label,H,PCover,NCover),_),
	recorded(progol,besthyp(Label1,_,_,_,_),DbRef),
	Label = [_,_,_,Gain|_],
	Label1 = [_,_,_,Gain1|_],
	Gain > Gain1, !,
	erase(DbRef),
	recordz(progol,besthyp(Label,Num,H,PCover,NCover),_).
update_besthyp(_).

get_performance:-
	(setting(train_pos,PFile) ->
		test(PFile,noshow,Tp,TotPos),
		Fn is TotPos - Tp;
		TotPos = 0, Tp = 0, Fn = 0),
	(setting(train_neg,NFile) ->
		test(NFile,noshow,Fp,TotNeg),
		Tn is TotNeg - Fp;
		TotNeg = 0, Tn = 0, Fp = 0),
	TotPos + TotNeg > 0,
	p_message('Training set performance'),
	write_cmatrix([Tp,Fp,Fn,Tn]),
	p1_message('Training set summary'), p_message([Tp,Fp,Fn,Tn]),
	fail.
get_performance:-
	(setting(test_pos,PFile) ->
		test(PFile,noshow,Tp,TotPos),
		Fn is TotPos - Tp;
		TotPos = 0, Tp = 0, Fn = 0),
	(setting(test_neg,NFile) ->
		test(NFile,noshow,Fp,TotNeg),
		Tn is TotNeg - Fp;
		TotNeg = 0, Tn = 0, Fp = 0),
	TotPos + TotNeg > 0,
	p_message('Test set performance'),
	write_cmatrix([Tp,Fp,Fn,Tn]),
	p1_message('Test set summary'), p_message([Tp,Fp,Fn,Tn]),
	fail.
get_performance.

write_cmatrix([Tp,Fp,Fn,Tn]):-
        P is Tp + Fn, N is Fp + Tn,
        PP is Tp + Fp, PN is Fn + Tn,
        Total is PP + PN,
        (Total = 0 -> Accuracy is 0.5; Accuracy is (Tp + Tn)/Total),
        find_max_width([Tp,Fp,Fn,Tn,P,N,PP,PN,Total],0,W1),
        W is W1 + 2,
        tab(5), write(' '), tab(W), write('Actual'), nl,
        tab(5), write(' '), write_entry(W,'+'), tab(6), write_entry(W,'-'), nl,
        tab(5), write('+'),
        write_entry(W,Tp), tab(6), write_entry(W,Fp), tab(6), write_entry(W,PP), nl,
        write('Pred '), nl,
        tab(5), write('-'),
        write_entry(W,Fn), tab(6), write_entry(W,Tn), tab(6), write_entry(W,PN), nl, nl,
        tab(5), write(' '), write_entry(W,P), tab(6), write_entry(W,N),
        tab(6), write_entry(W,Total), nl, nl,
        write('Accuracy = '), write(Accuracy), nl.

 
find_max_width([],W,W).
find_max_width([V|T],W1,W):-
        name(V,VList),
        length(VList,VL),
        (VL > W1 -> find_max_width(T,VL,W);
                find_max_width(T,W1,W)).
 
write_entry(W,V):-
        name(V,VList),
        length(VList,VL),
        Y is integer((W-VL)/2),
        tab(Y), write(V), tab(Y).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L A Z Y  E V A L U A T I O N


% lazy evaluation of literals in a refinement operation
lazy_evaluate_refinement(Refinement,LazyPreds,PosCover,NegCover,NewRefinement):-
	clause_to_list(Refinement,Lits),
	lazy_evaluate_refinement(Lits,LazyPreds,[],PosCover,NegCover,Lits1),
	list_to_clause(Lits1,NewRefinement), !.
lazy_evaluate_refinement(Refinement,_,_,_,Refinement).

lazy_evaluate_refinement([],_,L,_,_,L):- !.
lazy_evaluate_refinement([Lit|Lits],LazyPreds,Path,PosCover,NegCover,Refine):-
	lazy_evaluate([Lit],LazyPreds,Path,PosCover,NegCover,[Lit1]), 
	update(Lit1,Path,Path1), !,
	lazy_evaluate_refinement(Lits,LazyPreds,Path1,PosCover,NegCover,Refine).


% lazy evaluation of specified literals
% all #'d arguments of these literals are evaluated at reduction-time
lazy_evaluate(Lits,[],_,_,_,Lits):- !.
lazy_evaluate([],_,_,_,_,[]):- !.
lazy_evaluate([LitNum|LitNums],LazyPreds,Path,PosCover,NegCover,Lits):-
	(integer(LitNum) ->
		recorded(lits,lit_info(LitNum,Depth,Atom,I,O,D),_),
		functor(Atom,Name,Arity),
		member1(Name/Arity,LazyPreds), !,
		get_pclause([LitNum|Path],[],(Lit:-(Goals)),_,_,_);
		functor(LitNum,Name,Arity),
		member1(Name/Arity,LazyPreds), !,
		list_to_clause([LitNum|Path],(Lit:-(Goals)))),
	goals_to_clause(Goals,Clause),
	lazy_prove(pos,Lit,Clause,PosCover),
	(recorded(progol,positive_only(Name/Arity),_)->
		lazy_prove(neg,Lit,Clause,[]);
		lazy_prove_negs(Lit,Clause,NegCover)),
	functor(LazyLiteral,Name,Arity),
	collect_args(I,LazyLiteral),
	lazy_evaluate1(Atom,Depth,I,O,D,LazyLiteral,NewLits),
	retractall(progol_dyn,lazy_evaluate(_,_)),
	lazy_evaluate(LitNums,LazyPreds,Path,PosCover,NegCover,NewLits1),
	update_list(NewLits1,NewLits,Lits).
lazy_evaluate([LitNum|LitNums],LazyPreds,Path,PosCover,NegCover,[LitNum|Lits]):-
	lazy_evaluate(LitNums,LazyPreds,Path,PosCover,NegCover,Lits).

lazy_prove_negs(Lit,Clause,_):-
	recorded(progol,set(lazy_negs,true),_), !,
	recorded(progol,atoms(neg,NegCover),_),
	lazy_prove(neg,Lit,Clause,NegCover).
lazy_prove_negs(Lit,Clause,NegCover):-
	lazy_prove(neg,Lit,Clause,NegCover).

collect_args([],_).
collect_args([Argno/_|Args],Literal):-
	findall(Term,(recorded(progol_dyn,lazy_evaluate(pos,Lit),_),arg(Argno,Lit,Term)),PTerms),
	findall(Term,(recorded(progol_dyn,lazy_evaluate(neg,Lit),_),arg(Argno,Lit,Term)),NTerms),
	arg(Argno,Literal,[PTerms,NTerms]),
	collect_args(Args,Literal).

lazy_evaluate1(Atom,Depth,I,O,D,Lit,NewLits):-
	recorded(sat,last_lit(_),_),
	call_library_pred(Atom,Depth,Lit,I,O,D),
	findall(LitNum,(recorded(progol_dyn,lazy_evaluated(LitNum),DbRef),erase(DbRef)),NewLits).

call_library_pred(OldLit,Depth,Lit,I,O,D):-
	functor(OldLit,Name,Arity),
	recorded(progol,lazy_recall(Name/Arity,Recall),_),
	recorda(progol_dyn,callno(1),_),
	p1_message('lazy evaluation'), p_message(Name),
	repeat,
	evaluate(OldLit,Depth,Lit,I,O,D),
	recorded(progol_dyn,callno(CallNo),DbRef),
	erase(DbRef),
	NextCall is CallNo + 1,
	recorda(progol_dyn,callno(NextCall),DbRef1),
	NextCall > Recall,
	!,
	p_message('completed'),
	erase(DbRef1).
	 
evaluate(OldLit,_,Lit,I,O,D):-
	functor(OldLit,Name,Arity),
	functor(NewLit,Name,Arity),
	Lit,
	copy_args(OldLit,NewLit,I),
	copy_args(OldLit,NewLit,O),
	copy_consts(Lit,NewLit,Arity),
	update_lit(LitNum,false,NewLit,I,O,D),
	not(recorded(progol_dyn,lazy_evaluated(LitNum),_)),
	recorda(progol_dyn,lazy_evaluated(LitNum),_), !.
evaluate(_,_,_,_,_,_).

copy_args(_,_,[]).
copy_args(Old,New,[Arg/_|T]):-
	arg(Arg,Old,Term),
	arg(Arg,New,Term),
	copy_args(Old,New,T), !.

copy_consts(_,_,0):- !.
copy_consts(Old,New,Arg):-
	arg(Arg,Old,Term),
	arg(Arg,New,Term1),
	var(Term1), !,
	Term1 = progol_const(Term),
	Arg0 is Arg - 1,
	copy_consts(Old,New,Arg0).
copy_consts(Old,New,Arg):-
	Arg0 is Arg - 1,
	copy_consts(Old,New,Arg0).

% theorem-prover for lazy evaluation of literals
lazy_prove(_,_,_,[]).
lazy_prove(Type,Lit,Clause,[Interval|Intervals]):-
        lazy_index_prove(Type,Lit,Clause,Interval),
        lazy_prove(Type,Lit,Clause,Intervals).

lazy_index_prove(_,_,_,Start-Finish):-
        Start > Finish, !.
lazy_index_prove(Type,Lit,Clause,Start-Finish):-
        lazy_index_prove1(Type,Lit,Clause,Start),
        Start1 is Start + 1,
        lazy_index_prove(Type,Lit,Clause,Start1-Finish).

% bind input args of lazy literal
% each example gives an input binding
lazy_index_prove1(Type,Lit,Clause,Num):-
        (Clause = (Head:-Body)->true;Head=Clause,Body=true),
        prove1((example(Num,Type,Head),Body)),
        recorda(progol_dyn,lazy_evaluate(Type,Lit),_),
        fail.
lazy_index_prove1(_,_,_,_).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% S L P
% implemented as described by Muggleton, ILP-96

condition_target:-
	recorded(progol,set(condition,true),_),
	recorded(progol,modeh(_,Pred),_),
	add_generator(Pred,SPred),
	p_message('conditioning'),
	SPred =.. [_|Args],
	functor(Pred,Name,Arity),
	functor(Fact,Name,Arity),
	example(_,_,Fact),
	Fact =.. [_|Args], 
	condition(SPred),
	fail.
condition_target:-
	not(recorded(progol,set(condition,true),_)),
	recorded(progol,modeh(_,Pred),_),
	add_generator(Pred,_), !.
condition_target.


add_generator(Pred,SPred):-
	functor(Pred,Name,Arity),
	make_sname(Name,SName),
	functor(SPred,SName,Arity),
	(clause(SPred,_)-> 
		true;
		range_restrict(Pred,Arity,SPred,Body),
		asserta((SPred:-Body)),
		p1_message('included generator'), p_message(SName/Arity)).

make_sname(Name,SName):-
	concat(['*',Name],SName).

range_restrict(_,0,_,true):- !.
range_restrict(Pred,1,SPred,Lit):-
	!,
	range_restriction(Pred,1,SPred,Lit).
range_restrict(Pred,Arg,SPred,(Lit,Lits)):-
	range_restriction(Pred,Arg,SPred,Lit),
	Arg1 is Arg - 1,
	range_restrict(Pred,Arg1,SPred,Lits).

range_restriction(Pred,Arg,SPred,Lit):-
	arg(Arg,Pred,Type),
	get_type_name(Type,TName),
	functor(Lit,TName,1),
	arg(Arg,SPred,X),
	arg(1,Lit,X).

get_type_name(+Name,Name):- !.
get_type_name(-Name,Name):- !.
get_type_name(#Name,Name):- !.


condition(Fact):-
	slprove(condition,Fact), !.
condition(_).

sample(_,0,[]):- !.
sample(Name/Arity,N,S):-
	functor(Pred,Name,Arity),
	retractall(slp,samplenum(_)),
	retractall(slp,sample(_)),
	recorda(slp,samplenum(1),_),
	repeat,
	slprove(stochastic,Pred),
	recorda(slp,sample(Pred),_),
	recorded(slp,samplenum(N1),DbRef),
	erase(DbRef),
	N2 is N1 + 1,
	recorda(slp,samplenum(N2),DbRef1),
	N2 > N,
	!,
	erase(DbRef1),
	functor(Fact,Name,Arity),
	findall(Fact,(recorded(slp,sample(Fact),DbRef2),erase(DbRef2)),S).

gsample(Name/Arity,_):-
        make_sname(Name,SName),
        functor(SPred,SName,Arity),
        clause(SPred,true),
        ground(SPred), !,
        update_gsample(Name/Arity,_).
gsample(_,0):- !.
gsample(Name/Arity,N):-
	functor(Pred,Name,Arity),
	make_sname(Name,SName),
	functor(SPred,SName,Arity),
	Pred =.. [_|Args],
	retractall(slp,samplenum(_)),
	recorda(slp,samplenum(0),_),
	repeat,
	slprove(stochastic,SPred),
	SPred =..[_|Args],
	recorded(slp,samplenum(N1),DbRef),
	erase(DbRef),
	N2 is N1 + 1,
	recorda(slp,samplenum(N2),DbRef1),
	assertz(example(N2,rand,Pred)),
	N2 >= N,
	!,
	erase(DbRef1),
	recorda(progol,size(rand,N),_),
	recorda(progol,atoms(rand,[1-N]),_),
	recorda(progol,atoms_left(rand,[1-N]),_).

update_gsample(Name/Arity,_):-
        functor(Pred,Name,Arity),
        make_sname(Name,SName),
        functor(SPred,SName,Arity),
        retractall(progol,gsample(_)),
        retractall(slp,samplenum(_)),
        recorda(slp,samplenum(0),_),
        SPred =.. [_|Args],
        Pred =.. [_|Args],
        clause(SPred,true),
        ground(SPred),
        recorded(slp,samplenum(N1),DbRef),
        erase(DbRef),
        N2 is N1 + 1,
        recorda(slp,samplenum(N2),_),
        assertz(example(N2,rand,Pred)),
        fail.
update_gsample(_,N):-
        recorded(slp,samplenum(N),DbRef),
        N > 0, !,
        erase(DbRef),
        set(gsamplesize,N),
	recorda(progol,size(rand,N),_),
	recorda(progol,atoms(rand,[1-N]),_),
	recorda(progol,atoms_left(rand,[1-N]),_).
update_gsample(_,_).

	
slprove(_,true):-
	!.
slprove(Mode,not(Goal)):-
	slprove(Mode,Goal),
	!,
	fail.
slprove(Mode,(Goal1,Goal2)):-
	!,
	slprove(Mode,Goal1),
	slprove(Mode,Goal2).
slprove(Mode,(Goal1;Goal2)):-
	!,
	slprove(Mode,Goal1);
	slprove(Mode,Goal2).
slprove(_,Goal):-
	functor(Goal,Name,Arity),
	functor(BuiltIn,Name,Arity),
	system_predicate(Name,BuiltIn), !,
	Goal.
slprove(stochastic,Goal):-
	findall(Count/Clause,
		(clause(Goal,Body),Clause=(Goal:-Body),find_count(Clause,Count)),
		ClauseCounts),
	renormalise(ClauseCounts,Normalised),
	X is random,
	rselect_clause(X,Normalised,(Goal:-Body)),
	slprove(stochastic,Body).
slprove(condition,Goal):-
	functor(Goal,Name,Arity),
	functor(Head,Name,Arity),
	clause(Head,Body),
	not(not((Head=Goal,slprove(condition,Body)))),
	inc_count((Head:-Body)).

renormalise(ClauseCounts,Normalised):-
	sum_counts(ClauseCounts,L),
	L > 0,
	renormalise(ClauseCounts,L,Normalised).

sum_counts([],0).
sum_counts([N/_|T],C):-
	sum_counts(T,C1),
	C is N + C1.

renormalise([],_,[]).
renormalise([Count/Clause|T],L,[Prob/Clause|T1]):-
	Prob is Count/L,
	renormalise(T,L,T1).

rselect_clause(X,[P/C|_],C):- X =< P, !.
rselect_clause(X,[P/_|T],C):-
	X1 is X - P,
	rselect_clause(X1,T,C).


find_count(Clause,N):-
	copy_term(Clause,Clause1),
	recorded(slp,count(Clause1,N),_), !.
find_count(_,1).
	
inc_count(Clause):-
	recorded(slp,count(Clause,N),DbRef), !,
	erase(DbRef),
	N1 is N + 1,
	recorda(slp,count(Clause,N1),_).
inc_count(Clause):-
	recorda(slp,count(Clause,2),_).

find_posgain(PCover,P):-
	recorded(progol,set(greedy,true),_), !,
	interval_count(PCover,P).
find_posgain(PCover,P):-
	recorded(progol,atoms_left(pos,PLeft),_),
	intervals_intersection(PLeft,PCover,PC),
	interval_count(PC,P).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% S E A R C H  I / O 

record_clause(Label,Clause,Nodes,Flag):-
	recorded(progol,set(record,true),_),
	recorded(progol,set(recordfile,File),_), !,
	open(File,append,Stream),
	set_output(Stream),
	show_clause(Label,Clause,Nodes,Flag),
	close(Stream),
	set_output(user_output).
record_clause(_,_,_,_).

record_sat_example(N):-
	recorded(progol,set(record,true),_),
	recorded(progol,set(recordfile,File),_), !,
	open(File,append,Stream),
	set_output(Stream),
	p1_message('sat'), p_message(N),
	close(Stream),
	set_output(user_output).
record_sat_example(_).

record_search_stats(Clause,Nodes,Time):-
	recorded(progol,set(record,true),_),
	recorded(progol,set(recordfile,File),_), !,
	open(File,append,Stream),
	set_output(Stream),
	p1_message('clauses constructed'), p_message(Nodes),
	p1_message('search time'), p_message(Time),
	p_message('best clause'),
	pp_dclause(Clause),
	% show(hypothesis),
	close(Stream),
	set_output(user_output).
record_search_stats(_,_,_).

record_theory(Time):-
        recorded(progol,set(record,true),_),
        recorded(progol,set(recordfile,File),_), !,
        open(File,append,Stream),
        set_output(Stream),
        show(theory),
	p1_message('time taken'), p_message(Time),
        nl,
        (recorded(progol,set(maxcover,true),_)->
                show(progol,theory/5), nl,
                show(progol,max_set/4), nl,
                show(progol,rules/1);
                true),
        close(Stream),
        set_output(user_output).
record_theory(_).

record_settings:-
        recorded(progol,set(record,true),_),
        recorded(progol,set(recordfile,File),_), !,
	record_date(File),
	record_machine(File),
        open(File,append,Stream),
        set_output(Stream),
	show(settings),
	close(Stream),
        set_output(user_output).
record_settings.

% Unix specific date command
record_date(File):-
	concat([date,' >> ', File],Cmd),
	execute(Cmd).

% Unix specific machine name
record_machine(File):-
	concat([hostname,' >> ', File],Cmd),
	execute(Cmd).

show_clause(Label,Clause,Nodes,Flag):-
	p_message('-------------------------------------'),
	(Flag=explore -> p_message('exploratory clause');
		(Flag=sample-> p_message('selected from sample');
			p_message('found clause'))),
	pp_dclause(Clause),
	(setting(evalfn,Evalfn)-> true; Evalfn = coverage),
	show_stats(Evalfn,Label),
	p1_message('clause label'), p_message(Label),
	p1_message('clauses explored'), p_message(Nodes),
	p_message('-------------------------------------').


show_stats(Evalfn,[P,N,L,F|_]):-
	print_eval(Evalfn,F).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A U T O  -- R E F I N E
% 
% built-in refinement operator

gen_auto_refine:-
	set(refineop,true),
	not(clause(refine(_,_),_)), !,
	process_modes,
	process_determs,
	Refine = (refine(Clause1,Clause2):-
			setting(refine,auto), !,
			progol_refine(Clause1,Clause2)),
	set(caching,true),
	assert_static(Refine),
	p_message('included automatic definition of refinement operator').
gen_auto_refine.

process_modes:-
	once(abolish(progol_link_vars,2)),
	once(abolish(progol_has_ovar,4)),
	once(abolish(progol_has_ivar,4)),
	recorded(progol,modeb(_,Mode),_),
	process_mode(Mode),
	fail.
process_modes:-
	recorded(progol,determination(Name/Arity,_),_),
	functor(Mode,Name,Arity),
	recorded(progol,modeh(_,Mode),_),
	split_args1(Mode,Arity,I,O,C),
	functor(Lit,Name,Arity),
	add_ivars(Lit,I),
	add_ovars(Lit,O),
	fail.
process_modes.

process_determs:-
	once(abolish(progol_determination,2)),
	recorded(progol,determination(Name/Arity,Name1/Arity1),_),
	functor(Pred,Name1,Arity1),
	Determ = progol_determination(Name/Arity,Pred),
	(Determ -> true; assert_static(Determ)),
	fail.
process_determs.

process_mode(Mode):-
	functor(Mode,Name,Arity),
	split_args1(Mode,Arity,I,O,C),
	functor(Lit,Name,Arity),
	add_ioc_links(Lit,I,O,C),
	add_ovars(Lit,O).

add_ioc_links(Lit,I,O,C):-
	Clause = (progol_link_vars(Lit,Lits):-
			Body),
	get_o_links(O,Lit,Lits,true,OGoals),
	get_i_links(I,Lit,Lits,OGoals,IOGoals),
	get_c_links(C,Lit,IOGoals,Body),
	assert_static(Clause).

add_ovars(Lit,O):-
	member(Arg/Type,O),
	arg(Arg,Lit,V),
	(progol_has_ovar(Lit,V,Type,Arg)->true;
		assert_static(progol_has_ovar(Lit,V,Type,Arg))),
	fail.
add_ovars(_,_).

add_ivars(Lit,I):-
	member(Arg/Type,I),
	arg(Arg,Lit,V),
	(progol_has_ivar(Lit,V,Type,Arg)->true;
		assert_static(progol_has_ivar(Lit,V,Type,Arg))),
	fail.
add_ivars(_,_).


get_o_links([],_,_,Goals,Goals).
get_o_links([Arg/Type|T],Lit,Lits,GoalsSoFar,Goals):-
	arg(Arg,Lit,V),
	Arg1 is Arg - 1,
	Goal = (progol_output_var(V,Type,Lits);
		progol_output_var(V,Type,Lit,Arg1)),
	prefix_lits((Goal),GoalsSoFar,G1),
	get_o_links(T,Lit,Lits,G1,Goals).


get_i_links([],_,_,Goals,Goals).
get_i_links([Arg/Type|T],Lit,Lits,GoalsSoFar,Goals):-
	arg(Arg,Lit,V),
	Goal = progol_input_var(V,Type,Lits),
	prefix_lits((Goal),GoalsSoFar,G1),
	get_i_links(T,Lit,Lits,G1,Goals).

get_c_links([],_,Goals,Goals).
get_c_links([Arg/Type|T],Lit,GoalsSoFar,Goals):-
	arg(Arg,Lit,V),
	TypeFact =.. [Type,C],
	Goal = (TypeFact,V=C),
	prefix_lits((Goal),GoalsSoFar,G1),
	get_c_links(T,Lit,G1,Goals).
	

progol_input_var(Var,Type,[Head|_]):-
	progol_has_ivar(Head,Var,Type,_).
progol_input_var(Var,Type,[_|Lits]):-
        member(Lit,Lits),
        progol_has_ovar(Lit,Var,Type,_).

progol_output_var(Var,Type,[Head|_]):-
	progol_has_ovar(Head,Var,Type,_).
progol_output_var(Var,Type,Lits):-
	progol_input_var(Var,Type,Lits).
progol_output_var(Var,_,_).

progol_output_var(Var,Type,Lit,LastArg):-
	progol_has_ovar(Lit,Var,Type,Arg),
	Arg =< LastArg.

progol_refine(false,Head):-
	!,
	once(recorded(progol,determination(Name/Arity,_),_)),
	progol_get_hlit(Name/Arity,Head).
progol_refine((H:-B),(H1:-B1)):-
	!,
	goals_to_list((H,B),LitList),
	set(clauselength,L),
	length(LitList,ClauseLength),
	ClauseLength < L,
	progol_get_lit(Lit,LitList),	
	append([Lit],LitList,LitList1),
	list_to_goals(LitList1,(H1,B1)).
progol_refine(Head,Clause):-
	progol_refine((Head:-true),Clause).

progol_get_hlit(Name/Arity,Head):-
	functor(Head,Name,Arity),
	functor(Mode,Name,Arity),
	recorded(progol,mode(_,Mode),_),
	split_args1(Mode,Arity,I,_,C),
	get_c_links(C,Head,true,Equalities),
	Equalities.

progol_get_lit(Lit,[H|Lits]):-
	functor(H,Name,Arity),
	progol_get_lit(Lit,Name/Arity),
	progol_link_vars(Lit,[H|Lits]),
	not(member2(Lit,[H|Lits])).

progol_get_lit(Lit,Target):-
	progol_determination(Target,Lit).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R A N D O M   C L A U S E   G E N E R A T O R
% still being worked on
 
% obtain estimate of distribution of number of clauses
% at each clause length
clause_distribution(_,_):-
	retractall(progol,clause_distribution(_,_)),
	retractall(progol,total_clauses(_)),
	retractall(progol,lit_variants(_,_)),
	set(refine,auto),
	all(C,refine(false,C),Clauses),
	update_estimate_nclauses(Clauses),
	fail.
clause_distribution(L,N):-
	recorded(progol,clause_distribution(L,N),_).

update_estimate_nclauses([]):- !.
update_estimate_nclauses(Clauses):-
	update_estimate_variants(Clauses),
	all(C,(member(C1,Clauses),refine(C1,C)),NextClauses), !,
	update_estimate_nclauses(NextClauses).
update_estimate_nclauses(_).
	
update_estimate_variants([]):- !.
update_estimate_variants([Clause|Clauses]):-
	find_hashed_variants(Clause,1,N),
	update_distribution(Clause,N),
	update_estimate_variants(Clauses), !.

% number of variants of a template -- estimated from the first
% example left ungeneralised
estimate_variants(Clause,N):-
	recorded(progol,atoms_left(pos,[ExampleNum-_|_]),_),
	example(ExampleNum,pos,H),
	(Clause = (H:-B) -> true; B = true),
	retractall(progol_dyn,variant_count(_)),
	recorda(progol_dyn,variant_count(0),_),
	B,
	recorded(progol_dyn,variant_count(N),DbRef),
	erase(DbRef),
	N1 is N + 1,
	recorda(progol_dyn,variant_count(N1),_),
	fail.
estimate_variants(_,N):-
	(recorded(progol_dyn,variant_count(N),DbRef)->erase(DbRef); N=0).

update_distribution(Clause,N):-
	(Clause=(H:-B) -> CLits = (H,B); CLits = Clause),
	nlits(CLits,L),
	(recorded(progol,clause_distribution(L,N1),DbRef)->
		erase(DbRef),
		N2 is N1 + N;
		N2 is N),
	recorda(progol,clause_distribution(L,N2),_),
	(recorded(progol,total_clauses(N3),DbRef2)->
		erase(DbRef2),
		N4 is N3 + N;
		N4 is N),
	recorda(progol,total_clauses(N4),_).

find_hashed_variants(Clause,VSoFar,N):-
	clause_to_list(Clause,CList),
	hashed_variants(CList,VSoFar,N).

hashed_variants([],V,V).
hashed_variants([Lit|Lits],VSoFar,V):-
	hashed_variant(Lit,VSoFar,V1),
	hashed_variants(Lits,V1,V).

hashed_variant(Lit,VSoFar,V1):-
	functor(Lit,Name,Arity),
	functor(Template,Name,Arity),
        (recorded(lits,lit_info(_,_,Template,_,_,_),_) ->
		hashed_combinations(Lit,M);
		ub_hashed_combinations(Arity,Template,1,M)),
	V1 is VSoFar*M,
	recorda(progol,lit_variants(Name/Arity,M),_), !.

hashed_combinations(Lit,M):-
	functor(Lit,Name,Arity),
	recorded(progol,lit_variants(Name/Arity,M),_), !.
hashed_combinations(Lit,M):-
	functor(Lit,Name,Arity),
	functor(Lit1,Name,Arity),
	all(C,(recorded(lits,lit_info(_,_,Lit1,_,_,_),_),has_hashed(Lit1,Arity,[],C)),L),
	L \= [[]], !,
	length(L,M).
hashed_combinations(Lit,1).

has_hashed(Lit,0,L,L):- !.
has_hashed(Lit,Arg,CSoFar,C):-
	arg(Arg,Lit,progol_const(C1)), !,
	Arg1 is Arg - 1,
	has_hashed(Lit,Arg1,[C1|CSoFar],C).
has_hashed(Lit,Arg,CSoFar,C):-
	Arg1 is Arg - 1,
	has_hashed(Lit,Arg1,CSoFar,C).

ub_hashed_combinations(0,_,V,V):- !.
ub_hashed_combinations(Arg,Mode,VSoFar,V):-
	all(Type,(recorded(progol,mode(_,Mode),_),arg(Arg,Mode,#Type)),HashedTypes),
	HashedTypes \= [], !,
	find_max_values(HashedTypes,1,M),
	V1 is VSoFar*M,
	Arg1 is Arg - 1,
	ub_hashed_combinations(Arg1,Mode,V1,V).
ub_hashed_combinations(Arg,Mode,V1,V):-
	Arg1 is Arg - 1,
	ub_hashed_combinations(Arg1,Mode,V1,V).

find_max_values([],M,M).
find_max_values([Type|Types],MaxSoFar,M):-
	functor(Fact,Type,1),
	findall(T,(Fact,arg(1,Fact,T)),TypeVals),
	length(TypeVals,M1),
	(M1 >= MaxSoFar ->
		find_max_values(Types,M1,M);
		find_max_values(Types,MaxSoFar,M)).

has_hashed_loc(Arg,Mode):-
	Arg > 0,
	arg(Arg,Mode,#_), !.
has_hashed_loc(Arg,Mode):-
	Arg > 1,
	Arg1 is Arg - 1,
	has_hashed_loc(Arg1,Mode).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% U T I L I T I E S

% concatenate elements of a list into an atom

concat([Atom],Atom):- !.
concat([H|T],Atom):-
        concat(T,AT),
        name(AT,L2),
        name(H,L1),
        append(L2,L1,L),
        name(Atom,L).


split_clause((Head:-true),Head,true):- !.
split_clause((Head:-Body1),Head,Body2):- Body1 \= true, !, Body1 = Body2.
split_clause([Head|T],Head,T):- !.
split_clause([Head],Head,[true]):- !.
split_clause(Head,Head,true).

strip_true((Head:-true),Head):- !.
strip_true(Clause,Clause).

% pretty print a definite clause
pp_dclause(Clause):-
        (recorded(progol,set(pretty_print,true),_)->
                pp_dclause(Clause,true);
                pp_dclause(Clause,false)).
 
pp_dclause((H:-true),Pretty):-
        !,
        pp_dclause(H,Pretty).
pp_dclause((H:-B),Pretty):-
        !,
        copy_term((H:-B),(Head:-Body)),
        numbervars((Head:-Body),0,_),
        progol_portray(Pretty,Head),
        (Pretty = true ->
                write(' if:');
                write(' :-')),
        nl,
        recorded(progol,set(print,N),_),
        print_lits(Body,Pretty,1,N).

pp_dclause((Lit),Pretty):-
        copy_term(Lit,Lit1),
        numbervars(Lit1,0,_),
        progol_portray(Pretty,Lit1),
        write('.'), nl.
 
% pretty print a definite clause list: head of list is + literal
pp_dlist([]):- !.
pp_dlist(Clause):-
        (recorded(progol,set(pretty_print,true),_)->
                pp_dlist(Clause,true);
                pp_dlist(Clause,false)).
 
pp_dlist(Clause,Pretty):-
        copy_term(Clause,[Head1|Body1]),
        numbervars([Head1|Body1],0,_),
        progol_portray(Pretty,Head1),
        (Body1 = [] ->
                print('.'), nl;
                (Pretty = true ->
                        write(' if:');
                        write(' :-')),
        nl,
        recorded(progol,set(print,N),_),
        print_litlist(Body1,Pretty,1,N)).
 
print_litlist([],_,_,_).
print_litlist([Lit],Pretty,LitNum,_):-
        !,
        print_lit(Lit,Pretty,LitNum,LitNum,'.',_).
print_litlist([Lit|Lits],Pretty,LitNum,LastLit):-
        print_lit(Lit,Pretty,LitNum,LastLit,', ',NextLit),
        print_litlist(Lits,Pretty,NextLit,LastLit).
 
print_lits((Lit,Lits),Pretty,LitNum,LastLit):-
        !,
        (Pretty = true ->
                Sep = ', and ';
                Sep = ', '),
        print_lit(Lit,Pretty,LitNum,LastLit,Sep,NextLit),
        print_lits(Lits,Pretty,NextLit,LastLit).
print_lits((Lit),Pretty,LitNum,_):-
        print_lit(Lit,Pretty,LitNum,LitNum,'.',_).

print_lit(Lit,Pretty,LitNum,LastLit,Sep,NextLit):-
        (LitNum = 1 -> tab(3);true),
        progol_portray(Pretty,Lit), write(Sep),
        (LitNum=LastLit-> nl,NextLit=1; NextLit is LitNum + 1).
 

print_text([]).
print_text([Atom]):-
        !,
        write(Atom).
print_text([Atom|T]):-
        write(Atom), write(' '),
        print_text(T).

p1_message(Mess):-
	print('['), print(Mess), print('] ').

p_message(Mess):-
	print('['), print(Mess), print(']'), nl.

delete_all(_,[],[]).
delete_all(X,[Y|T],T1):-
        X == Y, !,
        delete_all(X,T,T1).
delete_all(X,[Y|T],[Y|T1]):-
        delete_all(X,T,T1).

delete_list([],L,L).
delete_list([H1|T1],L1,L):-
	delete(H1,L1,L2), !,
	delete_list(T1,L2,L).
delete_list([_|T1],L1,L):-
	delete_list(T1,L1,L).

delete(H,[H|T],T).
delete(H,[H1|T],[H1|T1]):-
	delete(H,T,T1).

delete1(H,[H|T],T):- !.
delete1(H,[H1|T],[H1|T1]):-
	delete1(H,T,T1).

delete0(_,[],[]).
delete0(H,[H|T],T):- !.
delete0(H,[H1|T],[H1|T1]):-
	delete0(H,T,T1).

append(A,[],A).
append(A,[H|T],[H|T1]):-
	append(A,T,T1).

dappend(Z1-Z2,A1-Z1,A1-Z2).

member1(H,[H|_]):- !.
member1(H,[_|T]):-
	member1(H,T).

member2(X,[Y|_]):- X == Y, !.
member2(X,[_|T]):-
	member2(X,T).


member(X,[X|_]).
member(X,[_|T]):-
	member(X,T).


reverse(L1, L2) :- revzap(L1, [], L2).

revzap([X|L], L2, L3) :- revzap(L, [X|L2], L3).
revzap([], L, L).

merge_vlist([],[]).
merge_vlist([V/L|T],Merged):-
        delete1(V/L1,T,T1), !,
        append(L,L1,L2),
        merge_vlist([V/L2|T1],Merged).
merge_vlist([V/L|T],[V/L|Merged]):-
        merge_vlist(T,Merged).
 
goals_to_clause((Head,Body),(Head:-Body)):- !.
goals_to_clause(Head,Head).

clause_to_list((Head:-true),[Head]):- !.
clause_to_list((Head:-Body),[Head|L]):-
        !,
        goals_to_list(Body,L).
clause_to_list(Head,[Head]).

extend_clause(false,Lit,(Lit)):- !.
extend_clause((Head:-Body),Lit,(Head:-Body1)):-
        !,
        app_lit(Lit,Body,Body1).
extend_clause(Head,Lit,(Head:-Lit)).
 
app_lit(L,(L1,L2),(L1,L3)):-
        !,
        app_lit(L,L2,L3).
app_lit(L,L1,(L1,L)).

prefix_lits(L,true,L):- !.
prefix_lits(L,L1,((L),L1)).

nlits((_,Lits),N):-
	!,
	nlits(Lits,N1),
	N is N1 + 1.
nlits(_,1).

list_to_clause([Goal],(Goal:-true)):- !.
list_to_clause([Head|Goals],(Head:-Body)):-
	list_to_goals(Goals,Body).

list_to_goals([Goal],Goal):- !.
list_to_goals([Goal|Goals],(Goal,Goals1)):-
	list_to_goals(Goals,Goals1).

goals_to_list((true,Goals),T):-
	!,
	goals_to_list(Goals,T).
goals_to_list((Goal,Goals),[Goal|T]):-
	!,
	goals_to_list(Goals,T).
goals_to_list(true,[]):- !.
goals_to_list(Goal,[Goal]).

get_clause(LitNum,Last,_,[]):-
        LitNum > Last, !.
get_clause(LitNum,Last,TVSoFar,[FAtom|FAtoms]):-
        recorded(lits,lit_info(LitNum,_,Atom,_,_,_),_), !,
        get_flatatom(Atom,TVSoFar,FAtom,TV1),
        NextLit is LitNum + 1,
        get_clause(NextLit,Last,TV1,FAtoms).
get_clause(LitNum,Last,TVSoFar,FAtoms):-
        NextLit is LitNum + 1,
        get_clause(NextLit,Last,TVSoFar,FAtoms).

get_flatatom(not(Atom),TVSoFar,not(FAtom),TV1):-
        !,
        get_flatatom(Atom,TVSoFar,FAtom,TV1).
get_flatatom(Atom,TVSoFar,FAtom,TV1):-
        functor(Atom,Name,Arity),
        functor(FAtom,Name,Arity),
        flatten_args(Arity,Atom,FAtom,TVSoFar,TV1).

get_pclause([LitNum],TVSoFar,Clause,TV,Length,LastDepth):-
        !,
        get_pclause1([LitNum],TVSoFar,TV,Clause,Length,LastDepth).
get_pclause([LitNum|LitNums],TVSoFar,Clause,TV,Length,LastDepth):-
        get_pclause1([LitNum],TVSoFar,TV1,Head,Length1,_),
        get_pclause1(LitNums,TV1,TV,Body,Length2,LastDepth),
        (Length2 = 0 ->
                Clause = Head;
                Clause = (Head:-Body)),
        Length is Length1 + Length2.

get_pclause1([LitNum],TVSoFar,TV1,Lit,Length,LastDepth):-
        !,
        recorded(lits,lit_info(LitNum,LastDepth,Atom,_,_,_),_),
        get_flatatom(Atom,TVSoFar,Lit,TV1),
        functor(Lit,Name,_),
        (Name = '='-> Length = 0; Length = 1).
get_pclause1([LitNum|LitNums],TVSoFar,TV2,(Lit,Lits1),Length,LastDepth):-
        recorded(lits,lit_info(LitNum,_,Atom,_,_,_),_),
        get_flatatom(Atom,TVSoFar,Lit,TV1),
        get_pclause1(LitNums,TV1,TV2,Lits1,Length1,LastDepth),
        functor(Lit,Name,_),
        (Name = '='-> Length = Length1; Length is Length1 + 1).

flatten_args(0,_,_,TV,TV):- !.
flatten_args(Arg,Atom,FAtom,TV,TV1):-
        arg(Arg,Atom,Term),
        Arg1 is Arg - 1,
        (Term = progol_const(Const) ->
                arg(Arg,FAtom,Const),
                flatten_args(Arg1,Atom,FAtom,TV,TV1);
                (integer(Term) ->
                        update(Term/Var,TV,TV0),
                        arg(Arg,FAtom,Var),
                        flatten_args(Arg1,Atom,FAtom,TV0,TV1);
                        (functor(Term,Name,Arity),
                         functor(FTerm,Name,Arity),
                         arg(Arg,FAtom,FTerm),
                         flatten_args(Arity,Term,FTerm,TV,TV0),
                         flatten_args(Arg1,Atom,FAtom,TV0,TV1)
                        )
                )
        ).


% returns intersection of S1, S2 and S1-Intersection
intersect1(Elems,[],[],Elems):- !.
intersect1([],_,[],[]):- !.
intersect1([Elem|Elems],S2,[Elem|Intersect],ElemsLeft):-
	member1(Elem,S2), !,
	intersect1(Elems,S2,Intersect,ElemsLeft).
intersect1([Elem|Elems],S2,Intersect,[Elem|ElemsLeft]):-
	intersect1(Elems,S2,Intersect,ElemsLeft).

subset1([],_).
subset1([Elem|Elems],S):-
	member1(Elem,S), !,
	subset1(Elems,S).

% two sets are equal

equal_set([],[]).
equal_set([H|T],S):-
	delete1(H,S,S1),
	equal_set(T,S1), !.

uniq_insert(_,X,[],[X]).
uniq_insert(descending,H,[H1|T],[H,H1|T]):-
	H > H1, !.
uniq_insert(ascending,H,[H1|T],[H,H1|T]):-
	H < H1, !.
uniq_insert(_,H,[H|T],[H|T]):- !.
uniq_insert(Order,H,[H1|T],[H1|T1]):-
	!,
	uniq_insert(Order,H,T,T1).


explore_eq(X1,X2):-
	(setting(explore_tolerance,Epsilon) -> true; Epsilon = 0.0),
	ADiff is abs(X1 - X2),
	ADiff =< Epsilon.

quicksort(_,[],[]).
quicksort(Order,[X|Tail],Sorted):-
	val(X,Xval),
	partition(Xval,Tail,Small,Big),
	quicksort(Order,Small,SSmall),
	quicksort(Order,Big,SBig),
        (Order=ascending-> append([X|SBig],SSmall,Sorted);
                append([X|SSmall],SBig,Sorted)).
	

partition(_,[],[],[]).
partition(X,[Y|Tail],[Y|Small],Big):-
	val(Y,Yval),
	X > Yval, !,
	partition(X,Tail,Small,Big).
partition(X,[Y|Tail],Small,[Y|Big]):-
	partition(X,Tail,Small,Big).

update_list([],L,L).
update_list([H|T],L,Updated):-
	update(H,L,L1), !,
	update_list(T,L1,Updated).

update(H,[H|T],[H|T]):- !.
update(H,[H1|T],[H1|T1]):-
	!,
	update(H,T,T1).
update(H,[],[H]).

val(A/_,A):- !.
val(A,A).

val1(_/B,B):- !.
val1(A,A).

% checks if 2 sets intersect
intersects(S1,S2):-
	member(Elem,S1), member1(Elem,S2), !.

% checks if bitsets represented as lists of intervals intersect
intervals_intersects([L1-L2|_],I):-
	intervals_intersects1(L1-L2,I), !.
intervals_intersects([_|I1],I):-
	intervals_intersects(I1,I).

intervals_intersects1(L1-_,[M1-M2|_]):-
	L1 >= M1, L1 =< M2, !.
intervals_intersects1(L1-L2,[M1-_|_]):-
	M1 >= L1, M1 =< L2, !.
intervals_intersects1(L1-L2,[_|T]):-
	intervals_intersects1(L1-L2,T).

% checks if bitsets represented as lists of intervals intersect
% returns first intersection
intervals_intersects([L1-L2|_],I,I1):-
	intervals_intersects1(L1-L2,I,I1), !.
intervals_intersects([_|I1],I,I1):-
	intervals_intersects(I1,I,I1).

intervals_intersects1(I1,[I2|_],I):-
	interval_intersection(I1,I2,I), !.
intervals_intersects1(I1,[_|T],I):-
	intervals_intersection(I1,T,I).

interval_intersection(L1-L2,M1-M2,L1-L2):-
	L1 >= M1, L2 =< M2, !.
interval_intersection(L1-L2,M1-M2,M1-M2):-
	M1 >= L1, M2 =< L2, !.
interval_intersection(L1-L2,M1-M2,L1-M2):-
	L1 >= M1, M2 >= L1, M2 =< L2, !.
interval_intersection(L1-L2,M1-M2,M1-L2):-
	M1 >= L1, M1 =< L2, L2 =< M2, !.

%most of the time no intersection, so optimise on that
% optimisation by James Cussens
intervals_intersection([],_,[]).
intervals_intersection([A-B|T1],[C-D|T2],X) :-
        !,
        (A > D ->
            intervals_intersection([A-B|T1],T2,X);
            (C > B ->
                intervals_intersection(T1,[C-D|T2],X);
                (B > D ->
                    (C > A ->
                        X=[C-D|Y];
                        X=[A-D|Y]
                    ),
                    intervals_intersection([A-B|T1],T2,Y);
                    (C > A ->
                        X=[C-B|Y];
                        X=[A-B|Y]
                    ),
                    intervals_intersection(T1,[C-D|T2],Y)
                )
            )
        ).
intervals_intersection(_,[],[]).


% finds length of intervals in a list
interval_count([],0).
interval_count([L1-L2|T],N):-
	N1 is L2 - L1 + 1,
	interval_count(T,N2),
	N is N1 + N2.
interval_count(I/L,N):-
	interval_count(I,N).

% convert list to intervals
list_to_intervals(List,Intervals):-
        quicksort(ascending,List,List1),
        list_to_intervals1(List1,Intervals).

list_to_intervals1([],[]).
list_to_intervals1([Start|T],[Start-Finish|I1]):-
        list_to_interval(Start,T,Finish,T1),
        list_to_intervals1(T1,I1).

list_to_interval(Finish,[],Finish,[]).
list_to_interval(Finish,[Next|T],Finish,[Next|T]):-
        Next - Finish > 1,
        !.
list_to_interval(_,[Start|T],Finish,Rest):-
        list_to_interval(Start,T,Finish,Rest).

% converts intervals into a list
intervals_to_list([],[]).
intervals_to_list([Interval|Intervals],L):-
        interval_to_list(Interval,L1),
        intervals_to_list(Intervals,L2),
        append(L2,L1,L), !.

% converts an interval into a list
interval_to_list(Start-Finish,[]):-
	Start > Finish, !.
interval_to_list(Start-Finish,[Start|T]):-
	Start1 is Start+1,
	interval_to_list(Start1-Finish,T).

interval_subsumes(Start1-Finish1,Start2-Finish2):-
	Start1 =< Start2,
	Finish1 >= Finish2.

interval_subtract(Start1-Finish1,Start1-Finish1,[]):- !.
interval_subtract(Start1-Finish1,Start1-Finish2,[S2-Finish1]):-
	!,
	S2 is Finish2 + 1.
interval_subtract(Start1-Finish1,Start2-Finish1,[Start1-S1]):-
	!,
	S1 is Start2 - 1.
interval_subtract(Start1-Finish1,Start2-Finish2,[Start1-S1,S2-Finish1]):-
	S1 is Start2 - 1,
	S2 is Finish2 + 1,
	S1 >= Start1, Finish1 >= S2, !.

% compiler instructions
declare_dynamic(Pred/Arity):-
	dynamic Pred/Arity.

clean_up:-
	clean_up_sat,
	clean_up_reduce.

clean_up_sat:-
	retractall(vars,_),
	retractall(terms,_),
	retractall(lits,_),
	retractall(ivars,_),
	retractall(ovars,_),
	retractall(split,_),
	retractall(sat,_),
	retractall(atoms,_),
	retractall(progol_dyn,_),
	gc.

clean_up_reduce:-
	retractall(search,_),
	retractall(pclause,_),
	retractall(nodes,_),
	retractall(gains,_),
	retractall(progol_dyn,_),
	gc.


retractall(Area,Fact):-
	recorded(Area,Fact,DbRef),
	erase(DbRef),
	fail.
retractall(_,_).

depth_bound_call(G):-
	recorded(progol,set(depth,D),_),
	depth_bound_call(G,D).

binom_lte(_,_,O,0.0):- O < 0, !.
binom_lte(N,P,O,Prob):-
        binom(N,P,O,Prob1),
        O1 is O - 1,
        binom_lte(N,P,O1,Prob2),
        Prob is Prob1 + Prob2, !.

binom(N,_,O,0.0):- O > N, !.
binom(N,P,O,Prob):-
        choose(N,O,C),
        E1 is P^O,
        P2 is 1 - P,
        O2 is N - O,
        E2 is P2^O2,
        Prob is C*E1*E2, !.
 
choose(N,I,V):-
        NI is N-I,
        (NI > I -> pfac(N,NI,I,V) ; pfac(N,I,NI,V)).

pfac(0,_,_,1).
pfac(1,_,_,1).
pfac(N,N,_,1).
pfac(N,I,C,F):-
        N1 is N-1,
        C1 is C-1,
        pfac(N1,I,C1,N1F),
        F1 is N/C,
        F is N1F*F1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i/o stuff

read_all(Pred):-
	clean_up,
	reset,
	read_rules(Pred),
	recorda(progol_dyn,set(updatebacks,true),DbRef),
	read_examples(Pred), 	
	record_targetpred, 	
	check_prune_defs,
	check_user_search,
	do_precomputation,
	check_posonly,
	check_auto_refine,
	erase(DbRef),
	show(settings).


read_rules(Pred):-
	retractall(progol,mode(_,_)),
	retractall(progol,determination(_,_)),
	construct_name(Pred,rules,File),
	reconsult(File).

read_examples(Pred):-
	(setting(skolemvars,SkVars) -> true; SkVars = 10000),
	recorda(progol,skolemvars(SkVars),_), % hack: var numbers after this are skolem
	read_examples(pos,Pred),
	read_examples(neg,Pred),
	recorded(progol,size(pos,P),_),
	recorded(progol,size(neg,N),_),
	(P > 0 -> PosE = [1-P]; PosE = []),
	(N > 0 -> NegE = [1-N]; NegE = []),
	recorda(progol,atoms(pos,PosE),_),
	recorda(progol,atoms_left(pos,PosE),_),
	recorda(progol,atoms(neg,NegE),_),
	recorda(progol,atoms_left(neg,NegE),_),
	set_lazy_recalls,
	set_lazy_on_contradiction(P,N),
        Prior is P / (P + N),
	(setting(prior,_) -> true; Prior is P/(P+N), set(prior,Prior)),
	reset_counts,
	recorda(progol,last_clause(0),_).

read_examples(Type,Pred):-
	retractall(progol,size(Type,_)),
	recorda(progol,size(Type,0),_),
	% retractall(progol,example(Type,_,_)),
	construct_name(Pred,Type,File),
	(Type = pos -> Flag = train_pos; Flag = train_neg),
	set(Flag,File),
	(open(File,read,Stream) ->
		p1_message(consulting),
		concat([Type, ' examples'],Mess),
		p_message(Mess);
		p1_message('cannot open'), p_message(File),
		fail),
	repeat,
	read(Stream,Example),
	(Example=end_of_file-> close(Stream);
	recorded(progol,size(Type,N),DbRef), erase(DbRef),
	N1 is N + 1,
	recorda(progol,size(Type,N1),_),
	(Type = pos ->
		recorded(progol,skolemvars(Sk1),DbRef2),
		skolemize(Example,Fact,Body,Sk1,SkolemVars),
		record_skolemized(Type,N1,SkolemVars,Fact,Body),
		Sk1 \= SkolemVars,
		erase(DbRef2),
		recorda(progol,skolemvars(SkolemVars),_);
		split_clause(Example,Head,Body),
		record_nskolemized(Type,N1,Head,Body)),
	fail),
	!.
read_examples(_,_).

construct_name(Prefix,Type,Name):-
	name(Prefix,PString),
	suffix(Type,SString),
	append(SString,PString,FString),
	name(Name,FString).

construct_prolog_name(Name,Name):-
	name('.pl',Suffix),
	name(Name,Str),
	append(Suffix,_,Str), !.
construct_prolog_name(Name,Name1):-
	name(Name,Str),
	name('.pl',Suffix),
	append(Suffix,Str,Name1Str),
	name(Name1,Name1Str).

suffix(pos,Suffix):- name('.f',Suffix).
suffix(neg,Suffix):- name('.n',Suffix).
suffix(rules,Suffix):- name('.b',Suffix).

record_targetpred:-
	recorded(progol_dyn,backpred(Name/Arity),DbRef),
	erase(DbRef),
	recorda(progol,targetpred(Name/Arity),_),
	record_testclause(Name/Arity),
	fail.
record_targetpred.

check_posonly:-
	recorded(progol,size(rand,N),_), 
	N > 0, !.
check_posonly:-
	retractall(slp,_),
	setting(evalfn,posonly),
	setting(gsamplesize,S),
	condition_target,
	recorded(progol,targetpred(Name/Arity),_),
	gsample(Name/Arity,S), !.
check_posonly.

check_prune_defs:-
	clause(prune(_),_), !,
	set(prune_defs,true).
check_prune_defs.

check_auto_refine:-
	(setting(lazy_bottom,true);setting(construct_bottom,false)),
	setting(refineop,false), !,
	set(refine,auto).
check_auto_refine.

check_user_search:-
	setting(evalfn,user),
	not(cost_cover_required),
	set(lazy_on_cost,true), !.
check_user_search.

cost_cover_required:-
	clause(cost(_,Label,Cost),Body),
	vars_in_term([Label],[],Vars),
	(occurs_in(Vars,p(Cost)); occurs_in(Vars,Body)), !.

vars_in_term([],Vars,Vars):- !.
vars_in_term([Var|T],VarsSoFar,Vars):-
        var(Var), !,
        vars_in_term(T,[Var|VarsSoFar],Vars).
vars_in_term([Term|T],VarsSoFar,Vars):-
        Term =.. [_|Terms], !,
        vars_in_term(Terms,VarsSoFar,V1),
        vars_in_term(T,V1,Vars).
vars_in_term([_|T],VarsSoFar,Vars):-
        vars_in_term(T,VarsSoFar,Vars).

occurs_in(Vars,(Lit,_)):-
	occurs_in(Vars,Lit), !.
occurs_in(Vars,(_,Lits)):-
	!,
	occurs_in(Vars,Lits).
occurs_in(Vars,Lit):-
	functor(Lit,_,Arity),
	occurs1(Vars,Lit,1,Arity).

occurs1(Vars,Lit,Argno,MaxArgs):- 
	Argno =< MaxArgs,
	arg(Argno,Lit,Term),
	vars_in_term([Term],[],Vars1),
	member(X,Vars), member(Y,Vars1), 
	X == Y, !.
occurs1(Vars,Lit,Argno,MaxArgs):- 
	Argno < MaxArgs,
	Next is Argno + 1,
	occurs1(Vars,Lit,Next,MaxArgs).

do_precomputation:-
	pre_compute(Rule),
	split_clause(Rule,Head,Body),
	(clause(Head,Body) -> true;
		asserta(Rule),
		p_message('pre-computation'),
		p_message(Rule)),
	fail.
do_precomputation.

set_lazy_negs(_):-
	recorded(progol,set(lazy_negs,false),_), !.
set_lazy_negs(N):-
	N >= 100, !,
	recorda(progol,set(lazy_negs,true),_).
set_lazy_negs(_).

set_lazy_recalls:-
	recorded(progol,lazy_evaluate(Name/Arity),_),
	functor(Pred,Name,Arity),
	recorda(progol,lazy_recall(Name/Arity,0),_),
	recorded(progol,mode(Recall,Pred),_),
	recorded(progol,lazy_recall(Name/Arity,N),DbRef),
	(Recall = '*' -> RecallNum = 100; RecallNum = Recall),
	RecallNum > N,
	erase(DbRef),
	recorda(progol,lazy_recall(Name/Arity,RecallNum),_),
	fail.
set_lazy_recalls.

set_lazy_on_contradiction(_,_):-
	recorded(progol,set(lazy_on_contradiction,false),_), !.
set_lazy_on_contradiction(P,N):-
	Tot is P + N,
	Tot >= 100, !,
	set(lazy_on_contradiction,true).
set_lazy_on_contradiction(_,_).

% clause for testing partial clauses obtained in search
record_testclause(Name/Arity):-
	functor(Head,Name,Arity),
	Clause = (Head:-
			recorded(pclause,pclause(Head,Body),_),
			get_depth_limit(N),
			N >= 0,
			Body, !),
	assertz(Clause).

skolemize((Head:-Body),SHead,SBody,Start,SkolemVars):-
	!,
	copy_term((Head:-Body),(SHead:-Body1)),
	numbervars((SHead:-Body1),Start,SkolemVars),
	goals_to_list(Body1,SBody).
skolemize(UnitClause,Lit,[],Start,SkolemVars):-
	copy_term(UnitClause,Lit),
	numbervars(Lit,Start,SkolemVars).
skolemize(UnitClause,Lit):-
	skolemize(UnitClause,Lit,[],0,_).

record_nskolemized(Type,N1,Head,true):-
	!,
	assertz(example(N1,Type,Head)).
record_nskolemized(Type,N1,Head,Body):-
	assertz((example(N1,Type,Head):-Body)).

record_skolemized(Type,N1,SkolemVars,Head,Body):-
	assertz(example(N1,Type,Head)),
	functor(Head,Name,Arity),
	update_backpreds(Name/Arity),
	add_backs(Body),
	add_skolem_types(SkolemVars,Head,Body).

add_backs([]).
add_backs([Lit|Lits]):-
	recorda(progol,back(Lit),_),
	functor(Lit,Name,Arity),
	declare_dynamic(Name/Arity),
	assertz(Lit),
	add_backs(Lits).

add_skolem_types(10000,_,_):- !.	% no new skolem variables
add_skolem_types(_,Head,Body):-
	add_skolem_types([Head]),
	add_skolem_types(Body).

add_skolem_types([]).
add_skolem_types([Lit|Lits]):-
	functor(Lit,PSym,Arity),
	get_modes(PSym/Arity,L),
	add_skolem_types1(Lit,L),
	add_skolem_types(Lits).

add_skolem_types1(_,[]):- !.
add_skolem_types1(Fact,[Lit|Lits]):-
	split_args(Lit,I,O,C),
	add_skolem_types2(Fact,I),
	add_skolem_types2(Fact,O),
	add_skolem_types2(Fact,C),
	add_skolem_types1(Fact,Lits).

add_skolem_types2(_,[]).
add_skolem_types2(Literal,[ArgNo/Type|Rest]):-
	arg(ArgNo,Literal,Arg),
	SkolemType =.. [Type,Arg],
	(recorded(progol,back(SkolemType),_)-> true;
		recorda(progol,back(SkolemType),_),
		asserta(SkolemType)),
	add_skolem_types2(Literal,Rest).


copy_args(_,_,Arg,Arity):-
	Arg > Arity, !.
copy_args(Lit,Lit1,Arg,Arity):-
	arg(Arg,Lit,T),
	arg(Arg,Lit1,T),
	NextArg is Arg + 1,
	copy_args(Lit,Lit1,NextArg,Arity).

index_clause((Head:-true),NextClause,(Head)):-
	!,
	recorded(progol,last_clause(ClauseNum),DbRef1),
	erase(DbRef1),
	NextClause is ClauseNum + 1,
	recorda(progol,last_clause(NextClause),_).
index_clause(Clause,NextClause,Clause):-
	recorded(progol,last_clause(ClauseNum),DbRef1),
	erase(DbRef1),
	NextClause is ClauseNum + 1,
	recorda(progol,last_clause(NextClause),_).

update_backpreds(Name/Arity):-
	recorded(progol_dyn,backpred(Name/Arity),_), !.
update_backpreds(Name/Arity):-
	recordz(progol_dyn,backpred(Name/Arity),_).
	
reset_counts:-
	retractall(sat,last_term(_)),
	retractall(sat,last_var(_)),
	recorda(sat,last_term(0),_),
	recorda(sat,last_var(0),_), !.

% reset the number of successes for a literal: cut to avoid useless backtrack
reset_succ:-
        retractall(progol_dyn,last_success(_)),
        recorda(progol_dyn,last_success(0),_), !.

skolem_var(Var):-
	atomic(Var), !,
	name(Var,[36|_]).
skolem_var(Var):-
	gen_var(Num),
	name(Num,L),
	name(Var,[36|L]).

gen_var(Var1):-
	recorded(sat,last_var(Var0),DbRef), !,
	erase(DbRef),
        Var1 is Var0 + 1,
	recorda(sat,last_var(Var1),_).
gen_var(0):-
	recorda(sat,last_var(0),_).

copy_var(OldVar,NewVar,Depth):-
	gen_var(NewVar),
	recorded(vars,vars(OldVar,TNo,I,O),_),
	recorda(vars,vars(NewVar,TNo,[],[]),_),
	recorda(vars,copy(NewVar,OldVar,Depth),_).

gen_lit(Lit1):-
	recorded(sat,last_lit(Lit0),DbRef), !,
	erase(DbRef),
        Lit1 is Lit0 + 1,
	recorda(sat,last_lit(Lit1),_).
gen_lit(0):-
	recorda(sat,last_lit(0),_).

gen_refine_id(R1):-
	recorded(refine,last_refine(R0),DbRef), !,
	erase(DbRef),
	R1 is R0 + 1,
	recorda(refine,last_refine(R1),_).
gen_refine_id(0):-
	recorda(refine,last_refine(0),_).

gen_lits([],[]).
gen_lits([Lit|Lits],[LitNum|Nums]):-
	gen_lit(LitNum),
	recorda(lits,lit_info(LitNum,0,Lit,[],[],[]),_),
	gen_lits(Lits,Nums).

update_theory(ClauseIndex):-
        recorded(progol,hypothesis(OldLabel,Hypothesis,OldPCover,OldNCover),DbRef), 
        erase(DbRef),
	index_clause(Hypothesis,ClauseIndex,Clause),
        (recorded(progol,example_selected(_,Seed),_)-> true;
                PCover = [Seed-_|_]),
	(setting(lazy_on_cost,true) ->
		label_create(Clause,Label),
        	extract_pos(Label,PCover),
        	extract_neg(Label,NCover),
        	interval_count(PCover,PC),
        	interval_count(NCover,NC),
		OldLabel = [_,_|T],
        	recordz(progol,theory(ClauseIndex,[PC,NC|T]/Seed,Clause,PCover,NCover),_);
        	recordz(progol,theory(ClauseIndex,OldLabel/Seed,Clause,
					OldPCover,OldNCover),_)),
        (recorded(progol,rules(Rules),DbRef3)->
                erase(DbRef3),
                recorda(progol,rules([ClauseIndex|Rules]),_);
                recorda(progol,rules([ClauseIndex]),_)),
        assertz(Clause), !.


rm_seeds:-
	update_theory(ClauseIndex), !,
	recorded(progol,theory(ClauseIndex,_,_,PCover,_),_),
	rm_seeds(pos,PCover),
	recorded(progol,atoms_left(pos,PLeft),_),
	interval_count(PLeft,PL),
	p1_message('atoms left'), p_message(PL),
	!.
rm_seeds.

rm_seeds(Type,RmIntervals) :-
        recorded(progol,atoms_left(Type,OldIntervals),DbRef),
        erase(DbRef),
        rm_seeds1(RmIntervals,OldIntervals,NewIntervals),
        recordz(progol,atoms_left(Type,NewIntervals),_).
 
rm_seeds1([],Done,Done).
rm_seeds1([Start-Finish|Rest],OldIntervals,NewIntervals) :-
        rm_interval(Start-Finish,OldIntervals,MidIntervals),!,
        rm_seeds1(Rest,MidIntervals,NewIntervals).

% update lower estimate on maximum size cover set for an atom
update_coverset(Type,_):-
        recorded(progol,hypothesis(Label,_,PCover,_),_),
	Label = [_,_,_,Gain|_],
        worse_coversets(PCover,Type,Gain,Worse),
        (Worse = [] -> true;
                update_theory(NewClause),
                update_coversets(Worse,NewClause,Type,Label)).

% revise coversets of previous atoms
worse_coversets(_,_,_,[]):-
	not(recorded(progol,set(maxcover,true),_)), !.
worse_coversets([],_,_,[]).
worse_coversets([Interval|Intervals],Type,Gain,Worse):-
	worse_coversets1(Interval,Type,Gain,W1),
	worse_coversets(Intervals,Type,Gain,W2),
	append(W2,W1,Worse), !.

worse_coversets1(Start-Finish,_,_,[]):-
        Start > Finish, !.
worse_coversets1(Start-Finish,Type,Gain,Rest):-
        recorded(progol,max_set(Type,Start,Label1,_),_),
	Label1 = [_,_,_,Gain1|_],
        Gain1 >= Gain, !,
        Next is Start + 1,
        worse_coversets1(Next-Finish,Type,Gain,Rest), !.
worse_coversets1(Start-Finish,Type,Gain,[Start|Rest]):-
        Next is Start + 1,
        worse_coversets1(Next-Finish,Type,Gain,Rest), !.

update_coversets([],_,_,_).
update_coversets([Atom|Atoms],ClauseNum,Type,Label):-
	(recorded(progol,max_set(Type,Atom,_,_),DbRef)->
		erase(DbRef);
		true),
	recorda(progol,max_set(Type,Atom,Label,ClauseNum),_),
	update_coversets(Atoms,ClauseNum,Type,Label), !.

rm_intervals([],I,I).
rm_intervals([I1|I],Intervals,Result):-
	rm_interval(I1,Intervals,Intervals1), 
	rm_intervals(I,Intervals1,Result).

rm_interval(_,[],[]).
rm_interval(I1,[Interval|Rest],Intervals):-
	interval_intersection(I1,Interval,I2), !,
	interval_subtract(Interval,I2,I3),
	rm_interval(I1,Rest,I4),
	append(I4,I3,Intervals).
rm_interval(I1,[Interval|Rest],[Interval|Intervals]):-
	rm_interval(I1,Rest,Intervals).

% select N random samples from pos/neg set
% if N = 0 returns first example in pos/neg set
gen_sample(Type,0):-
	!,
	recorded(progol,atoms_left(Type,[ExampleNum-_|_]),_),
	retractall(progol,example_selected(_,_)),
	p1_message('select example'), p_message(ExampleNum),
	recordz(progol,example_selected(Type,ExampleNum),_).
gen_sample(Type,SampleSize):-
	recorded(progol,size(Type,_),_),
	recorded(progol,atoms_left(Type,Intervals),_),
	% p1_message('select from'), p_message(Intervals),
	interval_count(Intervals,AtomsLeft),
	N is min(AtomsLeft,SampleSize),
	recordz(progol_dyn,sample_num(0),_),
	retractall(progol,example_selected(_,_)),
	repeat,
	recorded(progol_dyn,sample_num(S1),DbRef),
	S is S1 + 1,
	(S =< N ->
		get_random(AtomsLeft,INum),
		select_example(INum,0,Intervals,ExampleNum),
		not(recorded(progol,example_selected(Type,ExampleNum),_)),
		p1_message('select example'), p_message(ExampleNum),
		erase(DbRef),
		recordz(progol_dyn,sample_num(S),_),
		recordz(progol,example_selected(Type,ExampleNum),_),
		fail;
		erase(DbRef)), !.

select_example(Num,NumberSoFar,[Start-Finish|_],ExampleNum):-
	Num =< NumberSoFar + Finish - Start + 1, !,
	ExampleNum is Num - NumberSoFar + Start - 1.
select_example(Num,NumberSoFar,[Start-Finish|Rest],ExampleNum):-
	N1 is NumberSoFar + Finish - Start + 1,
	select_example(Num,N1,Rest,ExampleNum).
	
get_random(Last,INum):-
	X is random,
	Num is X*Last,
	Num1 is Num + 0.5,
	INum1 is integer(Num1),
	(INum1 = 0 -> INum = 1; INum = INum1).

% dummy pre-defined example to allow Yap to treat example/3
% as a static predicate.
example('$$dummy','$$dummy','$$dummy').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L A B E L S
% 
% calculation on labels

label_create(Clause,Label):-
        split_clause(Clause,Head,Body),
	nlits((Head,Body),Length),
        recordz(pclause,pclause(Head,Body),DbRef),
        recorded(progol,atoms(pos,Pos),_),
        recorded(progol,atoms(neg,Neg),_),
        recorded(progol,set(depth,Depth),_),
        prove(Depth,pos,(Head:-Body),Pos,PCover,_),
        prove(Depth,neg,(Head:-Body),Neg,NCover,_),
        erase(DbRef),
        assemble_label(PCover,NCover,Length,Label), !.

label_create(pos,Clause,Label):-
        split_clause(Clause,Head,Body),
        recordz(pclause,pclause(Head,Body),DbRef),
        recorded(progol,atoms(pos,Pos),_),
        recorded(progol,set(depth,Depth),_),
        prove(Depth,pos,(Head:-Body),Pos,PCover,_),
        erase(DbRef),
        assemble_label(PCover,unknown,unknown,Label).
label_create(neg,Clause,Label):-
        split_clause(Clause,Head,Body),
        recordz(pclause,pclause(Head,Body),DbRef),
        recorded(progol,atoms(neg,Neg),_),
        recorded(progol,set(depth,Depth),_),
        prove(Depth,neg,(Head:-Body),Neg,NCover,_),
        erase(DbRef),
        assemble_label(unknown,NCover,unknown,Label).

label_pcover(Label,P):-
	extract_cover(pos,Label,P).
label_ncover(Label,N):-
	extract_cover(neg,Label,N).

label_union([],Label,Label):- !.
label_union(Label,[],Label):- !.
label_union(Label1,Label2,Label):-
        extract_cover(pos,Label1,Pos1),
        extract_cover(pos,Label2,Pos2),
        extract_cover(neg,Label1,Neg1),
        extract_cover(neg,Label2,Neg2),
        extract_length(Label1,L1),
        extract_length(Label2,L2),
        update_list(Pos2,Pos1,Pos),
        update_list(Neg2,Neg1,Neg),
        Length is L1 + L2,
        list_to_intervals(Pos,PCover),
        list_to_intervals(Neg,NCover),
        assemble_label(PCover,NCover,Length,Label).

label_print([]):- !.
label_print(Label):-
	(setting(evalfn,Eval)->true;Eval=coverage),
	evalfn(Eval,Label,Val),
	print_eval(Eval,Val).

print_eval(Evalfn,Val):-
	evalfn_name(Evalfn,Name),
	p1_message(Name), p_message(Val).


eval_rule(0,Label):-
	recorded(progol,hypothesis(_,Clause,_,_),_), !,
	label_create(Clause,Label),
	p_message('Rule 0'),
	pp_dclause(Clause),
	extract_count(pos,Label,PC),
	extract_count(neg,Label,NC),
	extract_length(Label,L),
	label_print([PC,NC,L]),
	nl.
eval_rule(ClauseNum,Label):-
	integer(ClauseNum),
	ClauseNum > 0,
	recorded(progol,theory(ClauseNum,_,Clause,_,_),_),
	!,
	label_create(Clause,Label),
	extract_count(pos,Label,PC),
	extract_count(neg,Label,NC),
	extract_length(Label,L),
	concat(['Rule ',ClauseNum],RuleTag),
	concat(['Pos cover = ',PC,' Neg cover = ',NC],CoverTag),
	p1_message(RuleTag), p_message(CoverTag),
	pp_dclause(Clause),
	label_print([PC,NC,L]),
	nl.
eval_rule(_,_).


evalfn(Label,Val):-
	(setting(evalfn,Eval)->true;Eval=coverage),
	evalfn(Eval,Label,Val).

evalfn_name(compression,'compression').
evalfn_name(coverage,'pos-neg').
evalfn_name(laplace,'laplace estimate').
evalfn_name(pbayes,'pseudo-bayes estimate').
evalfn_name(auto_m,'m estimate').
evalfn_name(mestimate,'m estimate').
evalfn_name(posonly,'posonly bayes estimate').
evalfn_name(user,'user defined cost').

evalfn(compression,[P,N,L],Val):-
	(P = -inf -> Val = -10000.0;
        	Val is P - N - L + 1), !.
evalfn(coverage,[P,N,L],Val):-
	(P = -inf -> Val = -10000;
		Val is P - N), !.
evalfn(laplace,[P,N,L],Val):-
	(P = -10000 -> Val = 0.5;
		Val is (P + 1) / (P + N + 2)), !.
% the evaluation functions below are due to James Cussens
evalfn(pbayes,[P,N,L],Val):-
        (P = -10000 -> Val = 0.5;
                Acc is P/(P+N),
                setting(prior,Prior),
                K is (Acc*(1 - Acc)) / ((Prior-Acc)^2 ),
                Val is (P + K*Prior) / (P + N + K)), !.
evalfn(MEst,[P,N,L],Val):-
        (MEst = auto_m; MEst = mestimate),
        (P = -10000 -> Val = 0.5;
                Cover is P + N,
                setting(prior,Prior),   
                (MEst = auto_m -> K is sqrt(Cover);
                        (setting(m,M) -> K = M; K is sqrt(Cover))),
                Val is (P + K*Prior) / (Cover+K)), !.
evalfn(_,_,-10000).


assemble_label(P,N,L,[P,N,L]).

extract_cover(pos,[P,_,_],P1):-
        intervals_to_list(P,P1), !.
extract_cover(neg,[_,N,_],N1):-
        intervals_to_list(N,N1),!.
extract_cover(_,[]).

extract_count(pos,[P,_,_],P1):-
	interval_count(P,P1), !.
extract_count(neg,[_,N,_],N1):-
	interval_count(N,N1), !.
extract_count(neg,_,0).


extract_pos([P,_,_],P).
extract_neg([_,N,_],N).
extract_length([_,_,L],L).

get_start_label(user,[1,0,2,-10000]):- !.
get_start_label(posonly,[1,0,2,-1,0]):- !.
get_start_label(Evalfn,[1,0,2,Val]):-
	evalfn(Evalfn,[1,0,2],Val).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L I B R A R Y

progol_help:-
        progol_help(help).
progol_help(Topic):-
        !,
        progol_help_dir(HelpDir),
        concat(['more ',HelpDir,'/',Topic],X),
        nl,
        execute(X),
        nl.

progol_portray(hypothesis):-
	hypothesis(Head,Body,_),
	Body,
	portray((Head:-Body)),
	write('Continue portray [y. or n.])? '), read(n), !.
progol_portray(hypothesis):- !.

progol_portray(X):-
	recorded(progol,set(pretty_print,true),_),
	recorded(progol,text(X,Text),_), !,
        print_text(Text).
progol_portray(X):-
        writeq(X).

progol_portray(Pretty,X):-
        (Pretty = true ->
                recorded(progol,text(X,Text),_),
                print_text(Text);
                writeq(X)).



execute(C):-
	system(C), !.
execute(_).

store(Variable):-
	(recorded(progol,set(Variable,Value),_) -> true; Value = unknown),
	retractall(progol,save(Variable,_)),
	recorda(progol,save(Variable,Value),_).

reinstate(Variable):-
	recorded(progol,save(Variable,Value),DbRef), !,
	erase(DbRef),
	(Value = unknown -> noset(Variable); set(Variable,Value)).
reinstate(_).

set(Variable,Value):-
	var(Value), !,
	recorded(progol,set(Variable,Value),_).
set(Variable,Value):-
	noset(Variable),
	recordz(progol,set(Variable,Value),_),
	special_consideration(Variable,Value).

setting(Variable,Value):-
	recorded(progol,set(Variable,Value),_).

noset(Variable):-
        recorded(progol,set(Variable,Value),DbRef), !,
	store(Variable),
	erase(DbRef), 
	rm_special_consideration(Variable,Value).
noset(_).

text(Literal,Text):-
	retractall(progol,text(Literal,_)),
	recordz(progol,text(Literal,Text),_).

man(M):-
	progol_manual(M).

determinations(Pred1,Pred2):-
	recorded(progol,determination(Pred1,Pred2),_).

determination(Pred1,Pred2):-
	recordz(progol,determination(Pred1,Pred2),_).

commutative(Pred):-
	recordz(progol,commutative(Pred),_).

symmetric(Pred):-
	set(check_symmetry,true),
	recordz(progol,symmetric(Pred),_).

lazy_evaluate(Name/Arity):-
        recordz(progol,lazy_evaluate(Name/Arity),_).

check_implication(Name/Arity):-
	recordz(progol,check_implication(Name/Arity),_),
	declare_dynamic(Name/Arity).

positive_only(Pred):-
	recordz(progol,positive_only(Pred),_).

mode(Recall,Pred):-
	recordz(progol,modeb(Mode,Pred),_),
	recordz(progol,mode(Recall,Pred),_).

modes(N/A,Mode):-
        Mode = modeh(Recall,Pred),
        recorded(progol,Mode,_),
        functor(Pred,N,A).
modes(N/A,Mode):-
        Mode = modeb(Recall,Pred),
        recorded(progol,Mode,_),
        functor(Pred,N,A).

modeh(Recall,Pred):-
	recordz(progol,modeh(Recall,Pred),_),
	recordz(progol,mode(Recall,Pred),_).

modeb(Mode,Pred):-
	recordz(progol,modeb(Mode,Pred),_),
	recordz(progol,mode(Mode,Pred),_).

show(settings):-
	p_message('settings'),
	findall(P-V,setting(P,V),L),
	sort(L,L1),
	member(Parameter-Value,L1),
        tab(8), write(Parameter=Value), nl,
        fail.
show(determinations):-
	p_message('determinations'),
	show1(progol,determination(_,_)).
show(modes):-
	p_message('modes'),
	show1(progol,mode(_,_)).
show(sizes):-
	p_message('sizes'),
	show1(progol,size(_,_)).
show(bottom):-
	p_message('bottom clause'),
	set(verbosity,V),
	V > 0,
	recorded(sat,last_lit(Last),_),
	get_clause(1,Last,[],FlatClause),
	pp_dlist(FlatClause).
show(hypothesis):-
	p_message('hypothesis'),
        recorded(progol,hypothesis(_,Clause,_,_),_),
	pp_dclause(Clause).
show(theory):-
        nl,
        p_message('theory'),
        nl,
        recorded(progol,rules(L),_),
        reverse(L,L1),
        member(ClauseNum,L1),
	recorded(progol,theory(ClauseNum,_,_,_,_),_),
	eval_rule(ClauseNum,_),
	% pp_dclause(Clause),
        fail.
show(theory):-
	get_performance.
show(pos):-
	p_message('positives'),
	store(greedy),
	examples(pos,_),
	reinstate(greedy),
	fail.
show(neg):-
	p_message('negatives'),
	store(greedy),
	examples(neg,_),
	reinstate(greedy),
	fail.
show(rand):-
	p_message('random'),
	examples(rand,_),
	fail.
show(imap):-
	p_message('implication map'),
	recorded(sat,implied_by(Lit,Lits),_),
	member(Lit1,Lits),
	get_pclause([Lit,Lit1],[],Clause,_,_,_),
	pp_dclause(Clause),
	fail.
show(prior):-
	p_message('refinement priors'),
	beta(Refine,A,B),
	copy_term(Refine,Refine1),
	numbervars(Refine1,0,_),
	write(beta(Refine1,A,B)), write('.'), nl,
	fail.
show(posterior):-
	p_message('refinement posterior'),
	recorded(refine,beta(R,A,B),_),
	recorded(refine,refine_id(Refine,R),_),
	copy_term(Refine,Refine1),
	numbervars(Refine1,0,_),
	write(beta(Refine1,A,B)), write('.'), nl,
	fail.
show(_).


settings:-
	show(settings).


examples(Type,List):-
        example(Num,Type,Atom),
        member1(Num,List),
        write(Atom), write('.'), nl,
        fail.
examples(_,_).

write_rules(File):-
        open(File,write,Stream),
        set_output(Stream),
	show(theory),
        close(Stream),
        set_output(user_output).
write_rules(_).

best_hypothesis(Head1,Body1,[P,N,L]):-
	recorded(search,selected([P,N,L|_],Clause,_,_),_),
	split_clause(Clause,Head2,Body2), !,
	Head1 = Head2, Body1 = Body2.

hypothesis(Head1,Body1,Label):-
	recorded(pclause,pclause(Head2,Body2),_), !,
	Head1 = Head2, Body1 = Body2,
	get_hyp_label((Head2:-Body2),Label).
hypothesis(Head1,Body1,Label):-
        recorded(progol,hypothesis(_,Clause,_,_),_),
	split_clause(Clause,Head2,Body2), !,
	Head1 = Head2, Body1 = Body2,
	get_hyp_label((Head2:-Body2),Label).


get_hyp_label(_,Label):- var(Label), !.
get_hyp_label((_:-Body),[P,N,L]):-
	nlits(Body,L1),
	L is L1 + 1,
	(recorded(progol_dyn,covers(_,P),_)-> true;
			covers(_),
			recorded(progol_dyn,covers(_,P),_)),
	(recorded(progol_dyn,coversn(_,N),_)-> true;
			coversn(_),
			recorded(progol_dyn,coversn(_,N),_)).

rdhyp:-
	retractall(pclause,pclause(_,_)),
	retractall(progol_dyn,covers(_)),
        read(Clause),
        add_hyp(Clause),
        nl,
        show(hypothesis).

addhyp:-
        recorded(progol,hypothesis(Label,_,PCover,_),_), !,   
        rm_seeds,
        worse_coversets(PCover,pos,Label,Worse),
        recorded(progol,last_clause(NewClause),_),
        (Worse = [] -> true;
                update_coversets(Worse,NewClause,pos,Label)), !.
addhyp:-
        recorded(search,selected(Label,RClause,PCover,NCover),_), !,
        add_hyp(Label,RClause,PCover,NCover),
        rm_seeds,
        worse_coversets(PCover,pos,Label,Worse),
        recorded(progol,last_clause(NewClause),_),
        (Worse = [] -> true;
                update_coversets(Worse,NewClause,pos,Label)), !.

covers:-
        get_hyp(Hypothesis),
        label_create(Hypothesis,Label),
        extract_cover(pos,Label,P),
        examples(pos,P),
	length(P,PC),
	p1_message('examples covered'),
	p_message(PC),
	retractall(progol_dyn,covers(_,_)),
	recorda(progol_dyn,covers(P,PC),_).
coversn:-
        get_hyp(Hypothesis),
        label_create(Hypothesis,Label),
        extract_cover(neg,Label,N),
        examples(neg,N),
	length(N,NC),
	p1_message('examples covered'),
	p_message(NC),
	retractall(progol_dyn,coversn(_,_)),
	recorda(progol_dyn,coversn(N,NC),_).

covers(P):-
	get_hyp(Hypothesis),
	label_create(pos,Hypothesis,Label),
	retractall(progol_dyn,covers(_,_)),
	extract_pos(Label,PCover),
	interval_count(PCover,P),
	recorda(progol_dyn,covers(PCover,P),_).

coversn(N):-
	get_hyp(Hypothesis),
	label_create(neg,Hypothesis,Label),
	retractall(progol_dyn,coversn(_,_)),
	extract_neg(Label,NCover),
	interval_count(NCover,N),
	recorda(progol_dyn,coversn(NCover,N),_).

mincovers(Min):-
	get_hyp(Hypothesis),
	retractall(progol_dyn,covers(_,_)),
	prove_at_least(pos,Hypothesis,Min,PCover,P),
	recorda(progol_dyn,covers(PCover,P),_).
mincoversn(Min):-
	get_hyp(Hypothesis),
	retractall(progol_dyn,coversn(_,_)),
	prove_at_least(neg,Hypothesis,Min,NCover,N),
	recorda(progol_dyn,coversn(NCover,N),_).
maxcovers(Max):-
	get_hyp(Hypothesis),
	retractall(progol_dyn,covers(_,_)),
	prove_at_most(pos,Hypothesis,Max,PCover,P),
	recorda(progol_dyn,covers(PCover,P),_).
maxcoversn(Max):-
	get_hyp(Hypothesis),
	retractall(progol_dyn,coversn(_,_)),
	prove_at_most(neg,Hypothesis,Max,NCover,N),
	recorda(progol_dyn,coversn(NCover,N),_).

example_saturated(Example):-
	recorded(sat,sat(Num,Type),_),
	example(Num,Type,Example).

reset:-
        clean_up,
        retractall(cache,_),
        retractall(prune_cache,_),
        set(stage,command),
	set(construct_bottom,saturation),
	set(refineop,false),
        set(lazy_on_cost,false),
        set(nodes,5000),
        set(samplesize,1),
        set(minpos,1),
        set(gsamplesize,100),
        set(clauselength,4),
        set(explore,false),
        set(caching,false),
        set(greedy,false),
        set(refine,false),
	set(proof_strategy,restricted_sld),
        set(search,bf),
        set(prune_defs,false),
        set(evalfn,coverage),
        set(depth,5),
        set(verbosity,1),
        set(i,2),
        set(noise,0),
        set(print,4),
	set(splitvars,false).


% Auxilliary definitions needed for above

special_consideration(noise,_):-
        noset(minacc), !.
special_consideration(minacc,_):-
        noset(noise), !.

% the following needed for compatibility with earlier versions
special_consideration(search,ida):-
	set(search,bf), set(evalfn,coverage), !.
special_consideration(search,compression):-
	set(search,heuristic), set(evalfn,compression), !.
special_consideration(search,posonly):-
	set(search,heuristic), set(evalfn,posonly), !.
special_consideration(search,user):-
	set(search,heuristic), set(evalfn,user), !.

special_consideration(caching,true):-
	(setting(cache_clauselength,_)->true;set(cache_clauselength,3)).

special_consideration(search,bf):-
	(setting(evalfn,_) -> true; set(evalfn,coverage)), !.
special_consideration(search,df):-
	(setting(evalfn,_) -> true; set(evalfn,coverage)), !.
special_consideration(search,heuristic):-
	(setting(evalfn,_)->true; set(evalfn,compression)), !.
special_consideration(evalfn,coverage):-
	(setting(search,_)->true; set(search,bf)).
special_consideration(evalfn,S):-
	(setting(search,_)->true; set(search,heuristic)),
	(S = posonly -> noset(noise);
		recorded(progol,atoms(neg,NegE),_),
		recorded(progol,atoms_left(neg,[]),DbRef),
		erase(DbRef),
		reinstate(noise),
		recorda(progol,atoms_left(neg,NegE),_)).
special_consideration(refine,user):-
	set(refineop,true), !.
special_consideration(refine,auto):-
	gen_auto_refine, !.
special_consideration(refine,probabilistic):-
	set(caching,true),
	set(refineop,true),
	gen_auto_refine, !.
special_consideration(construct_bottom,reduction):-
	(setting(lazy_bottom,true) -> true; set(lazy_bottom,true)), !.
special_consideration(construct_bottom,saturation):-
	noset(lazy_bottom), !.
special_consideration(lazy_bottom,true):-
	(setting(construct_bottom,false) -> true; set(construct_bottom,reduction)), !.
special_consideration(lazy_bottom,false):-
	(setting(construct_bottom,false) -> true; set(construct_bottom,saturation)), !.
special_consideration(verbose,N):-
        set(verbosity,N), !.
special_consideration(pretty_print,true):-
	set(print,1), !.
special_consideration(_,_).

rm_special_consideration(caching,true):-
	noset(cache_clauselength), !.
rm_special_consideration(pretty_print,_):-
	set(print,4), !.
rm_special_consideration(verbose,_):-
	noset(verbosity), !.
rm_special_consideration(refine,_):-
	set(refineop,false), !.
rm_special_consideration(lazy_bottom,true):-
	(setting(refine,auto) -> set(refine,false); true), !.
rm_special_consideration(_,_).

show(Area,Name/Arity):-
        functor(Pred,Name,Arity),
        show1(Area,Pred).
show(_,_).

get_hyp((Head:-Body)):-
	recorded(pclause,pclause(Head,Body),_), !.
get_hyp(Hypothesis):-
        recorded(progol,hypothesis(_,Hypothesis,_,_),_).

add_hyp(end_of_file):- !.
add_hyp(Clause):-
        nlits(Clause,L),
	label_create(Clause,Label),
        extract_count(pos,Label,PCount),
        extract_count(neg,Label,NCount),
        Label1 = [PCount,NCount,L],
        retractall(progol,hypothesis(_,_,_,_)),
        extract_pos(Label,P),
        extract_neg(Label,N),
        recorda(progol,hypothesis(Label1,Clause,P,N),_).

add_hyp(Label,Clause,P,N):-
        retractall(progol,hypothesis(_,_,_,_)),
        recorda(progol,hypothesis(Label,Clause,P,N),_).

rmhyp:-
	recorded(pclause,pclause(Head,Body),DbRef),
	erase(DbRef),
	recorda(progol_dyn,tmpclause(Head,Body),_), !.
rmhyp:-
        recorded(progol,hypothesis(Label,Clause1,P,N),DbRef),
	erase(DbRef),
	recorda(progol_dyn,tmphypothesis(Label,Clause1,P,N),_), !.
rmhyp.

restorehyp:-
	recorded(progol_dyn,tmpclause(Head,Body),DbRef),
	erase(DbRef),
	recordz(pclause,pclause(Head,Body),_), !.
restorehyp:-
	recorded(progol_dyn,tmphypothesis(Label,Clause1,P,N),DbRef),
	erase(DbRef),
        recorda(progol,hypothesis(Label,Clause1,P,N),_), !.
restorehyp.

show1(Area,Pred):-
        recorded(Area,Pred,_),
        copy_term(Pred,Pred1), numbervars(Pred1,0,_),
        write(Pred1), write('.'), nl,
        fail.
show1(_,_).

clear_hyp:-
        retractall(progol,hypothesis(_,_,_,_)).

time(P,N,AvTime):-
        Start is cputime,
        time_loop(N,P),
        Stop is cputime,
        Time is Stop - Start,
        AvTime is Time/N.
        
 
time_loop(0,_):- !.
time_loop(N,P):-
        P,
        N1 is N - 1,
        time_loop(N1,P).

list_profile :-
	% get number of calls for each profiled procedure
	findall(D-P,profile_data(P,calls,D),LP),
	% sort them
	sort(LP,SLP),
	% and output (note the most often called predicates will come last
	write_profile_data(SLP).

write_profile_data([]).
	write_profile_data([D-P|SLP]) :-
	% just swap the two calls to get most often called predicates first.
	format('~w: ~w~n', [P,D]),
	write_profile_data(SLP).

test(File,Flag,N,T):-
	retractall(progol_dyn,covered(_)),
	retractall(progol_dyn,total(_)),
	recorda(progol_dyn,covered(0),_),
	recorda(progol_dyn,total(0),_),
	open(File,read,Stream),
	repeat,
	read(Stream,Fact),
	(Fact = end_of_file -> close(Stream);
		recorded(progol_dyn,total(T0),DbRef),
		erase(DbRef),
		T1 is T0 + 1,
		recorda(progol_dyn,total(T1),_),
		(once(Fact) ->
			(Flag = show ->
				p1_message(covered),
				progol_portray(Fact),
				nl;
				true);
			(Flag = show ->
				p1_message('not covered'),
				progol_portray(Fact),
				nl;
				true),
			fail),
		recorded(progol_dyn,covered(N0),DbRef1),
		erase(DbRef1),
		N1 is N0 + 1,
		recorda(progol_dyn,covered(N1),_),
		fail),
	!,
	recorded(progol_dyn,covered(N),DbRef2),
	erase(DbRef2),
	recorded(progol_dyn,total(T),DbRef3),
	erase(DbRef3).

:- progol_version(V), set(version,V), reset.
