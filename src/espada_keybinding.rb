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

class KeyCombination < Hash
  def self.parse_keycombination(keys)
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
        keysymbol = KeyCombination.str_to_keysymbol key
        if KeyCombination.is_modifier? keysymbol
          res[:modifiers] << keysymbol
        else
          res[:key] = keysymbol
        end
      end

      res[:modifiers].sort!
      res
    end
  end

  def self.str_to_keysymbol(key)
    if StrToKeymod[key] then StrToKeymod[key] else StrToKey[key] end
  end

  def self.is_modifier?(key)
    KeymodToQtKeymod.include?(key) \
    || KeymodToQtKeymod.include?(key.to_s.sub("Key_", "").to_sym)
  end

  def self.only_modifiers?(keycombination)
    keycombination[:key] == nil
  end

  def initialize(data=nil)
    super()

    if data.class == String
      KeyCombination.parse_keycombination(data).each { |key, val|
        self[key] = val
      }
    elsif data.class == Hash
      data.each { |key, val| self[key] = val }
    end
  end

  def only_modifiers?
    self[:key] == nil
  end
end

class KeyBinding < Hash
  def initialize(keys=nil, action=nil, mode=:global)
    super()

    self[:keys] = if keys.class == String
      KeyCombination.new(keys)
    else
      keys
    end

    self[:action] = if action.class == String
      Proc.new { eval action }
    else
      action
    end

    self[:mode] = mode
  end

  def ==(another)
    self[:keys] == another[:keys] && self[:mode] == another[:mode]
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

  def bindkey(bind, mode=:global)
    keys = KeyCombination.new bind[:keys]
    action = bind[:command]
    if action.class == String
      command = Proc.new { eval action }
    else
      command = action
    end
    @table[keys] = command
  end

  def bindkey2(keys=nil, action=nil, mode=:global)
    return if !keys || !action
    binding = KeyBinding.new keys, action, mode
    @table[{
      :keys => binding[:keys],
      :mode => binding[:mode]
    }] = binding[:action]
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
  binding_table.bindkey(*args)
end

def process_key(keycombination)
  #
  # If the keycombination is found in binding list, call the appropriate
  # function and prevent further key processing by returning true.
  # Otherwise, return false to forward the keycombination to the next
  # processor.
  #

  # DEBUG
  # ap keycombination

  if binding_table.exists? keycombination
    begin
      binding_table[keycombination].call
    rescue Exception => e
      message e
    ensure
      return true
    end

  else
    if keycombination[:modifiers].length != 0 \
       && !keycombination.only_modifiers? \
       && keycombination[:modifiers] != [:Shift]
      message "#{keycombination.inspect} is not defined" \
    end
    return false
  end
end
