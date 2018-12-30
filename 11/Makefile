default: solve.sh
	LC_ALL=C ls *.so *.sh | entr -c bash -c "LC_ALL=C gawk -f ./solve.sh input"

print: solve.sh awkprof.out awkprof.out.bak 
	ls $^ | entr -c make print_
print_: solve.sh awkprof.out awkprof.out.bak 
	@diff solve.sh awkprof.out > temp || true
	@cat temp
	@rm temp

awkprof.out: solve.sh
	@gawk --pretty-print -f solve.sh input

awkprof.out.bak: awkprof.out
	@sed -i.bak -e '116~1d' awkprof.out

lint: solve.sh
	ls $^ | entr -c make lint_
lint_: solve.sh
	gawk --lint -f ./solve.sh input > /dev/null
