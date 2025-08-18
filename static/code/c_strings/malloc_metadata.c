#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main() {
    size_t n = 10; // number of ints to allocate
    int* arr = malloc(n * sizeof(int)); // allocate n integers on heap
    printf("Pointer returned by malloc: %p (requested %zu bytes)\n",
           (void*)arr, n * sizeof(int));

    // ===== Accessing metadata =====
    // WARNING: This is implementation-specific!
    // In glibc, the size of the allocated block is usually stored
    // just before the pointer returned by malloc.
    // Technically this is undefined behavior in C and should only
    // be used for experimentation.
    size_t* meta = (size_t*)arr - 1; // one word before arr
    printf("glibc: Raw metadata (first word, contains size + flags): 0x%zx\n",
           *meta);
    // mask off the lowest 3 bits used for flags to get the total memory size
    // metadata + requested allocation size
    printf("       -> size: %zu bytes\n", *meta & ~0x7);

    free(arr); // free memory based on the metadata
    return 0;
}
