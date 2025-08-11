---
title: Boot
summary: A shallow dive into how PCs boot with a focus of Linux kernels
date: 2025-08-10T16:37:19+02:00
draft: true
math: true
categories:
  - Software
  - Informatics
---

TODO

Especially since switching to Linux I was always interested in how a PC actually boots.
Right out of the gate I needed to disable *Secure Boot*, somehow needed to configure *grub*, detect other operating systems (Windows) to dual boot.
Then I needed partitions and somehow needed to leave $1$MB space at the start, wanted to encrypt drives with *LUKS* which suddenly made automated mounting difficult.
So I guess it's time to finally make a shallow dive into how a PC (especially a Linux PC) boots to understand why things are like this.

## Boot
