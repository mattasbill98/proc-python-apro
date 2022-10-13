# PROC PYTHON usage in the Analytics Pro container

This repository contains an analytics example for using the Python procedure in SAS's Analytics Pro on Viya.

The userexec_usermods.sas file is included and can be added into the sasinside folder of the Analytics Pro on Viya deployment to enable PROC PYTHON. After executing the procedure and relaunching the container, the Logistic Regression code can be pasted into the SAS Studio window. The libname statement can be changed to better fit your needs but the data, the Iris dataset, should be within the sashelp libraries for use.

While I completed the analysis within one PROC PYTHON step, this is not required. There can be multiple PROC PYTHON & submit/endsubmit blocks. For example, I could have run the plot in one submit/endsubmit block and the logistic regression model in another.

# Additional Resources
[Analytics Pro Deployment Guide](https://go.documentation.sas.com/api/collections/anprocdc/v_001/docsets/dplyviya0ctr/content/dplyviya0ctr.pdf?locale=en)
