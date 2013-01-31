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

class TextEdit < Qt::TextEdit
  attr_accessor :double_click_interval,
                :last_click_moment

  signals :triple_clicked

  def initialize
    super
    @double_click_interval = $qApp.double_click_interval
    @last_click_moment = Time.now.to_ms

    connect(SIGNAL :triple_clicked) { @triple_button_action.call }
    puts "Hello World"
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

  def event_button_to_sym(event)
    case event.button
    when Mouse[:LeftButton]
      :LeftButton
    when Mouse[:RightButton]
      :RightButton
    when Mouse[:MiddleButton]
      :MiddleButton
    end
  end

  ###### Events

  def mouseReleaseEvent(event)
    puts event_button_to_sym event

    click_moment = Time.now.to_ms

    # Single click
    if click_moment - @last_click_moment > @double_click_interval
      puts ">> Single click"
    end

    @last_click_moment = click_moment

    super event
  end
end
