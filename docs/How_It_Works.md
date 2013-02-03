* The Espada application when running would have a global singleton `App` representing all resources of the app.

* Each text buffer is stored in the hashtable `App.text_buffers` as a pair `(text_buffer.hash => text_buffer)`

* Current buffer is determined by `App.current_buffer`, which in turns, depending on `App.current_buffer_hash`.  Whenever a text buffer receives focus, `App.current_buffer_hash` changes appropriately.
