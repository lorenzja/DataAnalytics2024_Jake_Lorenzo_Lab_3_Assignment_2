#Lab 3 Assignment 2

EPI_data <- read.csv("C:/Users/Jake Lorenzo/Desktop/Data Analytics/Lab 3 Assignment 2/epi2024results_DA_F24_lab03.csv")

install.packages("dplyr")

library("dplyr")

#filter EPI_data to remove every row that doesn't have "Global West" in the region column
EPI_filtered <- EPI_data %>% filter(region == "Global West")

attach((EPI_filtered))

#Histogram for Air in 'Global West' Region
summary(AIR)
fivenum(AIR,na.rm=TRUE)
stem(AIR)
hist(AIR)

hist(AIR, xlim = c(30, 100), ylim = c(0.000, 0.080), prob = TRUE)

lines(density(AIR,na.rm=TRUE,bw=1.))
rug(AIR)

#Plot/Overlay the standard curve line into the 'Air Global West Region Histogram'
x<-seq(30,100,1) 
q<- dnorm(x,mean=70.71, sd=5,log=FALSE) 
lines(x,q)
lines(x,.4*q) 

##Q-Q Plot for AIR in 'Global West' Region
qqnorm(AIR); qqline(AIR) 
qqplot(rt(ppoints(250), df = 5), AIR, xlab = "Q-Q plot for t dsn") 
qqline(AIR)

##############################################################################################3

#filter EPI_data to remove every row that doesn't have "Global West" in the region column
EPI_data_filtered <- EPI_data %>% filter(region == "Eastern Europe")

#Directly access the AIR column for EPI_data_filtered with using 'attach' command
EPI_data_filtered$AIR  

#Histogram for Air in 'Eastern Europe' Region
summary(EPI_data_filtered$AIR )
fivenum(EPI_data_filtered$AIR ,na.rm=TRUE)
stem(EPI_data_filtered$AIR )
hist(EPI_data_filtered$AIR )

hist(EPI_data_filtered$AIR , xlim = c(0, 80), ylim = c(0.000, 0.070), prob = TRUE)

lines(density(EPI_data_filtered$AIR ,na.rm=TRUE,bw=1.))
rug(EPI_data_filtered$AIR)


#Plot/Overlay the standard curve line into the 'Air Eastern Europe Region Histogram'
x<-seq(0,80,1) 
q<- dnorm(x,mean=41.89, sd=5,log=FALSE) 
lines(x,q)
lines(x,1.5*q) 


##Q-Q Plot for AIR in 'Eastern Europe' Region
qqnorm(EPI_data_filtered$AIR ); qqline(EPI_data_filtered$AIR) 
qqplot(rt(ppoints(250), df = 5), EPI_data_filtered$AIR , xlab = "Q-Q plot for t dsn") 
qqline(EPI_data_filtered$AIR )

#Histogram that combines both Air data for the Global West and Eastern Europe into one Histogram

AIR_Global_West <- EPI_data %>% filter(region == "Global West") %>% pull(AIR)
AIR_Eastern_Europe <- EPI_data %>% filter(region == "Eastern Europe") %>% pull(AIR)

# Create a combined data frame for the two regions
combined_AIR_data <- data.frame(
  AIR = c(AIR_Global_West, AIR_Eastern_Europe),
  Region = factor(c(rep("Global West", length(AIR_Global_West)), rep("Eastern Europe", length(AIR_Eastern_Europe))))
)

install.packages("ggplot2")
library("ggplot2")


range(combined_AIR_data$AIR)


summary(combined_AIR_data)

#check the data type
str(combined_AIR_data) 

# Inspect the individual components before combining
print(length(AIR_Global_West))  
print(length(AIR_Eastern_Europe))  


#Plot combined histogram
ggplot(combined_AIR_data, aes(x = AIR, fill = Region)) +
  geom_histogram(alpha = 0.6, position = "identity", binwidth = 5, color = "black") +
  labs(title = "Combined Histogram of AIR for Global West and Eastern Europe",
       x = "AIR",
       y = "Count") +
  theme_minimal() +
  scale_fill_manual(values = c("blue", "green")) +
  xlim(20, 100)


######################Exercise Linear Model################################################
#Five Variables - FSH (Fisheries), WRS (Water Resources), AIR (Air Quality), 
#H20 (Sanitation and Drinking Water), APO (Air Pollution)

View(EPI_data)

EPI_data_sorted <- EPI_data %>% select("country", "region", "EPI", "FSH", "WRS", "AIR", "H2O", "APO")

sum(is.na(EPI_data_sorted))

