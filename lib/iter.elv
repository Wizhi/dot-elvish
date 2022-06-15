use math

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

fn zip {|a b|
    range (math:min (count $a) (count $b)) | each {|i|
        put [$a[$i] $b[$i]]
    }
}
