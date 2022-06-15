use math

fn reduce-input {|f &z=$nil|
    each {|v|
        set z = (if $z {
            $f $z $v
         } else {
            put $v
        })
    }

    put $z
}

fn reduce-list {|f @a &z=$nil|
    if (not $z) {
        set z = (take 1 $a)
        set a = [(drop 1 $a)]
    }

    for a $a {
        set z = ($f $z $a)
    }

    put $z
}

fn zip {|a b|
    range (math:min (count $a) (count $b)) | each {|i|
        put [$a[$i] $b[$i]]
    }
}
