# Download a menu containing URLs to the text corpus of Peony Pavillion
# that is available at gongchepu.net
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

dlGongcheMenu <- function() {
  # Download the meta-data containing the url to each individual Gongchepu
  #
  # Args:
  #   None
  # Returns:
  #   A data.table with meta-data of all Acts of Peony Pavillion, availabe
  # Side-effects:
  #   Remove it self
  menu <-
    read_html('https://gongchepu.net/list/published') %>%
    html_nodes(xpath = '/html/body/div/div[32]/div/ul/li')

  # First column, Act
  cl1 <- menu %>% map(xml_child,1) %>% map(html_text)
  DT <- data.table(Act = cl1)

  # Second column, URLs to each Act
  # Here the URL's are relative path to the Base URL
  # Eg. if
  #   Relative URL = /reader/397/
  #   Base URL = https://gongchepu.net
  # then
  #   Full URL = https://gongchepu.net/reader/397/
  cl2 <-
    menu %>%
    map(html_nodes, 'a') %>%
    map(html_attr, 'href') %>%
    map(function(x) paste0('https://gongchepu.net', x))
  DT <- DT[, URL:=cl2]

  on.exit(rm(dlGongcheMenu, envir = parent.env(environment())))
  return(DT)
}
