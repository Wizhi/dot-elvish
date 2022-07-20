use epm

epm:install &silent-if-installed=$true github.com/zzamboni/elvish-completions

use github.com/zzamboni/elvish-completions/builtins

if (has-external carapace) {
    eval (carapace _carapace | slurp)
} else {
    use github.com/zzamboni/elvish-completions/cd
    use github.com/zzamboni/elvish-completions/git
}

set edit:completion:arg-completer[dotfiles] = $edit:completion:arg-completer[git]
