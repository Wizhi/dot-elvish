use re
use str

var dir = $E:HOME/journal
var editor = $E:EDITOR

fn -editor [e]{
    if (has-external $e) {
        external $e
    } elif (has-external $E:EDITOR) {
        external $E:EDITOR
    } else {
        fail 'no editor found'
    }
}

fn new [title &dir=$dir &editor=$editor]{
    set title = (str:trim-space $title)
    set editor = (-editor $editor)
    set dir = $dir/(date '+%Y/%m/%d')

    set file = (re:replace " +" "_" $title | str:replace "/" "-" (one) | str:to-lower (one))".md"
    set draft = (mktemp --tmpdir "journal-XXXXXXXXXX-"$file)

    printf "# %s" $title > $draft

    set before = (stat --format "%Y" $draft)

    $editor $draft

    set after = (stat --format "%Y" $draft)

    if (not-eq $before $after) {
        mkdir --parents $dir
        cp $draft $dir/$file
    }

    rm $draft
}
