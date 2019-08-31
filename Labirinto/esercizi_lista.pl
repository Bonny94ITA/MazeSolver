num_col(3).
num_righe(3).

occupata(pos(0,0)).
%occupata(pos(2,2)).
%occupata(pos(2,3)).
%occupata(pos(3,2)).

iniziale(pos(1,1)).
finale(pos(3,3)).

sommaLista([], 0).

sommaLista([Head | Tail], S) :-
    sommaLista(Tail,Somma),
    S is (Somma + Head).

reverseLista([Head|[]], [Head]).

reverseLista([Head|Tail], Reverted):-
    reverseLista(Tail, Partial),!,
    append(Partial, [Head], Reverted).

% nth(Lista,Posizione,Valore)
nth([Head|_],0,Head):-!.
nth([_|Tail],Pos,X):-
    nonvar(Pos),!,
    Pos1 is Pos-1,
    nth(Tail,Pos1,X).
nth([_|Tail],Pos,X):-
    nth(Tail,Pos1,X),
    Pos is Pos1+1.

min_in_list([Min],Min).

min_in_list([nodo(A,_,_),nodo(A1,_,_)|T],M) :-
    A =< A1,
    min_in_list([nodo(A,_,_)|T],M).

min_in_list([nodo(A,_,_),nodo(A1,_,_)|T],M) :-
    A > A1,
    min_in_list([nodo(A1,_,_)|T],M).

% swap(Lista,Pos1,Pos2,NuovaLista)

swap(Lista,Pos1,Pos2,NuovaLista):-
  nth(Lista,Pos1,X1),
  nth(Lista,Pos2,X2),
  setElement(Lista,Pos2,X1,Temp),
  setElement(Temp,Pos1,X2,NuovaLista).

% setElement(Lista,Posizione,Valore,NuovaLista)

setElement([_|Tail],0,X,[X|Tail]):-!.
setElement([Head|Tail],Pos,X,[Head|NuovaTail]):-
  Pos1 is Pos-1,
  setElement(Tail,Pos1,X,NuovaTail).

%addElement(NewElement,OldList,NewList).
addElement(X, [], [X]).
addElement(X, [Y | Rest], [X,Y | Rest]) :- X @< Y, !.
addElement(X, [Y | Rest1], [Y | Rest2]) :- addElement(X, Rest1, Rest2).

addListToList([],ListaFinale,ListaFinale):-!.
addListToList([Head|Tail],VecchiaLista,ListaRes) :-
    addElement(Head,VecchiaLista,ListaTemp),
    addListToList(Tail,ListaTemp,ListaRes).
    
minimo([X], X) :- !.
minimo([X,Y|Tail], N):-
    ( X > Y ->
        minimo([Y|Tail], N)
    ;
        minimo([X|Tail], N)
    ).
