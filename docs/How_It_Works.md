## Quick notes

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
    <img src="../concepts/text_buffer.png" /><br />
    Text Buffer mockup
</div>

    # TextEdit

    VBoxLayout @layout
    |
    |--HBoxLayout @path_bar
    |  |
    |  |--Label->Entry @path_entry
    |  |
    |  `--Label->Entry @cmd_entry
    |
    |--HBoxLayout @text_buffer_bar
    |  |
    |  |--(?) (Line Number)
    |  |
    |  `--TextBufferWidget [self]
    |  
    |--TextBufferWidget @directory_buffer
    |
    `--StatusBar @status_bar

The `TextEdit` widget is aware of the global app instance via its property `app`.

## `EntryLabel` widget

`EntryLabel` widget is a `Label` which could be transformed into an `Entry`.
