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

class KeyBinding < Hash
  def initialize
    super
  end
end

class BindingTable
  include Singleton

  attr_accessor :table

  def initialize
    @table = {}
  end

  def to_s
    @table.to_s
  end

  def bindkey(bind)
    keys = parse_keybinding bind[:keys]
    action = bind[:command]
    if action.class == String
      command = Proc.new { eval action }
    else
      command = action
    end
    @table[keys] = command
  end

  def parse_keybinding(keys)
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
    KeymodToQtKeymod.include?(key) \
    || KeymodToQtKeymod.include?(key.to_s.sub("Key_", "").to_sym)
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

  def only_modifiers?(keybinding)
    keybinding[:key] == nil
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
  binding_table.bindkey(*args)
end

def process_key(keybinding)
  #
  # If the keybinding is found in binding list, call the appropriate function
  # and prevent further key processing by returning true.  Otherwise, return
  # false to forward the keybinding to the next processer.
  #

  # DEBUG
  # ap keybinding

  if binding_table.exists? keybinding
    begin
      binding_table[keybinding].call
    rescue Exception => e
      message e
    ensure
      return true
    end

  else
    if keybinding[:modifiers].length != 0 \
       && !binding_table.only_modifiers?(keybinding) \
       && keybinding[:modifiers] != [:Shift]
      message "#{keybinding.inspect} is not defined" \
    end
    return false
  end
end
