# DataAnalytics2024_Jake_Lorenzo_Lab_3_Assignment_2


Part 1 Variable Distributions

Part 2 Linear Models
The first linear model I created compared the following five variables (FSH, WRS, AIR, H20, and APO) to the LOG_EPI data. The two varibales that most signifacantly influence EPI is AIR and APO. The R-Squared value for the world data model comparing LOG_WPI and WPO was 0.5363837. The second model I created compared the same variables to LOG_EPI but narrowed the scope to only the Global West Region. The R-squared value for comparing APO and LOG_EPI was 0.2306443. Since the R-Squared value for the Global model was higher than the Global West Model I can say that the Global model was a better fit. I think this was due to the small sample size of the Global West region and since the Global model had more data points to analyze more statistically signifacant information could be extracted.

Part 3 KNN Models

The three regions I chose were Global West, Southern Asia, and Eastern Europe and the variables I looked at were FSH, WRS, AIR, EPI, H20, and APO. 
Accuracy for k in ks
K = 1, Accuracy = 0.909090
K = 3, Accuracy = 1.000000
K = 5, Accuracy = 0.909090
K = 7, Accuracy = 0.909090
K = 9, Accuracy = 0.545454

For the second model I chose the Greater Middle East, Sub-Saharan Africa, and Asia-Pacifac regions. I tested the same variables and got the resulting accuracy scores for k in ks
K = 3, Accuracy = 0.7619048
K = 5, Accuracy = 0.7619048
K = 7, Accuracy = 0.7619048
K = 9, Accuracy = 0.8095238
K = 11, Accuracy = 0.8095238.

As we can see from the accuracy score for each model. The first model that tested the Global West, Southern Asia, and Eastern Europe regions had higher accuracy scores accross the k in ks distribution. This could be due to the sample size between the two models as well as the variablity of the data points for each.

Part 3 KMeans Clustering

The two models I chose to run KMeans on tested the same variables on the same regions as seen above in the KNN Models.
For the first model (Global West, Southern Asia, and Eastern Europe) 
for k in ks
K = 3, wss = 5.070621
K = 5, wss = 3.125096
K = 7, wss = 3.127612

For the second model (Greater Middle East, Sub-Saharan Africa, and Asia-Pacifac)
for k in ks
K = 11, wss = 6.431522
K = 13, wss = 5.689100
K = 15, wss = 5.075645

As we can see from comparing the two models, the first model (Global West, Southern Asia, and Eastern Europe) had lower WSS scores which means that that model had less variability in the data (each point was closer to the centroid). This means that the first model was more accurate. This could be due to the first model having a more well defined cluster structure.

