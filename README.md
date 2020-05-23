This plug-in lets you complete e-mail addresses in Vim by those found in your inbox (or any other mail folder) via [notmuch](https://notmuchmail.org).
Useful, for example, when using `Vim` as editor for `mutt` (especially with `$edit_headers` set).

# Usage

When you're editing a mail file in Vim that reads
```mail
    From: Fulano <Fulano@Silva.com>
    To:   foo
```
and in your Inbox there is an e-mail from
```mail
    Mister Foo <foo@bar.com>
```
and your cursor is right after `foo`, then hit `Ctrl+X Ctrl+O` to obtain:
```mail
    From: Fulano <Fulano@Silva.com>
    To:   Mister Foo <foo@bar.com>
```

# Commands

To complete an e-mail address inside Vim press `CTRL-X CTRL-O` in insert
mode. See `:help i_CTRL-X_CTRL-O` and `:help compl-omni`.

# Installation

1. Copy the folders of this repository into your Vim runtime path (`~/.vim` on Linux and macOS), and
2. download and install (by `make && sudo cp notmuch-addrlookup /usr/local/bin`) [notmuch-addrlookup](https://github.com/aperezdc/notmuch-addrlookup-c).
    If you are missing superuser rights, then compile it (by `make`) and add the path of the folder that contains the obtained executable `notmuch-addrlookup` (say `~/bin`) to your environment variable `$PATH`:
    If you use `bash` or `zsh`, by adding to `~/.profile` or `~/.zshenv` the line

    ```sh
        PATH=$PATH:~/bin
    ```

   If the executable `notmuch-addrlookup` is unavailable, but `notmuch` is, then `notmuch address` will be used instead;
   whose results are however less pertinent.

If you use [vim-plug](https://github.com/junegunn/vim-plug), then both steps can be achieved at once by pasting the following code snippet into your `vimrc` (between `call plug#begin()` and `call plug#end()`):

```vim
Plug 'Konfekt/vim-notmuch-addrlookup'

if !executable('notmuch-addrlookup')
  Plug 'aperezdc/notmuch-addrlookup-c', { 'do': 'make' }
  let $PATH .= expand(':~/.vim/plugged/notmuch-addrlookup-c')
endif
```
    
3. If you like to filter out most probably impersonal e-mail addresses such as those that come from mailer daemons or accept no reply, then try adding

    ```vim
    let g:notmuch_filter = 1
    ```

    to your `vimrc`, which will discard all e-mail addresses that satisfy the regular expression given by the variable `g:notmuch_filter_regex` that defaults to

    ```vim
      let g:notmuch_filter_regex = '\v^[[:alnum:]._%+-]*%([0-9]{9,}|([0-9]+[a-z]+){3,}|\+|nicht-?antworten|ne-?pas-?repondre|not?([-_.])?reply|<(un)?subscribe>|<MAILER\-DAEMON>)[[:alnum:]._%+-]*\@'
    ```

# Related Plug-ins

- The plug-ins [vim-notmuch-address](https://github.com/adborden/vim-notmuch-address) and [vim-notmuch-addresses](https://github.com/mikejsavage/vim-notmuch-addresses) achieve the same, but use `notmuch address` exclusively.
- The plugin [vim-mailquery](https://github.com/Konfekt/vim-mailquery) lets you complete e-mail addresses in Vim by those in your Inbox (or any other mail folder).
- The [vim-mutt-aliases](https://github.com/Konfekt/vim-mutt-aliases) plug-in lets you complete e-mail addresses in Vim by those in your `mutt` alias file and (when the alias file is periodically populated by the [mutt-alias.sh](https://github.com/Konfekt/mutt-alias.sh) shell script) gives a more static alternative to this plug-in.

# Credits

- to Adrian Perez's [notmuch-addrlookup](https://github.com/aperezdc/notmuch-addrlookup-c).
- to Lu Guanqun as the fork [vim-mutt-aliases](https://github.com/Konfekt/vim-mutt-aliases) of [Lu Guanqun](mailto:guanqun.lu@gmail.com)'s [vim-mutt-aliases-plugin](https://github.com/guanqun/vim-mutt-aliases-plugin/tree/063a7bdd0d852a118253278721f74a053776135d) served as a template.

# License

Distributable under the same terms as Vim itself.  See `:help license`.

