

library(RColorBrewer)
library('IMIFA')
library('fields')

plotloadC <- function(x, na.col = "#FFFFFF", ptype = c("image", "points"),
                      border.col = "#FFFFFF", dlabels = NULL, rlabels = FALSE,
                      clabels = FALSE, pch = 15, cex = 3, label.cex = 0.6){
  # for(i in 1:length(x)){
  #   temp <- x[[i]]
  #   temp[which(abs(temp) < 1)] <- 0
  #   x[[i]] <- temp
  # }
  #x[which(abs(x) < 0.1)] <- 0
  xl    <- unlist(x)
  ux    <- unique(xl)
  nHalf <- length(ux)/2
  Min = quantile(unlist(lapply(x, min)), probs = 0.5)#min(ux)
  Max = quantile(unlist(lapply(x, max)), probs = 0.5)#max(ux)
  Thresh = 0
  ## Make vector of colors for values below threshold
  rc1 = colorRampPalette(colors = c("red", "white"), space="Lab")(nHalf+1)    
  ## Make vector of colors for values above threshold
  rc2 = colorRampPalette(colors = c("white", "blue"), space="Lab")(nHalf+1)
  rampcols = c(rc1, rc2)
  
  rb1 = seq(Min, Thresh, length.out=nHalf+1)
  rb2 = seq(Thresh, Max, length.out=nHalf+1)[-1]
  rampbreaks = c(-max(abs(ux)), rb1, rb2, max(abs(ux)))#c(rb1, rb2)
  
  cmat <- mat2cols((x), compare = T, cols = rampcols, breaks=rampbreaks)
  info <- list()
  for(i in 1: length(x)){
    N <- nrow(cmat[[i]])
    P <- ncol(cmat[[i]])
    cmati <- replace(cmat[[i]], is.na(cmat[[i]]), na.col)
    levels <- sort(unique(as.vector(cmati)))
    z <- matrix(unclass(factor(cmati, levels = levels, labels = seq_along(levels))),
                nrow = N, ncol = P)
    info[[i]] <- list(x = seq_len(P), y = seq_len(N), z = t(z),
                      col = levels)
  }
  
  return(list(info=info, col = rampcols, brk = rampbreaks))
}

## Make
#par(mfrow=c(1,2))
dev.new()

comp_l_latent <- read.csv("~/Documents/vestalab/ML_proj/comp_l_latent.csv", header=FALSE)
comp_nl_latent <- read.csv("~/Documents/vestalab/ML_proj/comp_nl_latent.csv", header=FALSE)

lambdas1 <- list(t(as.matrix(comp_l_latent)), t(as.matrix(comp_nl_latent)))

out1 <- plotloadC(lambdas1)
infoful1 <- out1$info

Infolam <- infoful1[[1]]
image(Infolam$x, Infolam$y, Infolam$z, col = Infolam$col, yaxt="n",main = "PFA for Standardized data", xlab="Factors",  cex.lab = 1.5, ylab="")
box(lwd=3.5)

Infolam <- infoful1[[2]]
dev.new()
image(Infolam$x, Infolam$y, Infolam$z, col = Infolam$col, yaxt="n",main = "FBPFA for Standardized data", xlab="Factors",  cex.lab = 1.5, ylab="")
box(lwd=3.5)

unlam <- matrix(unlist(lambdas1), 1, length(unlist(lambdas1)))
#dev.new()

image.plot(1, length(unlist(lambdas1)), unlam, col = out1$col, breaks = out1$brk, legend.only = T, cex.lab = 2, ylab="")


dev.off()


