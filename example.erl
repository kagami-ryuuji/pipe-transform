-module(test).
-compile(export_all).
-compile({parse_transform, pipe_transform}).

test() ->
  A = 1,
  [pipe||A, fn, fn, fn]. % fn(fn(fn(A)))

test2() ->
  [pipe||foo, md:fn, md:fn(1,2), fn]. % fn(md:fn(md:fn(foo),1,2))

test3() ->
  ['|>'||foo, {md,fn}, {md,fn,1,2}, fn]. % fn(md:fn(md:fn(foo),1,2))

fn(A) -> A + 1.
