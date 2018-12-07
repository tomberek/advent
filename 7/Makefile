default: solve.sh | awkprof.out awkprof.out.bak 
	@clear
	ls *.sh | entr awk -f ./solve.sh input

print: solve.sh awkprof.out awkprof.out.bak 
	ls $^ | entr make print_
print_: solve.sh awkprof.out awkprof.out.bak 
	@clear
	@diff solve.sh awkprof.out > temp || true
	@cat temp
	@rm temp

awkprof.out: solve.sh
	@awk --pretty-print -f solve.sh input

awkprof.out.bak: awkprof.out
	@sed -i.bak -e '116~1d' awkprof.out

lint: solve.sh
	ls $^ | entr make lint_
lint_: solve.sh
	@clear
	awk --lint -f ./solve.sh input > /dev/null
