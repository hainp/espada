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

class DirView < Widget
  attr_accessor :tree, :model, :path_entry, \
                :box

  def initialize
    super

    create_path_entry
    create_tree_view
    connect_signals
    create_layout
  end

  def create_path_entry
    @path_entry = Entry.new
  end

  def create_tree_view
    @model = Qt::FileSystemModel.new
    set_path(if current_dir != "" then current_dir else "~".expand_path end)
  end

  def connect_signals
    
  end

  def create_layout
    
  end
end
