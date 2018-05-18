#include <stdio.h>
#include <stdint.h>
#include <errno.h>
#include <stdlib.h>
#include <stdbool.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <string.h>

// Include the Weld API.
#include "../../../c/weld.h"

typedef void (*SourceI32) (int32_t*);
typedef void (*SinkI32) (int32_t*);

struct args {
    SourceI32 src;
    SinkI32 sink;
};

static const char ITERATE_CODE[] = "|s:stream[i32],s_out:streamappender[i32]| iterate(s_out,|b| {merge(b, next(s)*2), true})";
static const char FOR_CODE[] = "|s_in:stream[i32], s_out:streamappender[i32]| for(s_in, s_out, |b, v| merge(b, v*2))";

extern "C" void stdio_stream_src(int32_t * next) {
    while(true) {
        char * line = readline(">");
        if (line == NULL) {
            printf("\nEOF read. Exiting...\n");
            exit(EXIT_SUCCESS);
        } else {
            add_history(line);
            //printf("text -> %s\n", line);
            errno = 0;
            long n = strtol(line, NULL, 0);
            free(line);
            if (errno == 0) {
                //printf("number -> %ld\n", n);
                *next = (int32_t) n;
                return;
            } else {
                fprintf(stderr, "Input could not be interpreted as a number!\n");
            }
        }
    }
}

extern "C" void stdio_stream_sink(int32_t * next) {
    printf("sunk %d\n", *next);
}

void run_weld(SourceI32 src, SinkI32 sink) {
    // Compile Weld module.
    weld_error_t e = weld_error_new();
    weld_conf_t conf = weld_conf_new();
    weld_module_t m = weld_module_compile(ITERATE_CODE, conf, e);
    weld_conf_free(conf);
    
    if (weld_error_code(e)) {
        const char *err = weld_error_message(e);
        printf("Error message: %s\n", err);
        exit(1);
    }
    
    struct args input = {src, sink};
    
    weld_value_t arg = weld_value_new(&input);
    
    // Run the module and get the result.
    conf = weld_conf_new();
    weld_value_t result = weld_module_run(m, conf, arg, e);
    void *result_data = weld_value_data(result);
    //printf("Answer: %lld\n", *(int64_t *)result_data);
    
    // Free the values.
    weld_value_free(result);
    weld_value_free(arg);
    weld_conf_free(conf);
    
    weld_error_free(e);
    weld_module_free(m);
    printf("Freeing data and quiting!\n");
}

void run_c(SourceI32 src, SinkI32 sink) {
    while(true) {
        int32_t n;
        src(&n);
        int32_t n2 = n * 2;
        sink(&n2);
    }
}

int main() {
    
    run_weld(stdio_stream_src, stdio_stream_sink);
    //run_c(stdio_stream_src, stdio_stream_sink);
    
    return 0;
}
