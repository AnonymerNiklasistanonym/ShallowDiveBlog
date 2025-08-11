#include <stdio.h> // printf

void print_array(const char* name, const int integers[], int elements) {
    printf("%s (%d): ", name, elements);
    const char *separator = "";
    for(int j=0; j<elements; j++) {
      printf("%s%d", separator, integers[j]);
      separator = ",";
    }
    printf("\n");
 }

int main() {
    // Static array (fixed size)
    int staticArr[5] = {10, 20, 30, 40, 50}; // specify size + values
    staticArr[0] = 1;                        // change values
    int staticArrAuto[] = {10, 20, 30, 40};  // values determine size
    int staticArrZeros[5] = {1, 2};          // remaining values are 0

    print_array("staticArr", staticArr, 5);
    printf("0: %d, 2: %d\n", staticArr[0], staticArr[2]);
    print_array("staticArrAuto", staticArrAuto, 4);
    print_array("staticArrZeros", staticArrZeros, 5);

    // Pointer Arithmetic
    int *staticArrPtr = staticArr;    // use pointer to access/change values
    printf("[staticArrPtr] 0: %d, 2: %d\n", *staticArrPtr, *(staticArrPtr + 2));
    // This works because the compiler is automatically changing the memory
    // address by 2 * sizeOf(int)
    printf("staticArrPtr                 = %p [pointer]\n",
           (void *)staticArrPtr);
    printf("staticArrPtr + 1             = %p [pointer]\n",
           (void *)(staticArrPtr + 1));
    printf("staticArrPtr + 1             = %p [size_t]\n",
           (size_t)staticArrPtr + 1);
    printf("staticArrPtr + 1*sizeof(int) = %p [size_t]\n",
           (size_t)staticArrPtr + 1 * sizeof(int));
    // THATS WHY IT'S VERY IMPORTANT TO HAVE THE CORRECT POINTER DATA TYPE!
    long *staticArrPtrL = (long *)staticArr;
    printf("(long *) staticArrPtr + 1    = %p [long pointer]\n",
           (void *)(staticArrPtrL + 1));
}
