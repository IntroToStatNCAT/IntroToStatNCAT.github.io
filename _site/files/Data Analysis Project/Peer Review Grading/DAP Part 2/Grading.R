library(tidyverse)

MATH007_DAP2 <- read_csv("MATH007_DAP2.csv")

x = MATH007_DAP2%>%
  na.omit()%>%
  mutate(First_ans = tolower(First_ans),
         Last_ans = tolower(Last_ans))%>%
  group_by(Group, First_ans, Last_ans)%>%
  summarise(Contribution = round(mean(Percentage),2))

x%>%
  ungroup()%>%
  count(Group)

write.csv(x, "Math007-DAP2-Peer-Grade.csv", row.names = F)
