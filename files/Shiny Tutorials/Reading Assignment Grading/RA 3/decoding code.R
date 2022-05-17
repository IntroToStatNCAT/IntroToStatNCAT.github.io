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
  if (i %in% c(4,10)){ #For students that dont put the hash in the right spot
    hash = r_line[10] #Reads the comments
  }
  else{
    if(i %in% c(14)){
      hash = sub("\\.*</pre>", "", sub(".*\\id=\"hash_output\">", "", r_line[8])) #For submissions with weird inline code
    }
    else{
      hash = sub("\\.*</pre>", "", sub(".*\\id=\"hash_output\">", "", r_line[7])) #Reads the submission
    }
    
  }
  if(i %in% c(100)){
    hash = sub("\\.*</p></div>", "", sub(".*\\=\"0\">", "", r_line[7]))
  }
  if(i %in% c(100)){
    hash = sub("\\.*<p>", "", sub(".*\\</p>", "", r_line[7]))
  }
  
  temp_dat = c(name, hash)
  
  dat = rbind(dat, temp_dat)
}

row.names(dat) = NULL
colnames(dat) = c("Username","hash")

dat = as.data.frame(dat)

dat[13,2] = "QlpoOTFBWSZTWQDFhjwAAt9/wP/+fSxkZ//wPzP/0L/v//BAAAgB0AO6vI5O7DbncHDFAmUaTyif6k0ZNo1E0GRp6mgyDQABoB6geIGUJtTCT1T1BppoGgAAAAyaAAAAADEEmiNTBBoTTQNGgNBpoAANAAaDagONDQNGmRpo0yAxMEAANAaA0yAwJkCRSJqGjTTJiGg0AA0DQ0DQBkA0A0AnQWciDiJDBOcV7i8ZWlwSIQP3mS4EDhnkv6fs2497WOWeqRkiCamK8QTxLT3/00gkmKE+f8X3q7VT8NmgsAglOOtHpO8suo9u9YPkzZARahL1o2wiNLIjFYkMQAwEEbQ2AQTECImCSO3EhTg2oNJgBI1KYIvCruoWFAB0CZQrSVq8VGDOHiKcVcHf1L8NjX7Fvc0RtW2+HC4dqUh4BwMzq5OL1H2iqhADboGrnd6tFwgRbGraCPqQ8gUHHwe6BMsYYYatrJwNNjGv46Mt2Y5Azhh5BdNRQSZQHPIN+6lWCDyNXFynzBeJCUUdf1cM0tMRaNWVDbdsg8S5EFYWGBjWgmSGdi8cPIKyikE7gogxtEFEeQYpQYyMBRlg5QTi4gs4emAIBUDmQoIwlHIjQIuL8AsFgaooAmQsBLgmmdjWYmFgwZpwzaqux1hNFIG6i5qa2Qs5yDu6dzqwh7cojbwoB/Y3mtufklFrwjz+N2REk/mtiVm1co1ZpOHEhcMzui/Z00RuaxKcGbMb6F8bI38ei7+a2bIOO7i8qkokIADSlC1mSxBmSCCSLmxnXDhx8qzMMasj6KMaCuou9AwhhuXcASFGipM7PM9ubFcatXVZB2kJhqPAwdC9ttVICEtTHpsC8ZVl0WZxIWLjfRADW1q1jW0oZcJEdR7CgRYbgTnZJ9knwJUAZU1ZKvNSKYV16ib05MGxj6grQByINfW4VS2lKyUvKSvLLukX9KfdUDOYDGMvhFOWOdUkDQfLXrRmBChUJjSGUJAowTYT20LyWid9gC5QXTCQZQAbCmVdxhWcKhGK310e0ZiAIOdQg8PWtqgQBDOUsKBxsQyIKCO1qsaqP0nYm9n3Ltf81AZU4BI0s43eWHbqJ4skgRhx5bf8LZb3xjoF3Br1CNJoeEL/kYSS/NvhkHYBbwAy1IiCTFr4uN5LA6ZqzA43idDKBOM87oIINxTa1YbzApQaXoA6UNkmsDfCAWgO0autcJjmR0icR4wgYPwdyFbdrZYXHVZHatz5qAI4aYkByDInccwFVCh8HhzR/W29lA12DLQIWJnBfL6Ka8DTHhaTeGLr63g2A/kqXP6Nj/xdyRThQkADFhjw"

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

RA3 <- read_csv("gc_MATH224007.202220_column_2022-01-23-19-53-03.csv")

RA3 = left_join(RA3, dat, by = "Username")

RA3 = RA3%>%
  mutate(`(RA1) Reading Assignment #1 [Total Pts: 20 Score] |1672899` = score)%>%
  select(-score)

write.csv(RA3, "MATH224007 Dr.Mostafa - RA3.csv", row.names = F)
