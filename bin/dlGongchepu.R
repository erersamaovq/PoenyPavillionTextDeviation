# Download webpages which caontains text corpus from Gongchepu.net
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

dlGongchepu <- function () {
  # Dowload the Gongchepu and store them in a html file, if any of them are not downloaded yet
  #
  # Args:
  #   None
  # Returns:
  #   None
  # Side-effects:
  #   1. Download all Gongchepu under WORKING_DIR/data/gongchepu
  #   2. Remove itself
  if (!dir.exists('./data/gongchepu')) {
    dir.create('./data/gongchepu')
  }
  if (!file.exists('./bin/scrape.js')) {
    stop("scrape.js doesn't exist!")
  }

  source('./bin/dlGongchepuMenu.R')
  menu <- dlGongchepuMenu()
  # Maximum number of acts in menu
  apply(
    menu,
    MARGIN = 1,
    function(ro) {
      actName <- eval(parse(text=glue("ro['Act']")))
      actURL <- eval(parse(text=glue("ro['URL']")))
      dest <- glue('./data/gongchepu/{file}', file = glue('{actName}.html'))
      if (!file.exists(dest)) {
        cat(sprintf('Downloading %s from %s ...\n', actName, actURL))
        execute <- glue('./bin/phantomjs ./bin/scrape.js {actURL} {dest}')
        system(execute)
      }
    }
  )

  cat('All files are downloaded under "data/gongchepu" dir\n')
  on.exit(rm(dlGongchepu, envir = .GlobalEnv))
}
