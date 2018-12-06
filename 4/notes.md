# pretty printe
```
ls *.sh | entr bash -c "awk --pretty-print -f solve1.sh sorted ; sed -i.bak -e 's/^\t//' awkprof.out ; diff awkprof.out solve1.sh | sed 1,15d | cat -A "
```

# lint
```
ls *.sh | entr awk --lint -f ./solve1.sh sorted
```

# Normal
```
ls *.sh | entr awk -f ./solve1.sh sorted
```

