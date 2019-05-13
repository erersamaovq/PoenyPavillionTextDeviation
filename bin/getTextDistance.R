# Compute the text distance of all combinations of text pairs from two dataset
#
# Copyright (C) 2019 Xiayi Gu
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without eevn the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

getTextDistance <- function(x, y, distance.methods = c('lcs')) {
  # Download the webpages from Gongchepu.net, extract the text corpus, and store
  # them in a data frame.
  #
  # Args:
  #   x, y: Two column with Lyrics
  #   distance.methods: Measure of text distance, see ?stringdist::stringdist for more information
  # Returns:
  #   None
  # Side-effects:
  #   1. Store a csv file, matchedNamesMatrix.csv, with test distance
  #   2. Remove it self

  DTDistance <- data.table()
  for (i in distance.methods) {
    dist <- as.list(apply(stringdistmatrix(x, y, as.character(parse(text=i))), 1, which.min))
    DTDistance <- rbindlist(list(DTDistance, dist))
  }
  fwrite(DTDistance, './data/DTDistance.csv')
  on.exit(rm(getTextDistance, envir = parent.env(environment())))
  return(DTDistance)
}
