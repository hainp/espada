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

require 'espada_keybinding'

require 'espada_gui_utils'
require 'espada_string_utils'
require 'espada_datetime_utils'
require 'espada_fs_utils'

def exec_shell_command(text)
  return nil if !current_pty
  current_pty << text
  current_pty.get_output
end

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
  # TODO: find out the appropriate timeout
  statusbar.show_message text, 1500
end

def binding_list
  BindingTable.instance if defined? BindingTable
end

def current_pty
  current_buffer.pty if defined? current_buffer
end
