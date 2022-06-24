use iter

fn comp {|f @fs|
    iter:reduce {|z v|
        put {|@a| $z ($v $@a)}
    } $fs &z=$f
}
