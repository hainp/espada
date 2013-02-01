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
require 'awesome_print'

class TextEdit < Qt::TextEdit
  attr_accessor :pressed_mouse_button

  signals :triple_clicked

  def initialize
    super
    reset_mouse
    setContextMenuPolicy Qt::NoContextMenu
  end

  def reset_mouse
    @pressed_mouse_button = {
      :LeftButton   => false,
      :RightButton  => false,
      :MiddleButton => false,
    }
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
    text_cursor.selected_text || ""
  end

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

  def handle_double_button(event)
    mouse_button = mouse_button_to_sym event
    puts "[double-button] #{mouse_button}"
    ap @pressed_mouse_button

    cut if @pressed_mouse_button[:LeftButton] &&
           @pressed_mouse_button[:MiddleButton]
    paste if @pressed_mouse_button[:LeftButton] &&
             @pressed_mouse_button[:RightButton]

    return false if mouse_button == :MiddleButton
    true
  end

  def mouseDoubleClickEvent(event)
    @pressed_mouse_button[mouse_button_to_sym event] = true
    process_next = true
    process_next = handle_double_button(event) if selected_text != ""
    # puts "[double-click] process_next? #{process_next}"
    super event if process_next
  end

  def mouseReleaseEvent(event)
    @pressed_mouse_button[mouse_button_to_sym event] = false
    super event if mouse_button_to_sym(event) != :MiddleButton
  end

  def mousePressEvent(event)
    @pressed_mouse_button[mouse_button_to_sym event] = true
    # puts "\n>> [event] mouse_press"
    # ap @pressed_mouse_button

    process_next = true

    if n_pressed_mouse_buttons == 1
      # Eval text with middle button is clicked
      if @pressed_mouse_button[:MiddleButton]
        append(eval_text selected_text)
        return
      end
    else
      process_next = handle_double_button(event)
    end

    super event if process_next
  end
end
