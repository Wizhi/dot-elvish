set paths = [$E:HOME/.local/bin $@paths]

use builtin

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
        git:styled:pwd
    } else {
        tilde-abbr $pwd
    }

    put ' > '
}

set edit:rprompt = {
    for segment [
        (git:only-in-repository {
            git:styled:icon
            git:styled:head
            git:styled:status
        })
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

fn cd {|@path|
    fn if-first {|s f~|
        if (eq $s (or (take 1 $path) $nil)) {
            f
        }
    }

    var overrides = [
        (git:only-in-repository {
            if-first "," $git:pwd~
        })
    ]

    builtin:cd (take 1 [$@overrides $@path])
}
