library(readr)
LandWCF_Copy_October_17_2020_11_29 <- read_csv("~/Downloads/LandWCF_November 1, 2020_16.42.csv")


library(readr)
centroidsUS <- read_csv("~/workspace/lwcf/assets/centroidsUS.csv")
tester<-merge(centroidsUS, LandWCF_Copy_October_17_2020_11_29, by.x=c('State','County'), all=FALSE)

##Finding those thatt didn't fill in County
t<-LandWCF_Copy_October_17_2020_11_29[- grep("", LandWCF_Copy_October_17_2020_11_29$County),]
tester1<-merge(centroidstates, t, by.x='State', all=FALSE)
tester1$StateAp<-NULL

tester=rbind(tester,tester1)



library(dplyr)


tester$Q10<- gsub("(trail resurfacing, bridge construction, multi-use paths)|(parking areas, electrical, roads, ADA accessibility, shelters, water treatment, waste management)|(surface upgrades and rehabilitation, lighting, running tracks)|(including ADA accessibility)|(boathouses, beaches piers/pavilions, boat launches)", "", tester$Q10)
tester$Q10<-gsub("\\(State Comprehensive Outdoor Recreation Plans \\(SCORPs) and Master Plans)", "", tester$Q10)
tester$Q10<-gsub("\\(please describe on next page)", "", tester$Q10)
tester$Q10<-gsub("\\ ()", "", tester$Q10)
tester$Q10<-gsub("\\()", "", tester$Q10)
tester$Q10<-gsub("\\:", "", tester$Q10)
tester$Q9<-gsub("\\(please describe)", "", tester$Q9)
tester$Q15<-gsub("\\(please describe)", "", tester$Q15)
tester$Q9<-gsub("\\:", "", tester$Q9)
tester$Q15<-gsub("\\:", "", tester$Q15)


write.csv(tester, file="lwcfsurvey.csv")



