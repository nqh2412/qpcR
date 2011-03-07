\name{Rsq.ad}
\alias{Rsq.ad}

\title{Adjusted R-square value of a fitted model}

\description{
Calculates the adjusted R-square value for objects of class \code{nls}, \code{lm}, \code{glm}, \code{drc}
 or any other models from which \code{\link{fitted}}, \code{\link{residuals}} and \code{\link{coef}} can be extracted.
}

\usage{
Rsq.ad(object)
}

\arguments{
  \item{object}{a fitted model.}
 }

\value{
The adjusted R-square value of the fit.
}

\details{
Calculates the adjusted \eqn{R^2} by \deqn{R_{adj}^2 = 1 - \frac{n - 1}{n - p} \cdot (1 - R^2)}
 with n = sample size, p = number of parameters and \eqn{R^2} = R-square value.
}

\author{
Andrej-Nikolai Spiess
}


\examples{
## single model
m1 <- pcrfit(reps, 1, 2, l5)
Rsq.ad(m1)

## compare different models with increasing
## number of parameters
ml1 <- lapply(list(l3, l4, l5), function(x) pcrfit(reps, 1, 2, x))
sapply(ml1, function(x) Rsq.ad(x)) 
}

\keyword{models}
\keyword{nonlinear}
