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

require 'awesome_print'

require 'espada_pty'
require 'espada_utils'

class HandlerIcon < Icon
  def initialize(path)
    super
  end
end

class TextBufferWidget < Qt::TextEdit
  attr_accessor :pressed_mouse_button,
                :saved

  def initialize
    super
    reset_mouse
    path = "/dev/null"

    @allow_double_middle_click = false
    @saved = false
    setContextMenuPolicy Qt::NoContextMenu
    create_custom_scrollbar

    # Detect changes
    connect(SIGNAL :textChanged) {
      @saved = false
    }
  end

  def create_custom_scrollbar
    set_vertical_scroll_bar_policy Qt::ScrollBarAlwaysOff
  end

  def reset_mouse
    @pressed_mouse_button = {
      :LeftButton   => false,
      :RightButton  => false,
      :MiddleButton => false,
    }
  end

  def app
    App || nil
  end

  def save(*args)
    save(*args)
  end

  def load(path)
    set_plain_text read_file(path)
    @saved = true
  end

  ###### Helpers

  def has_selection?
    text_cursor.has_selection
  end

  def cursor_in_selection?
    cursor = text_cursor
    #puts "#{cursor.position} - #{cursor.selection_start} #{cursor.selection_end}"
    has_selection? \
      && cursor.selection_start <= cursor.position \
      && cursor.position <= cursor.selection_end
  end

  def clear_selection
    cursor = text_cursor
    cursor.clear_selection
    set_text_cursor cursor
  end

  def selected_text
    text_cursor.selection.toPlainText || ""
  end

  # def selected_text_with_format
  #   puts text_cursor.selection.toPlainText
  #   text_cursor.selection.toPlainText || ""
  # end

  def select_word_under_cursor(pos)
    cursor = cursor_for_position pos
    cursor.select TextCursor::WordUnderCursor
    set_text_cursor cursor
  end

  def select_line
    cursor = text_cursor
    cursor.move_position TextCursor::StartOfBlock
    cursor.move_position TextCursor::EndOfBlock, TextCursor::KeepAnchor
    set_text_cursor cursor
  end

  ###### Internal Helper

  def n_pressed_mouse_buttons
    res = 0
    @pressed_mouse_button.each { |key, val| res += val ? 1 : 0 }
    res
  end

  def only_middle_button_clicked?
    n_pressed_mouse_buttons == 1 && @pressed_mouse_button[:MiddleButton]
  end

  ###### Events

  def focusInEvent(event)
    app.current_buffer_hash = hash if app.respond_to?(:current_buffer_hash)
    super
  end

  def handle_double_button(event)
    mouse_button = mouse_event_to_sym event
    # puts "[double-button] #{mouse_button}"
    # ap @pressed_mouse_button

    cut if @pressed_mouse_button[:LeftButton] \
           && @pressed_mouse_button[:MiddleButton]
    paste if @pressed_mouse_button[:LeftButton] \
             && @pressed_mouse_button[:RightButton]

    # Don't let default X's middle-click behaviour interferes
    return false if mouse_button == :MiddleButton
    true
  end

  def mouseDoubleClickEvent(event)
    @pressed_mouse_button[mouse_event_to_sym event] = true
    process_next = true
    process_next = handle_double_button(event)
    # puts "[double-click] process_next? #{process_next}"
    # ap @pressed_mouse_button

    # Special case: double middle-click only
    if mouse_event_to_sym(event) == :MiddleButton \
       && n_pressed_mouse_buttons == 1
      @allow_double_middle_click = true
    end

    super event if process_next
  end

  # This is where all default handlers are activated
  def mouseReleaseEvent(event)
    @pressed_mouse_button[mouse_event_to_sym event] = false

    return if mouse_event_to_sym(event) == :MiddleButton \
              && (not @allow_double_middle_click)

    @allow_double_middle_click = false
    super event
  end

  def mousePressEvent(event)
    @pressed_mouse_button[mouse_event_to_sym event] = true
    # puts "\n>> [event] mouse_press"
    # ap @pressed_mouse_button

    process_next = true

    if n_pressed_mouse_buttons == 1

      if @pressed_mouse_button[:MiddleButton]
        # Jump to a file or directory if the selected text has the form of
        # a path, otherwise eval or execute command

        result, command_type = eval_text selected_text
        result.strip! if result.class == String

        if command_type == :shell && result != ""
          shell_buffer.append result
          shell_buffer.show
        end

        # Don't activate default middle-click default behaviour
        return

      elsif @pressed_mouse_button[:RightButton]
        $stderr.puts "[event] right_click"
      end

    else
      process_next = handle_double_button event
    end

    super event if process_next
  end
