# Espada Text Editor

Espada the *fully* hackable text editor.

## Resources & Channels

**For pre-0.5 release, please contact author directly via his email (cmpitgATgmaildotcom).**

* Homepage: TODO

* Mailing list:
  - Announcement (very low traffic): TODO
  - Development: TODO
  - Usage: TODO

* Wiki: TODO

* Screencasts: TODO

* Bug reporting: TODO

* **Question form**: <http://goo.gl/cUgp7> (If you're lazy ;-), or simply don't want to leave any trace)

* Code hosting:
  - On Github: <https://github.com/CMPITG/espada>
  - On Bitbucket: <https://bitbucket.org/cmpitg/espada>

The easiest way to ask question and contact project author is to form the *question form* above.

## Platforms

Espada supports all platforms that *Ruby* and *QtRuby* support.  This means any GNU/Linux distro (Debian, Slackware, Fedora, Gentoo, ...) or \*nix derivative (*BSD, MacOS X, ...) should be sufficient enough to run Espada.  Otherwise, please file a bug report.

Please note that Microsoft Windows® is *not* supported (and probably never will).  Feel free to fork and make changes if you'd like it to work with Windows.

Tested platforms:

* Debian (all versions which supports Ruby 1.9)
* Ubuntu 12.04 LTS
* Fedora 17 and 18

## Requirement

* Ruby 1.9 (1.8 is no longer supported)
* QtRuby
* awesome_print
* pseudo-terminal
* ruby_parser

## Installation

Make sure you have all the required dependencies.  The best way to install dependencies is via your system's package management, which varies across systems.  Otherwise, all dependencies may be installed with *gem*, so in short:

* Install Ruby 1.9 and Gem.

* Install dependencies:

  ```sh
  gem install qtbindings awesome_print pseudo-terminal ruby_parser
  ```

* Download/clone Espada via Git or Mercurial:

  ```sh
  git clone git://github.com/CMPITG/espada.git
  ```

  or

  ```sh
  hg clone https://bitbucket.org/cmpitg/espada
  ```

  or

  ```sh
  wget -O espada.zip https://github.com/CMPITG/espada/archive/experiment.zip && unzip espada.zip
  ```

* Run `espada.sh` inside Espada directory.

## Documentation

All main documentations are available inside `docs` directory.  Other materials will be published on the website or wiki or screencast channel and announced in the announcement mailing list (TODO).

## Development

Currently Espada is a one man's work.  The author uses Mercurial as his version control system.  The code is hosted at [Bitbucket](https://bitbucket.org/cmpitg/espada) and [Github](<https://github.com/CMPITG/espada>) (note that the 2 trees are exactly the same).

## License

Copyright (C) 2013 by Nguyễn Hà Dương <cmpitgATgmaildotcom>

The Espada Text Editor is license under the terms of the GNU General Public License v3.  For further information, please read the license information in `COPYING`.

Special thanks to:

* Nguyễn Năng Thắng (thangnnATiwayvietnamDOTcom)
* Nguyễn Phan Hải (hainp2604ATgmailDOTcom)
