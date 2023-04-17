# Linking-stability-with-molecular-geometries-of-perovskites-and-lanthanide-richness-using-machine-lea
The file contains code and requires data and instruction to run the code. 
•	Data
1.	X_screen_mapped.csv
2.	comp_l_latent.csv
3.	comp_nl_latent.csv
4.	Y.csv
5.	new_xmat.RData

•	Code

1.	HZ_test.R
2.	Factor_model_submission.ipynb
3.	Multiregression_multiple_submission.ipynb
4.	Ehull_EForm_regression.ipynb
5.	plot_factor_model_submission.R


Code Structure
Here we describe how above codes are used in different parts of our analysis. Two of these codes are written in R and the rest in python based on the availability of the required packages.

•	Algorithm 1:  Nonparametric marginal screening and selecting top 100 features. 

6.	HZ_test.R: It is written in R. Implements the overall workflow. One can run it on the original data which can be downloaded from https://www.sciencedirect.com/science/article/pii/S2352340918305092?via%3Dihub setting RUN_HZTEST=TRUE. The default is set as RUN_HZTEST =FALSE which would automatically load the screened and min-max scaled data X_screen_mapped.csv, prepared using the same code on the original data. The screened, but unscaled data is in new_xmat.RData as needed in our Factor model analysis for lanthanide (new_xmat_l) and non-lanthanide (new_xmat_nl) respectively. 

•	Section 5.1: Linear Factor Model
o	Factor_model_submission.ipynb: From new_xmat.RData  new_xmat_l and new_xmat_nl are loaded and linear factor models are implemented using them as described in Section 5.1 of the paper and the estimated loading matrices are saved as comp_l_latent.csv and comp_nl_latent.csv for the lanthanides and non-lanthanides respectively.

o	plot_factor_model_submission.R: It loads the estimated loading matrices comp_l_latent.csv and comp_nl_latent.csv, and the Figure 4(c) and 4 (d) are produced.

•	Section 5.2: Model Assessment-multivariate multiple regression
7.	Multiregression_multiple_submission.ipynb This code loads the X_screen_mapped.csv
o	  and Y.csv data and run the analysis outlined in Section 5.2 of the paper and produces Table 2.
•	Section 5.3: Inference study using EHull and EForm
o	Ehull_EForm_regression.ipynb This code loads the Y.csv, Y_new_Ehull.csv, Y_new_form.csv, group_vect.csv data and run the analysis outlined in Section 5.3 of the paper, and produces Table 3 and Figure 6. 

 	





![image](https://user-images.githubusercontent.com/66028426/232378479-809ca85b-9f3d-4bb8-a72a-eb182e9d856c.png)
