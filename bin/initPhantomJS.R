# Download PhantomJS for dynamic web-scrapping
#
# Copyright (C) 2019 Xiayi Gu
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

initPhantomJS <- function() {
  # Download PhantomJS if it's not there. Currently only supports Linux and macOS and there's no plan to support non-*nix system
  #
  # Args:
  #   None
  # Returns:
  #   None
  # Side-effects:
  #   1. A file named phantomjs is stored in the working directory.
  #   2. Remove itself
  if (!file.exists('./bin/phantomjs')) {
    if (Sys.info()['sysname'] == 'Linux') {
      phJS_url <- 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2'
      phJS_name <- 'phatomjs.tar.bz2'
      phJS_bin <- './phantomjs-2.1.1-linux-x86_64/bin/phantomjs'
      phJS_dir <- './phantomjs-2.1.1-linux-x86_64'
    } else if (Sys.info()['sysname'] == 'Darwin') {
      phJS_url <- 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-macosx.zip'
      phJS_name <- 'phatomjs.zip'
      phJS_bin <- './phantomjs-2.1.1-linux-macos/bin/phantomjs'
      phJS_dir <- './phantomjs-2.1.1-linux-macos'
    }
    download.file(phJS_url, phJS_name)
    untar(phJS_name)
    file.copy(phJS_bin, './bin')
    file.remove(phJS_name)
    unlink(phJS_dir, TRUE)
  }

  on.exit(rm(initPhantomJS, envir = .GlobalEnv))
}
