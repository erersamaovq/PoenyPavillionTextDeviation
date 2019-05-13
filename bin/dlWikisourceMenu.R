# Generate a data frame containing URLs to the text corpus of Peony Pavillion
# that is available at Wikisource
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

dlWikisourceMenu <- function () {
  # Dowload the Original Text of Peony Pavillion and store them in a data.table
  #
  # Args:
  #   None
  # Returns:
  #   A data.table with text of Peony Pavillion whose Act Name matches
  # Side-effects:
  #   Remove itself
  menu <-
    read_html('https://zh.wikisource.org/wiki/牡丹亭') %>%
    html_nodes(xpath = '/html/body/div[3]/div[3]/div[4]/div/table[3]') %>%
    html_nodes('li')

  # First column, Act
  cl1 <- menu %>% map(xml_child,1) %>% map(html_text)
  DT <- data.table(Act=cl1)

  # Second column, URLs to each Act
  # Here the URL's are relative path to the Base URL
  # Eg. if
  #   Relative URL = /wiki/%E7%89%A1%E4%B8%B9%E4%BA%AD/%E6%A6%9C%E4%B8%8B
  #   Base URL = https://zh.wikisource.org
  # then
  #   Full URL = https://zh.wikisource.org/wiki/%E7%89%A1%E4%B8%B9%E4%BA%AD/%E6%A6%9C%E4%B8%8B
  cl2 <-
    menu %>%
    map(html_nodes, 'a') %>%
    map(html_attr, 'href') %>%
    map(function(x) paste0('https://zh.wikisource.org',x))
  DT <- DT[, URL:=cl2]

  on.exit(rm(dlWikisourceMenu, envir = parent.env(environment())))
  return(DT)
}
