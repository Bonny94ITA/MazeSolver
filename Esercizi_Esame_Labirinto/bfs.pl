%bfs(Soluzione)
bfs(Soluzione):-
    iniziale(S),
    bfsAux([nodo(S,[])],[],Soluzione).

%Coda = [nodo(S,Azioni)|...]
%bfsAux(Coda,Visitati,Soluzione)
bfsAux([nodo(S,Azioni)|_],_,Azioni):-finale(S),!.
bfsAux([nodo(S,Azioni)|Tail],Visitati,Soluzione):-
    findall(Azione,applicabile(Azione,S),ListaApplicabili),
    generaFigli(nodo(S,Azioni),ListaApplicabili,[S|Visitati],ListaFigli),
    append(Tail,ListaFigli,NuovaCoda),
    bfsAux(NuovaCoda,[S|Visitati],Soluzione).

%generaFigli(Nodo,ListaAzioniApplicabili,ListaStatiVisitati,ListaNodiFigli)
generaFigli(_,[],_,[]).
generaFigli(nodo(S,AzioniPerS),[Azione|AltreAzioni],Visitati,[nodo(SNuovo,[Azione|AzioniPerS])|FigliTail]):-
    trasforma(Azione,S,SNuovo),
    \+member(SNuovo,Visitati),!,
    generaFigli(nodo(S,AzioniPerS),AltreAzioni,Visitati,FigliTail).
generaFigli(nodo(S,AzioniPerS),[_|AltreAzioni],Visitati,FigliTail):-
    generaFigli(nodo(S,AzioniPerS),AltreAzioni,Visitati,FigliTail).
