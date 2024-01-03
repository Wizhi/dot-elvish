use math

fn reduce {|f~ @list &z=$nil|
    each {|v|
        set z = (if $z {
            f $z $v
        } else {
            put $v
        })
    } $@list

    put $z
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
fn map {|f~ list @lists|
    var n = (reduce {|z v| math:min $z (count $v)} ^
                    &z=(count $list) ^
                    $lists)

    range $n | each {|i|
        f $list[$i] (each {|a| put $a[$i]} $lists)
    }
}

fn zip {|list1 list2 @lists|
    map {|@a| put $a } $list1 $list2 $@lists
}

fn -partition-input {|n step|
    var a = []

    each {|v|
        set a = (conj $a $v)
        if (== $n (count $a)) {
            put $a
            set a = $a[$step..]
        }
    }

    if (< 0 (count $a)) {
        put $a
    }
}

fn -partition-list {|n step list|
    range (count $list) &step=$step | each {|i|
        put $list[$i..(math:min (+ $i $n) (count $list))]
    }
}

fn partition {|n @list &step=$nil|
    set step = (coalesce $step $n)

    if (== (count $list) 0) {
        -partition-input $n $step
    } elif (== (count $list) 1) {
        -partition-list $n $step $list[0]
    } else {
        fail 'expected 1 list, got '(count $list)
    }
}

fn first {|f~ @list|
    each {|v|
        if (f $v) {
            put $v
            break
        }
    } $@list
}

fn filter {|f~ @list|
    each {|x|
        if (f $x) {
            put $x
        }
    } $@list
}
