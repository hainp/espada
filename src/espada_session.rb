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

require 'espada_utils'

class SessionSingleton
  include Singleton

  attr_accessor :info

  def initialize
    @info = {}
  end

  def print
    ap @info
  end

  def [](key)
    @info[key]
  end

  def []=(key, val)
    @info[key] = val
  end

  def merge!(*args)
    @info.merge!(*args)
  end

  def merge(*args)
    @info.merge(*args)
  end
end

Session = SessionSingleton.instance
