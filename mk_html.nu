#!/usr/bin/env nu

export def main [] {
  let out: path = if ($env.out? | is-not-empty) {
    mkdir $env.out
    $'($env.out)/index.html'
  } else {
    $'($env.HOME)/Downloads/Gatefall.html'
  }
  
  let src: path = $env.src? | default .
  
  ls $src
  | filter {|f| $f.name | str ends-with '.md'}
  | each {|f|
      let full_name = ($f.name | path basename | parse '{full_name}.md').0.full_name
      ($f.name | path basename | parse '{num} {name}.md').0
      | update num {into int}
      | insert content {|r| $"# ($full_name)\n\n" + (open --raw $f.name) + "\n"}
    }
  | sort-by num
  | get content
  # Process Obisidian's internal links
  | str replace --all --regex '\[\[(?<name>[^\]]*)]]' '[$name]'
  | to text --no-newline
  | pandoc --from=markdown+emoji+smart-simple_tables-multiline_tables-yaml_metadata_block --to=html --standalone --table-of-contents --template=($src)/template.html --output=($out) --metadata='title=Gatefall'
}
