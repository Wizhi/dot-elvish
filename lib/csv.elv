use iter
use str

fn from {|&headers=$false &sep="m"|
  if $headers {
    set headers = [(str:split $sep (read-line))]

    from-lines | each {|line|
      var cols = [(str:split $sep $line)]

      make-map [(iter:zip $headers $cols)]
    }
  } else {
    from-lines | each {|line|
      put [(str:split $sep $line)]
    }
  }
}
