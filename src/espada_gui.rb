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

require 'rubygems'
require 'singleton'
require 'Qt'
require './espada_utils'

require './gui/gui_constants'
require './gui/application'
require './gui/widget'
require './gui/font'
require './gui/box_layout'
require './gui/splitter'
require './gui/label'
require './gui/icon'
require './gui/entry'
require './gui/entry_label'
require './gui/main_window'
require './gui/text_cursor'
require './gui/text_edit'

###### Tag: espada_main_container

class MainContainer < Widget
  def initialize
    super
    set_layout VBoxLayout.new
  end

  def add(widget)
    layout.add_widget widget
  end
end