# Remove rows with any NA values
EPI_data_cleaned <- na.omit(EPI_data_sorted)

str(EPI_data_cleaned)

EPI_data_cleaned$EPI_log <- log10(EPI_data_cleaned$EPI)

#creating and plotting a linear model
linear_model_EPI <- lm(EPI_log ~ FSH + WRS + AIR + H2O + APO, data = EPI_data_cleaned)

summary(linear_model_EPI)

##The column with the lowest P-Value (most impacts EPI) is AIR (Air Quality) and APO (Air Pollution)
#Looking at the summary statistics:
#H2O and WRS are statistically significant at p-value of 0.05
#AIR and APO  have much smaller p-values than the 0.05 confidence level so very statistically significant

plot(linear_model_EPI)

# Plot the relationship between LOG EPI and APO (Air Pollution)
plot(EPI_data_cleaned$APO, EPI_data_cleaned$EPI_log, 
     main = "Log(EPI) vs APO (Air Pollution)",
     xlab = "APO (Air Pollution)", 
     ylab = "Log(EPI)", 
     pch = 19, col = "blue")

# Add the fitted regression line
abline(lm(EPI_log ~ APO, data = EPI_data_cleaned), col = "red", lwd = 2)

#Filter the linear model to "Global West" region only
EPI_cleaned_gw <- EPI_data_cleaned %>% filter(region == "Global West")

summary(EPI_cleaned_gw)
plot(EPI_cleaned_gw)

# Plot the relationship between LOG EPI and APO (Air Pollution)
plot(EPI_cleaned_gw$APO, EPI_cleaned_gw$EPI_log, 
     main = "Log(EPI) vs APO (Air Pollution)",
     xlab = "APO (Air Pollution)", 
     ylab = "Log(EPI)", 
     pch = 19, col = "blue")


# Add the fitted regression line
abline(lm(EPI_log ~ APO, data = EPI_cleaned_gw), col = "red", lwd = 2)


#######################Section 3 - Classification (KNN)###################################################

View(EPI_data_cleaned)

EPI_data_ready <- EPI_data_cleaned %>% select(-EPI_log)

#filter to create new df with only 3 regions of data
EPI_classification <- EPI_data_ready %>% filter(region %in% c("Global West", "Southern Asia", "Eastern Europe"))

normalize <- function(x) {return ((x - min(x)) / (max(x) - min(x))) }

EPI_classification[3:8] <- as.data.frame(lapply(EPI_classification[3:8], normalize))

summary(EPI_classification)

s_EPI <- sample(38,27)

#split into train/test set
EPI.train <-EPI_classification[s_EPI,]

#the '-' before  is the notation for taking all other values in the data set not captured in the line above
EPI.test <-EPI_classification[-s_EPI,]

EPI.train <-EPI_classification[s_EPI,-1]
EPI.test <-EPI_classification[-s_EPI,-1]

sqrt(27)
k = 5

install.packages("class")
library(class)

KNNpred <- knn(train = EPI.train[2:7], test = EPI.test[2:7], cl = EPI.train$region, k = k)

contingency.table <- table(KNNpred,EPI.test$region)
contingency.table

contingency.matrix = as.matrix(contingency.table)

sum(diag(contingency.matrix))/length(EPI.test$region)

accuracy <- c()
ks <- c(1,3,5,7,9)

for (k in ks) {
  KNNpred <- knn(train = EPI.train[2:7], test = EPI.test[2:7], cl = EPI.train$region, k = k)
  
  contingency.table <- table(KNNpred, EPI.test$region)  
  contingency.matrix = as.matrix(contingency.table) 
  
  accuracy_k <- sum(diag(contingency.matrix)) / sum(contingency.matrix)  
  accuracy <- c(accuracy, accuracy_k) 
}

plot(ks,accuracy,type = "b", ylim = c(0.6, 1.1))
print(accuracy)

##KNN Model with Different Three Regions

library("dplyr")

EPI_classifier <- EPI_data_ready %>% filter(region %in% c("Greater Middle East", "Sub-Saharan Africa", "Asia-Pacific"))

normalize <- function(x) {return ((x - min(x)) / (max(x) - min(x))) }

EPI_classifier[3:8] <- as.data.frame(lapply(EPI_classifier[3:8], normalize))

summary(EPI_classifier)

s_EPI_region <- sample(70,49)

#split into train/test set
EPI_region.train <-EPI_classifier[s_EPI_region,]

#the '-' before  is the notation for taking all other values in the data set not captured in the line above
EPI_region.test <-EPI_classifier[-s_EPI_region,]

