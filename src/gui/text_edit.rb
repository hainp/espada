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

require './espada_utils'
require './gui/status_bar'
require 'awesome_print'

class TextBufferWidget < Qt::TextEdit
  attr_accessor :pressed_mouse_button,
                :path,
                :saved

  def initialize
    super
    reset_mouse
    path = "/dev/null"

    @allow_double_middle_click = false
    @saved = false
    setContextMenuPolicy Qt::NoContextMenu

    # Detect changes
    connect(SIGNAL :textChanged) {
      @saved = false
    }
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

  def set_path(path)
    @path = path
  end

  def save(*args)
    save(*args)
  end

  def load(path)
    set_plain_text read_file(path)
    set_path path
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

      # Eval text with middle button is clicked
      if @pressed_mouse_button[:MiddleButton]
        res = eval_text(selected_text)
        # append res.to_s if res.strip != ""
        return
      end

    else
      process_next = handle_double_button(event)
    end

    super event if process_next
  end
end

class TextEdit < Widget
  attr_accessor \
    :layout,
    :path_bar,
    :text_buffer_bar, :main_buffer,
    :directory_buffer,
    :status_bar

  signals :triple_clicked

  def initialize
    super
    @layout = VBoxLayout.new
    @path_bar = HBoxLayout.new
    @text_buffer_bar = HBoxLayout.new
    @main_buffer = TextBufferWidget.new
    @directory_buffer = TextBufferWidget.new
    @status_bar = StatusBar.new

    self.set_layout @layout

    @layout.add_layout @path_bar
    @layout.add_layout @text_buffer_bar
    @layout.add_widget @directory_buffer
    @layout.add_widget @status_bar

    @text_buffer_bar.add_widget @main_buffer

    @directory_buffer.hide

    @status_bar.show
    @status_bar.show_message "Ready", 2000
  end

  ##
  ## Events forward to TextBufferWidget
  ##

  def set_line_wrap_column_or_width(wrap_mode)
    @main_buffer.set_line_wrap_column_or_width wrap_mode
  end

  def set_line_wrap_mode(wrap_mode)
    @main_buffer.set_line_wrap_mode wrap_mode
  end

  def load(path)
    @main_buffer.load path
  end

  def set_path(path)
    @main_buffer.set_path path
  end

  def path
    @main_buffer.path
  end
end
