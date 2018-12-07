# pretty printe
```
ls *.sh | entr bash -c "awk --pretty-print -f solve.sh input ; sed -i.bak -e 's/^\t//' awkprof.out ; diff awkprof.out solve.sh | sed 1,15d | cat -A "
```

# lint
```
ls *.sh | entr awk --lint -f ./solve.sh input
```

# Normal
```
ls *.sh | entr awk -f ./solve.sh input
```

