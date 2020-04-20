# Research Project : video games modding vulnerabilities

In this repository you will find our tentative to exploit *Lua 5.2.1* virtual machine (the one used within Factorio), although they were not successful.

The main issue is that the shell-code is embedded inside the Lua script and end-up being allocated on the heap which is non executable on most OS. If you are interested in creating a working version of the exploits, maybe you should take a look at Return Oriented Programming (ROP).

## Exploiting *Lua 5.2*

### Previous work

We did nothing really new since *Lua* bytecode exploits have been known for more than a decade. We were very heavily inspired by Peter Cawler script which provided us with almost-working memory primitives.

Here is a small list of previous work that we found :

* 2010 : Peter Cawley - [Bytecode abuse module for Lua 5.2](http://www.corsix.org/lua/bytecode_abuse_0_1.lua) 
* 2013 : Peter Cawley - [Exploiting Company of Heroes 2 ‘s Lua engine (5.1)](https://gist.github.com/corsix/6575486)
* 2016 : [Exploiting the Lua engine within Redis](https://gist.github.com/benmmurphy/7d609f96deab5e297918bf9a395350e2)) by @benmurphy
* 2016 : Peter Cawley - [Exploiting Lua 5.2 64 bits on Linux](https://gist.github.com/corsix/49d770c7085e4b75f32939c6c076aad6)
* 2017 : [Escaping the Lua 5.2 sandbox with untrusted bytecode](https://apocrypha.numin.it/talks/lua_bytecode_exploitation.pdf) by [\@numinit](https://github.com/numinit)

### Remote code execution by crafting a *Light C Function*

The idea is to convert the type of a *Lua Function* to a *Light C Function*. This is done in a few steps :

1. Allocate a function
2. Change it's type tag
3. Change it's function pointer
4. Call it

This exploit is not complete, as there seems to be some kind of caching of *Lua* functions because even with the type tag rewritten our shell-code ends up being interpreted as *Lua bytecode* instead of x86 assembly.

Our tentative lies in [fn_craft.lua](./fn_craft.lua).

### Remote code execution by finding the thread state object

The idea is to find the memory allocator function pointer, and rewrite it to point to our shellcode. It is conveniently stored in the thread state object which is the first object allocated by the interpreter. Since every *garbage-collectable* object has an header including a pointer to the previous allocated object, it should be possible to find the thread state object by traversing the list.

However, for some reason our script broken and we lacked the time to investigate it.

Our tentative lies in [bfs.lua](./bfs.lua)

## Paper

If you read French, you can take a look at [our report](./report/report.pdf) (licensed under [(CC BY-NC-SA 4.0)](https://creativecommo
ns.org/licenses/by-nc-sa/4.0/)).

However our analysis of the video game industry security practices is in English, and is available here : [final presentation](./presentation.pdf) (same license).
