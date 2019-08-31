:- use_module(library(heaps)).


	
	


smallest(List,Min) :- sort(List,[Min|_]).
	