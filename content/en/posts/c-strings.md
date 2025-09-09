---
title: C-Strings
summary: A shallow dive into what C-Strings are and other types of strings
date: 2025-05-11
lastmod: 2025-08-31
draft: false
math: true
tags:
  - C
  - Strings
  - Binary
  - ASCII
  - Unicode
  - Pointers
categories:
  - Software
  - Informatics
---

## Basics

The C programming language has a set of functions implementing operations on strings (character/byte strings) in its standard library:

{{< include_code file="c_strings/demo.c" lang="c" >}}

{{< include_code file="c_strings/demo.log" lang="text" >}}

There is no real *string* data type but instead `char[]` are used (character arrays).
Also while other languages like Java store the length of an array C instead has the convention to **null-terminate** every `char[]` instead:

- a string of $n$ characters is represented as an array of $n + 1$ elements
- each character is usually a numeric value that maps to a character (e.g. ASCII codes)
- the last character is a "`NULL` character" with numeric value $0$ (**no other character has this numeric value!**)

Meaning the line `char str1[] = "Hello"` actually stores 6 `char`s where the last one is `NULL`:

{{< include_code file="c_strings/null_termination.c" lang="c" >}}

{{< include_code file="c_strings/null_termination.log" lang="text" >}}

## Hardware

- the smallest addressable memory unit in most hardware nowadays is a byte $=8$ bits
  - each bit can store $2$ states: $1$/$0$
  - $n$ bits can store $2^n$ possible combinations (e.g. ${\color{red}2}$ bits: $2^{\color{red}2} = 4$ [`00`, `01`, `10`, `11`])
- $32$-bit, $64$-bit, ... refer to CPU architectures (and corresponding operating systems)
  - Registers **INSIDE** CPUs are used to hold immediate data:
    - instructions
    - memory addresses
    - data for calculations
  - A $n$-bit CPU has $n$-bit wide registers (e.g. $64$-bit CPU has $64$ bit $= 8$ byte wide registers)
    - This length is often called the natural unit of data a CPU processes at a time: a `word` / `size_t`
      - Linux: `unsigned long`
      - Windows: `SIZE_T`
  - Since memory access instructions (e.g. Assembly `mov`/`load`/`store`) of the CPU ISA (Instruction Set Architecture) are hard-coded to use a register as memory address
    - a $32$ bit CPU can address a theoretic maximum of $2^{32}$ byte $\approx 4$ gigabytes
    - a $64$ bit CPU can address a theoretic maximum of $2^{64}$ byte $\approx 18$ exabytes ($= 18000$ terrabytes)

### Hardware Implementation C Strings

- on a hardware level all characters are stored as:
  - consecutive (*in memory*)

  - fixed width (*all characters have the same bit length*)

    {{< mathblock >}}
    \overbrace{00001010}^{\text{character } 1}\overbrace{00000010}^{\text{character }2}\dots\overbrace{00000000}^{\text{last character }}
    {{< /mathblock >}}

  - unsigned binary integers (*each character represents a positive number*)

    {{< mathblock >}}
    \begin{aligned}
    00001010_2 &= 2^0*0 + 2^1 * 1 + 2^2 * 0 + 2^3 * 1 + 2^4 * 0 + \dots \\
               &= 2_{10} + 8_{10} = {10}_{10}
    \end{aligned}
    {{< /mathblock >}}

  - terminated at the end by an additional zero code unit (**all code units before are non-zero**)

    {{< mathblock >}}
    \begin{aligned}
    00000000_2 &= 2^0*0 + 2^1 * 0 + \dots \\
               &= 0_{10}
    \end{aligned}
    {{< /mathblock >}}

- when speaking of *strings* normally code units of type `char`/`wchar_t` are meant

  - a `char` is $8$ bits $=1$ byte (on most modern machines)
  - a `wchar_t` is $16/32$ bits  $=$ $2/4$ byte

### Memory (in C)

There are 3 memory areas:

1. **Registers**: *(in CPU, managed by the CPU, generally not accessible)*

   - Extremely fast but tiny storage inside the CPU
   - Each register has the width of the bit count of the CPU ($32$ bit = $32$ bit registers)
   - Example a modern `x86-64` $64$-bit CPU like the AMD Ryzen 7 7800X3D has per Instruction Set Architecture (ISA):
     - $16$ general purpose registers where each one is $64$-bits wide: integer arithmetic, pointer storage, function arguments, local storage, ...
     - Some special registers like the instruction pointer register: tracks the address of the next instruction to execute
     - SIMD/floating-point registers: AVX-$512$ allows up to $32 \times 512$-bit vector registers
     - Some legacy registers that remain largely unused
     - **BUT** in reality on the microarchitecture level there are hundreds of more registers to enable out-of-order execution, pipelining, ...
