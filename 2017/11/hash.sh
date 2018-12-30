sz=5
seq 0 $(($sz-1)) > list1

grep -oE "[0-9]+" |
	while read -r len ;
	do cat <(tail -n $(($sz-$((pos)))) list1) <(head -n $((pos)) list1) > list2
       cat list2 | tr '\n' '*'
       echo
	   cat <(head -n $len list2 | tac) <(tail -n $(($sz-$len)) list2) > list3
       cat list3 | tr '\n' '*'
       echo "Solution:"
	   cat <(tail -n $((pos)) list3) <(head -n $(($sz-$((pos)))) list3) > list1
       cat list1 | tr '\n' '*'
       echo
	   ((pos=($pos+$len+$((skip++)))%$sz))
	done

cat list1 ; rm -f list[1-3]
