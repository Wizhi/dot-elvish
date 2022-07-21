set paths = [$E:HOME/.local/bin $@paths]

use ./completions
use ./aliases
use ./prompt

use dotenv
use journal

fn dotfiles {|@a| git --git-dir=$E:HOME/.dotfiles --work-tree=$E:HOME $@a }

set E:EDITOR = hx

fn watch {|@a &n=2s|
    edit:clear

    while $true {
        var out = [(peach {|cmd| $cmd } $a)]

        edit:clear

        for l $out {
            echo $l
        }

        sleep $n
    }
}
