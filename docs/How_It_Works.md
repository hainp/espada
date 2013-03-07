## Quick notes

* From time to time I find out that for each file I'm editting I need a shell associated with it.  So I added `shell_buffer` to each TextEdit to serve that purpose:

  - At first, the current working dir of the `shell_buffer` is the path of the text buffer associated with it.

  - User can change its working dir anytime just by `cd` or `chdir` or `change_dir` or `!cd`.

### Purposes & design philisophy

* *Espada* itself is a full-feature Ruby environment, designed specifically for *text processing* and *shell interacting*, so **\[DISCUSS\]** all convenient functions (`create_dir`, `save`, ...) are in global model (`Kernel`).

* "When in doubt, leave it out!"

* Syntactic sugar is one of user's best friends.  E.g. `create_dir` and `mkdir`, ...

## Running/testing notes:

* Working directory must always be `./src/`.  **Subject to change.**

* The unique`Qt::Application` instance must be named `App`.

## Application instance: `App`

* Each text buffer is stored in the hashtable `App.text_buffers` as a pair `(text_buffer.object_id => text_buffer)`.

* Current buffer is determined by `App.current_buffer`, which in turns, depending on `App.current_buffer_id`.  Whenever a text buffer receives focus, `App.current_buffer_id` changes appropriately.

* The Espada application when running would have a global singleton `App` representing all resources of the app.

## `TextEdit` widget

A `TextEdit` is also known as a *text buffer* or simply *buffer*.  When a buffer is destroyed, the garbage collection is trigger to save memory.

Each `TextEdit` widget contains:

<div style="align: center; text-align: center">
    <img src="../concepts/text_buffer.png" width="430px" /><br />
    Text Buffer mockup
</div>

    # TextEdit

    VBoxLayout @layout
    |
    |--Splitter @path_bar
    |  |
    |  |--Label @path_entry
    |  |
    |  `--Label->Entry @cmd_entry
    |
    |--Splitter @buffer_region
    |  |
    |  |--HBoxLayout @text_buffer_bar
    |  |  |
    |  |  |--(?) (Line Number)
    |  |  |
    |  |  `--TextBufferWidget @buffer
    |  |
    |  `--TextBufferWidget @shell_buffer
    |
    `--StatusBar @status_bar

The `TextEdit` widget is aware of the global app instance via its property `app`.

## `EntryLabel` widget

`EntryLabel` widget is a `Label` which could be transformed into an `Entry`.
