#include <stdio.h>  // strlen, strcpy, strtok, strstr
#include <string.h> // printf

int main() {
    char str1[] = "Hello";
    char text[] = "one,two,three";
    // strlen - get length of string
    printf("Length of str1: %zu\n", strlen(str1)); // 5
    // strcpy - copy string into buffer
    char buffer[50];
    strcpy(buffer, str1); // buffer now contains "Hello"
    printf("Copied: %s\n", buffer);
    // strcat - concatenate two strings
    strcat(buffer, " ");   // buffer: "Hello "
    strcat(buffer, "World");  // buffer: "Hello World"
    printf("Concatenated: %s\n", buffer);
    // strtok - tokenize a string by commas
    char *token = strtok(text, ",");
    while (token != NULL) {
        printf("Token: %s\n", token);
        token = strtok(NULL, ",");
    }
    // strstr - search for a substring
    char *found = strstr(buffer, "World");
    if (found) {
        printf("Found substring at position: %ld\n", found - buffer);
    }
    // ...
}
