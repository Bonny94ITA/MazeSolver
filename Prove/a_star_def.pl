% Esempio 3 x 3
num_col(3).
num_righe(3).

iniziale(pos(1,1)).
finale(pos(3,3)).
occupata(pos(0,0)).
/*
occupata(pos(2,1)).
occupata(pos(3,1)).
occupata(pos(1,3)).
occupata(pos(2,3)).
*/

/*
% Esempio 10 x 10
num_col(10).
num_righe(10).

occupata(pos(1,5)).
occupata(pos(2,5)).
occupata(pos(3,5)).
occupata(pos(4,5)).
occupata(pos(5,5)).
occupata(pos(6,5)).
occupata(pos(7,5)).
occupata(pos(7,1)).
occupata(pos(7,2)).
occupata(pos(7,3)).
occupata(pos(7,4)).
occupata(pos(5,7)).
occupata(pos(6,7)).
occupata(pos(7,7)).
occupata(pos(8,7)).
occupata(pos(4,7)).
occupata(pos(4,8)).
occupata(pos(4,9)).
occupata(pos(4,10)).

iniziale(pos(4,2)).
finale(pos(7,9)).
*/

/*
num_col(7).
num_righe(7).
occupata(pos(1,4)).
occupata(pos(1,3)).
occupata(pos(2,4)).
occupata(pos(3,4)).
occupata(pos(2,1)).
occupata(pos(3,1)).
occupata(pos(3,2)).
occupata(pos(4,1)).
occupata(pos(4,2)).

occupata(pos(0,0)).
iniziale(pos(1,1)).
finale(pos(7,7)).
*/

%check su applicabilità mossa.
applicabile(nord,pos(R,C)) :- R>1, R1 is R-1, \+ occupata(pos(R1,C)).
applicabile(sud,pos(R,C)) :- num_righe(NR), R<NR, R1 is R+1, \+ occupata(pos(R1,C)).
applicabile(ovest,pos(R,C)) :- C>1, C1 is C-1, \+ occupata(pos(R,C1)).
applicabile(est,pos(R,C)) :- num_col(NC), C<NC, C1 is C+1, \+ occupata(pos(R,C1)).

%Esecuzione dell'azione se applicabile.
trasforma(est,pos(R,C),pos(R,C1)) :-   C1 is C+1.
trasforma(ovest,pos(R,C),pos(R,C1)) :- C1 is C-1.
trasforma(sud,pos(R,C),pos(R1,C)) :-   R1 is R+1.
trasforma(nord,pos(R,C),pos(R1,C)) :-  R1 is R-1.

bfs(Soluzione):-
    iniziale(S),
    hCosto(S,F),
    bfs_aux([nodo(F,S,[],0)],[],SoluzioneInversa),
    reverse(SoluzioneInversa,Soluzione).

% bfs_aux(Coda,Visitati,Soluzione)
% Coda = [nodo(S,Azioni)|...]
bfs_aux([nodo(_,S,Azioni,_)|_],_,Azioni):-finale(S),!.
bfs_aux([nodo(F,S,Azioni,G)|ApertiTail],Chiusi,Soluzione):-
    findall(Azione,applicabile(Azione,S),ListaApplicabili),
    generaFigli(nodo(F,S,Azioni,G),ApertiTail,ListaApplicabili,[S|Chiusi],ListaFigli),
    aggiuntaFigliInAperti(ListaFigli,ApertiTail,Chiusi,NuoviAperti),
    %addElement(Tail,ListaFigli,NuoviAperti),
    /*min_in_list(NuoviAperti,NodoMinimoF),
    select(NodoMinimoF,NuoviAperti,NuoviApertiTail),*/
    bfs_aux(NuoviAperti,[nodo(_,S,Azioni,_)|Chiusi],Soluzione),!.

