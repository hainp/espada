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

class TextEdit < Qt::TextEdit
  attr_accessor :middle_button_action,
                :right_button_action,
                :left_button_action,
                :triple_button_action,
                :in_double_click,
                :in_triple_click,
                :double_click_moment,
                :double_click_interval,
                :output

  signals :triple_clicked

  def initialize
    super
    @left_button_action    = nil
    @middle_button_action  = lambda { default_middle_button_action }
    @right_button_action   = lambda { default_right_button_action }
    @triple_button_action  = lambda { default_triple_button_action }
    @double_click_interval = $qApp.double_click_interval
    @in_double_click       = false
    @double_click_moment   = Time.now
    @output = nil

    connect(SIGNAL :triple_clicked) { @triple_button_action.call }
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
    text_cursor.selected_text
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

  ###### Events

  def default_middle_button_action
    eval_text selected_text
  end

  def default_right_button_action
    puts ">> Right button"
  end

  def mouseReleaseEvent(event)
    @left_button_action.call if @left_button_action \
                                 && event.button == Mouse[:LeftButton]

    @middle_button_action.call if @middle_button_action \
                                  && event.button == Mouse[:MiddleButton]

    @right_button_action.call if @right_button_action \
                                 && event.button == Mouse[:RightButton]

    super event unless (@left_button_action \
                        && event.button == Mouse[:LeftButton]) \
                       || (@middle_button_action \
                           && event.button == Mouse[:MiddleButton]) \
                       || (@right_button_action \
                           && event.button == Mouse[:RightButton])
  end
end
