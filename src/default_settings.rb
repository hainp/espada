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

require 'espada_gui'

EspadaSettings = {
  :normal_text_font => Font.new("Monaco", 10, Font::Normal),

  :size => {
    :width => 800,
    :height => 600
  },

  :position => {
    :x => 130,
    :y => 70
  },

  :default_contents_path => "../tests/Default_Contents.txt",

  :wrap_mode => WrapMode[:WidgetWidth],
  :wrap_column => 78,
}

EspadaDefaultKeybindings = [
  {
    :keys    => "<ctrl> p",
    :action  => Proc.new { goto_file_or_eval }
  },
  {
    :keys    => "<ctrl> s",
    :action  => Proc.new { save }
  },
  {
    :keys    => "<ctrl> <shift> s",
    :action  => Proc.new { save_as }
  },
  {
    :keys    => "<super> c",
    :action  => Proc.new { prev_line }
  },
]
