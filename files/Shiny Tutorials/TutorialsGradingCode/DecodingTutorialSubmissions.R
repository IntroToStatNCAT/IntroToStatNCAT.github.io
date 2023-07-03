library(learnr)
library(gradethis)
library(learnrhash)
library(tidyverse)

#make sure to download the list of .txt files with individual student submissions
listfile <- list.files(pattern = "txt",full.names = T, recursive = TRUE)

dat = c()

n = length(listfile)

for(i in 1:n){
  x1 = file(listfile[i],"r")
  r_line = readLines(x1)
  name = sub("\\).*", "", sub(".*\\(", "", r_line[1])) #Reads the first line
  if (i %in% c(8,10,11,12,20)){ #For students that dont put the hash in the right spot
    hash = r_line[10] #Reads the comments
  }
  else{
    if(i %in% c(2)){
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

dat = as.data.frame(dat)

score = c()

for (i in 1:nrow(dat)) {
  score[i] = learnrhash::decode_obj(dat$hash[i])%>%
    filter(correct == "TRUE")%>%
    summarise(score = round(n()/10*20,2))%>%
    pull(score)
  
}

score

dat = cbind(dat, score)
dat = dat %>% select(Username, score)
dat

#download the lastname, firstname, username and 
#tutorial_1 columns from the LMS gradebook and
#save it as "tutorial_1.csv"
#Then read the file to R to be updated with the tutorial_1 scores

tutorial_1 <- read_csv("tutorial_1.csv")

tutorial_1 = left_join(tutorial_1, dat, by = "Username")

tutorial_1 = tutorial_1%>%
  mutate(`name_of_assignment_column_in_gradebook` = score)%>%
  select(-score)

write.csv(tutorial_1, "tutorial_1_scores.csv", row.names = F)
