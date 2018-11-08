# run in bash terminal: 
#   sudo Rscript /mbon/admin/add_users.R; cat /etc/passwd
#   BB keeping mbon_users.csv secured on laptop
library(tidyverse)
library(readxl)
library(glue)

pass  = read_lines("/data/nps_passwd.txt")
users = read_excel('/data/nps-r-workshop/data/nps_participants.xlsx')
tmp   = '~/tmp_user.txt'

for (i in 1:nrow(users)){ # i=1
  
  user  <- users$username[i] %>% tolower()
  name  <- users$full[i] %>% str_replace("(\\w*)\\W*<(.*)>.*", "\\1")
  email <- users$full[i] %>% str_replace("(\\w*)\\W*<(.*)>.*", "\\2")
  dir_home = glue("/home/{user}")
  
  uid <- read_delim(
    "/etc/passwd", ":", 
    col_names = c(
      "user", "pass", "uid", "gid", "info", "dir", "shell")) %>%
    filter(uid >= 1000, uid < 10000) %>% 
    arrange(uid) %>% 
    tail(1) %>% 
    pull(uid) + 1
  
  writeLines(glue(
    "{user}:{pass}:{uid}:{uid}:{name} <{email}>:{dir_home}:/bin/bash"), tmp)
  
  system(sprintf('sudo newusers %s', tmp))
  # sudo deluser USER
  
  if (!dir.exists(dir_home)){
    system(sprintf('sudo mkdir %s; sudo chown -R %s %s\n', dir_home, user, dir_home))
  }
  system(glue('sudo ln -s /data {dir_home}/data'))
  
  unlink(tmp)
}
