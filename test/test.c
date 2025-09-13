#include "unity.h"
#include <stdint.h>
#include <stdlib.h>

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
extern void remove_from_set(SparseSet* s, uint32_t value);
extern int  contains_in_set(SparseSet* s, uint32_t value);
extern int  search_in_set(SparseSet* s, uint32_t value);
extern void union_sets(SparseSet* A, SparseSet* B, SparseSet* C);
extern void intersection_sets(SparseSet* A, SparseSet* B, SparseSet* C);
extern int  issubset_sets(SparseSet* A, SparseSet* B);
extern void setdifference_sets(SparseSet* A, SparseSet* B, SparseSet* C);

void setUp(void) {}
void tearDown(void) {}

void test_insert_and_contains(void) {
    SparseSet s;
    TEST_ASSERT_TRUE(initialize_set(&s, 50, 20));

    TEST_ASSERT_TRUE(insert_into_set(&s, 5));
    TEST_ASSERT_TRUE(contains_in_set(&s, 5));
    TEST_ASSERT_FALSE(contains_in_set(&s, 10));

    destroy_set(&s);
}

void test_union_and_intersection(void) {
    SparseSet A, B, C;
    initialize_set(&A, 50, 20);
    initialize_set(&B, 50, 20);
    initialize_set(&C, 50, 20);

    insert_into_set(&A, 5);
    insert_into_set(&A, 10);
    insert_into_set(&B, 10);
    insert_into_set(&B, 20);

    union_sets(&A, &B, &C);
    TEST_ASSERT_TRUE(contains_in_set(&C, 5));
    TEST_ASSERT_TRUE(contains_in_set(&C, 20));

    destroy_set(&C);
    initialize_set(&C, 50, 20);
    intersection_sets(&A, &B, &C);
    TEST_ASSERT_TRUE(contains_in_set(&C, 10));
    TEST_ASSERT_FALSE(contains_in_set(&C, 5));

    destroy_set(&A);
    destroy_set(&B);
    destroy_set(&C);
}

void test_union(void) {
    SparseSet A, B, C;
    initialize_set(&A, 50, 20);
    initialize_set(&B, 50, 20);
    initialize_set(&C, 50, 40);

    insert_into_set(&A, 1);
    insert_into_set(&A, 2);
    insert_into_set(&A, 3);

    insert_into_set(&B, 3);
    insert_into_set(&B, 4);
    insert_into_set(&B, 5);

    union_sets(&A, &B, &C);

    TEST_ASSERT_TRUE(contains_in_set(&C, 1));
    TEST_ASSERT_TRUE(contains_in_set(&C, 2));
    TEST_ASSERT_TRUE(contains_in_set(&C, 3));
    TEST_ASSERT_TRUE(contains_in_set(&C, 4));
    TEST_ASSERT_TRUE(contains_in_set(&C, 5));
    TEST_ASSERT_FALSE(contains_in_set(&C, 6));

    destroy_set(&A);
    destroy_set(&B);
    destroy_set(&C);
}

void test_intersection(void) {
    SparseSet A, B, C;
    initialize_set(&A, 50, 20);
    initialize_set(&B, 50, 20);
    initialize_set(&C, 50, 20);

    insert_into_set(&A, 1);
    insert_into_set(&A, 2);
    insert_into_set(&A, 3);
    insert_into_set(&A, 4);

    insert_into_set(&B, 3);
    insert_into_set(&B, 4);
    insert_into_set(&B, 5);
    insert_into_set(&B, 6);

    intersection_sets(&A, &B, &C);

    TEST_ASSERT_EQUAL_INT(2, C.size);
    TEST_ASSERT_TRUE(contains_in_set(&C, 3));
    TEST_ASSERT_TRUE(contains_in_set(&C, 4));
    TEST_ASSERT_FALSE(contains_in_set(&C, 1));
    TEST_ASSERT_FALSE(contains_in_set(&C, 5));

    destroy_set(&A);
    destroy_set(&B);
    destroy_set(&C);
}

void test_subset_and_difference(void) {
    SparseSet A, B, C;
    initialize_set(&A, 50, 20);
    initialize_set(&B, 50, 20);
    initialize_set(&C, 50, 20);

    insert_into_set(&A, 5);
    insert_into_set(&A, 10);
    insert_into_set(&B, 10);

    setdifference_sets(&A, &B, &C);
    TEST_ASSERT_TRUE(contains_in_set(&C, 5));
    TEST_ASSERT_FALSE(contains_in_set(&C, 10));

    TEST_ASSERT_FALSE(issubset_sets(&A, &B));
    TEST_ASSERT_TRUE(issubset_sets(&C, &A));

    destroy_set(&A);
    destroy_set(&B);
    destroy_set(&C);
}

void test_edge_cases(void) {
    SparseSet A, B, C;
    initialize_set(&A, 50, 20);
    initialize_set(&B, 50, 20);
    initialize_set(&C, 50, 40);

    union_sets(&A, &B, &C);
    TEST_ASSERT_EQUAL_INT(0, C.size);

    destroy_set(&C);
    initialize_set(&C, 50, 20);
    intersection_sets(&A, &B, &C);
    TEST_ASSERT_EQUAL_INT(0, C.size);

    destroy_set(&A);
    destroy_set(&B);
    destroy_set(&C);
}

void test_remove(void) {
    SparseSet s;
    initialize_set(&s, 50, 20);

    insert_into_set(&s, 5);
    insert_into_set(&s, 10);
    insert_into_set(&s, 15);

    TEST_ASSERT_TRUE(contains_in_set(&s, 5));
    TEST_ASSERT_TRUE(contains_in_set(&s, 10));

    remove_from_set(&s, 5);
    TEST_ASSERT_FALSE(contains_in_set(&s, 5));
    TEST_ASSERT_TRUE(contains_in_set(&s, 10));
    TEST_ASSERT_TRUE(contains_in_set(&s, 15));

    destroy_set(&s);
}

void test_search(void) {
    SparseSet s;
    TEST_ASSERT_TRUE(initialize_set(&s, 50, 20));

    insert_into_set(&s, 5);
    insert_into_set(&s, 10);
    insert_into_set(&s, 15);

    TEST_ASSERT_EQUAL_INT(0, search_in_set(&s, 5));
    TEST_ASSERT_EQUAL_INT(1, search_in_set(&s, 10));
    TEST_ASSERT_EQUAL_INT(2, search_in_set(&s, 15));

    TEST_ASSERT_EQUAL_INT(-1, search_in_set(&s, 3));
    TEST_ASSERT_EQUAL_INT(-1, search_in_set(&s, 20));
    TEST_ASSERT_EQUAL_INT(-1, search_in_set(&s, 25));

    destroy_set(&s);
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_insert_and_contains);
    RUN_TEST(test_union_and_intersection);
    RUN_TEST(test_union);
    RUN_TEST(test_intersection);
    RUN_TEST(test_subset_and_difference);
    RUN_TEST(test_edge_cases);
    RUN_TEST(test_remove);
    RUN_TEST(test_search);
    return UNITY_END();
}
