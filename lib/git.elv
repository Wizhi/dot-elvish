use epm

epm:install &silent-if-installed=$true github.com/href/elvish-gitstatus

use str
use github.com/href/elvish-gitstatus/gitstatus

var cwd

set before-chdir = [$@before-chdir {|dir|
    set cwd = (gitstatus:query $dir)
}]

set edit:after-command = [$@edit:after-command {|_|
    set cwd = (gitstatus:query $pwd)
}]

fn only-in-repository {|f~|
    if $cwd[is-repository] {
        f
    }
}

fn pwd {
    only-in-repository {
        put $cwd[workdir]
    }
}

var styled: = (ns [
    &icon~={
        put ""
    }
    &pwd~={
        put (styled (basename $cwd[workdir]) blue)(str:trim-prefix $pwd $cwd[workdir])
    }
    &head~={
        if (eq $cwd[local-branch] '') {
            styled $cwd[commit][..8] yellow
        } elif (or (eq $cwd[local-branch] $cwd[remote-branch]) (eq $cwd[remote-branch] '')) {
            styled $cwd[local-branch] green
        } else {
            put (styled $cwd[local-branch] green)':'(styled $cwd[remote-branch] yellow)
        }
    }
    &status~={
        var status; set status = ''

        fn add {|k i @s|
            if (> $cwd[$k] 0) {
                set status = $status(styled $i $@s)
            }
        }

        add conflicted     '%' red
        add unstaged       '!' yellow
        add staged         '+' green
        add untracked      '?' blue
        add commits-behind '🠗' yellow
        add commits-ahead  '🠕' green

        if (not-eq $status '') {
            put $status
        }
    }
])
