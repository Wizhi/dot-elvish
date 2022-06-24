use iter

fn partial {|f @a|
    put {|@b| $f $@a $@b}
}

fn comp {|f @fs|
    iter:reduce {|z v|
        put {|@a| $z ($v $@a)}
    } $fs &z=$f
}

fn memoize {|f|
    var c = [&]

    put {|@a|
        if (not (has-key $c $a)) {
            set c = (assoc $c $a ($f $@a))
        }

        all $c[$a]
    }
}
