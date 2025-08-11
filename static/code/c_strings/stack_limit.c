#include <stdio.h>        // printf
#include <stdlib.h>       // malloc
#include <sys/resource.h> // stack size limit

int main() {
    // Stack allocation have limits
    struct rlimit rl;
    if (getrlimit(RLIMIT_STACK, &rl) == 0) {
        printf("Stack size limit: %ld bytes (%.2f MB)\n",
               rl.rlim_cur, rl.rlim_cur / (1024.0 * 1024));
    } else {
       fprintf(stderr, "Error: Unable to get stack size limit.\n");
       return 1;
    }
    // E.g. with a 8MB limit for the stack allocating more triggers a stack overflow
    int bigArray[10 * 1024 * 1024]; // 40 MB -> Triggers a Segmentation fault on Linux

    // Dynamic array (Heap allocated)
    // Either big or dynamic sized arrays can be allocated in a region of RAM
    size_t elements = 500;
    size_t size = elements * sizeof(int);
    printf("Allocate memory for %d elements of %d byte size => %zu bytes\n",
           elements, sizeof(int), size);
    int *arr = malloc(size);
    if (arr == NULL) {
       fprintf(stderr, "Error: Memory allocation of %zu bytes failed.\n", size);
       return 1;
    }
    // ... access/change is the same
    free(arr); // THE ALLOCATED RAM REGION MUST BE MANUALLY FREED
    // THIS CAN ONLY BE DONE ONCE AND arr IS NOT ALLOWED TO BE ACCESSED AGAIN!
}
// Stack size limit: 8388608 bytes (8.00 MB)
// Allocate memory for 500 elements of 4 byte size => 2000 bytes
