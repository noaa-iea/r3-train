# run in bash terminal: 
#   sudo Rscript /mbon/admin/add_users.R; cat /etc/passwd
#   BB keeping mbon_users.csv secured on laptop

users = read.csv('/mbon/admin/mbon_users.csv')
is_docker = ifelse(Sys.info()['nodename'] == 'mbon', F, T)
tmp = '/mbon/admin/tmp_user.txt'

for (i in 1:nrow(users)){ # i=6
  
  with(users[i,], {
    dir_home = sprintf('/mbon/home/%s', user)
    writeLines(sprintf(
      # <Username>:<Password>:<UID>:<GID>:<User Info>:<Home Dir>:<Default Shell>
      "%s:%s:%d:%d:%s <%s>:%s:/bin/bash" ,
      user, pass, id, id, name, email, dir_home), tmp)
    system(sprintf('newusers %s', tmp))
    if (!dir.exists(dir_home)){
      system(sprintf('sudo mkdir %s; sudo chown -R %s %s\n', dir_home, user, dir_home))
    }
  })
  
}
