library(learnr)
library(gradethis)
library(learnrhash)
library(tidyverse)

listfile <- list.files(pattern = "txt",full.names = T, recursive = TRUE)

listfile

dat = c()

n = length(listfile)

x1 = file(listfile[1],"r")
readLines(x1)

for(i in 1:n){
  x1 = file(listfile[i],"r")
  r_line = readLines(x1)
  name = sub("\\).*", "", sub(".*\\(", "", r_line[1])) #Reads the first line
  if (i %in% c(8,9)){#For students that dont put the hash in the right spot
    hash = r_line[10] #Reads the comments
  }
  
  else{
    if(i %in% c(1,6, 13)){
      hash = sub("\\.*</pre>", "", sub(".*\\id=\"hash_output\">", "", r_line[8])) #For submissions with weird inline code
    }
    else{
      hash = sub("\\.*</pre>", "", sub(".*\\id=\"hash_output\">", "", r_line[7])) #Reads the submission
    }
    
  }
  
  if (i %in% c(11)){#For students that dont put the hash in the right spot
    hash = r_line[11] #Reads the comments
  }
  
  temp_dat = c(name, hash)
  
  dat = rbind(dat, temp_dat)
}


row.names(dat) = NULL
colnames(dat) = c("Username","hash")

dat = as.data.frame(dat)

score = c()

decode_obj(dat$hash[10])

for (i in 1:nrow(dat)) {
  score[i] = learnrhash::decode_obj(dat$hash[i])%>%
    filter(correct == "TRUE")%>%
    summarise(score = round(n()/6*20,2))%>%
    pull(score)
  
}

score

dat = cbind(dat, score)
dat = dat %>% select(Username, score)%>%mutate(score = ifelse(is.nan(score), 0, score))
dat

RA10 <- read_csv("gc_MATH224007.202220_column_2022-01-23-19-53-03.csv")

RA10 = left_join(RA10, dat, by = "Username")

RA10 = RA10%>%
  mutate(`(RA1) Reading Assignment #1 [Total Pts: 20 Score] |1672899` = score)%>%
  select(-score)

write.csv(RA10, "MATH224001 Dr.Mostafa - RA10.csv", row.names = F)
