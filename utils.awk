
@load "ordchr"
@load "rwarray"
@load "/nix/store/bn25s9fbvdyxfgl8c22xnr35jfzyf1n6-gawkextlib-unstable/lib/json.so"
function copy_array(dest, source,   i, count)
{
    delete dest
    for (i in source) {
        if (typeof(source[i]) == "array") {
            count += copy_array(dest[i], source[i])
        } else {
            dest[i] = source[i]
            count++
        }
    }
    return count
}
