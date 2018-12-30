package main

import (
	"fmt"
	"strconv"
	"strings"
)

const input = 640441

func main() {
	scores := []byte{'3', '7'}
	a, b := 0, 1

	for len(scores) < 50000000 {
		score := []byte(strconv.Itoa(int(scores[a] - '0' + scores[b] - '0')))
		scores = append(scores, score...)

		a = (a + 1 + int(scores[a]-'0')) % len(scores)
		b = (b + 1 + int(scores[b]-'0')) % len(scores)
	}

	fmt.Println("Part A:", string(scores[input:input+10]))
	fmt.Println("Part B:", strings.Index(string(scores), strconv.Itoa(input)))
}
