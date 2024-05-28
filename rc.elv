use builtin
use git

set paths = [$E:HOME/.local/bin $@paths]
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

# Custom cd with various override shorthands.
# If no override is detected, it works as normal cd would.
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

fn dotfiles {|@a| git --git-dir=$E:HOME/.dotfiles --work-tree=$E:HOME $@a }

fn only-when-external {|e f~|
    if (has-external $e) {
        f
    }
}

only-when-external direnv {
    eval (direnv hook elvish | slurp)
}

only-when-external carapace {
    eval (carapace _carapace | slurp)
}
