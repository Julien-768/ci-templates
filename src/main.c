/**
 * @brief Minimal firmware build test.
 */

int main(void) {
    volatile int value = 42;

    return value == 42 ? 0 : 1;
}
