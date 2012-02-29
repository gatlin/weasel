weasel
===

An implementation of Richard Dawkins' [weasel][1] program. The idea is to use a
simple genetic algorithm to evolve an arbitrary phrase. The default is
"METHINKS IT IS LIKE A WEASEL," from Hamlet.

I wrote this backstage during a theater performance. I forgot a line but my
code came out okay.

Usage
---

The code was written for clisp. It was my first ever lisp program so I did not
bother making it into a standalone executable. Load the code in clisp and type

* `(evolve "ARBITRARY STRING OF UPPERCASE AND SPACES")` or
* `(evolve weasel)` to trigger the default.

License
---

The code is licensed under the [WTFPL][2]. Do whatever the fuck you want with
it.

[1]: http://en.wikipedia.org/wiki/Weasel_program
[2]: http://sam.zoy.org/wtfpl/
