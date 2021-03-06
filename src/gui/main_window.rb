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

require 'gui/label'
require 'gui/status_bar'

class MainWindow < Qt::Widget
  attr_accessor :closing_action,
                :layout,
                :menubar,
                :statusbar,
                :main_buffer_placeholder

  def initialize
    super

    @main_buffer_placeholder = {}

    create_menubar
    create_statusbar
    create_layout

    @closing_action = lambda { true }
  end

  def create_layout
    @layout = VBoxLayout.new
    @layout.set_no_margins
    @layout.set_spacing 0
    set_layout @layout

    @main_buffer_placeholder = {
      :item => Label.new,
      :index => 1
    }

    @layout.add @menubar
    @layout.add @main_buffer_placeholder[:item]
    @layout.add @statusbar
  end

  def create_statusbar
    @statusbar = StatusBar.new
  end

  def create_menubar
    @menubar = MenuBar.new

    @menubar.add_action "&File"
  end

  def closeEvent(event)
    res = @closing_action.call
    if res then event.accept else event.ignore end
  end

  def create_widget(widget)
    @layout.add widget
  end

  def add(widget)
    add_widget widget
  end

  def set_central_widget(widget)
    # TODO: Remove central widget if it's already there
    @layout.insert_widget @main_buffer_placeholder[:index], widget
    @main_buffer_placeholder[:item].hide
  end

  ###
  ### Event-related stuff
  ###

  def closeEvent(event)
    Session.update
    save_file_with_text(
      Settings.get_config_file(:session),
      Session.to_pretty_json,
      "Session saved to #{Settings.get_config_file(:session)}")

    puts "[main_window] [event] [close] placeholder"
    puts "[current_buffer] [saved] #{current_buffer.saved}" if current_buffer
    event.accept()
  end
end
