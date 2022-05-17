library(learnr)
library(gradethis)
library(learnrhash)
library(tidyverse)

listfile <- list.files(pattern = "txt",full.names = T, recursive = TRUE)

listfile

dat = c()

n = length(listfile)

x1 = file(listfile[2],"r")
readLines(x1)

for(i in 1:n){
  x1 = file(listfile[i],"r")
  r_line = readLines(x1)
  name = sub("\\).*", "", sub(".*\\(", "", r_line[1])) #Reads the first line
  if (i %in% c(8,10,21)){#For students that dont put the hash in the right spot
    hash = r_line[10] #Reads the comments
  }
  else{
    if(i %in% c(19)){
      hash = sub("\\.*</pre>", "", sub(".*\\id=\"hash_output\">", "", r_line[8])) #For submissions with weird inline code
    }
    else{
      hash = sub("\\.*</pre>", "", sub(".*\\id=\"hash_output\">", "", r_line[7])) #Reads the submission
    }
    
  }
  
  temp_dat = c(name, hash)
  
  dat = rbind(dat, temp_dat)
}


row.names(dat) = NULL
colnames(dat) = c("Username","hash")

dat[4,2] = "QlpoOTFBWSZTWcCPdg4AAsL/wP/37ihNd3/yK0EeRL93//FAACABwAJcFYTQISBDRk0ANDQaaBpoANNNNAAGmRoDJE09CT1T0j1DQNANAAA0MgeoGgAA4yNMmJoMmTCaZAyGgNAaZNDACaAwkUTSan6U2Ip5TGmpphA09Q9QANNNBkZqBp4olA0kWy2IXAUppQoNm2yUVhhAUmmwR1MDQ1TTSoz3ZNsavc0OPpmSusmulpIsPphgJLOzV6tERIAm1tVnR1QSk65WWRYxsbaxy/NWe9QpUW+XrhLH569yjk014xK6RiRwMSTSQDAQcPDBNoRFMSEY2gQud+zfVz34LISQIvMSMh6fhaTSEikROBNBRohpCNnkKMObPswOBWjgqjLaSLIvoBk5hKVNEQBwAfy3bexK+bT7Jt0RVZGggT6tUKr+TQc08W+ypJfNJU12zBxSezQsmK9EnJKtqZE1uoAAuXDbXsJKGVokxJNqaSScSYrZpxnvLWJYcaMIkxxQpUJFrXgBFxGCcEIgM0GMBUkxBDI1UPopjMXOEwsRe4QDWwWCBgw0ZNHte5AgCIiIiElapYCTgaGV5xbt9a+QAfaJJJYNcOlYLW0GXkYFGXDm99VKoI9+T8Gs5eUo2QWY9HtwTrl4yoiTFZiq54pcdhkGafXfFroiV/2iJcAomwBAYJb/zPPAV2EhQAQVdD0VyedZOKceAZlDNjfp+VpywCVM1Cbnl4lTDeh3qeAFzqWTZRBoURGC9Ei9UCF2rYtktgRWyhcQRd83uM+6IAnWjbQfGtYntQFdXNhpp6ylbjzEyrCBOEkiWBZpVHRnvxQTcpx/Wc3jWIv7hhmy4QZDhGYNvgt/mg5v9Bj/4u5IpwoSGBHuwcA="

dat = dat[-2,]

dat = as.data.frame(dat)

score = c()

for (i in 1:nrow(dat)) {
  score[i] = learnrhash::decode_obj(dat$hash[i])%>%
    filter(correct == "TRUE")%>%
    summarise(score = round(n()/13*20,2))%>%
    pull(score)
  
}

score

dat = cbind(dat, score)
dat = dat %>% select(Username, score)%>%mutate(score = ifelse(is.nan(score), 0, score))
dat

RA9 <- read_csv("gc_MATH224007.202220_column_2022-01-23-19-53-03.csv")

RA9 = left_join(RA9, dat, by = "Username")

RA9 = RA9%>%
  mutate(`(RA1) Reading Assignment #1 [Total Pts: 20 Score] |1672899` = score)%>%
  select(-score)

write.csv(RA9, "MATH224001 Dr.Mostafa - RA9.csv", row.names = F)
