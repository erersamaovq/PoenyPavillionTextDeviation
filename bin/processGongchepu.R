# Generate a data frame with text corpus extracted from Gongchepu.net
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

processGongchepu <- function() {
  # Download the webpages from Gongchepu.net, extract the text corpus, and store
  # them in a data frame.
  #
  # Args:
  #   None
  # Returns:
  #   A data.table with Qupai, the name of fixed tones, and the Text
  # Side-effects:
  #   Remove it self
  if (is_empty(dir('./data/gongchepu'))) {
    stop("Please verify gongchepu data files are stored under gongchepu directory.")
  }

  DTGongche <- data.table('Qupai' = character(), 'Lyrics' = character())
  for (f in dir('./data/gongchepu', full.names = TRUE)) {
    batches <- read_html(f, encoding = 'UTF-8') %>%
      html_node('div#gcn') %>%
      html_text() %>%
      str_split('\\n【') %>%
      unlist() %>%
      # Skip lines of metadata starts with `^;.*`
      str_subset('^;', negate = TRUE) %>%
      # Remove the following patterns
      #   `^>.* or ^=.*`    Player's actions in the play
      str_remove_all('(>.+)(?=\\n|$)') %>%
      str_remove_all('=') %>%
      #   `pz`              Footnotes
      str_remove_all('pz\\{.+\\}') %>%
      #   `{}`              Gongche
      str_remove_all('\\{.+\\}') %>%
      #   `（.+）`          Key and other information
      str_remove_all('（.+）') %>%
      #   `^$`              Empty lines
      stri_replace_all_fixed('\\', '') %>%
      str_remove_all('\n') %>%
      # Remove leading and trailing spaces
      str_trim()
    # Column 1 is the name of the Fixed-Tune
    cl1 <- batches %>% str_extract('^.+(?=】)')
    # Column 2 is the lyrics
    cl2 <- batches %>% str_extract('(?<=】).+$')
    DTGongche <-
      rbindlist(list(DTGongche,
                     data.table('Qupai' = cl1,
                                'Lyrics' = cl2)))
  }

  on.exit(rm(processGongchepu, envir = parent.env(environment())))
  return(DTGongche)
}
