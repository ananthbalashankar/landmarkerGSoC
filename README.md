landmarkerGSoC
==============
This is the working repo of my project for GSoC 2013. It aims to provide a working system to provide
shopping malls the mechanism to gather analytics about the shoppers through their smartphones. The Android phone application
collects the data from the sensors on the smartphone and sends it to the Server. The server then passes it on to the Matlab
code which processes it to extract Landmarks. The concept of landmarks [sensor signatures] used here is the one
presented in the MobiSys 2012 conference [http://synrg.ee.duke.edu/papers/unloc-final.pdf]. The landmarks hence got, are
annotated with data entered by the users' phone application like: comments, ratings. 

The landmarks encountered provides a mechanism to get the heat-map of the shopping mall. This can be used by the mall owner
to optimize his discounts/ offers. Also, a mechanism to push to the user locally relevant data is being developed.

