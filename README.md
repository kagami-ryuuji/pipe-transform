# pipe-transform

## Usage

Pipe transform uses syntax of list comprehension:

```erlang
[pipe||Arg, ...]
```
## Example

```erlang
-module(foo).
-compile({parse_transform, pipe_transform}).

-export([f/0]).

f()  -> [pipe||1 f g(2)].

f(X) -> X + 1.

g(X, K) -> X * K.
```

Arg (first element) is passed as is, the rest are transformed into function calls
Arg and every call result become first argument of the next call:

```[pipe||x, fn(y)]        => fn(x, y)```
```[pipe||x, fn(y), fn(z)] => fn(fn(x, y), z)```

Functions are called from left to right