end

class TextEdit < Widget
  attr_accessor \
    :layout,
    :path_bar, :handler_icon, :path_label, :cmd_entry,
    :buffer_region, :text_buffer_bar, :buffer,
    :shell_buffer, :pty

  signals :triple_clicked

  def initialize
    super

    create_layout
    create_path_bar
    create_buffer_region
    create_pty                 # Slow the program down dramatically

    arrange_layout

    set_font Settings.normal_text_font if defined? Settings
  end

  def create_pty
    @pty = EspadaPTY.new
  end

  def create_layout
    @layout = VBoxLayout.new
    @layout.set_spacing 0
    @layout.set_no_margins
    self.set_layout @layout
  end

  def create_buffer_region
    @buffer_region = Splitter.new
    @text_buffer_bar = VBoxLayout.new
    @buffer = TextBufferWidget.new
    @shell_buffer = TextBufferWidget.new
    main_buffer_widget = Widget.new

    @buffer_region.set_orientation Orientation[:Vertical]

    @text_buffer_bar.add_widget @buffer
    main_buffer_widget.set_layout @text_buffer_bar
    # main_buffer_widget.set_window_flags Qt::FramelessWindowHint
    main_buffer_widget.set_no_margins

    @buffer_region.add_widget main_buffer_widget
    @buffer_region.add_widget @shell_buffer
  end

  def create_path_bar
    @path_bar = Splitter.new
    @handler_icon = HandlerIcon.new "#{espada_path}/../img/handler_icon.ico"
    @path_label = Label.new
    @cmd_entry = EntryLabel.new

    @handler_icon.forbid_resize :horizontal

    @path_label.textInteractionFlags = \
      Qt::TextSelectableByKeyboard | Qt::TextSelectableByMouse

    @cmd_entry.set_text "Inline commands..."

    path_and_icon_container_layout = HBoxLayout.new
    path_and_icon_container_layout.add_widget @handler_icon
    path_and_icon_container_layout.add_widget @path_label

    path_and_icon_container = Widget.new
    path_and_icon_container.set_layout path_and_icon_container_layout

    @path_bar.add_widget path_and_icon_container
    @path_bar.add_widget @cmd_entry

    @path_bar.forbid_resize :vertical
  end

  def arrange_layout
    @layout.add_widget @path_bar
    @layout.add_widget @buffer_region

    @text_buffer_bar.add_widget @buffer

    @shell_buffer.hide
  end

  ##
  ## Events forward to TextBufferWidget
  ##

  def set_line_wrap_column_or_width(wrap_mode)
    @buffer.set_line_wrap_column_or_width wrap_mode
  end

  def set_line_wrap_mode(wrap_mode)
    @buffer.set_line_wrap_mode wrap_mode
  end

  def load(path)
    @buffer.load path
    set_path path
  end

  def set_path(path)
    path = expand_path path
    @path_label.set_text path
  end

  def path
    @path_label.text
  end

  def path=(value)
    value = expand_path value
    @buffer.path= value
  end

  def set_font(font)
    @buffer.set_font font
    @shell_buffer.set_font font
  end

  def to_plain_text
    @buffer.to_plain_text
  end

  def saved
    @buffer.saved
  end

  def saved=(value)
    @buffer.saved= value
  end

  def zoom(value)
    @buffer.zoom_in value
  end
end
