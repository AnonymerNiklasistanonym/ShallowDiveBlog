#include <stdio.h>  // printf
#include <string.h> // strlen

const char* ASCII_CONSTANT = "Hello!"; // Only ASCII symbols
const char* UTF8_CONSTANT = "ÄÖÜ€";    // UTF-8 symbols (file is UTF-8 encoded)

size_t utf8_strlen(const char *s) {
    size_t count = 0;
    while (*s) {                   // As long as the byte/char is not NULL
        if ((*s & 0xC0) != 0x80) { // Start of code point if the byte bitmask
            count++;               // isn't 10xxxxxx ['abcd & 1000'='a000']
        }                          // -> '0xC0'(hex)='11000000'(binary)
                                   // -> '0x80'(hex)='10000000'(binary)
                                   // -> the first 2 bits of *s must be !='10'
        s++;                       // Point to the next consecutive byte/char
    }                              // memory location
    return count;
}

int main() {
    printf("ASCII_CONSTANT: %s (length = %d, utf-8 length = %d)\n",
           ASCII_CONSTANT, strlen(ASCII_CONSTANT), utf8_strlen(ASCII_CONSTANT));
    printf("UTF8_CONSTANT: %s  (length = %d, utf-8 length = %d)\n",
           UTF8_CONSTANT, strlen(UTF8_CONSTANT), utf8_strlen(UTF8_CONSTANT));
}
