\name{pcrboot}
\alias{pcrboot}

\title{Bootstrapping and jackknifing qPCR (and other) data}

\description{
Confidence intervals for the estimated parameters and goodness-of-fit measures are calculated for a nonlinear qPCR data fit by either\cr
a) boostrapping the residuals of the fit or\cr
b) jackknifing and refitting the data.

If data of class \code{pcrfit} is supplied, confidence intervals are also calculated for all parameters obtained from the \code{\link{efficiency}} analysis.
Works for all models with a \code{model$data} item and a \code{\link{fitted}} and \code{\link{residuals}} function.
See 'Details'. 
}

\usage{
pcrboot(object, type = c("boot", "jack"), B = 100, njack = 1,
        plot = TRUE, do.eff = TRUE, conf = 0.95, verbose = TRUE, ...)
}

\arguments{
  \item{object}{an object of class 'pcrfit' or other.}
  \item{type}{either \code{boot}strapping or \code{jack}knifing.} 
  \item{B}{numeric. The number of iterations.} 
  \item{njack}{numeric. In case of \code{type = "jack"}, how many datapoints to exclude. Defaults to leave-one-out.}
  \item{plot}{should the fitting and final results be displayed as a plot?}
  \item{do.eff}{logical. If \code{TRUE}, \code{\link{efficiency}} analysis will be performed.}
  \item{conf}{the confidence level.}
  \item{verbose}{logical. If \code{TRUE}, the iterations will be printed on the console.}
  \item{...}{other parameters to be passed on to the plotting functions.}
}

\details{
Non-parametric bootstrapping is applied using the centered residuals.\cr
1) Obtain the residuals from the fit: \deqn{\hat{\varepsilon_{t}} = y_t - f(x_t, \hat{\theta})}
2) Draw bootstrap pseudodata: \deqn{y_{t}^{\ast} = f(x_t, \hat{\theta}) + \epsilon_{t}^{\ast}}
where \eqn{\epsilon_{t}^{\ast}} are i.i.d. from distribution \eqn{\hat{F}}, where the residuals from the original fit are centered at zero.\cr
3) Fit \eqn{\hat\theta^\ast} by nonlinear least-squares.\cr
4) Repeat \emph{B} times, yielding bootstrap replications \deqn{\hat\theta^{\ast 1}, \hat\theta^{\ast 2}, \ldots, \hat\theta^{\ast B}}
One can then characterize the EDF and calculate confidence intervals for each parameter: \deqn{\theta \in [EDF^{-1}(\alpha/2), EDF^{-1}(1-\alpha/2)]}      
The jackknife alternative is to perform the bootstrap on the data-predictor vector, i.e. eliminating a certain number of datapoints.\cr 
If the residuals are correlated or have non-constant variance the latter is recommended. This may be the case in qPCR data,
 as the variance in the low fluorecence region (ground phase) is usually much higher than in the rest of the curve. 
}

\value{
A list containing the following items:
  \item{ITER}{a list containing each of the results from the iterations.}   
  \item{CONF}{a list containing the confidence intervals for each item in \code{ITER}.}
  
Each item contains subitems for the coefficients (\code{coef}), root-mean-squared error (\code{rse}),
 residual sum-of-squares (\code{rss}), goodness-of-fit measures (\code{gof}) and the efficiency analysis (\code{eff}).
If \code{plot = TRUE}, all data is plotted as boxplots including confidence intervals.     
}

\author{
Andrej-Nikolai Spiess
}

\references{
Bates DM and Watts DG (1988).\cr
Nonlinear regression analysis and its applications.\cr
Wiley, Chichester, UK.\cr

Seber GAF and Wild CJ (1989).\cr
Nonlinear regression.\cr
Wiley, New York.

Roy T (1994).\cr
Boostrap accuracy for non-linear regression models.\cr
\emph{J Chemometics}, \bold{8}: 37-44.
}
          
\examples{
## simple bootstrapping with
## too less iterations...
par(ask = FALSE)
m1 <- pcrfit(reps, 1, 2, l4)
res <- pcrboot(m1, B = 20)

## jackknifing with leaving
## 5 datapoints out
m2 <- pcrfit(reps, 1, 2, l4)
res <- pcrboot(m2, type = "jack", njack = 5, B = 20)
}
    
\keyword{models}
\keyword{nonlinear}
