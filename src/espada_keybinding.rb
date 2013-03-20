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
end

binding_list = BindingTable.instance

class Fixnum
  def parse_keymod
    keymods = []
    KeymodValues.each do |value|
      (keymods << NumberToKeymod[value]) if (self & value) == value
    end
    keymods
  end

  def parse_key
    NumberToKey[self]
  end
end
