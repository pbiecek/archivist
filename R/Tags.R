##    archivist package for R
##
#' @title Tags 
#'
#' @description
#' \code{Tags} are attributes of an artifact, i.e., a class, a name, names of artifact's parts, etc... 
#' The list of artifact tags vary across artifact's classes. 
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' 
#' \code{Tags} are attributes of an artifact. They can be the artifact's \code{name},
#' \code{class} or \code{archiving date}. Furthermore, for various artifact's classes 
#' more different \code{Tags} are available. 
#' 
#' A \code{Tag} is represented as a string and usually has the following structure
#' \code{"TagKey:TagValue"}, e.g., \code{"name:iris"}.
#' 
#' \code{Tags} are stored in the \link{Repository}. If data is extracted from an artifact
#' then a special \code{Tag}, named \code{relationWith} is created.
#' It specifies with which artifact this data is related to.
#' 
#' The list of supported artifacts which are divided thematically is presented below.
#' The newest list is also available on \pkg{archivist} \code{wiki} on 
#' \href{https://github.com/pbiecek/archivist/wiki/archivist-package---Tags}{{Github}}.
#' 
#' Regression Models
#' 
#' \describe{
#'   \item{\code{lm}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item coefname
#'      \item rank
#'      \item df.residual
#'      \item date
#'   }
#'   }
#'   \item{\code{summary.lm}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item sigma
#'      \item df
#'      \item r.squared
#'      \item adj.r.squared
#'      \item fstatistic
#'      \item fstatistic.df
#'      \item date
#'   }
#'   }
#'   \item{\code{glmnet}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item dim
#'      \item nulldev
#'      \item npasses
#'      \item offset
#'      \item nobs
#'      \item date
#'   }
#'   }
#'   \item{\code{survfit}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item n
#'      \item type
#'      \item conf.type
#'      \item conf.int
#'      \item strata
#'      \item date
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
#'      \item name
#'      \item class
#'      \item memb.exp
#'      \item dunn_coeff
#'      \item normalized dunn_coeff
#'      \item k.crisp
#'      \item objective
#'      \item tolerance
#'      \item iterations
#'      \item converged
#'      \item maxit
#'      \item clus.avg.widths
#'      \item avg.width
#'      \item date
#'   }
#'   }
#'   \item{\code{lda}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item N
#'      \item lev
#'      \item counts
#'      \item prior
#'      \item svd
#'      \item date
#'   }
#'   }
#'   \item{\code{qda}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item N
#'      \item lev
#'      \item counts
#'      \item prior
#'      \item ldet
#'      \item terms
#'      \item date
#'   }
#'   }
#' }
#' Statistical Tests
#' 
#' \describe{
#'   \item{\code{htest}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item method
#'      \item data.name
#'      \item null.value
#'      \item alternative
#'      \item statistic
#'      \item parameter
#'      \item p.value
#'      \item conf.int.
#'      \item estimate
#'      \item date
#'   }
#'   }
#' }
#' 
#' When none of above is specified, Tags are assigned by default
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
#'    \item \link{addTagsRepo}
#'    \item \link{getTagsLocal}
#'    \item \link{getTagsRemote}
#'    \item \link{saveToLocalRepo}
#'    \item \link{searchInLocalRepo},
#'    \item \link{searchInRemoteRepo}. 
#'  }
#' 
#' @note 
#' In the following way one can specify his own \code{Tags} for artifacts by 
#' setting artifact's attribute before call of the \code{saveToLocalRepo} function: 
#' \code{attr(x, "tags" ) = c( "name1", "name2" )}, where \code{x} is an artifact 
#' and \code{name1, name2} are \code{Tags} specified by a user.
#' It can be also done in a new, simpler way by using \code{userTags} parameter like this: 
#'  \itemize{
#'    \item \code{saveToLocalRepo(model, repoDir, userTags = c("my_model", "do not delete"))}.
#'  }
#'  Specifing additional \code{Tags} by attributes can be beneficial when one uses \link{addHooksToPrint}.
#' 
#' @examples
#' 
#' \dontrun{
#' # examples
#' # data.frame object
#' data(iris)
#' exampleRepoDir <- tempfile()
#' createLocalRepo(repoDir = exampleRepoDir)
#' saveToLocalRepo( iris, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteLocalRepo( exampleRepoDir, deleteRoot=TRUE )
#' 
#' # ggplot/gg object
#' library(ggplot2)
#' df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),y = rnorm(30))
#' library(plyr)
#' ds <- ddply(df, .(gp), summarise, mean = mean(y), sd = sd(y))
#' myplot123 <- ggplot(df, aes(x = gp, y = y)) +
#'   geom_point() +  geom_point(data = ds, aes(y = mean),
#'                              colour = 'red', size = 3)
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir )
#' saveToLocalRepo( myplot123, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteLocalRepo( exampleRepoDir, deleteRoot=TRUE )
#' 
#' # lm object
#' model <- lm(Sepal.Length~ Sepal.Width + Petal.Length + Petal.Width, 
#'            data= iris)
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir )
#' asave( model, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteLocalRepo( exampleRepoDir, TRUE )
#' 
#' # agnes (twins) object
#' library(cluster)
#' data(votes.repub)
#' agn1 <- agnes(votes.repub, metric = "manhattan", stand = TRUE)
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir )
#' saveToLocalRepo( agn1, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteLocalRepo( exampleRepoDir, TRUE )
#' 
#' # fanny (partition) object
#' x <- rbind(cbind(rnorm(10, 0, 0.5), rnorm(10, 0, 0.5)),
#'           cbind(rnorm(15, 5, 0.5), rnorm(15, 5, 0.5)),
#'           cbind(rnorm( 3,3.2,0.5), rnorm( 3,3.2,0.5)))
#' fannyx <- fanny(x, 2)
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir )
#' saveToLocalRepo( fannyx, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteLocalRepo( exampleRepoDir, TRUE )
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
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir )
#' asave( lda1, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteLocalRepo( exampleRepoDir, TRUE )
#' 
#' # qda object
#' tr <- c(7,38,47,43,20,37,44,22,46,49,50,19,4,32,12,29,27,34,2,1,17,13,3,35,36)
#' train <- rbind(iris3[tr,,1], iris3[tr,,2], iris3[tr,,3])
#' cl <- factor(c(rep("s",25), rep("c",25), rep("v",25)))
#' qda1 <- qda(train, cl)
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir )
#' saveToLocalRepo( qda1, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteLocalRepo( exampleRepoDir, TRUE )
#' 
#' 
#' # glmnet object
#' library( glmnet )
#' 
#' zk=matrix(rnorm(100*20),100,20)
#' bk=rnorm(100)
#' glmnet1=glmnet(zk,bk)
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir )
#' saveToLocalRepo( glmnet1, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteLocalRepo( exampleRepoDir, TRUE )
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
#' ## Constructing panel functions on the run; prepanel
#' trellis.plot <- xyplot(NOx ~ C | EE, data = ethanol,
#'                        prepanel = function(x, y) prepanel.loess(x, y, span = 1),
#'                        xlab = "Compression Ratio", ylab = "NOx (micrograms/J)",
#'                        panel = function(x, y) {
#'                          panel.grid(h = -1, v = 2)
#'                          panel.xyplot(x, y)
#'                          panel.loess(x, y, span=1)
#'                        },
#'                        aspect = "xy")
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir )
#' saveToLocalRepo( trellis.plot, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteLocalRepo( exampleRepoDir, TRUE )
#' 
#' # htest object
#' 
#' x <- c(1.83,  0.50,  1.62,  2.48, 1.68, 1.88, 1.55, 3.06, 1.30)
#' y <- c(0.878, 0.647, 0.598, 2.05, 1.06, 1.29, 1.06, 3.14, 1.29)
#' this.test <- wilcox.test(x, y, paired = TRUE, alternative = "greater")
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir )
#' saveToLocalRepo( this.test, repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )
#' deleteLocalRepo( exampleRepoDir, TRUE )
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
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir )
#' saveToLocalRepo( myFit , repoDir=exampleRepoDir )
#' showLocalRepo( exampleRepoDir, "tags" )[,-3]
#' deleteLocalRepo( exampleRepoDir, TRUE)
#' 
#' # origin of the artifacts stored as a name - chaining code
#' library(dplyr)
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir )
#' data("hflights", package = "hflights")
#' hflights %>%
#'   group_by(Year, Month, DayofMonth) %>%
#'   select(Year:DayofMonth, ArrDelay, DepDelay) %>%
#'   saveToLocalRepo( exampleRepoDir, value = TRUE ) %>%
#'   # here the artifact is stored but chaining is not finished
#'   summarise(
#'     arr = mean(ArrDelay, na.rm = TRUE),
#'     dep = mean(DepDelay, na.rm = TRUE)
#'   ) %>%
#'   filter(arr > 30 | dep > 30) %>%
#'   saveToLocalRepo( exampleRepoDir ) 
#'   # chaining code is finished and after last operation the 
#'   # artifact is stored
#' showLocalRepo( exampleRepoDir, "tags" )[,-3]
#' showLocalRepo( exampleRepoDir )
#' deleteLocalRepo( exampleRepoDir, TRUE)
#' 
#' rm( exampleRepoDir )
#' }
#' @family archivist
#' @name Tags
#' @docType class
invisible(NULL)
