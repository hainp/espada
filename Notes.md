######
Tasks

* Make keybinding a subclass of `Hash` and define `to_s`

* Refacter `text_edit.buffer.install_event_filter`

* Keybinding rules:

  - Format:

    + For users: `JSON`

    + In code: Ruby's `hash`

    + Example:

        ```JSON
        // JSON
        [ { "keys": "<ctrl> s",                "command": "save" },
          { "keys": ["<ctrl> x", "<ctrl> s"],  "command": "save" } ]
        ```

        ```Ruby
        # Ruby hash
        [{
          :keys => "<ctrl> s",
          :command => Proc.new { save }
        },
        {
          :keys => "<ctrl> <shift> s",
          :command => Proc.new { save_as }
        }]
        ```

    + Reasons: `JSON` format is portable and easy generated => GUI config

  - The recommended way to configure keybinding is either editing the `JSON` config file directly (located in `$HOME/.config/espada/keybindings.json`) or using Espada GUI config tool.  Espada will discard the `JSON` file if there's any syntax error.

  - Notes:

    + Modal keybinding is possible, though not encouraged (TODO: explain what modal binding is)

    + Keybinding will almost instantly be activated

    + The `command`'s value in each keybinding will be `eval`-ed or `call`-ed (depending on whether it's a string or `Proc`).  Though possible, it's *NOT* recommended to put multiple function calls or complex expression into `command`.  If you wish to do that, define a new function in `$HOME/.config/espada/init.rb` or somewhere that your `init.rb` reads, then put in into `command`.

    + `keybindings.json` would be read **after** all other `.rb` files or extensions are read.  So your keybinding will *override* your extensions' keybinding config.

    + TODO: Keybinding *per mode* or *per extension*.

* **NOTES**: Current `eval` is totally unsafe -> TODO: Should it be safe?

* To-be-implemented: determine if `current_buffer` is main text buffer or `shell_buffer`.

* Eval-ing:

    ```
    # 2+ shell commands
    !ls ~
    !ls ~/Desktop

    # Multiline Ruby expression
    puts '''Hello
    World'''

    # Multiline shell command
    !ls ~ \
        ~/tmp \
        /tmp

    #
    # Mixed Ruby expression & shell command -> not allowed -> you can always
    # call shell commands or external program using Ruby code
    #

    # Don't use this

    !ls ~      \
        ~/tmp  \
        /tmp
    puts '''Hello
    World'''

    # Use this instead

    `ls ~         \
        ~/tmp/    \
        /tmp/`
    puts '''Hello
    World'''

    # Or this

    current_pty << """
      ls ~      \
         ~/tmp  \
         /tmp/
    """
    puts '''Hello
    World'''
    ```

* UX:
  - Tab vs. tiling (perhaps tab is better? -> running apps on desktop, tab in browser)
  - Continue-browsing (?) -> file #1 is below file #2
  - Top-right icon: show/hide `shell_buffer`
  - Top-right toplevel icon:
    + New column (aka. split horizontally)
    + New row (aka. split vertically)
  - Ergonomics binding key for movement (Programmer Dvorak and QWERTY version) as package
  - Design a way to write package (extension)
  - Support TextMate & Sublime Text's XML extension
  - Auto save for unnamed files, ask for saving for named file
  - Command piping
  - Macros

* Convenient functions:
  - `message_box`

* Log all commands to a message buffer:
  - `message_buffer.show` & `message_buffer.hide`

* IPC: named pipe
  - Protocol
  - Actions
  - Interact with other language/script/environment

* Refactor tool for Ruby
  - Release as a package

* Default config: `~/.config/espada/`
  - `init.rb`
  - `session.json`

* Default temp: `~/.config/espada/unsaved_buffers/`

* Philosophy:
  - What can be done with mouse can be done with keyboard

