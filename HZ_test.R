install.packages("xlsx")
library(xlsx)
library('parallel')


file <- read_excel("Documents/vestalab/ML_proj/total_data.xlsx")
sheet1 <- read_excel("Documents/vestalab/ML_proj/total_data.xlsx",sheet='DFT Calculated Dataset')  # read first sheet
sheet2 <- read_excel("Documents/vestalab/ML_proj/total_data.xlsx",sheet='Dataset with Generated Features')
sheet1_work<-as.data.frame(sheet1)
sheet2_work<-as.data.frame(sheet2)[,3:964]
colnames(sheet2_work)=colnames(sheet2[,3:964])

Y<-as.matrix(as.data.frame(sheet2[,3:9]))
X<-as.matrix(as.data.frame(sheet2[,10:964]))


RUN_paranormal=FALSE
if (RUN_paranormal)
{
  X_normal<-huge.npn(X, npn.func = "truncation")
  Y_normal<-huge.npn(Y, npn.func = "truncation")
}
if (!RUN_paranormal)
{
  load('/Users/sampreetibhattacharya/Documents/vestalab/ML_proj/XY_normal.rda')
  
}


#H-Z test
library('mvnTest')
RUN_HZTEST=FALSE

if(RUN_HZTEST)
{
  test_HZ<-function(i,j)
  {
    return(HZ.test(as.matrix(cbind(X_normal[,j],Y_normal[,i])))@HZ)
  }
  index_matrix<-matrix(NA,7*955,2)
  index_matrix[,1]<-rep(1:7,each=955)
  index_matrix[,2]<-rep(1:955,7)
  out_test_stats=mcmapply(index_matrix[,1],index_matrix[,2],FUN=test_HZ,mc.cores= 1)
  
  
  
  row_mean=rowMeans(out_test) # checking the average of the HZ value
  row_mean[which(row_mean>6898)]=0
  sel_ind=order(row_mean,decreasing=T)[1:100]
  colnames(X)[order(row_mean,decreasing=T)[1:100]]
  plot(row_mean[which(row_mean<6898)])
  sum(rowMeans(out_test)>6000) # total bumber of features which are significant
  X_screened<-X[,sel_ind] # only picking up the screened parameter.
  
  # Mapping to zero-1 since most of the methods are non parametric
  X_screen_mapped<-X_screened
  for( i in 1:dim(X_screened)[2])
  {
    if( max(X_screened[,i])!=min(X_screened[,i])) # to avoid na see below th expression
    {
      X_screen_mapped[,i]=(X_screened[,i]-min(X_screened[,i]))/(max(X_screened[,i])-min(X_screened[,i]))
    }
    
  }
}
if(!RUN_HZTEST)
{
  X_screen_mapped <- read.csv("~/Documents/vestalab/ML_proj/X_screen_mapped.csv", row.names=1, comment.char="#")
}

