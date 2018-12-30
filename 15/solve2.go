package main
import (
    . "fmt"
    _ "io/ioutil"
    "io/ioutil"
    "os"
    "strings"
    "strconv"
    _ "regexp"
)
const input = 92510
func main() {
    Println("hi")
    bytes, err := ioutil.ReadFile(os.Args[1])
    if err != nil {
        panic(err) }
    strs := strings.Split(string(bytes),"\n")
    Println(strs)

    scores := []byte{3,7}
    a, b := 0, 1

    step := 0
    for ; step < 30 || strings.Index(string(scores),strconv.Itoa(input)) < 0; step++ {
        value := scores[a] + scores[b]

        extra := []byte(strconv.Itoa(int(value)))
        scores := append(scores,extra...)

        a = (a + 1 + int(scores[a])) % len(scores)
        b = (b + 1 + int(scores[b])) % len(scores)
    }
    Println(step)

}
