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

require 'espada_ruby_parser'
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
  #
  # Difference from the original eval_text: Proper Ruby exp will be eval-ed,
  # not executed!
  #
  # TODO: Think carefully which one is more appropriate and better?
  #

  # Quick and dirty hacks to standardize text
  text = text[0..-2] while text[-1] == 10 || text[-1] == 13
  text.strip!

  # Exec if the first character is `!`
  return [exec_shell_command(text.but_first), :shell] if text.first == "!"[0]

  command_type = if valid_ruby_exp?(text) then :ruby else :shell end

  result = case command_type
  when :ruby
    begin
      eval text, TOPLEVEL_BINDING
    rescue Exception => e
      message e
    end
  when :shell
    exec_shell_command text if text != ""
  end

  [result, command_type]
end

def message(text)
  puts ">> #{text}"
  # TODO: find out the appropriate timeout
  statusbar.show_message text.to_s, 1500
end

def current_pty
  current_buffer.pty if defined? current_buffer
end

def goto_file_or_eval(*text)
  #
  # Take zero of one argument:
  # * If taking 0 argument: text == selected_text
  # * Otherwise: text = text[0]
  #

  current_buffer.goto_file_or_eval(*text) if defined? current_buffer
end

def valid_ruby_exp?(text)
  begin
    EspadaRubyParser.parse text
    true
  rescue Racc::ParseError
    false
  end
end

def binding_table
  BindingTable.instance
end

def binding_list
  binding_table
end
