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

  def but_last_char
    self[0..self.length - 2]
  end
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
  puts "|#{text}| #{text.last_char}"

  return `#{text.but_first_char}` if text.first_char == "!"[0]
  # Eval, if fails => execute external command
  begin
    eval text
  rescue Exception => e
    `#{text}`
  end
end

def save_file_with_text(path, text)
  File.open(yourfile, 'w') { |file| file.write("your text") }
end

def time_diff(start, finish)
  (finish - start) * 1000
end