* File jumping with forms:

    /home/cmpitg/tmp/hello.c
    /home/cmpitg/tmp/hello.c:30
    /home/cmpitg/tmp/hello.c:/void helloWorld(/

* Add buffer handler icon

* Easy way to add more menu

* Add menu

* Re-implement context menu of right click event

* Implement drag and drop for buffer handler icon

######

Settings are handled by the `Settings` singleton.  To update settings, use:

    Settings.update(ahashtable)

See `./src/default_settings.rb` for more details.

######

* Each buffer has a path associated with it
  - If the buffer represents normal or directory, the path is the file/directory
  - If the buffer represents an error, the path is `null`.

* When opening each file/dir using right mouse, a new window appears

######

* Contants are stored in hashtables
* Variables are stored in instances
* Setting & getting style vs "="

######

To clear selection

    TextEdit->setSelection (0,0,0,0);

Or

    QTextCursor textCursor = textEditor->textCursor();
    textCursor.clearSelection();
    textEditor->setTextCursor( textCursor );

######

MainWindow < Qt::MainWindow
  attr_accessor :closing_action

Qt::TextEdit supports HTML conversion -> great point

######

class TextEdit < Qt::TextEdit
  attr_accessor :middle_button_action, :right_button_action, :left_button_action

  def initialize
    super
    @left_button_action    = lambda { default_left_button_action }
    @middle_button_action  = lambda { default_middle_button_action }
    @right_button_action   = lambda { default_right_button_action }
  end

###### Catch mouse event:

Add an event filter that eats the event. On Windows with api-calls I think this is only possible with native TextFields and not with a Qt one.

Maybe you where filtering for right clicks?

It should work to subclass the QTextEdit and reimplement contextMenuEvent or rather contentsContextMenuEvent

Actually an event filter for contextMenuEvent should work as well, maybe installed on th viewport rather than the ScrollView subclass itself.

######

Re: Is there a way to get text from under the mouse cursor?

    If using a QTextEdit, QTextEdit::cursorForPosition() should help. Pass it the mouse position and then use a QTextCursor to select and get the word.

Re: QTextEdit: get word under the mouse pointer?

    Start with looking at QTextEdit docs. According to your problem description, you need a methods which takes a QPoint. You'll find a method which gives you a QTextCursor. The next step is to dig into QTextCursor docs. Search for "word" and you'll find QTextCursor::WordUnderCursor. The rest is left as an exercise for the reader. 

Catch QEvent::ToolTip and use QToolTip::showText().

Edit: try something like this
Qt Code:
Switch view

    bool MyTextEdit::event(QEvent* event)
    {
        if (event->type() == QEvent::ToolTip)
        {
            QHelpEvent* helpEvent = static_cast<QHelpEvent*>(event);
            QTextCursor cursor = cursorForPosition(helpEvent->pos());
            cursor.select(QTextCursor::WordUnderCursor);
            if (!cursor.selectedText().isEmpty())
                QToolTip::showText(helpEvent->globalPos(), cursor.selectedText());
            else
                QToolTip::hideText();
            return true;
        }
        return QTextEdit::event(event);
    }

###### Implementing triple click

* Get double click interval: `Qt::Application::doubleClickInterval`
* When catching the third click, see if the interval is not greater than the double click one and emit the triple click event if necessary

* Single click:
Click

* Double click:
Click
Double
Click

* Triple click:
Click
Double
Click
Click

##### Mouse note

Event should be handled in with `press`, not `release`.

##### Resize widget in a box

http://stackoverflow.com/questions/11000083/cant-resize-widgets-in-qvboxlayout

`layout->setStretch(index, stretch)`

##### Ctrl + Wheel for zooming

http://stackoverflow.com/questions/7987881/how-to-scale-zoom-a-qtextedit-area-from-a-toolbar-button-click-and-or-ctrl-mou

##### Widget margins and paddings

    QLayout::setContentsMargins() (since Qt 4.3)
    QLayout::setMargin()
    QLayout::setSpacing()

##### Menu Bar

Adding action to a specific location

Use QMenuBar::insertMenu in conjunction with QMenu::menuAction.

For example, if you want to dynamically insert the "Print" menu at the location before the "Help" menu, you can do something like this:

QMenu *printMenu = new QMenu(tr("&Print"));
menuBar()->insertMenu(ui->menuHelp->menuAction(), printMenu);

