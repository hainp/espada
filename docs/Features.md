## Settings

* `ESPADA_TMP_DIR` points to Espada's temporary directory:
  - Default to: `$HOME/.config/espada/tmp/`

* `ESPADA_EXTENSIONS_DIR` points to Espada's extensions directory:
  - Default to: `$HOME/.config/espada/extensions/`
  - The extension would automatically be disabled if the extension dir has the file named `disabled`

* `startup_buffers` determines which buffers are automatically opened when Espada starts up:
  - `:last_time` (default)
  - `[file_path1, file_path2, ...]`

* Built-in support for [TextMate](http://macromates.com/) [bundle](http://manual.macromates.com/en/bundles).

* Keybinding:

    bindkey(["<ctrl> x", "<ctrl> s"],    { save })
    bindkey(["<ctrl> s"],                { save })
    bindkey(["<ctrl> f4"],               { close_file })
    bindkey(["<super> p"],               { puts "Hello World" })
    bindkey(["<ctrl> left"],             { backward_word })
    bindkey(["<ctrl> right"],            { forward_word })

## Properties

### Buffer

* Each buffer associates with a physical file, unless it represents no files.

* If it presents no files, it's associated with `$ESPADA_TMP_DIR/new_<autofilename>`.

* For each an *adjustable* interval of 5 seconds, if there's no modifying command, the file is saved.

* Unless specified, sessions are kept after Espada is closed.

* By default, brackets (`([{`) are automatically paired.  This feature could be turned off by: `remove_feature(:autopair)` or `remove_feature(:autopair, :mode_apl)` or using JSON/hashtable configuration.

* Each buffer has a handler icon at the top-left corner:
  + Left-click: enlarge buffer size vertically.
  + Right-click: maximize buffer vertically, hiding all other buffers in the same column.
  + Middle-click: tile/untile buffer.

* Whenever a buffer is load or its size is changed via its handler icon, the mouse is automatically placed at the center of that buffer's handler icon.

## Interacting

### Command Execution

* By default: output is piped to a new buffer.

* Input/Output redirection:
  - If the command is prefixed by `<`, the output replaces the command itself.
  - If the command is prefixed by `>`, the command takes the input from the selected text.  If the selected text contains the command, input would be taken *after the first blank line* after the command.
  - If the command is prefixed by `|`, both of the above rules are applied.

* Commmands are executed using Ruby's `\`` notation.

* All commands are recorded into a message buffer: `log_buffer`. [TODO]

### File Jumping

File jumping with forms:

    /home/cmpitg/tmp/hello.c
    /home/cmpitg/tmp/hello.c:30
    /home/cmpitg/tmp/hello.c:/void helloWorld(/

If the file is opened in a buffer, switch to that buffer, if it's not, open the file in a buffer.

### Clicking

* Middle click to evaluate Ruby function or execute shell command or open a file:
  - If the selected text take the any of the [file jumping](#file_jumping) form, jump to the file, otherwise,
  - Default: try evaluating Ruby function
  - If the evaluation fails, try executing external command.  The rules for command execution is mentioned in [command execution section](#command_execution)
  - Executing external command might be force with the `!` prefix:

    ```
    puts "Hello World"            # "Hello World" is printed
    puts "A String".first_char    # "A" is printed
    message_box "Okay! Thanks."   # Display a message box

    ls ~                          # ls $HOME and display the output
    ```

* Double middle click: like middle click in normal X environment: pasting selected text

* Right click context menu default:
  - Cut, copy, paste
  - Jump to file (in selection)
  - Copy file path, copy directory path, open directory
  - Evaluate/execute, evaluate/execute on selection

* Ctrl + right click default: search for the current word or selected text.

* Left click default:
  - Single click: Jump
  - Double click: Word selection
  - Triple click: Line selection

* Ctrl + left click default: visually change value of the current word or selection text:
  - Number
  - Color
  - Otherwise: no effect

* Alt + left click default: documentation lookup.

* Left click -> right click (hold left button, then press right button): paste.

* Left click -> middle click (hold left button, then press middle button): cut.

* Re-mapping click events is not possible with configuration.  You need to modify Espada source code in order to do that.

## Literate Progamming Mode

TODO: Explain

### Features

* Two columns by default:
  - First column represents the literate program
  - Second column represents the code generated from the first column

* Default language for documentation: *Markdown*.  Supported languages:
  - *Markdown* - Modified Maruku, Modified Multimarkdown
  - *LaTeX* - ?
  - A *Lisp* HTML template - ?
  - *HTML 5* - ?

* Code chunks are denoted with:

    ```<language>
    $ <_unique_chunk_name_> $

    [...]
    ```

  For example:

    ```Ruby
    $ _main_setting_ $

    Settings = {
      :normal_text_font => Font.new("Droid Sans", 12, Font::Normal),

      :size => {
        :width => 800,
        :height => 600
      },

      :position => {
        :x => 130,
        :y => 70
      },

      :default_contents_path => "../tests/Default_Contents.txt",

      :wrap_mode => TextEdit::WidgetWidth,
      :wrap_column => 78,
    }
    ```

  If the chunk doesn't go into program, it doesn't contain the second line like above.

  To insert chunk, use `$$ <_unique_chunk_name_> $$`, to output to a file, use `$> <file_path> $`

    ```Ruby
    $> ./src/main.rb $

    $$ _main_require_libs_ $$

    $$ _main_setting_ $$
    $$ _main_funcs_ $$

    run_main
    ```

* Code generation is automatically processed, text render is not.

* Syntax coloring for document part and code part.  Document part & code part have delimeter (a small single line or section coloring).

* Directory structures:

  - Default:
    * `./main/` - your literate program
    * `./main/tests` - your literate program - test (might not be needed)
    * `./src/` - code generation *should* go here
    * `./docs/` - docs generation and other docs here
    * `./tests/` - test generation *should* go here
    * `./tmp/`
    * `./COPYPING` - license (should be generated)
    * `./README.*` - README file

  - Configuration:

      TODO

* Frequently used commands:

  - Code generation

  - Doc generation
    + HTML format
    + PDF format

  - Build

  - Run tests

  - Preview HTML

  - Preview PDF

  - List tags, indexes

* Build tool: TODO

### Rules

* Code generation is done by *adjustable* **2-second** interval if no modification is made.

* Chunk names must start with `_` and end with `_`, and should **NOT** contain spaces or special characters as they would be processed using Ruby's regex library.  Unexpected behaviour might occur if this warn is not fulfilled.

* In chunk, there **must** be at least *one* blank line after the definition of chunk name or chunk output.

* File names in snippet should **NOT** have white spaces.

### Packaging and distributing

### Examples

#### Hello World in Ruby

    This program demonstrate basic literate programming with Espada.  The most boring part is probably the insertion of license headers to all the source code:

        ```Ruby
        $ _license_header_and_encoding_ $

        # encoding: UTF-8

        #
        # This file is a part of Espada project.
        #
        # Copyright (C) 2013 Nguyễn Hà Dương <cmpitgATgmaildotcom>
        #
        # Espada is free software: you can redistribute it and/or modify
        # it under the terms of the GNU General Public License as published by
        # the Free Software Foundation, either version 3 of the License, or
        # (at your option) any later version.
        #
        # Espada is distributed in the hope that it will be useful, but
        # WITHOUT ANY WARRANTY; without even the implied warranty of
        # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
        # General Public License for more details.
        #
        # You should have received a copy of the GNU General Public License
        # along with Espada.  If not, see <http://www.gnu.org/licenses/>.
        #

        ```

    Our main program would probably be like:

        ```Ruby
        $> ./src/main.rb $

        $$ _license_header_and_encoding_ $$

        $$ _init_widgets_ $$
        $$ _define_main_ $$

        main
        ```

    The only purpose of the `main` function is to instantiate the main widget and run the main loop:

        ```Ruby
        $ _define_main_ $

        def main
          app = Qt::Application.new ARGV
          main_window = MyWindow.new
          app.exec
        end
        ```

    Our application only has: 1) a main window, 2) a "Say Hello" button and 3) a "Quit" button, so:

        ```Ruby
        $ _init_widgets_ $

        class MyWindow < Qt::Widget
          def initialize
            super

            set_font Qt::Font.new('Monaco', 18, Qt::Font::Bold)
            resize 600, 400

            say_hello = Qt::PushButton.new 'Say Hello'
            connect(say_hello, SIGNAL('clicked()')) {
              puts "Hello World!"
            }

            quit = Qt::PushButton.new 'Quit'
            connect quit, SIGNAL('clicked()'), $qApp, SLOT('quit()')

            box = Qt::VBoxLayout.new
            box.add_widget say_hello
            box.add_widget say_quit

            set_layout box
          end
        end
        ```
