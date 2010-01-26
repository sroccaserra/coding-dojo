Coding Dojo
===========

Emacs lib to quickly create a small TDD craddle in various languages.

Usage
-----

Call the `dojo-new-project` command. It will ask you for a project name in the minibuffer, then a language (with auto completion).

That's it, it will create a TDD craddle for you, in a directory named `ProjectName-Language`.

Installation
------------

- Add `coding-dojo.el` to your path, then add the `dojo-new-project` command to the autoload list:
        (autoload 'dojo-new-project "coding-dojo" nil t)
- Customize the `coding-dojo` group, setting:
  - the *dojo-template-dir*` variable to point to the coding-dojo `languages` directory (or your own template dir).
  - the `*dojo-project-dir*` variable to point to the directory where you want your new projects to be created.

That's it, now call `dojo-new-project` when you want to create a new project.


Adding a new language
---------------------

To add a new language craddle, just add a directory named after your language in the `languages` directory.

In this directory, put all the required files. All `$main` strings within these files will be replaced by the name you give to the project, and the file named `main.ext` will be renamed after your project's name (see examples in the `languages` directory).
