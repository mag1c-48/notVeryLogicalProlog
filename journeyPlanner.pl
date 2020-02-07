route(dublin, cork, 200, 'fct').
route(cork, dublin, 200, 'fct').
route(cork, corkAirport, 20, 'fc').
route(corkAirport, cork, 25, 'fc').
route(dublin, dublinAirport, 10, 'fc').
route(dublinAirport, dublin, 20, 'fc').
route(dublinAirport, corkAirport, 225, 'p').
route(corkAirport, diblinAirport, 225, 'p').


foot(Arg1, Arg2, Time) :- route(Arg1, Arg2, D, _), Time = D / 5.
car(Arg1, Arg2, Time) :- route(Arg1, Arg2, D, _), Time = D / 80.
train(Arg1, Arg2, Time) :- route(Arg1, Arg2, D, _), Time = D / 100.
plane(Arg1, Arg2, Time) :- route(Arg1, Arg2, D, _), Time = D / 500.
startRoute(Route) :- Route = _, Route = [].

timeChecker(Arg1, Arg2, PossibleTransport, Mode, Time) :- 
    route(Arg1, Arg2, _, StringyBoy), string_chars(StringyBoy, Transport), 
    string_chars(PossibleTransport, Transport2), member(f, Transport), member(f, Transport2), Mode = "f", foot(Arg1, Arg2, Time), !.
timeChecker(Arg1, Arg2, PossibleTransport, Mode, Time) :- 
    route(Arg1, Arg2, _, StringyBoy), string_chars(StringyBoy, Transport), 
    string_chars(PossibleTransport, Transport2), member(c, Transport), member(c, Transport2), Mode = "c", car(Arg1, Arg2, Time), !.
timeChecker(Arg1, Arg2, PossibleTransport, Mode, Time) :- 
    route(Arg1, Arg2, _, StringyBoy), string_chars(StringyBoy, Transport), 
    string_chars(PossibleTransport, Transport2), member(t, Transport), member(t, Transport2), Mode = "t", train(Arg1, Arg2, Time), !.
timeChecker(Arg1, Arg2, PossibleTransport, Mode, Time) :- 
    route(Arg1, Arg2, _, StringyBoy), 
    string_chars(StringyBoy, Transport), string_chars(PossibleTransport, Transport2), 
    member(p, Transport), member(p, Transport2), Mode = "p", plane(Arg1, Arg2, Time), !.

findRoute(Arg1, Arg1, Route, New_Route) :- 
    append(Route, [Arg1], New_Route), !.
findRoute(Arg1, Arg2, Route, New_Route) :- 
    route(Arg1, X, _, _), startRoute(Route), 
    not(member(X, Route)), append(Route, [Arg1], Next_Route),   
    findRoute(X, Arg2, Next_Route, New_Route).
findRoute(Arg1, Arg2, Route, New_Route) :- 
    route(Arg1, X, _, _), not(member(X, Route)), 
    append(Route, [Arg1], Next_Route), 
    findRoute(X, Arg2, Next_Route, New_Route).

time([_], _, Time) :- Time = 0, !.
time([Arg1, Arg2| Tail], PossibleTransport, Time) :- 
    timeChecker(Arg1, Arg2, PossibleTransport, _, Time2), append([Arg2], Tail, New_Route), 
    time(New_Route, PossibleTransport, Time3), Time = Time3 + Time2.
shortest(Arg1, Arg2, Modes, Time, Route) :- bagof(findRoute(Arg1, Arg2, _, Route), time(Route, Modes, Time), _).

journey(Arg1, Arg1, _) :- write("Looks like you are already there"), !.
journey(Arg1, Arg2, Modes) :- shortest(Arg1, Arg2, Modes, T, _), write("You got to your destination via the fastest route!"), !.
journey(_, _, _) :- write("No route available sorry"), !.