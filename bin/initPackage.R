# Load the specified packages
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

initPackage <- function(lib) {
  # Load packages, and install them if not installed yet.
  #
  # Args:
  #   lib: A Character vector with names of libraries to be loaded
  #
  # Returns:
  #   None
  #
  # Side-Effects:
  #   1. Install required libraries if not installed yet
  #   2. Load the libraryt
  #   3. Remove itself

  for (l in lib) {
    tryCatch(
      if (!suppressWarnings(require(l, character.only = TRUE))) {
        install.packages(l)
        library(l, character.only = TRUE)
      },
      error = function(e) {
        print(e)
      }
    )
  }
  on.exit(rm(initPackage, envir = .GlobalEnv))
}
