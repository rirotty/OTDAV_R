#loading the package:
library(xml2)
library(rvest)
library(stringr)
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("ggplot2")
library(cluster)
library(fpc)

frame=data.frame()
url <-'https://www.artsper.com/fr/oeuvres-d-art-contemporain?price=0-25000&sort=5&ipp=120&page='
for(i in 1:100)
{
#Reading the html content from 
webpage <- read_html(str_c(url,i))

#scrape title of the product
oeuvres_html <- html_nodes(webpage,'.title-item') %>% html_nodes("span")
 title <- html_text(oeuvres_html)
 head(title)

 artist_html <- html_nodes(webpage,'.relative > p > i')
 arti <- html_text(artist_html)
 head(arti)
 
 cat_html <- html_nodes(webpage,'.relative > p > .category')
 cat <- html_text(cat_html)
 head(cat)
 

 popularity <- 1:120
 popularity <- popularity + 120*i
 
 placeholder<-data.frame(arti, cat, title, popularity)
frame<-rbind(frame,placeholder)
}

write.csv(frame,"otdav_dataa.csv")
categories<-table(frame$cat)

lbls <- paste(names(categories), "\n", categories, sep="")
pie(categories, labels = lbls, 
    main="Catégories des oeuvres")


cats<-head(sort(table(frame$cat),decreasing = TRUE),n=3L)


barplot(cats, las = 2, main ="Categories with most artworks",
        ylab = "Artworks", xlab="Categories",col = c("mistyrose", "lightcyan", "lavender"))

wordcloud(frame$title, min.freq=1,max.words=200,random.order=FALSE, rot.per=0.35, 
                    colors=brewer.pal(8, "Dark2"))



table(frame$title)
top<-head(sort(table(frame$title),decreasing = TRUE),n=5L)
barplot(top,col=c("lightblue", "mistyrose", "lightcyan", 
     "lavender", "cornsilk"),main ="Top artists",beside = TRUE)

set.seed(20)
frameCluster <- kmeans(frame[, 2:4], 3, nstart = 20)
frameCluster
table(frameCluster$cluster, frame$popularity)
frameCluster$cluster <- as.factor(frameCluster$cluster)
plotcluster(frame[,4:4],frameCluster$cluster)








 