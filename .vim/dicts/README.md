
<!-- vim-markdown-toc GFM -->
* [Dictionaries](#dictionaries)
  * [How do I use it in (N)Vim ?](#how-do-i-use-it-in-nvim-)
  * [Legal](#legal)

<!-- vim-markdown-toc -->

# Dictionaries

Dictionaries I managed to collect and generate using a python script that
I wrote <https://github.com/nl253/DictGen>

- frequent.dict

> Generated using my DictGen script from analysing word frequencies of:

+ All Harry Potter books (for regular english words)
+ A few man pages
+ A few computer science textbooks

> The words have been 'normalised', short words removed, stopwords
> removed, numbers removed, case removed, very, very high quality.

- css.dict

> This one is very good as well.

- erlang.dict

- haskell.dict

- java.dict

- javascript.dict

- perl.dict

- php.dict

- python.dict

> This one I got from someone on GitHub but tbh it is a little bit too
> `complete`.  2.4 MB is an overkill and you will see a lot of redundant
> sections from external libraries, frameworks you might not use ...
> My advice, stick to omnicompletion from jedi or rope.
> I recommend : https://github.com/python-mode/python-mode

- shell.dict (tiny)

- sql.dict

> Also generated by me, it looks decent, it only includes upper case
entries.
> Because sql is not a particularly larg language it only includes
about 400
> entries.

- thesaurus.txt

> An amazing thesaurus, highly recommended.

- en.utf-8.add

> Extra spelling entries from vim

-------------------------------------------------------------------------

## How do I use it in (N)Vim ?

Use my vim-dicts plugin https://www.github.com/nl253/vim-dicts

--------------------------------------------------------------------------

Now for markup languages you will get completion for things you have
written before, like places, words you made up, and your name, address
etc.

For programming languages you will get completion for relevant
variable names and things you've written before.

Now when you press CTRL-N (or CTRL-P)

![Alt text](screenshot.png?raw=true "popupmenu")
![Alt text](screenshot2.png?raw=true "popupmenu")
![Alt text](screenshot3.png?raw=true "popupmenu")


If there are any issues please let me know.

--------------------------------------------------------------------------

## Legal

Some albeit modified content is from
https://github.com/titoBouzout/Dictionaries, extra legal info in LICENSE.