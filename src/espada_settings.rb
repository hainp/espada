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

#
# * All Espada settings are organized into a singleton named Settings.
#
# * A setting is changed via a hashtable with as the following example:
#
#     Settings.update({
#       :wrap_mode => TextEdit::WidgetWidth,
#       :wrap_column => 78
#     })
#
# * `Settings.update_settings` is called once when Espada starts
#

require 'singleton'
require 'awesome_print'

require 'espada_utils'

class SettingsSingleton < Hash
  include Singleton

  attr_accessor :path, :user_config_file

  def initialize
    super
    @path = expand_path "~/.config/espada/"
    @user_config_file = {
      :settings      => "settings.json",
      :session       => "session.json",
      :keybindings   => "keybindings.json",
      :theme         => "theme.json"
    }
  end

  def get_config_file(kind)
    "#{@path}/#{@user_config_file[kind]}"
  end
end

Settings = SettingsSingleton.instance
