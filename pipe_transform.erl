-module(pipe_transform).
-compile(export_all).

parse_transform(Forms, Options) ->
  Forms2 = replace(Forms),
  io: format("~p~n", [Forms2]),
  Forms2.

replace({lc, Line, {atom, Line2, '|>'}, Path}) ->
  pipe(Path);

replace({lc, Line, {atom, Line2, pipe}, Path}) ->
  pipe(Path);

replace(Forms) when is_list(Forms) ->
  [replace(F) || F <- Forms];

replace(Forms) when is_tuple(Forms) ->
  Forms2 = tuple_to_list(Forms),
  Forms3 = [replace(F) || F <- Forms2],
  list_to_tuple(Forms3);

replace(Form) ->
  Form.

pipe([A|T]) ->
  mkfun(T, A).

mkfun([], A) ->
  A;

% {m, f, ...}
mkfun([{tuple, Line, [M, F | A0]}|T], A) ->
  mkfun(T, {call, Line, {remote, Line, M, F}, [A|A0]});

% m:f
mkfun([{remote, Line, M, F}|T], A) ->
  mkfun(T, {call, Line, {remote, Line, M, F}, [A]});

% m:f(...)
mkfun([{call, Line, Remote, A0}|T], A) ->
  mkfun(T, {call, Line, Remote, [A|A0]});

% f
mkfun([{atom, Line, F}|T], A) ->
  mkfun(T, {call, Line, {atom, Line, F}, [A]}).
