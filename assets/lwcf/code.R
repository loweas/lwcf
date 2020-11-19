library(readr)
## The file name needs to be changed
LandWCF <- read_csv("~/Downloads/LandWCF_November 19, 2020_14.10")
LandWCF$Q6_1[LandWCF$Q1_2_TEXT=="City of Farmington"]<-"New Mexico"
## Remove Columns and Identifiable Rows
test <- LandWCF[-c(1:2),] 
test <- test[-c(1:17)] 

## Change Name of Columns
library(dplyr)
test= test %>% 
  rename(
    State = Q6_1,
    County = Q6_2
  )

library(readr)
##  Merge on State/County
centroidsUS <- read_csv("~/workspace/lwcf/assets/centroidsUS.csv")
tester<-merge(centroidsUS, test, by.x=c('State','County'), all=FALSE)

##Finding those thatt didn't fill in County
t<-test[- grep("", test$County),]
tester1<-merge(centroidstates, t, by.x='State', all=FALSE)
tester1$StateAp<-NULL

## Bind together
tester=rbind(tester,tester1)



## Clean up some of the strings in the data so easier to view on C3.js

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
tester$Q15<-gsub("Campground \\+ Hospitality", "Campground/Hospitality", tester$Q15)
tester$Q15<-gsub("Kayaking and Rafting", "Kayaking/Rafting", tester$Q15)

tester$Top11<-0
tester$Top11[tester$Q5_1=="Palisade Wall Repair at Alpine Tunnel Historic District Gunnison" | 
               tester$Q5_1=="Fishing Pier, Delaware City Branch Channel of the C&D Canal"|
             tester$Q5_1=="Restore Rumney"|
               tester$Q5_1=="All Abilities Park"|
               tester$Q5_1=="Animas River Wave Features"|
               tester$Q5_1=="Red Rock Canyon National Conservation Area Restoration"|
               tester$Q5_1=="Crooked River"|
               tester$Q5_1=="Indian Creek Climbing Conservation"|
               tester$Q5_1=="Spokane County-- Make Beacon Hill Public"|
               tester$Q5_1=="Port of Anacortes--Developing the Cap Sante Marina RV Park"|
               tester$Q5_1=="New River Gorge National River Trail moderazation" ]<-1

#Write CSV file
write.csv(tester, file="lwcfsurvey.csv")

#Write GeoJson File 
library("geojsonio", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")
geojson_write(tester, file = "lwcf.geojson")


library("tm")
library("SnowballC")
library("RColorBrewer")
library("wordcloud")

texts=tester$Q5_2
docs <- Corpus(VectorSource(texts))

docs <- docs %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(stripWhitespace)
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))
dtm <- TermDocumentMatrix(docs) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)
df<- df[-c(1),] 
words <- df %>% count(word, sort=TRUE)set.seed(1234) # for reproducibility 
wordcloud(words = df$word, freq = df$freq, min.freq = 1,           max.words=100, random.order=FALSE, rot.per=0.35, scale=c(3.5,0.25),         colors = c('#5c8e53', '#2a4c7e', '#8E535C', '#784a6f','#008072'))

