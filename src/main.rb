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

require 'espada_settings'
require 'espada_utils'

require 'default_settings'

ESPADA_PATH = current_executing_dir __FILE__

class MainApplication
  include Singleton

  attr_accessor :app,
                :settings,
                :main_win,
                :buffers,
                :current_buffer_id

  def initialize
    @app = Qt::Application.new ARGV
    @buffers = {}
    update_settings
    create_main_window
    create_main_text_buffer
  end

  def to_s
    "<MainApplication #{hash}>"
  end

  def self.to_s
    self.instance.to_s
  end

  def create_main_text_buffer
    text_edit = TextEdit.new
    text_edit.set_line_wrap_column_or_width Settings.wrap_column
    text_edit.set_line_wrap_mode Settings.wrap_mode
    text_edit.load Settings.default_contents_path

    @main_win.set_central_widget text_edit
    @current_buffer_id = text_edit.object_id
    @buffers[@current_buffer_id] = text_edit
  end

  def create_main_window
    win = MainWindow.new
    win.set_window_title "Espada Text Playground"
    win.resize Settings.size[:width], Settings.size[:height]
    win.move Settings.position[:x], Settings.position[:y]
    win.show

    @main_win = win
  end

  def exec
    @app.exec
  end

  def update_settings
    # Get runtime settings
    EspadaSettings[:double_click_timeout] =
      EspadaSettings[:double_click_timeout] || $qApp.doubleClickInterval

    Settings.update EspadaSettings
    Settings.default_contents_path = \
        "#{espada_path}/#{Settings.default_contents_path}"
    @settings = Settings

    puts "=> Settings: "
    Settings.print
  end

  def current_buffer
    @buffers[@current_buffer_id]
  end

  def shell_buffer
    current_buffer.shell_buffer
  end
end

App = MainApplication.instance
App.exec
