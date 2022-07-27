# Manual pages TO-DO

- Write man pages source files in _Markdown_ and use `pandoc` to convert to _groff_:

```
for doc in *.1.md; do
	pandoc --standalone --target man --output "${doc%.md}" -- "$doc"
fi
```

## Testing
```
pandoc --standalone --target man -- git-restore-mtime.1.md | man -l -
man -l git-restore-mtime.1
manpath  # default search path for manpages
```

## References
* https://www.howtogeek.com/682871/how-to-create-a-man-page-on-linux/

## Also worth considering
- help2man
  - http://www.gnu.org/software/help2man
  - `sudo apt install help2man`
- txt2man
  - https://github.com/mvertes/txt2man
  - `sudo apt install txt2man`
- ronn
  - https://github.com/rtomayko/ronn
  - `sudo apt install ruby-ronn`
