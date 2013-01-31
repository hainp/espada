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
require './espada_settings'
require './default_settings'
require './espada_utils'

espada = {}

class EApplication
  attr_accessor :app
                :settings

  def initialize
    @app = Qt::Application.new ARGV
    update_settings
  end

  def exec
    @app.exec
  end

  def update_settings
    # Get runtime settings
    EspadaSettings[:double_click_timeout] =
      EspadaSettings[:double_click_timeout] || $qApp.doubleClickInterval

    Settings.update EspadaSettings
    @settings = Settings

    ap "=> Settings: "
    Settings.print
  end
end

###### Tag: main_application

app = EApplication.new
espada[:app] = app

###### Tag: main_layout_container

# The container carrying a layout of the main window

main_container = MainContainer.new
espada[:main_container] = main_container

###### Tag: main_window

win = MainWindow.new
win.set_window_title "Espada Text Playground"
win.set_font Settings.normal_text_font
win.resize Settings.size[:width], Settings.size[:height]
win.move Settings.position[:x], Settings.position[:y]
espada[:win] = win

###### Tag: main_text_buffer

text_edit = TextEdit.new
text_edit.set_plain_text read_file(Settings.default_contents_path)
text_edit.set_line_wrap_column_or_width Settings.wrap_column
text_edit.set_line_wrap_mode Settings.wrap_mode
main_container.add text_edit
espada[:text_edit] = text_edit

###### Tag: main_window_layout

win.set_central_widget main_container

###### Tag: main_program

puts "\n>>>> Espada Text"
# PP.pp espada
ap espada
win.show
app.exec
