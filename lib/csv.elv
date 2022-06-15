use iter
use str

fn from {|&headers=$false|
  if $headers {
    set headers = [(str:split "," (read-line))]

    from-lines | each {|line|
      var cols = [(str:split "," $line)]

      make-map [(iter:zip $headers $cols)]
    }
  } else {
    from-lines | each {|line|
      put [(str:split "," $line)]
    }
  }
}