2. **Stack**: *(in RAM, managed by CPU/OS)*

   ```c
   void f() {
       int arr[1024]; // 4 KB on the stack
   } // automatically freed when function returns
   ```

   - A contiguous block of memory that (usually limited, e.g. $8$MB per thread) stores local variables and function call information
   - Memory is allocated when a function is called and freed when it returns
   - If you exceed it the CPU throws a page fault/the OS throws a stack overflow exception

3. **Heap**: (*in RAM, managed by OS*)

   ```c
   void f() {
       int* arr = malloc(1024 * sizeof(int)); // 4 KB on heap
       // it actually allocates some additonal metadata
       // ...
       free(arr); // must be manually released
       // free knows through the metadata "how much" it needs to free
       // free also frees the metadata so it's only possible to call it once
   }
   ```

   - A region of memory used for dynamic allocation
   - Memory is manually managed:
     - First the memory is requested with e.g. `malloc`
     - Then it must be explicitly released with e.g. `free()`
   - The heap is larger and more flexible than the stack, but access is generally slower because for example:
     - Sometimes memory is not one contiguous block
     - Fragmentation creates holes and finding a suitable free block can take time during allocation

Demo for metadata on the heap on Linux with `malloc` and `glibc`:

{{< include_code file="c_strings/malloc_metadata.c" lang="c" >}}

{{< include_code file="c_strings/malloc_metadata.log" lang="text" >}}

Demo for reaching the stack limit with a big stack allocation:

{{< include_code file="c_strings/stack_limit.c" lang="c" >}}

### Pointers in C

1. **Stack Allocation**

   ```c
   int x = 10;
   int *p = &x; // p points to stack memory
   // or
   int arr[1024];
   ```

   - Pointers can reference variables allocated on the stack
   - Lifetime ends when the function scope ends, all memory is automatically released, **the memory location is now hot garbage that crashes your program if you look at it!**

2. **Heap Allocation**

   ```c
   int *p = malloc(sizeof(int));
   *p = 20; // p points to heap memory
   // or
   int* arr = malloc(1024 * sizeof(int));
   // ...
   free(p);
   free(arr);
   ```

   - Pointers can reference dynamically allocated memory using e.g. `malloc`
   - Lifetime ends when the memory is manually freed with e.g. `free()`

3. **Immutable String Literals (`char*`)**

   ```c
   char *s = "hello"; // points to immutable string
   ```

   - String literals are stored in read-only memory (implementation-defined)

     - Memory efficiency
     - Safety from accidental modification
     - Faster access
     - Functions that take `const char *` can safely accept string literals without copying
   - Modifying the contents leads to **undefined behavior!**
   - Use `const char *` to make intent explicit (and help the compiler):

     ```c
     const char *s = "hello";
     ```

Demo for the different pointer types:

{{< include_code file="c_strings/pointer.c" lang="c" >}}

{{< include_code file="c_strings/pointer.log" lang="text" >}}

## Character encoding

To consistently map (encode) binary numbers represent by bits also known as code points to characters/symbols there are multiple standards:

### ASCII (American Standard Code for Information Interchange)

In 1963 the ASCII character encoding defined $2^7=128$ symbols consisting of $33$ unprintable symbols and $95$ printable characters.

