fn reduce {|f &z=$nil|
    each {|v|
        set z = (if $z {
            $f $z $v
         } else {
            put $v
        })
    }

    put $z
}
