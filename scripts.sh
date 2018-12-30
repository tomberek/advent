https://www.tldp.org/LDP/abs/html/textproc.html



seq 200 | ( export PROGRAM="$(cat solve.sh | sed -e '/^\s*\#/ d' | tr '\n' ';' | sed -e 's/;;\+/;/g' )" ; parallel gawk -e "$PROGRAM" ) > res



join res <(cat log | cut -c 1-80) --header


look 20 res

cat log | cut -c1-80 | pr -o 5 --width=65

