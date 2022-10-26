/* Proc Python within the Apro Container with Example */

*Create the library;
libname open "/data";

proc python; 
submit;

#set timeout=120 (proc python timeout=120;) option if proc python takes too long to initialize

import os
#os.system("python3 -m pip install sklearn --user")
#os.system("python3 -m pip install pandas --user")
#os.system("python3 -m pip install numpy --user")
#os.system("python3 -m pip install seaborn --user")
#os.system("python3 -m pip install matplotlib --user")
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

#Read in the data & convert sas data set to dataframe
data = SAS.sd2df("sashelp.iris")
#print(data)

##################### Plot the data #######################

# might have to clear the graph using plt.clf() if you run your (changed) Python code multiple times
# to ensure that the latest graph is stored in the .png file.
plt.clf()

scat_plot = sns.FacetGrid(data, hue ="Species",
              height = 6).map(plt.scatter,
                              'PetalLength',
                              'SepalLength').add_legend()
plt.xlabel('Petal Length (cm)')
plt.ylabel('Sepal Length (cm)')
scat_plot.fig.subplots_adjust(top=.95)
plt.title('Sepal & Petal Length by Species')
plt.grid(True)
SAS.pyplot(plt)

plt.clf()

###################### Logistic Regression ##########################

#Separate the target from the dependencies
X = data.iloc[:, data.columns != 'Species'] # removes the species column
y = data.iloc[:, data.columns == 'Species'] #Selects only the species variable

#Split the data into 70% training and 30% testing
x_train, x_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=123)

#Train the Logistic Regression Model
model = LogisticRegression()
model.fit(x_train, y_train) 

#Test the model
predictions = model.predict(x_test)
print(predictions)# printing predictions

#Get precision, recall, f1-score
print(classification_report(y_test, predictions))

#Print accuracy
print(accuracy_score(y_test, predictions))

#Merge the test set 
tst = np.column_stack([x_test, y_test]) #column_stack = Stack 1-D arrays as columns into a 2-D array

#Merge the test set with the predictions
tst_merged = np.column_stack([tst, predictions])
cols = ['SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth', 'Species', 'Predicted']
df = pd.DataFrame(tst_merged, columns = cols) #must be in dataframe format to convert to sas dataset
#print(df)

#convert the dataframe to a sas dataset
SAS.df2sd(df, "open.iris_predicted")
SAS.df2sd(data, "open.iris_full")

endsubmit;
run;

*Print the test dataset with predicted values;
proc print data = open.iris_predicted;
run;
