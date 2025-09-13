#define _POSIX_C_SOURCE 199309L

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

typedef struct {
    uint32_t maxVal;
    uint32_t capacity;
    uint32_t size;
    uint32_t *dense;
    uint32_t *sparse;
} SparseSet;

extern int  initialize_set(SparseSet* s, uint32_t maxVal, uint32_t capacity);
extern void destroy_set(SparseSet* s);
extern int  insert_into_set(SparseSet* s, uint32_t value);
extern int  search_in_set(SparseSet* s, uint32_t value);
extern void union_sets(SparseSet* A, SparseSet* B, SparseSet* C);

static inline double elapsed_ns(struct timespec start, struct timespec end) {
    return (end.tv_sec - start.tv_sec) * 1e9 +
           (end.tv_nsec - start.tv_nsec);
}

void generate_random_set(SparseSet* s, uint32_t size, uint32_t maxVal) {
    for (uint32_t i = 0; i < size; i++) {
        uint32_t val;
        do {
            val = rand() % maxVal;
        } while (!insert_into_set(s, val));
    }
}

int main(void) {
    srand((unsigned)time(NULL));

    const int trials = 1000;
    const int maxSize = 2000;
    const int step    = 200;

    printf("# size, searchin(ns), searchout(ns), union(ns)\n");

    for (int n = step; n <= maxSize; n += step) {
        double totalHit = 0, totalMiss = 0, totalUnion = 0;

        for (int t = 0; t < trials; t++) {
            SparseSet A, B, C;
            initialize_set(&A, 10 * maxSize, n);
            initialize_set(&B, 10 * maxSize, n);
            initialize_set(&C, 10 * maxSize, 2 * n);

            generate_random_set(&A, n, 10 * maxSize);
            generate_random_set(&B, n, 10 * maxSize);

            uint32_t existing = A.dense[rand() % A.size];
            struct timespec s1, e1;
            clock_gettime(CLOCK_MONOTONIC, &s1);
            search_in_set(&A, existing);
            clock_gettime(CLOCK_MONOTONIC, &e1);
            totalHit += elapsed_ns(s1, e1);

            uint32_t missing;
            do {
                missing = rand() % (10 * maxSize);
            } while (search_in_set(&A, missing) != -1);
            struct timespec s2, e2;
            clock_gettime(CLOCK_MONOTONIC, &s2);
            search_in_set(&A, missing);
            clock_gettime(CLOCK_MONOTONIC, &e2);
            totalMiss += elapsed_ns(s2, e2);

            struct timespec s3, e3;
            clock_gettime(CLOCK_MONOTONIC, &s3);
            union_sets(&A, &B, &C);
            clock_gettime(CLOCK_MONOTONIC, &e3);
            totalUnion += elapsed_ns(s3, e3);

            destroy_set(&A);
            destroy_set(&B);
            destroy_set(&C);
        }

        printf("%d, %.2f, %.2f, %.2f\n",
               n,
               totalHit / trials,
               totalMiss / trials,
               totalUnion / trials);
    }

    return 0;
}
