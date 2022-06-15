use math

fn -reduce-input {|f &z=$nil|
    each {|v|
        set z = (if $z {
            $f $z $v
         } else {
            put $v
        })
    }

    put $z
}

fn -reduce-list {|f @a &z=$nil|
    if (not $z) {
        set z = (take 1 $a)
        set a = [(drop 1 $a)]
    }

    for a $a {
        set z = ($f $z $a)
    }

    put $z
}

fn reduce {|f @a &z=$nil|
	if (== (count $a) 0) {
		-reduce-input $f &z=$z
	} else {
		-reduce-list $f $@a &z=$z	
	}
}

# Calls f with arguments consisting of the first value of each list, followed 
# by calling f with arguments consisting of the second value of each list, 
# until any one of the the lists is exhausted.
#
# Examples:
#   iter:map $'+~' [1 2 3] [4 5 6]
#   ▶ (num 5)
#   ▶ (num 7)
#   ▶ (num 9)
#
#   iter:map {|a b| put [$a $b]} [1 2 3] [a b c]
#   ▶ [1 a]
#   ▶ [2 b]
#   ▶ [3 c]
fn map {|f list @lists|
    var n = (reduce {|z v| math:min $z (count $v)} ^
                    &z=(count $list) ^
                    $@lists)

    range $n | each {|i|
      $f $list[$i] (each {|a| put $a[$i]} $lists)
    }
}
