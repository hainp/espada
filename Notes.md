######
Tasks

* Readjust fonts for `path_entry` & `cmd_entry`

* `method_missing` for `TextEdit` -> pass to its `@main_buffer`

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

