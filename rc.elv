use epm

epm:install &silent-if-installed=$true github.com/zzamboni/elvish-completions

use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/git

fn dotfiles [@a]{ git --git-dir=$E:HOME/.dotfiles --work-tree=$E:HOME $@a }
edit:completion:arg-completer[dotfiles] = $edit:completion:arg-completer[git]

edit:abbr['||'] = '| less'
