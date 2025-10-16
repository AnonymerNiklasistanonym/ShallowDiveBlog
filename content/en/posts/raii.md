---
title: RAII
summary: A shallow dive into the programming idiom RAII (Resource Acquisition Is Initialization)
date: 2025-10-16
lastmod: 2025-10-16
tags:
  - RAII
  - Programming Idiom
  - C++
categories:
  - Informatics
draft: true
math: true
---

TODO: Sources

## Concept

The concept behind Resource Acquisition Is Initialization (RAII) is to tie the liftetime of resources to objects.

Meaning the anti pattern of this programming idiom would be to manage the resources independent from their lifetime.

One example would be that if you enroll at a university you get a student card to access rooms and once they graduate they keep the card until someone is collecting it. If that someone forgets to collect it the student can maybe still can access rooms and other stuff.

When following the design pattern RAII the card is given to the student the moment they enroll and they can't graduate successfully without giving the card back/destroying the card.
This is where the analogy kinda falls off since if they ever switch the university and thus are not a student any more or if they die the card also must be given back/deleted.

{{< note >}}
Needs a better example
{{< /note >}}

## History

Where did RAII come from?

There was a major transition from big mainframes to smaller multi user systems in the early 70s which made the low level, portable, general purpose programming language C very popular since other popular languages like Fortran or Cobol were domain specific in financial or scientific computing.

A PhD student at Cambridge University named Bjarne Stroustrup was researching distributed computing systems around that time and to program/simulate his ideas he had the options to use C for the performance or use simula, which was slow but introduced objects, inheritance perfect for writing complicated simulations while C had only functions.

So he began working on a programming language that had both, calling it initially "*C with Classes*".

One of the biggest issues in C was and still is to this day the manual memory management and all the issues that come with it.

You can forget to give back memory, you can free memory multiple times, have dangling pointers pointing to freed memory, ...

To combat a lot of those issues he had the idea to introduce the RAII by adding a `destructor` which is automatically called when an object runs out of scope that in contrast to the constructor should free or give back all allocated resources.

This means once correctly implemented it's impossible to forget to give back a resource or to accidentally give something back multiple times.

## Implementation

The C++ implementation

> RAII ensures that destructors are called automatically when an exception is thrown, so all resources owned by local objects are released cleanly.
>  This means code doesn’t need explicit `try/catch` or `finally` blocks for cleanup — making exception safety *automatic*.

## Changes

Changes over time

## Examples

C++ code RAII vs Antipattern

## Java Comparison

How does Java do it, try with resources

> RAII provides **deterministic** resource management — resources are released exactly when an object goes out of scope.
>
> In contrast, garbage collection (GC) is **non-deterministic**; the runtime decides when to reclaim memory, which can delay or complicate cleanup of non-memory resources like files or sockets.

## Potential Pitfalls

<-> Comparison to Rust which introduces ownership

## Discussion

- How is RAII fundamentally different from using a garbage collector for resource management?
  - RAII is tied to **scope** and works for *any* resource (file handles, locks, GPU buffers), not just memory.
  - Garbage collectors only reclaim memory and typically require additional mechanisms (like finalizers or `using` blocks) to handle other resources safely.
- How does RAII contribute to exception safety guarantees in object-oriented design?
- In modern C++ (with move semantics and smart pointers), does RAII still need to be taught explicitly?
  - **Answer A (Yes, it’s foundational):**
     Absolutely — RAII remains the underlying *philosophy* behind smart pointers and resource wrappers.
     Even though `unique_ptr`, `vector`, or `lock_guard` make it easy, developers must understand RAII to design their own safe classes and manage ownership correctly.
  - **Answer B (Less so in practice):**
     Arguably, most modern C++ developers use RAII *implicitly* via standard library components.
     It’s less about teaching “how to implement RAII” and more about recognizing that **the STL already embodies it**, so understanding the concept is useful mainly for deeper design insight.
- Could we think of RAII as a kind of *automatic transaction* pattern — where object lifetime defines the transaction boundary?
  - **Answer A (Yes, conceptually):**
     That’s a fair analogy — acquiring a resource in a constructor and releasing it in a destructor mirrors a transaction’s “begin” and “commit/rollback” phases.
     The object’s lifetime defines the scope of that “transaction,” ensuring cleanup even on failure.
  - **Answer B (Not exactly):**
     While RAII guarantees cleanup, it doesn’t inherently manage *rollback logic* or *atomicity* like a real transaction system does.
     It’s more about deterministic finalization than transactional semantics, though the analogy helps describe its structured cleanup behavior.
