use ./completions
use ./prompt

use dotenv
use journal

fn dotfiles [@a]{ git --git-dir=$E:HOME/.dotfiles --work-tree=$E:HOME $@a }

set edit:abbr['||'] = '| less'

set E:EDITOR = kak
