library(learnr)
library(gradethis)
library(learnrhash)
library(tidyverse)

listfile <- list.files(pattern = "txt",full.names = T, recursive = TRUE)

listfile

dat = c()

n = length(listfile)


for(i in 1:n){
  x1 = file(listfile[i],"r")
  r_line = readLines(x1)
  name = sub("\\).*", "", sub(".*\\(", "", r_line[1])) #Reads the first line
  if (i %in% c(11,12,15,23)){#For students that dont put the hash in the right spot
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
    hash = sub("\\.*</p></div>", "", sub(".*<div data-b-wrap=\"true\"><p data-b-index=\"0\">", "", r_line[7]))
  }
  
  temp_dat = c(name, hash)
  
  dat = rbind(dat, temp_dat)
}


row.names(dat) = NULL
colnames(dat) = c("Username","hash")

dat = as.data.frame(dat)

score = c()

for (i in 1:nrow(dat)) {
  score[i] = learnrhash::decode_obj(dat$hash[i])%>%
    filter(correct == "TRUE")%>%
    summarise(score = round(n()/9*20,2))%>%
    pull(score)
  
}

score

dat = cbind(dat, score)
dat = dat %>% select(Username, score)%>%mutate(score = ifelse(is.nan(score), 0, score))
dat

RA7 <- read_csv("gc_MATH224007.202220_column_2022-01-23-19-53-03.csv")

RA7 = left_join(RA7, dat, by = "Username")

RA7 = RA7%>%
  mutate(`(RA1) Reading Assignment #1 [Total Pts: 20 Score] |1672899` = score)%>%
  select(-score)

write.csv(RA7, "MATH224001 Dr.Mostafa - RA7.csv", row.names = F)
