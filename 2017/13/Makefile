default: solve.sh Makefile input
	ls $^ | entr -c bash -c "LC_ALL=C awk -f ./solve.sh input"

default2: solve.sh Makefile input
	ls $^ | entr -c bash -c "LC_ALL=C awk -f ./solve.sh input2"


par: solve.sh
	@export PROGRAM="$$( cat solve.sh | sed -e '/^\s*\#/ d' | tr '\n' ';' | sed -e 's/;;\+/;/g' )" ; cat input | parallel gawk -e "$$PROGRAM"


print: solve.sh awkprof.out awkprof.out.bak 
	ls $^ | entr -c make print_
print_: solve.sh awkprof.out awkprof.out.bak 
	@diff solve.sh awkprof.out > temp || true
	@cat temp
	@rm temp

awkprof.out: solve.sh
	@awk --pretty-print -f solve.sh input

awkprof.out.bak: awkprof.out
	@sed -i.bak -e '116~1d' awkprof.out

lint: solve.sh
	ls $^ | entr -c make lint_
lint_: solve.sh
	awk --lint -f ./solve.sh input > /dev/null
