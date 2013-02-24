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

require './gui/gui_constants'

class Time
  def to_ms
    (self.to_f * 1000.0).to_i
  end
end

class String
  def last_char
    self[self.length - 1]
  end

  def first_char
    self[0]
  end

  def but_first_char
    self[1..self.length - 1]
  end

  def rest
    but_first_char
  end

  def but_last_char
    self[0..self.length - 2]
  end
end

def expand_path(path)
  File.expand_path path
end

# Read file without failing, no exception is thrown

def read_file(path)
  begin
    contents = File.read path
  rescue Exception => e
    contents = ""
  end
  contents
end

def eval_text(text)
  text = text[0..-2] while text[-1] == 10 || text[-1] == 13
  text.strip!

  # Exec if the first character is `!`
  return `#{text.but_first_char}` if text.first_char == "!"[0]

  begin
    text.split("\u07ed").each do |line|
      # The scope of `eval` is always global
      eval(line.chomp, TOPLEVEL_BINDING) if line
    end
  rescue Exception => e
    puts e
    `#{text}`
  end
end

def message(text)
  puts ">> #{text}"
end

def save_file_with_text(path, text)
  File.open(path, 'w') { |file| file.write text }
  message "Saved to #{path}"
end

def save_as(path)
  buffer = current_buffer
  return nil if not buffer
  path = path || current_buffer.path
  save_file_with_text path, buffer.to_plain_text
  current_buffer.path = path
  current_buffer.saved = true
end

def save(*args)
  if args.length == 0
    save_file_with_text current_buffer.path, current_buffer.to_plain_text
  else
    save_file_with_text args[0], current_buffer.to_plain_text
  end
  current_buffer.saved = true
end

def time_diff(start, finish)
  (finish - start) * 1000
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
