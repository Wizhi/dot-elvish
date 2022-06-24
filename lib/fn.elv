use iter

fn partial {|f @a|
    put {|@b| $f $@a $@b}
}

fn comp {|f @fs|
    iter:reduce {|z v|
        put {|@a| $z ($v $@a)}
    } $fs &z=$f
}
