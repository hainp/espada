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
require 'espada_session'
require 'espada_utils'

require 'default_params'

ESPADA_PATH = current_executing_dir __FILE__

class MainApplication
  include Singleton

  attr_accessor :app,
                :main_win,
                :buffers,
                :current_buffer_id

  def initialize
    @app = Qt::Application.new ARGV
    @buffers = {}
    read_settings
    update_settings
    read_session
    create_default_keybindings
    create_main_window
    create_main_text_buffer
  end

  def read_session
    saved_session = read_file_json Settings.get_config_file(:session)
    Session.merge! saved_session
  end

  def read_settings
    if !path_exists? Settings.path
      create_dir Settings.path
    else
      saved_settings = read_file_json Settings.get_config_file(:settings)
      EspadaSettings.merge! saved_settings
    end
  end

  def to_s
    "<MainApplication #{hash}>"
  end

  def create_default_keybindings
    EspadaDefaultKeybindings.each { |binding|
      bindkey binding[:keys], binding[:action], binding[:mode]
    }
  end

  def create_main_text_buffer
    text_edit = TextEdit.new
    text_edit.set_line_wrap_column_or_width Settings.wrap_column
    text_edit.set_line_wrap_mode Settings.wrap_mode
    text_edit.load Session[:default_contents_path] \
      if Session[:default_contents_path]

    @main_win.set_central_widget text_edit
    @current_buffer_id = text_edit.object_id
    @buffers[@current_buffer_id] = text_edit
  end

  def create_main_window
    win = MainWindow.new
    win.set_window_title "Espada Text Playground"
    win.resize Session[:size][:width], Session[:size][:height]
    win.move Session[:position][:x], Session[:position][:y]
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

    # TODO: Remove this
    Session[:default_contents_path] = \
        "#{espada_path}/#{Session[:default_contents_path]}"

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
message "Ready"
App.exec
