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

require 'singleton'
require 'awesome_print'

class BindingTable
  include Singleton

  attr_accessor :table

  def initialize
    @table = {}
  end

  def to_s
    @table.to_s
  end

  def bindkey(keycombination)
    keys = parse_key_combination keycombination[:keys]
    action = keycombination[:command]
    if action.class == String
      command = Proc.new { eval action }
    else
      command = action
    end
    @table[keys] = command
  end

  def parse_key_combination(keys)
    if keys.class == Array
      # Modal binding
      # TODO: To be implemented
      nil
    else
      res = {
        :modifiers => [],
        :key => nil
      }

      # Standardize the string, remove noise
      keys.strip!
      keys.downcase!
      keys.gsub!("  ", " ") while keys.match("  ")

      keys.split(" ").each do |key|
        keysymbol = str_to_keysymbol key
        if is_modifier? keysymbol
          res[:modifiers] << keysymbol
        else
          res[:key] = keysymbol
        end
      end

      res[:modifiers].sort!
      res
    end
  end

  def str_to_keysymbol(key)
    if StrToKeymod[key] then StrToKeymod[key] else StrToKey[key] end
  end

  def is_modifier?(key)
    KeymodToQtKeymod.include? key
  end

  def include?(*args)
    @table.include?(*args)
  end

  def exists?(key)
    include?(key)
  end

  def [](key)
    @table[key]
  end
end

class Fixnum
  def parse_keymod
    keymods = []
    KeymodValues.each do |value|
      (keymods << NumberToKeymod[value]) if (self & value) == value
    end

    # Use for unordered comparison
    keymods.sort!
  end

  def parse_key
    NumberToKey[self]
  end
end

def bindkey(*args)
  BindingTable.instance.bindkey(*args)
end

def process_key(keybinding)
  #
  # If the keybinding is found in binding list, call the appropriate function
  # and prevent further key processing by returning true.  Otherwise, return
  # false to forward the keybinding to the next processer.
  #

  # ap keybinding
  if binding_table.exists? keybinding
    binding_table[keybinding].call
    true
  else
    message "#{keybinding.inspect} is not defined" \
      if keybinding[:modifiers].length != 0
    false
  end
end
