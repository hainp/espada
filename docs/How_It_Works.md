* The Espada application when running would have a global singleton `App` representing all resources of the app.

* Each text buffer is stored in the hashtable `App.text_buffers` as a pair `(text_buffer.hash => text_buffer)`

* Current buffer is determined by `App.current_buffer`, which in turns, depending on `App.current_buffer_hash`.  Whenever a text buffer receives focus, `App.current_buffer_hash` changes appropriately.

* Each text buffer contains server parts:

<div style="align: center; text-align: center">
    <img src="../concepts/text_buffer.png" /><br />
    Text Buffer mockup
</div>


    # TextEdit

    VBoxLayout
    |
    |--HBoxLayout
    |  |
    |  |--Label->Entry [Path]
    |  |
    |  `--Label->Entry [Temporary Command]
    |
    |--HBoxLayout
    |  |
    |  |--(?) [Line Number]
    |  |
    |  `--TextBuffer [Main Content]
    |  
    |--TextBuffer [Directory Buffer]
    |
    `--StatusBar
