pcrboot <- function(
object, 
type = c("boot", "jack"),  
B = 100, 
njack = 1,
plot = TRUE, 
do.eff = TRUE, 
conf = 0.95, 
verbose = TRUE,
...)
{
  type <- match.arg(type)
  if (class(object) != "pcrfit" && class(object) != "nls") stop("Use only with objects of class 'pcrfit' or 'nls'!")   
    
  DATA <- eval(object$data, sys.frame(0))    
  if (class(object) != "pcrfit") resp <- all.vars(formula(object)[[2]]) else resp <- 2
  
  fitted1 <- fitted(object)
  resid1 <- residuals(object)   
  modList <- list()
  effList <- list()    
  ndata <- nrow(DATA)  
  noconv <- 0
  if (class(object) != "pcrfit") do.eff = FALSE
  
  ### collect stats and if 'pcrfit' model, 
  ### efficiency analysis     
  
  for (i in 1:B) {    
    newDATA <- DATA         
    if (type == "boot") newDATA[, resp] <- fitted1 + sample(scale(resid1, scale = FALSE), replace = TRUE)
     else {
      sampleVec <- sample(1:ndata, njack)    
      newDATA <- newDATA[-sampleVec, ]      
     }
     
    newMODEL <- try(update(object, data = newDATA))
    
    if (inherits(newMODEL, "try-error")) {
      noconv <- noconv + 1
      next
    }
          
    if (plot) plot(newMODEL, ...)
    
    modList[[i]] <- list(coef = coef(newMODEL), sigma = summary(newMODEL)$sigma,
                         rss = sum(residuals(newMODEL)^2), 
                         dfb = abs(coef(newMODEL) - coef(object))/(summary(object)$parameters[, 2]),
                         gof = pcrGOF(newMODEL)) 
    
    if (do.eff) effList[[i]] <- efficiency(newMODEL, plot = FALSE, ...)          
    
    if (verbose) {
      if (i %% 10 == 0) cat(i) else cat(".")
      if (i %% 50 == 0) cat("\n")
      flush.console()
    }
  }
  cat("\n\n")
  if (verbose) cat("fitting converged in ", 100 - (noconv/B), "% of iterations.\n\n", sep = "") 
   
  ### stat analysis    
  COEF <- t(sapply(modList, function(z) z$coef))  
  RSE <- sapply(modList, function(z) z$sigma)  
  RSS <- sapply(modList, function(z) z$rss)           
  GOF <- t(sapply(modList, function(z) unlist(z$gof))) 
  
  effDAT <- t(sapply(effList, function(z) unlist(z)))    
 
  statList <- list(coef = COEF, rse = RSE, rss = RSS, gof = GOF, eff = effDAT) 
  confList <- lapply(statList, function(x) t(apply(as.data.frame(x), 2, function(y) quantile(y, c((1 - conf)/2, 1 - (1 - conf)/2), na.rm = TRUE)))) 
    
  if (plot) {
    ndata <- sum(rapply(statList, function(x) ncol(x)))
    par(mfrow = c(6, 5))
    par(mar = c(1, 2, 2, 1))
    for (i in 1:length(statList)) { 
      temp <- as.data.frame(statList[[i]])
      if (is.vector(statList[[i]])) colnames(temp) <- names(statList)[i]
      for (j in 1:ncol(temp)) {
        if (all(is.na(temp[, j]))) next 
        COL <- switch(names(statList)[i], coef = 2, gof = 3, eff = 4)             
        boxplot(temp[, j], main = colnames(temp)[j], col.main = COL, outline = FALSE, ...)  
        abline(h = confList[[i]][j, ], col = 2, ...)    
      }    
    }           
   }  
  return(list(ITER = statList, CONF = confList))   
} 