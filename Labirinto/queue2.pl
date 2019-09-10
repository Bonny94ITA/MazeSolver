:- use_module(library(heaps)).

initial_estates([node(2,5,4,3),node(2,510,4,3),node(3,5,4,3)]).
nodetwo(node(X, _, _, _)).

than([], X, Y).
than([H|T], X, [H1|T1]) :-
        H < X,
        less_than(T, X, H).
	


smallest(List,Min) :- sort(List,[Min|_]).
	