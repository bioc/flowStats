% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SimulateMixture.R
\name{SimulateMixture}
\alias{SimulateMixture}
\title{Random Generation from a t Mixture Model with Box-Cox Transformation}
\usage{
SimulateMixture(N, w, mu, sigma, nu = 4, lambda)
}
\arguments{
\item{N}{The number of observations.}

\item{w}{A vector of length \eqn{K}, containing the \eqn{K} cluster
proportions.}

\item{mu}{A matrix of size \eqn{K \times P}{K x P}, where \eqn{K} is the
number of clusters and \eqn{P} is the dimension, containing the \eqn{K} mean
vectors.}

\item{sigma}{An array of dimension \eqn{K \times P \times P}{K x P x P},
containing the \eqn{K} covariance matrices.}

\item{nu}{The degrees of freedom used for the \eqn{t} distribution.}

\item{lambda}{The Box-Cox transformation parameter.  If missing, the
conventional \eqn{t} distribution without transformation will be used.}
}
\value{
A matrix of size \eqn{N \times P}{N x P}.
}
\description{
This function can be used to generate a sample from a multivariate \eqn{t}
mixture model with Box-Cox transformation.
}
\examples{
### Number of components
K <- 5
### Dimension
p <- 2
### Number of observations
n <- 200
Mu <- matrix(runif(K*p, 0, 20), K, p)
Sigma <- array(0, c(K, p, p))

for (k in 1:K)
{
    Sigma[k,,][outer(1:p, 1:p, ">")] <- runif(p*(p-1)/2,-.1,.1)
    diag(Sigma[k,,]) <- runif(p,0,1)
    ### Make sigma positive definite
    Sigma[k,,] <- Sigma[k,,] \%*\% t(Sigma[k,,])
}

### Generate the weights
w <- rgamma(K,10,1)
w <- w/sum(w)

y <- SimulateMixture(n, w, Mu, Sigma, nu=4)
}
\seealso{
\code{\link{flowClust}}
}
\author{
Raphael Gottardo <\email{raph@stat.ubc.ca}>, Kenneth Lo
<\email{c.lo@stat.ubc.ca}>
}
\keyword{datagen}
