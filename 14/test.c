// gcc -shared -o libtest.so -fpic test.c -lgawkextlib -v
#include <stdio.h>
#include <assert.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>

#include "gawkapi.h"

static const gawk_api_t *api;    /* for convenience macros to work */
static awk_ext_id_t ext_id;
static const char *ext_version = "test extension: version 1.0";

int plugin_is_GPL_compatible;

static awk_value_t *
do_test(int nargs, awk_value_t *result, struct awk_ext_func *unused)
{
    awk_value_t newdir;
    int ret = -1;

    assert(result != NULL);

    if (get_argument(0, AWK_STRING, & newdir)) {
		ret = printf("test: %s\n",newdir.str_value.str);
        if (ret < 0)
            update_ERRNO_int(errno);
    }
    return make_number(ret, result);
}
static awk_ext_func_t func_table[] = {
    { "test", do_test, 2, 0, awk_false, NULL }
};

static awk_bool_t init_module(void)
{
  return awk_true;
}
static awk_bool_t (*init_func)(void) = init_module;
dl_load_func(func_table, test, "")

