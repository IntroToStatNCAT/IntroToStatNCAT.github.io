library(learnr)
library(gradethis)
library(learnrhash)
library(tidyverse)

listfile <- list.files(pattern = "txt",full.names = T, recursive = TRUE)

dat = c()

n = length(listfile)


for(i in 1:n){
  x1 = file(listfile[i],"r")
  r_line = readLines(x1)
  name = sub("\\).*", "", sub(".*\\(", "", r_line[1])) #Reads the first line
  if (i %in% c(12,20,25)){ #For students that dont put the hash in the right spot
    hash = r_line[10] #Reads the comments
  }
  else{
    if(i %in% c(8)){
      hash = sub("\\.*</pre>", "", sub(".*\\id=\"hash_output\">", "", r_line[8])) #For submissions with weird inline code
    }
    else{
      hash = sub("\\.*</pre>", "", sub(".*\\id=\"hash_output\">", "", r_line[7])) #Reads the submission
    }
    
  }
  if(i %in% c(4)){
    hash = sub("\\.*</p></div>", "", sub(".*\\=\"0\">", "", r_line[7]))
  }
  if(i %in% c(17)){
    hash = sub("\\.*<p>", "", sub(".*\\</p>", "", r_line[7]))
  }
  
  temp_dat = c(name, hash)
  
  dat = rbind(dat, temp_dat)
}

row.names(dat) = NULL
colnames(dat) = c("Username","hash")

dat = as.data.frame(dat)

dat[19,2] = "QlpoOTFBWSZTWZ4HWI4AAkt/wP//+Kh8///8K0Gew79n/+BAAAIBwAJcFsZNqGk0kbSeUyI0bU8RqekAGgGgH6poGh6hoNGI9QJU1GKntBqnqPUA2o9QaAAAZGgBoAaaA0DjJgmhkMjIyaGgDQZGEA0GjTIYhoAJIhCeiMVP0UYmQ00AaDRoZHpABkaB6QzUJcz2RFIvZhDxtyRyGV5QQiLJoxUFoZHckazIraRx5LKhcTJK12xiFuNp3vzASQsTGXjssk1cuRxF3ikfqNUL4Dr7bsYRarQ5coMk5ajXYEMkhMhAa7JJ0yQBawAji1HZb7aWNxYYd57iRUukwIK2EqsPJu+aMZ7O/NupdMqqSJwJu5potNFJhnM+QzfbjJoqCYGDQJxMDrXKcHM3i9u53LcHZbbeMSzakJyRCMpqcqoeYpkL7BFEgpQh3NupJMZ+bnOwIJ7cd7DfGRI6XZSOGCRw0pDUReIdiW3akU2zaaRRO53euca669iCRrAtr4JFYWRSHAxQ0ZqZ00pkid0dvCVBjFnnHL2bKLaoYEbMtGaEmm5q4YrWJSx3vifE0imIhmZ2Tbixbh8fgiE0uPYDmrLYN5ZKwYgCSRBtXhTRXzWzrO+HRdoTihH4qEKE54BhZUdkMb6RyBax7/LFAihiwyMD+YEQA5YmQo47uV7yra089xGZoRxkDe5ujAlfmIUmnlL5EZ4z0iWM1bXORIpxHb8GpSSbnDXfgtgD2CVkaSqu82KaCdhQY5pLHBWt3mrFtrCQjr/CeszGxCXwuGCagSe4yRFm0KWtYp4wmr+uPDKccEAjrpAAZaSIkMF9DKFLRpHZlSGgqkQpr9E0c6DCLGZAyEglWiJVc15tV5LQ4yx5XJLue+IowpQ0KKIA9SeuisRB0nPCJY4HH72TJ/JQEf4u5IpwoSE8DrEc"

learnrhash::decode_obj(dat$hash[18])

score = c()

for (i in 1:nrow(dat)) {
  score[i] = learnrhash::decode_obj(dat$hash[i])%>%
    filter(correct == "TRUE")%>%
    summarise(score = round(n()/9*20,2))%>%
    pull(score)
  
}

score

dat = cbind(dat, score)
dat = dat %>% select(Username, score)
dat

RA2 <- read_csv("gc_MATH224007.202220_column_2022-01-23-19-53-03.csv")

RA2 = left_join(RA2, dat, by = "Username")

RA2 = RA2%>%
  mutate(`(RA1) Reading Assignment #1 [Total Pts: 20 Score] |1672899` = score)%>%
  select(-score)

write.csv(RA2, "MATH224007 Dr.Mostafa - RA2.csv", row.names = F)
