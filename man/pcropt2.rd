\name{pcropt2}
\alias{pcropt2}

\title{Elimination of qPCR cycles with low/high impact on fitted parameters}

\description{
The qPCR curve containing \emph{n} cycles is refitted \emph{n-1} times, each time leaving out one cycle.
The difference of the new coefficients of the fit in comparison to the original coefficients is calculated and those cycles are eliminated that have a weak (strong) influence on the change of coefficients. A new model is returned with the selected cycles left out.  
}

\usage{
pcropt2(object, plot = TRUE, which.par = "all", quan = 0.1, 
        delete = c("low", "high"), ...)
}

\arguments{
  \item{object}{an object of class 'pcrfit'.}
  \item{plot}{logical. If \code{TRUE}, the refitting and the final result are plotted.}
  \item{which.par}{The coefficient(s) to be analysed. Either \code{"all"} for all coefficients, or the coefficient name, i.e. \code{"b"}.}
  \item{quan}{the quantile for selecting the cycles exhibiting weak (strong) influence on the coefficient estimation.} 
  \item{delete}{which cycles to delete. Those with \code{low} influence on the coefficients or those with a \code{high} one.} 
  \item{...}{other parameters to be passed on to the plotting functions.}
}

\details{
For each deletion of cycle \eqn{i = 1, \ldots, n}, the qPCR data is refitted yielding new parameter estimates
\deqn{\hat\theta^{\ast 1}, \ldots, \hat\theta^{\ast i}}
The difference to the original coefficients \eqn{\hat\theta} is calculated by \deqn{crit = \frac{\left|\hat\theta - \hat\theta^{\ast i}\right|}{s.e.(\hat\theta)}}
with s.e. = standard error. The user then chooses the cycles with \eqn{F^{-1}(p) = inf\{crit \in \R: F(crit) \ge p\}}
with \eqn{p} = the selected quantile.  
}

\value{
A new model of class 'pcrfit' with the corresponding cycles removed.
}

\author{
Andrej-Nikolai Spiess
}

\references{
Nonlinear regression analysis and its applications.\cr
Bates DM & Watts DG.\cr
Wiley, Chichester, UK, 1988.\cr
}

\seealso{
The function \code{\link{pcropt1}} which removes cycles sequentially from both sides of the curve.
}

\examples{
## which cycles have low influence
## on parameter 'c' (the lower
## asymptote)?
m1 <- pcrfit(reps, 1, 2, l4)
pcropt2(m1, which.par = "c", quan = 0.3, delete = "low")

\dontrun{
## and on 'b' and 'e'?
pcropt2(m1, which.par = c("b", "e"), quan = 0.3, delete = "low")

## very high influence on 'd'
## (upper asymptote)?
pcropt2(m1, which.par = c("d"), quan = 0.1, delete = "high") 
}
}


\keyword{models}
\keyword{nonlinear}