EPI_region.train <-EPI_classifier[s_EPI_region,-1]
EPI_region.test <-EPI_classifier[-s_EPI_region,-1]

k = 5

library(class)

KNNpred <- knn(train = EPI_region.train[2:7], test = EPI_region.test[2:7], cl = EPI_region.train$region, k = k)

contingency.table <- table(KNNpred,EPI_region.test$region)
contingency.table

contingency.matrix = as.matrix(contingency.table)

sum(diag(contingency.matrix))/length(EPI_region.test$region)

accuracy <- c()
ks <- c(3,5,7,9,11)

for (k in ks) {
  KNNpred <- knn(train = EPI_region.train[2:7], test = EPI_region.test[2:7], cl = EPI_region.train$region, k = k)
  
  contingency.table <- table(KNNpred, EPI_region.test$region)  
  contingency.matrix = as.matrix(contingency.table) 
  
  accuracy_k <- sum(diag(contingency.matrix)) / sum(contingency.matrix)  
  accuracy <- c(accuracy, accuracy_k) 
}

plot(ks,accuracy,type = "b", ylim = c(0.4, 1.1))
print(accuracy)

#######################Section 4 - Clustering K-Means############################################################################

View(EPI_data_ready)
EPI_data_ready1 <- EPI_data_ready[-1]

#filter to create new df with only 3 regions of data
EPI_km_region <- EPI_data_ready1 %>% filter(region %in% c("Global West", "Southern Asia", "Eastern Europe"))

summary(EPI_km_region)

set.seed(123)

normalize <- function(x) {return ((x - min(x)) / (max(x) - min(x))) }

EPI_km_region[2:7] <- as.data.frame(lapply(EPI_km_region[2:7], normalize))

summary(EPI_km_region)

#PCA to reduce dimensions

pca_result <- prcomp(EPI_km_region[, -1], center = TRUE, scale. = TRUE)

# reduce to 2-dimensions for plotting
pca_data <- pca_result$x[, 1:2]  

# run k-means
EPI.km <- kmeans(pca_data, centers = 3)

assigned.clusters <- as.factor(EPI.km$cluster)

ggplot(data.frame(pca_data), aes(x = PC1, y = PC2, colour = assigned.clusters)) +
  geom_point()

wss <- c()
ks <- c(3,5,7)
for (k in ks) {
  EPI.km <- kmeans(EPI_km_region[,-1], centers = k)
  wss <- c(wss,EPI.km$tot.withinss)
}
plot(ks,wss,type = "b")

labeled.clusters <- as.character(assigned.clusters)
labeled.clusters[labeled.clusters==1] <- "Global West"
labeled.clusters[labeled.clusters==2] <- "Southern Asia"
labeled.clusters[labeled.clusters==3] <- "Eastern Europe"
table(labeled.clusters, EPI_km_region[,1])
print(wss)

##Section 4 K-Means Three Different Regions################################################################333

EPI_data_ready1 <- EPI_data_ready[-1]

#filter to create new df with only 3 regions of data
EPI_km_region2 <- EPI_data_ready1 %>% filter(region %in% c("Sub-Saharan Africa", "Latin America & Caribbean", "Asia-Pacific"))

summary(EPI_km_region2)

set.seed(123)

normalize <- function(x) {return ((x - min(x)) / (max(x) - min(x))) }

EPI_km_region2[2:7] <- as.data.frame(lapply(EPI_km_region2[2:7], normalize))

summary(EPI_km_region2)

#PCA to reduce dimensions

pca_result2 <- prcomp(EPI_km_region2[, -1], center = TRUE, scale. = TRUE)

# reduce to 2-dimensions for plotting
pca_data2 <- pca_result2$x[, 1:2]  

# run k-means
EPI.km2 <- kmeans(pca_data2, centers = 3)

assigned.clusters <- as.factor(EPI.km2$cluster)

ggplot(data.frame(pca_data2), aes(x = PC1, y = PC2, colour = assigned.clusters)) +
  geom_point()

wsx <- c()
ks <- c(11,13,15)
for (k in ks) {
  EPI.km2 <- kmeans(EPI_km_region2[,-1], centers = k)
  wsx <- c(wsx,EPI.km2$tot.withinss)
}
plot(ks,wsx,type = "b")

labeled.clusters <- as.character(assigned.clusters)
labeled.clusters[labeled.clusters==1] <- "Sub-Saharan Africa"
labeled.clusters[labeled.clusters==2] <- "Latin America & Caribbean"
labeled.clusters[labeled.clusters==3] <- "Asia-Pacific"
table(labeled.clusters, EPI_km_region2[,1])
print(wsx)


