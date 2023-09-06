use iter

# Takes a function fn along with fewer than normal arguments to fn, and returns a new function that takes
# any additional arguments to fn. Calling the returned function calls fn with args + additional args.
fn partial {|fn @args|
    put {|@additional| $fn $@args $@additional}
}

# Takes one-or-more functions and returns a new function which is the composition of these.
# The composed function takes any number of arguments which are applied to the rightmost function,
# the result of which is then applied to the next function (right-to-left), etc.
# The final result of the composed function is thus the result of the leftmost function.
fn comp {|fn @fns|
    iter:reduce {|z v|
        put {|@a| $z ($v $@a)}
    } $fns &z=$fn
}

# Takes a function fn and returns a memoized version of it.
# The memoized version contains an in-memory cache of the mapping from arguments to results.
# When calls with the same arguments are repeated, the result from the cache is returned.
fn memoize {|fn|
    var cache = [&]

    put {|@args|
        if (not (has-key $cache $args)) {
            set cache = (assoc $cache $args [($fn $@args)])
        }

        all $cache[$args]
    }
}