- Inspired by type/telewriter layout
  - A-Z, a-z, 0-9, punctuation marks
  - the ordering of characters, such as the uppercase letters preceding lowercase ones
  - control characters like
    - Carriage Return (`CR`) and Line Feed (`LF`) $\Rightarrow$ Creates new line by moving the *printer* back to first column and to the next line
  - ![1959 Hermes 3000 input (https://typewriterdatabase.com/1959-hermes-3000.17675.typewriter)](../../images/c_strings/hermes_3000.jpg)
  - ![1963 Teletype Model 33 input (https://kbd.news/Teletype-Model-33-1274.html)](../../images/c_strings/teletype-model-33-top.jpg)

They are represented by numbers from $[0,127]$:

```txt
 0 NUL    16 DLE    32      48 0    64 @    80 P    96 `   112 p
 1 SOH    17 DC1    33 !    49 1    65 A    81 Q    97 a   113 q
 2 STX    18 DC2    34 "    50 2    66 B    82 R    98 b   114 r
 3 ETX    19 DC3    35 #    51 3    67 C    83 S    99 c   115 s
 4 EOT    20 DC4    36 $    52 4    68 D    84 T   100 d   116 t
 5 ENQ    21 NAK    37 %    53 5    69 E    85 U   101 e   117 u
 6 ACK    22 SYN    38 &    54 6    70 F    86 V   102 f   118 v
 7 BEL    23 ETB    39 '    55 7    71 G    87 W   103 g   119 w
 8 BS     24 CAN    40 (    56 8    72 H    88 X   104 h   120 x
 9 HT     25 EM     41 )    57 9    73 I    89 Y   105 i   121 y
10 LF     26 SUB    42 *    58 :    74 J    90 Z   106 j   122 z
11 VT     27 ESC    43 +    59 ;    75 K    91 [   107 k   123 {
12 FF     28 FS     44 ,    60 <    76 L    92 \   108 l   124 |
13 CR     29 GS     45 -    61 =    77 M    93 ]   109 m   125 }
14 SO     30 RS     46 .    62 >    78 N    94 ^   110 n   126 ~
15 SI     31 US     47 /    63 ?    79 O    95 _   111 o   127 DEL
```

The reason the symbols are encoded as $7$-bit values was intentional because early computers handled data in bytes which are blocks of 8 bits.
The extra, eighth bit was originally reserved for error checking.

#### ASCII Extensions

This was enough for basic English use but was extended by various countries internationally to $8$-bit values ($2^8=256$ meaning $128$ custom symbols) to support their symbols/punctuation/...

- e.g. ISO/IEC 8859 which contains `ä`, `ü`, `ö`, `ß`, `€`, `Ä`, ...

### Unicode

To solve the problem of multiple character encoding standards (that are different depending on the current locale) Unicode is one table that contains all of them instead of having to switch the encoding depending on the current use case.

Designed in 1988 by Joe Becker at Xerox this standard (where the first $256$ code points mirror the ISO/IEC 8859-1 standard) extends the code points to $16$ bits ($2^{16}=65536$) which should allow to universally encode all modern/future text with one standard: https://symbl.cc/en/unicode-table/.

This was later extended to $32$ bits for supplementary characters in Unicode 3.0 (1999) and nowadays contains even a lot of emotes.

#### UTF (Unicode Transformation Format)

If you would store each character as $32$ bits this would waste for most characters in English/Latin $2/3$ of $4$ empty bytes.

To support all current Unicode code points but still keep the storage size small a transfer function is used that widens the amount of bytes depending on how big the code point of a single symbol is (variable length characters):

- UTF-8 uses $1$ to $4$ byte per code point (indicated by a bit mask)

  - Maximal compatibility with ASCII since the first $128$ symbol have the same code points

  - | First code point | Last code point    | Byte 1     | Byte 2     | Byte 3     | Byte 4     |
    | ---------------- | ------------------ | ---------- | ---------- | ---------- | ---------- |
    | U+0000 (0)       | U+007F (127)       | `0yyyzzzz` |            |            |            |
    | U+0080 (128)     | U+07FF (2047)      | `110xxxyy` | `10yyzzzz` |            |            |
    | U+0800 (2048)    | U+FFFF (65535)     | `1110wwww` | `10xxxxyy` | `10yyzzzz` |            |
    | U+010000 (65536) | U+10FFFF (1114111) | `11110uvv` | `10vvwwww` | `10xxxxyy` | `10yyzzzz` |

    - If the first bit in a byte is $0$ it's a $1$ byte wide wide symbol

    - If the first bits in a byte are $110$ it's a $2$ byte wide wide symbol

    - ...

    - e.g. `ä` has the Unicode code point `U+00E4` (228, `1110 0100`):

      ```text
      // UTF-8 encoding pattern for 2-byte characters:
         110x xxyy   10yy zzzz
      // Filling in the bits of 00E4:
      // -> 0000 0000 1110 0100
      //    wwww xxxx yyyy zzzz
      //
      //    0 0011     10 0100
      // 110x xxyy   10yy zzzz
         1100 0011   1010 0100
      ```

- UTF-16 uses $2$ or $4$ byte per code point (indicated by a high surrogate)

  - Used by the Windows API and by many programming environments such as Java and Qt
  - If the first 2 bytes are between U+D800 ($55296$) and U+DFFF ($57343$) this indicates a surrogate pair meaning this code point is combined by this and the next $2$ bytes

- UTF-32 uses a fixed width $4$ byte code point

  - No transfer necessary since every Unicode character fits into $32$ bit

> Using a variable length encoding like UTF-8 breaks existing code for string length and other operations when counting the actual code points!
>
> The bigger size or e.g. resolving the actual encoded symbols with multiple bytes needs to be explicitly counted!
>
> {{< include_code file="c_strings/unicode.c" lang="c" >}}
> {{< include_code file="c_strings/unicode.log" lang="text" >}}

## Arrays/Pointer Arithmetic

C always knows thanks to the pointer signature `int* array` the size of each element (`int`, e.g. $32$ bits on $64$-bit `x86-64`) when for example an array of `int`s is allocated.

Using now `arr[index]` or `*(arr + index)` it can thus translate the memory location to the first element stored in the pointer to the correct memory offset of the array element which is called pointer arithmetic:

{{< include_code file="c_strings/arrays.c" lang="c" >}}

{{< include_code file="c_strings/arrays.log" lang="text" >}}

Funnily enough this means that the following is true:

```c
arr[index] == *(arr + index) == *(index + arr) == index[arr]
```

```c
pointer[0] == *(pointer + 0) == *pointer
```

But C doesn't know (always) or rather doesn't check the bounds or the correct type of your array so be sure to not overshoot the actual memory of the array and make your program crash!
