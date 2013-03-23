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
    install_event_filter self

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
    puts "[main_window] [event] [close] placeholder"
    puts "[current_buffer] [saved] #{current_buffer.saved}" if current_buffer
    event.accept()
  end

  def eventFilter(sender, event)
    #
    # Weird behaviours:
    # * Modifiers are activated during KeyPress
    # * Other characters are activated during KeyRelease
    # * If movement keys are pressed only, they're activated during KeyRelease
    #   But if there are modifiers, they're during both
    #

    #
    # This `if` clause is ugly for performance purpose, a better-looking way
    # is to use
    # `[EventType[:KeyRelease], EventType[:KeyPress]].include? event.type`
    # but that would allocate an array everytime an event is created. Ruby's
    # objects are mutable, remember?
    #
    if (event.type == EventType[:KeyRelease] \
        || event.type == EventType[:KeyPress])
      key = event.key.parse_key
      keymod = event.modifiers.parse_keymod

      if event.type == EventType[:KeyPress]
        valid = true
      else
        valid = event.text != ""
        valid ||= (MovementKeys.include?(key) && keymod.length == 0)
        valid &&= keymod.length < 2
        valid &&= !(keymod == [:Shift])
      end

      if binding_list.is_modifier?(key)
        keymod << key.to_s.sub("Key_", "").to_sym
        keymod.uniq!
        key = nil
      end

      return process_key({ :modifiers => keymod, :key => key }) if valid
    end

    #
    # Let the default event handler processes the key
    #

    false
  end
end