generaFigli(_,_,[],_,[]):-!.
generaFigli(nodo(F,S,AzioniPerS,G),Aperti,[Azione|AltreAzioni],Chiusi,[nodo(F1,SNuovo,[Azione|AzioniPerS],G1)|FigliTail]):-
    trasforma(Azione,S,SNuovo),
    \+member(nodo(_,SNuovo,_,_),Chiusi),
    \+member(nodo(_,SNuovo,_,_),Aperti),!,
    gCosto(G,G1),
    hCosto(S,H),
    fCosto(H,G,F1), write(F1),nl,
    generaFigli(nodo(F,S,AzioniPerS,G),Aperti,AltreAzioni,Chiusi,FigliTail).
generaFigli(nodo(F,S,AzioniPerS,G),Aperti,[_|AltreAzioni],Chiusi,FigliTail):-
    generaFigli(nodo(F,S,AzioniPerS,G),Aperti,AltreAzioni,Chiusi,FigliTail).

%aggiuntaOrdinataElem(NewElement,OldList,NewList).
aggiuntaOrdinataElem(X, [], [X]).
aggiuntaOrdinataElem(X, [Y | Rest], [X,Y | Rest]) :- X @< Y, !.
aggiuntaOrdinataElem(X, [Y | Rest1], [Y | Rest2]) :- aggiuntaOrdinataElem(X, Rest1, Rest2).

%aggiuntaFigliInAperti(ListToBeInserted,Aperti,Closed,ResultingList)
aggiuntaFigliInAperti([],ListaFinale,_,ListaFinale):-!.
aggiuntaFigliInAperti([Head|Tail],VecchiAperti,Chiusi,ListaRes) :-
    gestioneApertiChiusi(Head,VecchiAperti,NuoviAperti,Chiusi,NuoviChiusi),
    %aggiuntaOrdinataElem(Head,NuoviAperti,ListaTemp),
    aggiuntaFigliInAperti(Tail,ListaTemp,NuoviChiusi,ListaRes).

gestioneApertiChiusi(nodo(F,S,_,_),Aperti,NuoviAperti,_,_) :-
    member(nodo(X,S,_,_),Aperti),
    F < X,
    select(nodo(X,S,_,_),Aperti,NuoviAperti),
    aggiuntaOrdinataElem(Head,NuoviAperti,ListaTemp).

gestioneApertiChiusi(nodo(F,S,_,_),_,_,Chiusi,NuoviChiusi) :-
    member(nodo(X,S,_,_),Chiusi),
    F < X,
    select(nodo(X,S,_,_),Chiusi,NuoviChiusi).

gestioneApertiChiusi(nodo(_,S,_,_),Aperti,_,Chiusi,_) :-
    \+member(nodo(_,S,_,_),Chiusi),
    \+member(nodo(_,S,_,_),Aperti),
    aggiuntaOrdinataElem(Head,NuoviAperti,ListaTemp).


gCosto(G,G1) :-
    G1 is G+1.

hCosto(CellaCorrente, Costo):-
    finale(Goal),
    distanzaManhattan(CellaCorrente,Goal,Distanza),
    Costo is Distanza.

fCosto(G,H,F) :-
    F is G + H.

distanzaManhattan(pos(X1,Y1),pos(X2,Y2),Distanza) :-
    Distanza is abs(X1-X2) + abs(Y1-Y2).

min_in_list([Min],Min).
min_in_list([nodo(A,_,_,_),nodo(A1,_,_,_)|T],M) :-
    A =< A1,
    min_in_list([nodo(A,_,_,_)|T],M).

min_in_list([nodo(A,_,_,_),nodo(A1,_,_,_)|T],M) :-
    A > A1,
    min_in_list([nodo(A1,_,_,_)|T],M).

nth([Head|_],0,Head):-!.
nth([_|Tail],Pos,X):-
    nonvar(Pos),!,
    Pos1 is Pos-1,
    nth(Tail,Pos1,X).
nth([_|Tail],Pos,X):-
    nth(Tail,Pos1,X),
    Pos is Pos1+1.
