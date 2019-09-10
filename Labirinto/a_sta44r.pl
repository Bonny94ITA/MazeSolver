%Dimensione labirinto.
num_col(3).
num_righe(3).

%Celle con ostacoli.

/*occupata(pos(2,5)).
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
occupata(pos(4,9)).*/
occupata(pos(0,0)).
iniziale(pos(1,1)).
finale(pos(3,3)).

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

    %CellaCorrente: cella di partenza da cui calcolare adiacenti,
    %ListaAdiacenti: Lista contenente la cella ad {nord,sud,ovest,est} in base alla regola, oppure vuota.
cellaAdiacenteEst(CellaCorrente,ListaAdiacenti):-
    applicabile(est,CellaCorrente),
    trasforma(est,CellaCorrente,CellaAdiacenteEst),
    append(_,[CellaAdiacenteEst],ListaAdiacenti),!;
    \+applicabile(est,CellaCorrente),
    append(_,[],ListaAdiacenti),!.

    %CellaCorrente: cella di partenza da cui calcolare adiacenti,
    %ListaAdiacenti: Lista contenente la cella a {nord,sud,ovest,est} in base alla regola, oppure (;) vuota se lo spostamento non applicabile.
cellaAdiacenteOvest(CellaCorrente,ListaAdiacenti):-
    applicabile(ovest,CellaCorrente),
    trasforma(ovest,CellaCorrente,CellaAdiacenteOvest),
    append(_,[CellaAdiacenteOvest],ListaAdiacenti),!;
    \+applicabile(ovest,CellaCorrente),
    append(_,[],ListaAdiacenti),!.

    %CellaCorrente: cella di partenza da cui calcolare adiacenti,
    %ListaAdiacenti: Lista contenente la cella a {nord,sud,ovest,est} in base alla regola, oppure (;) vuota se lo spostamento non applicabile.
cellaAdiacenteNord(CellaCorrente,ListaAdiacenti):-
    applicabile(nord,CellaCorrente),
    trasforma(nord,CellaCorrente,CellaAdiacenteNord),
    append(_,[CellaAdiacenteNord],ListaAdiacenti),!;
    \+applicabile(nord,CellaCorrente),
    append(_,[],ListaAdiacenti),!.

    %CellaCorrente: cella di partenza da cui calcolare adiacenti,
    %ListaAdiacenti: Lista contenente la cella a {nord,sud,ovest,est} in base alla regola, oppure (;) vuota se lo spostamento non applicabile.
cellaAdiacenteSud(CellaCorrente,ListaAdiacenti):-
    applicabile(sud,CellaCorrente),
    trasforma(sud,CellaCorrente,CellaAdiacenteSud),
    append(_,[CellaAdiacenteSud],ListaAdiacenti),!;
    \+applicabile(sud,CellaCorrente),
    append(_,[],ListaAdiacenti),!.

    %CellaCorrente: cella di partenza da cui calcolare adiacenti,
    %ListaAdiacenti: Lista contenente le celle adiacenti a CellaCorrente.
celleAdiacenti(CellaCorrente,ListaAdiacenti):-
    cellaAdiacenteEst(CellaCorrente,E),
    cellaAdiacenteOvest(CellaCorrente,O),
    cellaAdiacenteNord(CellaCorrente,N),
    cellaAdiacenteSud(CellaCorrente,S),
    append(E,O,EO),
    append(N,S,NS),
    append(EO,NS,ListaAdiacenti).

bfs(Soluzione):-
    iniziale(S),
    hCosto(S,F),
    bfs_aux([nodo(S,[],0,F)],[],Soluzione).

% bfs_aux(Coda,Visitati,Soluzione)
% Coda = [nodo(S,Azioni)|...]
bfs_aux([nodo(S,Azioni,_,_)|_],_,Azioni):-finale(S),!.
bfs_aux([nodo(S,Azioni,G,F)|Tail],Visitati,Soluzione):-
    findall(Azione,applicabile(Azione,S),ListaApplicabili),
    generaFigli(nodo(S,Azioni,G,F),Tail,ListaApplicabili,[nodo(S, Azioni,_,_)|Visitati],ListaFigli),
    append(Tail,ListaFigli,NuovaCoda),
    write(NuovaCoda),nl,nl,
    bfs_aux(NuovaCoda,[nodo(S,Azioni)|Visitati],Soluzione).

generaFigli(_,_,[],_,[]):-!.
generaFigli(nodo(S,AzioniPerS,G,F),Opened,[Azione|AltreAzioni],Visitati,[nodo(SNuovo,[Azione|AzioniPerS],G1,F1)|FigliTail]):-
    trasforma(Azione,S,SNuovo),
    gCosto(G,G1),
    hCosto(S,H),
    fCosto(H,G,F1),
    \+member(nodo(SNuovo,_),Visitati),
    \+member(nodo(SNuovo,_),Opened),!,
    generaFigli(nodo(S,AzioniPerS,G,F),Opened,AltreAzioni,Visitati,FigliTail).
generaFigli(nodo(S,AzioniPerS,G,F),Opened,[_|AltreAzioni],Visitati,FigliTail):-
    generaFigli(nodo(S,AzioniPerS,G,F),Opened,AltreAzioni,Visitati,FigliTail).

hCosto(CellaCorrente, Costo):-
    finale(Goal),
    distanzaManhattan(CellaCorrente,Goal,Distanza),
    Costo is Distanza.

gCosto(G,G1) :-
    G1 is G+1.

fCosto(G,H,F) :-
    F is G + H.

distanzaManhattan(pos(X1,Y1),pos(X2,Y2),Distanza) :-
    Distanza is abs(X1-X2) + abs(Y1-Y2).

costoPasso(pos(_,_), pos(_, _), Costo) :-
    Costo is 1.
