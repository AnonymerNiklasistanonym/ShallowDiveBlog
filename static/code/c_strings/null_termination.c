#include <stdio.h>  // strlen
#include <string.h> // printf

int main() {
    char str1[] = "Hello";
    // Reported length of string
    printf("Length of str1: %zu\n", strlen(str1)); // 5
    // Memory layout
    for (size_t i = 0; i < strlen(str1) + 1; i++) {
        printf("str[%zu] = '%c' (ASCII %d)\n", i, str1[i], (unsigned char)str1[i]);
    }
}
