##    archivist package for R
##
#' @title Tags 
#'
#' @description
#' \code{Tags} are attributes of an artifact, i.e., a class, a name, names of artifact's parts, etc.. 
#' The list of artifact tags vary across artifact's classes. 
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' 
#' \code{Tags} are attributes of an artifact. \code{Tags} can be an artifact's \code{name}, \code{class} or \code{archiving date}. 
#' Furthermore, for various artifact's classes more different \code{Tags} are available and can 
#' be searched in \link{searchInLocalRepo} or \link{searchInGithubRepo} functions. 
#' 
#' \code{Tags} are stored in the \link{Repository}. If data is extracted from artifact a special \code{Tag}
#' named \code{relationWith} is created, and specifies with which artifact this data is related to.
#' 
#' So far supported artifact list is presented below. Objects are divided thematically.
#' The newest list is also available on \pkg{archivist} \code{wiki} on 
#' \href{https://github.com/pbiecek/archivist/wiki/archivist-package---Tags}{{Github}}.
#' 
#' Regression Models
#' 
#' \describe{
#'   \item{\code{lm}}{
#'   \itemize{
#'      \item coefname
#'      \item class
#'      \item name
#'      \item date
#'   }
#'   }
#'   \item{\code{glmnet}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'   }
#'   }
#'   \item{\code{survfit}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'      \item strata
#'      \item type
#'   }
#'   }
#' }
#' Plots
#' 
#' \describe{
#'   \item{\code{ggplot}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item date
#'      \item labelx
#'      \item labely
#'   }
#'   }
#'   \item{\code{trellis}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'   }
#'   } 
#' }
#' Results of Agglomeration Methods
#' 
#' \describe{
#' \item{\code{twins which is a result of agnes, diana or mona functions}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'      \item ac
#'   }
#'   }
#'   \item{\code{partition which is a result of pam, clara or fanny functions}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'      \item objective
#'   }
#'   }
#'   \item{\code{lda}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'   }
#'   }
#'   \item{\code{qda}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'      \item terms
#'   }
#'   }
#' }
#' Statistical Tests
#' 
#' \describe{
#'   \item{\code{htest}}{
#'   \itemize{
#'      \item alternative
#'      \item method
#'      \item date
#'      \item name
#'      \item class
#'   }
#'   }
#' }
#' 
#' When non of above is specified, tags are corresponded by default
#' 
#' \describe{
#'   \item{\code{default}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item date
#'   }
#'   }
#'   \item{\code{data.frame}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item date
#'      \item varname
#'   }
#'   }
#'   }
#' 
#' @seealso 
#' Functions using \code{Tags} are:
#'  \itemize{
#'    \item \link{searchInLocalRepo},
#'    \item \link{searchInGithubRepo}. 
#'  }
#' 
#' @note One can specify his own \code{Tags} for artifacts by setting artifact's attribute 
#' before call of the \code{saveToRepo} function like this: 
#' \code{attr(x, "tags" ) = c( "name1", "name2" )}, where \code{x} is artifact 
#' and \code{name1, name2} are \code{Tags} specified by an user.
#' 
#' @examples
#' 
#' # examples
#' \dontrun{
#' # data.frame object
#' data(iris)
#' exampleRepoDir <- tempdir()
#' createEmptyRepo(repoDir = exampleRepoDir)
#' saveToRepo( iris, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteRepo( exampleRepoDir )
#' 
#' # ggplot/gg object
#' library(ggplot2)
#' df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),y = rnorm(30))
#' library(plyr)
#' ds <- ddply(df, .(gp), summarise, mean = mean(y), sd = sd(y))
#' myplot123 <- ggplot(df, aes(x = gp, y = y)) +
#'   geom_point() +  geom_point(data = ds, aes(y = mean),
#'                              colour = 'red', size = 3)
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( myplot123, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteRepo( exampleRepoDir )
#' 
#' # lm object
#' model <- lm(Sepal.Length~ Sepal.Width + Petal.Length + Petal.Width, 
#'            data= iris)
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( model, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteRepo( exampleRepoDir )
#' 
#' # agnes (twins) object
#' library(cluster)
#' data(votes.repub)
#' agn1 <- agnes(votes.repub, metric = "manhattan", stand = TRUE)
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( agn1, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteRepo( exampleRepoDir )
#' 
#' # fanny (partition) object
#' x <- rbind(cbind(rnorm(10, 0, 0.5), rnorm(10, 0, 0.5)),
#'           cbind(rnorm(15, 5, 0.5), rnorm(15, 5, 0.5)),
#'           cbind(rnorm( 3,3.2,0.5), rnorm( 3,3.2,0.5)))
#' fannyx <- fanny(x, 2)
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( fannyx, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteRepo( exampleRepoDir )
#' 
#' # lda object
#' library(MASS)
#' 
#' Iris <- data.frame(rbind(iris3[,,1], iris3[,,2], iris3[,,3]),
#'                    Sp = rep(c("s","c","v"), rep(50,3)))
#' train <- c(8,83,115,118,146,82,76,9,70,139,85,59,78,143,68,
#'            134,148,12,141,101,144,114,41,95,61,128,2,42,37,
#'            29,77,20,44,98,74,32,27,11,49,52,111,55,48,33,38,
#'            113,126,24,104,3,66,81,31,39,26,123,18,108,73,50,
#'            56,54,65,135,84,112,131,60,102,14,120,117,53,138,5)
#' lda1 <- lda(Sp ~ ., Iris, prior = c(1,1,1)/3, subset = train)
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( lda1, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteRepo( exampleRepoDir )
#' 
#' # qda object
#' tr <- c(7,38,47,43,20,37,44,22,46,49,50,19,4,32,12,29,27,34,2,1,17,13,3,35,36)
#' train <- rbind(iris3[tr,,1], iris3[tr,,2], iris3[tr,,3])
#' cl <- factor(c(rep("s",25), rep("c",25), rep("v",25)))
#' qda1 <- qda(train, cl)
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( qda1, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteRepo( exampleRepoDir )
#' 
#' 
#' # glmnet object
#' library( glmnet )
#' 
#' zk=matrix(rnorm(100*20),100,20)
#' bk=rnorm(100)
#' glmnet1=glmnet(zk,bk)
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( glmnet1, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteRepo( exampleRepoDir )
#' 
#' # trellis object
#' require(stats)
#' library( lattice)
#' ## Tonga Trench Earthquakes
#' 
#' Depth <- equal.count(quakes$depth, number=8, overlap=.1)
#' xyplot(lat ~ long | Depth, data = quakes)
#' update(trellis.last.object(),
#'        strip = strip.custom(strip.names = TRUE, strip.levels = TRUE),
#'        par.strip.text = list(cex = 0.75),
#'        aspect = "iso")
#' 
#' ## Examples with data from `Visualizing Data' (Cleveland, 1993) obtained
#' ## from http://cm.bell-labs.com/cm/ms/departments/sia/wsc/
#' 
#' EE <- equal.count(ethanol$E, number=9, overlap=1/4)
#' 
#' ## Constructing panel functions on the fly; prepanel
#' trellis.plot <- xyplot(NOx ~ C | EE, data = ethanol,
#'                        prepanel = function(x, y) prepanel.loess(x, y, span = 1),
#'                        xlab = "Compression Ratio", ylab = "NOx (micrograms/J)",
#'                        panel = function(x, y) {
#'                          panel.grid(h = -1, v = 2)
#'                          panel.xyplot(x, y)
#'                          panel.loess(x, y, span=1)
#'                        },
#'                        aspect = "xy")
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( trellis.plot, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteRepo( exampleRepoDir )
#' 
#' # htest object
#' 
#' x <- c(1.83,  0.50,  1.62,  2.48, 1.68, 1.88, 1.55, 3.06, 1.30)
#' y <- c(0.878, 0.647, 0.598, 2.05, 1.06, 1.29, 1.06, 3.14, 1.29)
#' this.test <- wilcox.test(x, y, paired = TRUE, alternative = "greater")
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( this.test, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteRepo( exampleRepoDir )
#' 
#' # survfit object
#' library( survival )
#' # Create the simplest test data set 
#' test1 <- list(time=c(4,3,1,1,2,2,3), 
#'               status=c(1,1,1,0,1,1,0), 
#'              x=c(0,2,1,1,1,0,0), 
#'              sex=c(0,0,0,0,1,1,1)) 
#' # Fit a stratified model 
#' myFit <-  survfit( coxph(Surv(time, status) ~ x + strata(sex), test1), data = test1  )
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( myFit , repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )[,-3]
#' deleteRepo( exampleRepoDir )
#' 
#' # origin of the artifacts stored as a name - chaining code
#' library(dplyr)
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' data("hflights", package = "hflights")
#' hflights %>%
#'   group_by(Year, Month, DayofMonth) %>%
#'   select(Year:DayofMonth, ArrDelay, DepDelay) %>%
#'   saveToRepo( exampleRepoDir, chain = TRUE ) %>%
#'   # here the artifact is stored but chaining is not finished
#'   summarise(
#'     arr = mean(ArrDelay, na.rm = TRUE),
#'     dep = mean(DepDelay, na.rm = TRUE)
#'   ) %>%
#'   filter(arr > 30 | dep > 30) %>%
#'   saveToRepo( exampleRepoDir ) 
#'   # chaining code is finished and after last operation the 
#'   # artifact is stored
#' showLocalRepo( exampleRepoDir, "tags" )[,-3]
#' showLocalRepo( exampleRepoDir )
#' deleteRepo( exampleRepoDir )
#' 
#' rm( exampleRepoDir )
#' }
#' @family archivist
#' @name Tags
#' @docType class
invisible(NULL)