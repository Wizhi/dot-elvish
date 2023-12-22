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

fn -reduce-list {|f list &z=$nil|
    if (not $z) {
        set z = (coalesce (take 1 $list))
        set list = [(drop 1 $list)]
    }

    for a $list {
        set z = ($f $z $a)
    }

    put $z
}

fn reduce {|f @a &z=$nil|
    if (== (count $a) 0) {
        -reduce-input $f &z=$z
    } elif (== (count $a) 1) {
        -reduce-list $f $a[0] &z=$z
    } else {
        fail 'expected 1 list, got '(count $a)
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
                    $lists)

    range $n | each {|i|
        $f $list[$i] (each {|a| put $a[$i]} $lists)
    }
}

fn zip {|list1 list2 @lists|
    map {|@a| put $a } $list1 $list2 $@lists
}

fn -partition-input {|n|
    var i w = 0 []

    each {|a|
        set i w = (+ $i 1) [$@w $a]

        if (== (% $i $n) 0) {
            put $w
            set w = []
        }
    }

    if (> (count $w) 0) {
        put $w
    }
}

fn -partition-list {|n list &step=$nil|
    range (- (count $list) (math:max $n $step) -1) &step=$step | each {|i|
        put $list[$i..(+ $i $n)]
    }
}

fn partition {|n @list &step=$nil|
    if (== (count $list) 0) {
        if $step {
            fail '&step option is only supported for list'
        }

        -partition-input $n
    } elif (== (count $list) 1) {
        -partition-list $n $list[0] &step=(coalesce $step $n)
    } else {
        fail 'expected 1 list, got '(count $list)
    }
}

fn -first-input {|f|
    each {|v|
        if ($f $v) {
            put $v
            break
        }
    }
}

fn -first-list {|f list|
    for v $list {
        if ($f $v) {
            put $v
            return
        }
    }
}

fn first {|f @list|
    var n = (count $list)

    if (== $n 0) {
        -first-input $f
    } elif (== $n 1) {
        -first-list $f $list[0]
    } else {
        fail "invalid usage"
    }
}

fn filter {|f @list|
    each {|x|
        if ($f $x) {
            put $x
        }
    } $@list
}
