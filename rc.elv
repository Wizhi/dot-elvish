use ./completions
use ./prompt

use dotenv

fn dotfiles [@a]{ git --git-dir=$E:HOME/.dotfiles --work-tree=$E:HOME $@a }

set edit:abbr['||'] = '| less'
