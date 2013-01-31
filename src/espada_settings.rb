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

#
# * All Espada settings are organized into a singleton named Settings.
#
# * A setting is changed via a hashtable with as the following example:
#
#     Settings.update_settings({
#       :wrap_mode => TextEdit::WidgetWidth,
#       :wrap_column => 78
#     })
#
# * `Settings.update_settings` is called once when Espada starts
#

class SettingsSingleton
  include Singleton

  def initialize
    @self = SettingsSingleton
  end

  def update_settings(ahash)
    add_properties_from_hash ahash
  end

  def add_properties_from_hash(ahash)
    a_hash.each { |key, val|
      # Add getter
      @self.send(:define_method, key) { 
        @self.instance_variable_get("@#{key}")
      }

      # Add setter
      @self.send(:define_method, "#{key}=") { |val|
        @self.instance_variable_set("@#{key}", val)
      }

      # Set default value
      @self.instance_variable_set("@#{key}", val)
    }
  end
end

Settings = SettingsSingleton.instance
