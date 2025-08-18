#include <stdio.h>  // printf
#include <stdlib.h> // malloc, free
#include <string.h> // strcpy

void print_array(const char* name, const char* chars) {
    printf("%s [code units]: ", name);
    const char *separator = "";
    size_t counter = 0;
    while (*chars) {
        printf("%s%d", separator, *chars);
        separator = ",";
        chars++;
    }
    printf("%s%d", separator, *chars);
    printf("\n");
}

int main() {
    // 1. Stack Allocation (automatic memory management)

    // > Pointer to string literal (read-only! | they are always immutable!)
    char* literalPtr = "Literal String";  // Automatically inserts a NULL at the end
    //literalPtr[0] = 'l';                // NOT POSSIBLE! IMMUTABLE!

    // To indicate that you always write 'const'
    const char* CONST_LITERAL_PTR = "Immutable Literal String";

    // > Static string (can be updated | mutable)
    char staticStr[] = "Static String";
    staticStr[0] = 's';

    printf("Literal Pointer:         %s\n", literalPtr);
    printf("Literal Pointer [CONST]: %s\n", CONST_LITERAL_PTR);
    printf("Static String:           %s\n", staticStr);
    print_array("literalPtr", literalPtr);
    print_array("staticStr ", staticStr);

    // 2. Heap Allocation (manual memory management)

    // Allocate memory for a string on the heap
    size_t len = strlen("Heap String") + 1;   // +1 for NULL terminator
    char* heapStr = (char*)malloc(len);
    if (!heapStr) {
        perror("malloc failed");
        return 1;
    }

    // Copy content into heap memory (mutable)
    strcpy(heapStr, "Heap String");
    heapStr[0] = 'h'; // modifying is safe as long as index < strlen

    printf("Heap String:             %s\n", heapStr);
    print_array("heapStr   ", heapStr);

    // Clean up heap memory
    free(heapStr);
}
