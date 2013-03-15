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

require 'gui/gui_constants'

require 'espada_string_utils'
require 'espada_datetime_utils'
require 'espada_fs_utils'

def eval_text(text)
  text = text[0..-2] while text[-1] == 10 || text[-1] == 13
  text.strip!

  # Exec if the first character is `!`
  return [`#{text.but_first}`, :shell] if text.first == "!"[0]

  command_type = :ruby
  # TODO: ugly code
  result = begin
    text.split("\u07ed").each do |line|
      # The scope of `eval` is always global
      eval(line.chomp, TOPLEVEL_BINDING) if line
    end
  rescue Exception => e
    puts e
    command_type = :shell
    begin
      `#{text}` if text != ""
    rescue Exception => e
      # Fail silently
      ""
    end
  end

  [result, command_type]
end

def message(text)
  puts ">> #{text}"
end

def mouse_event_to_sym(event)
  case event.button
  when Mouse[:LeftButton]
    :LeftButton
  when Mouse[:RightButton]
    :RightButton
  when Mouse[:MiddleButton]
    :MiddleButton
  end
end

def current_buffer
  if App && App.current_buffer then App.current_buffer else nil end
end

def shell_buffer
  if App && App.shell_buffer then App.shell_buffer else nil end
end

def main_window
  if defined? App && App.main_win then App.main_win else nil end
end

def main_menubar
  main_window.menubar if main_window
end

# Strictly speaking, Menu is different from MenuBar, but this MenuBar is
# global, so this should be accepted
def main_menu
  main_menubar
end
