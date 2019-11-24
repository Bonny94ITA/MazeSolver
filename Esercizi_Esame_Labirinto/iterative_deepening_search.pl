:- ['./labirinto.pl', 'mosse.pl'].

%   Algoritmo Iterative Deepening a cui viene fornita una soglia iniziale di 1.
%   Il limite viene incrementato ogni volta che non viene trovato uno stato obiettivo
%   ad una certa profondità limite.
%   L'algoritmo procede fino al raggiungimento di d, la profondità più piccola in cui
%   trovare lo stato obiettivo.

id(Soluzione):-
    statistics(walltime, [_ | [_]]),
    id_search_aux(Soluzione, 1),
    statistics(walltime, [_ | [TempoEsecuzione]]),
    write('TEMPO IMPIEGATO: '), write(TempoEsecuzione), write(' ms.'), nl.

% #####################################################################
% id_search_aux(Soluzione,Soglia)
%                 output   input
% #####################################################################
id_search_aux(Soluzione,Soglia):-
    %% depth_limited_search(Soluzione,Soglia),
    iniziale(S),
    dls_aux(S,Soluzione,[S],Soglia),
    write("Soluzione raggiunta a profondita': "),
    write(Soglia), nl,!.
id_search_aux(Soluzione,Soglia):-
    NuovaSoglia is Soglia+1,
    id_search_aux(Soluzione,NuovaSoglia).

% #####################################################################
% depth_limited_search(Soluzione, Soglia)
%                       output    input
% #####################################################################
%% depth_limited_search(Soluzione,Soglia):-
%%     iniziale(S),
%%     dls_aux(S,Soluzione,[S],Soglia).

% #####################################################################
% dls_aux(StatoCorrente, ListaAzioni, ListaNodiVisitati,Soglia):-
%             input         output     intput            input
% #####################################################################
dls_aux(S,[],_,_):-finale(S).
dls_aux(S,[Azione|AzioniTail],Visitati,Soglia):-
    Soglia>0,
    applicabile(Azione,S),
    trasforma(Azione,S,SNuovo),
    \+member(SNuovo,Visitati),
    NuovaSoglia is Soglia-1,
    dls_aux(SNuovo,AzioniTail,[SNuovo|Visitati],NuovaSoglia).
