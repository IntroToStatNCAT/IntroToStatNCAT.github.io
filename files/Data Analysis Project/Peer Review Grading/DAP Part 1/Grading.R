library(tidyverse)

MATH007_DAP1 <- read_csv("MATH007_DAP1.csv")

MATH

x = MATH007_DAP1%>%
  na.omit()%>%
  mutate(First_ans = tolower(First_ans),
         Last_ans = tolower(Last_ans))%>%
  group_by(Group, First_ans, Last_ans)%>%
  summarise(Contribution = round(mean(Percentage),2))


write.csv(x, "Math007-DAP1-Peer-Grade.csv", row.names = F)
