Sheep In Your Shoes : A Game
============================

![Game Screenshot](screenshot.png)

What?
-----

* A **simple game** for the _Shoes_ GUI toolkit by _Why The Lucky Stiff_. See [www.shoooes.net][shoes].

* An **educational** aid for teaching programming concepts.

* An illustration of **object oriented programming principles**: _mapping_ the problem domain, _encapsulation_, _modularity_, _interface_.

* A demo of modern **2D** computer graphics and interactivity.

* A testament of iterative, **organic cultivating** of the code toward it's better self


Why?
----

Because teaching programming concepts is hard.

When you have to teach basics of programming -- _nota bene_ to humanities students -- things are sometimes too abstract. Particularly when you have to explain difference between various [programming paradigms][wiki_programming_paradigm] and why Object-Oriented Programming is (at least some) solution to „fragile code“.

The principles are laid out in the code of `animals-oriented-on-objects.rb` file. But you cannot _see_ them. And you are not sure _why_ do you make those silly classes anyway.

Things can be seen much clearly in the game. You suddenly know why a sheep is an _„object“_ and why we say it has some _properties_ and some _messages_ can be sent to it.

You also know how to start writing code. You usually start with _something_. A `simple-bounce.rb` file from samples included with _Shoes_ in this case.

Then you gradually build up the environment of your game: you make the pasture green a put a sheep on it. You make the sheep move. You add more sheep and make the move. You add a dog, and make the dog catch the sheep. In the end you „refactor“ the syntax of the game, add documentation, things like that.

All of these steps are saved in **Git tags** one to thirteen, so you can easily do a `git checkout 1`, `git checkout 2` to see development of the code and walk through it slowly.

_Shoes_ and _Ruby_ make all of this very, very easy. Ruby is probably the best language for teaching programming, for beginners and advanced alike. And with _Shoes_, you can just see everything.


Setup
-----

1. Download the _Shoes_ platform from [www.shoooes.net/downloads][shoesdl]

2. Open the `sheep_in_your_shoes.rb` file in _Shoes_


Binaries (not necessary up-to-date)
------------------------------------

* [Mac OS X](http://data.karmi.cz/ffuk/Sheep_In_Your_Shoes/sheep_in_your_shoes.dmg "DMG, 4.4MB")
* [Windows ](http://data.karmi.cz/ffuk/Sheep_In_Your_Shoes/sheep_in_your_shoes.exe "EXE, 2MB")

---

Written by Karel Minarik ([www.karmi.cz](karmi)). Published under MIT license.

<!-- References -->

[src]:            http://github.com/karmi/sheep_in_your_shoes/tree
[boxed]:          http://the-shoebox.org/apps/109
[karmi]:          http://www.karmi.cz

[shoes]:          http://www.shoooes.net
[shoesdl]:        http://shoooes.net/downloads
[shoessrc]:       http://github.com/why/shoes/tree/master
[shoeswiki]:      http://github.com/why/shoes/wikis

[wiki_programming_paradigm]: http://en.wikipedia.org/wiki/Programming_paradigm