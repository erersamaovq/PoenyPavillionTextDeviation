# Generate a data frame with text corpus extracted from Wikisource
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
processWikisource <- function() {
  # Download the webpages from Wikisource, extract the text corpus, and store
  # them in a data frame.
  #
  # Args:
  #   None
  # Returns:
  #   A data.table with Qupai, the name of fixed tones, and the Text
  # Side-effects:
  #   Remove it self
  if (is_empty(dir('./data/wikisource'))) {
    stop("Please verify wikisource data files are stored under wikisource directory.")
  }

  DTWikisource <- data.table('Qupai' = character(), 'Lyrics' = character())
  for (f in dir('./data/wikisource', full.names = TRUE)) {
    batches <- read_html(f, encoding = 'UTF-8') %>%
      html_nodes(xpath = '/html/body/div[3]/div[3]/div[4]/div/div/p') %>%
      html_text() %>%
      # Temporarily split them by '('
      str_split('\\(') %>%
      unlist() %>%
      # Remove the following patterns
      #   `.+）`          Key and other information
      str_remove_all('.+\\)') %>%
      # Temporarily concantenate everything together then split them by '\n'
      reduce(str_c) %>%
      str_split('\n') %>%
      unlist()

    # Column 1 is the name of the Fixed-Tune
    cl1 <- batches %>% str_extract('(?<=【).+(?=】)') %>% stri_remove_empty_na()
    # Column 2 is the lyrics
    cl2 <-
      batches %>%
      str_extract('(?<=】).+$') %>%
      stri_remove_empty_na() %>%
      # Remove leading and trailing spaces
      str_trim()
    DTWikisource <-
      rbindlist(list(DTWikisource,
                     data.table('Qupai' = cl1,
                                'Lyrics' = cl2)))
  }

  on.exit(rm(processWikisource, envir = parent.env(environment())))
  return(DTWikisource)
}
