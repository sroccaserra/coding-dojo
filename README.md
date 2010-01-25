Coding Dojo
===========

Emacs lib to quickly create a small TDD craddle in various languages.

Usage
-----

Add `coding-dojo.el` to your path, then add it to the autoload list:

    (autoload 'dojo-new-project "coding-dojo" nil t)

and set the `*dojo-template-dir*` variable to point to the coding-dojo `languages` directory (or your own template dir).

Then call `dojo-new-project` when you want to create a new project.

`dojo-new-project` will ask you the name of the project, then in which language you want to work.


Adding new languages
--------------------

To add a new language craddle, just add a directory named after your language in the `languages` directory.

In this directory, put all the required files. All `$main` strings within these files will be replaced by the name you give to the project, and the file named `main.ext` will be renamed after your project's name (see examples in the `languages` directory).



