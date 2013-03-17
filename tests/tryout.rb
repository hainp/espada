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

require 'pry'
require 'espada_gui'

require 'pty'

# master, slave = PTY.open
# read, write = IO.pipe
# pid = PTY.spawn "factor", :in => read, :out => slave
# read.close
# slave.close

# write.puts "42"
# p master.gets

# write.puts "oaeu"
# # p master.gets


read, write, pid = PTY.spawn "sh -i"

## Using master to read & write to write

binding.pry
