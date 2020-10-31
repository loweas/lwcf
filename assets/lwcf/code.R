library(readr)
LandWCF_Copy_October_17_2020_11_29 <- read_csv("~/Downloads/LandWCF_October 29, 2020_14.00.csv")


library(readr)
centroidsUS <- read_csv("~/workspace/lwcf/assets/centroidsUS.csv")
tester<-merge(centroidsUS, LandWCF_Copy_October_17_2020_11_29, by.x=c('State','County'), all=FALSE)

##Finding those thatt didn't fill in County
t<-LandWCF_Copy_October_17_2020_11_29[- grep("", LandWCF_Copy_October_17_2020_11_29$County),]
tester1<-merge(centroidstates, t, by.x='State', all=FALSE)
tester=rbind(tester,tester1)

write.csv(tester, file="tester.csv")

## Multi-question for project location land
multi=tester
multi$American_Battlefield_Protection_Program<-0
multi$American_Battlefield_Protection_Program[grep("American Battlefield Protection Program", multi$Q9)]<-1
multi$BLM<-0
multi$BLM[grep("Bureau of Land Management", multi$Q9)]<-1
multi$NPS<-0
multi$NPS[grep("National Park Service", multi$Q9)]<-1
multi$FWS<-0
multi$FWS[grep("Fish & Wildlife Service", multi$Q9)]<-1
multi$USFS<-0
multi$USFS[grep("U.S. Forest Service", multi$Q9)]<-1
multi$localstate<-0
multi$localstate[grep("State and Local Assistance Program", multi$Q9)]<-1
multi$Forest_Legacy_Program<-0
multi$Forest_Legacy_Program[grep("Forest Legacy Program", multi$Q9)]<-1
multi$Other<-0
multi$Other[grep("Other", multi$Q9)]<-1
multi$Unknow<-0
multi$Unknow[grep("Unknown", multi$Q9)]<-1

write.csv(multi, file="multi.csv")
