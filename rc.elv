use ./completions
use ./prompt

use dotenv
use journal

fn dotfiles {|@a| git --git-dir=$E:HOME/.dotfiles --work-tree=$E:HOME $@a }

set edit:abbr['||'] = '| less'

set E:EDITOR = kak

fn reduce {|f @v &z=$nil|
    if (eq $z $nil) {
        set z = (coalesce (take 1 $v))
        set v = [(drop 1 $v)]
    }

    for v $v {
        set z = ($f $z $v)
    }

    put $z
}
