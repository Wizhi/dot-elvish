set paths = [$E:HOME/.local/bin $@paths]

use ./completions
use ./aliases
use git

use journal

fn dotfiles {|@a| git --git-dir=$E:HOME/.dotfiles --work-tree=$E:HOME $@a }

if (has-external direnv) {
    eval (direnv hook elvish | slurp)
}

set E:EDITOR = helix

set edit:prompt = {
    if $git:cwd[is-repository] {
        git:pwd
    } else {
        tilde-abbr $pwd
    }

    put ' > '
}

set edit:rprompt = {
    for segment [
        (git:head)
        (git:status)
    ] {
        if $segment {
            put ' ' $segment
        }
    }
}

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
