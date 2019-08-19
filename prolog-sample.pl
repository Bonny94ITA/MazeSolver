#fact source

male(goku).
female(chichi).
parent(goku, gohan).
parent(chichi, gohan).

parent_of(X, Y, Z) :- male(X), female(Y), parent(X, Z), parent(Y, Z).

/*
#running the program

where: query -> result

male(goku). -> true


female(goku). -> false
parent(goku, gohan). -> true
parent(goku, chichi). -> false
parent(X, gohan). -> X = goku
parent_of(vegeta, bulma, trunks). -> false (although its true, its still considered false since its not in the fact source)
parent_of(X, Y, gohan). -> X = goku, Y = chichi
parent_of(goku, chichi, gohan). -> true*/