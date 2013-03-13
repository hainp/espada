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

class MainWindow < Qt::Widget
  attr_accessor :closing_action,
                :layout,
                :menubar

  def initialize
    super

    add_layout
    set_no_margins
    add_menubar

    @closing_action = lambda { true }
  end

  def add_layout
    @layout = VBoxLayout.new
    set_layout @layout
  end

  def add_menubar
    @menubar = MenuBar.new
    @layout.add @menubar
    @menubar.add_action "&File"
  end

  def closeEvent(event)
    res = @closing_action.call
    if res then event.accept else event.ignore end
  end

  def set_no_margins
    layout.set_contents_margins 0, 0, 0, 0
  end

  def add_widget(widget)
    @layout.add widget
  end

  def add(widget)
    add_widget widget
  end

  def set_central_widget(widget)
    add widget
  end
end
