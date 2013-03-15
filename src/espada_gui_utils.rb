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

def message_box(text)
  msg_box = MessageBoxInstance.instance
  msg_box.set_text text
  msg_box.exec
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
  App.current_buffer if App && App.current_buffer
end

def shell_buffer
  App.shell_buffer if App && App.shell_buffer
end

def main_window
  App.main_win if defined? App && App.main_win
end

def main_menubar
  main_window.menubar if defined? main_window
end

# Strictly speaking, Menu is different from MenuBar, but this MenuBar is
# global, so this should be accepted
def main_menu
  main_menubar
end

def statusbar
  main_window.statusbar if defined? main_window
end
