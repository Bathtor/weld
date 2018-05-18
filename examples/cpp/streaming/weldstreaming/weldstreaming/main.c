//
//  main.c
//  weldstreaming
//
//  Created by Lars Kroll on 2018-05-16.
//  Copyright © 2018 Lars Kroll. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <stdbool.h>
#include <readline/readline.h>
#include <readline/history.h>

//struct SourceI32 {
//    void (*next) (int32_t*);
//};
//struct SinkI32 {
//    void (*write) (int32_t);
//};
typedef void (*SourceI32) (int32_t*);
typedef void (*SinkI32) (int32_t);
void stdio_stream_src(int32_t *);
void stdio_stream_sink(int32_t);
void weld_loop(SourceI32, SinkI32);

int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Starting stream.\n");
    weld_loop(&stdio_stream_src, &stdio_stream_sink);
    return EXIT_SUCCESS;
}

void weld_loop(SourceI32 src, SinkI32 sink) {
    while(true) {
        int32_t n;
        src(&n);
        int32_t n2 = n * 2;
        sink(n2);
    }
}

void stdio_stream_src(int32_t * next) {
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

void stdio_stream_sink(int32_t next) {
    printf("%d\n", next);
}
