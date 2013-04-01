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

require 'fileutils'
require 'json'

#
# TODO: move this class extension to another file
#
class Hash
  def keys_to_syms
    tmp_hash = {}
    self.each { |key, val|
      new_key = key.to_sym
      new_val = if val.class == Hash
        val.keys_to_syms
      else
        val
      end

      self.delete key
      tmp_hash[new_key] = new_val
    }

    self.merge! tmp_hash
  end
end

def expand_path(path)
  File.expand_path path
end

def mkdir(path)
  FileUtils.mkpath path
end

def create_dir(path)
  mkdir path
end

def current_executing_dir(path)
  File.expand_path File.dirname(path)
end

def espada_path
  if defined? ESPADA_PATH then ESPADA_PATH else "" end
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

def read_file_json(path, key_as_symbol=true)
  contents = read_file(path)
  contents = if contents != "" then JSON.parse contents else {} end

  if key_as_symbol
    result = contents.keys_to_syms
  else
    result = contents
  end

  result
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

def path_exists?(path)
  File.exists? path
end
