
extractTags <- function ( object, objectNameX, ... )
  UseMethod("extractTags")

extractTags.default <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )
  date <- paste0( "date:", now() )
  return( c( name, class, date ) )
}

extractTags.data.frame <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )
  var <- unique( paste0( "varname:", c( colnames( object ) ) ) )
  date <- paste0( "date:", now() )
  return( c( name, class, var, date ) )
}

extractTags.ggplot <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )
  labx <- paste0( "labelx:", object$labels$x )
  laby <- paste0( "labely:", object$labels$y )
  date <- paste0( "date:", now() )
  return( c( name, class, labx, laby, date ) )
}

extractTags.trellis <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )
  date <- paste0( "date:", now() )
  return( c( name, class, date ) )
}

extractTags.lm <- function( object, objectNameX, ... ) {  
    name <- paste0( "name:", objectNameX )
    class <- paste0( "class:", class( object ) )
    coefname <- paste0( "coefname:", names( object$coefficients ) )
    rank <- paste0( "rank:", object$rank )
    df.residual <- paste0( "df.residual:", object$df.residual )
    date <- paste0( "date:", now() )
    return( c( name, class, coefname, rank, df.residual, date ) )
}

extractTags.summary.lm <- function( object, objectNameX, ... ) {  
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )  
  sigma <- paste0( "sigma:", round( object$sigma, 4 ) )
  df <- paste0( "df:", object$df )
  r.squared <- paste0( "R^2:", round( object$r.squared, 4 ) )
  adj.r.squared <- paste0( "adjusted R^2:", round( object$adj.r.squared, 4 ) )
  fstat <- object$fstatistic
  fstatistic <- paste0( "fstatistic:",  round( fstat[1], 1 ))
  fstatistic.df <- paste0("fstatistic.df:", fstat[-1])
  date <- paste0( "date:", now() )
  return( c( name, class, sigma, df, r.squared,
             adj.r.squared, fstatistic, fstatistic.df, date ) )
}

extractTags.htest <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )
  method <- paste0( "method:", object$method )
  data.name <- paste0( "data.name:", object$data.name)
  null.value <- object$null.value
  null.value <- paste0("null.value:", names(null.value), "=", null.value ) 
  alternative <- paste0( "alternative:", object$alternative )
  statistic <- paste0("statistic:", object$statistic ) 
  parameter <- object$parameter
  if (!is.null(parameter)){
    parameter <- paste0("parameter:", paste0(names(parameter), "=", parameter))    
  } else {
    parameter <- paste0("parameter:", deparse(parameter))
  } 
  p.value <- paste0("p.value:", object$p.value)
  intervals <- object$conf.int
  if (!is.null(intervals)){
    intervals <- round(intervals, 6)
    intervals <- paste0(attributes(intervals)$conf.level*100, " percent conf.int.:[", intervals[1],", ", intervals[2],"]")
  } else {
    intervals <- paste0("conf.int.:", deparse(intervals))
  }
  estimate <- object$estimate  
  if (!is.null(estimate)){
    estimate <- round(estimate, 6)
    estimate <- paste0("estimate:", estimate)
  } else {
    estimate <- paste0("estimate:", deparse(estimate))
  }
  date <- paste0( "date:", now() )
  return( c( name, class, method, data.name, null.value, alternative,
             statistic, parameter, p.value, intervals, estimate, date ) )
}

extractTags.lda <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )
  N <- paste0("N:", object$N)
  lev <- paste0("lev:", object$lev)
  counts <- object$counts
  counts <- paste0("counts_", names(counts),":", counts)
  prior <- round(object$prior, 3)
  prior <- paste0("prior_", names(prior), ":", prior)
  svd <- paste0("svd:", round(object$svd, 3))
  date <- paste0( "date:", now() )
  return( c( name, class, N, lev, counts, prior, svd, date ) )
}

extractTags.qda <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )
  N <- paste0("N:", object$N)
  lev <- paste0("lev:", object$lev)
  counts <- object$counts
  counts <- paste0("counts_", names(counts),":", counts)
  prior <- round(object$prior, 3)
  prior <- paste0("prior_", names(prior), ":", prior)
  ldet <- paste0("ldet:", object$ldet)
  terms <- object$terms
  terms <- paste0( "terms:", ifelse(!is.null(terms), terms, deparse(terms)))                  
  date <- paste0( "date:", now() )
  return( c( name, class, N, lev, counts, prior, ldet, terms, date ) )
}

extractTags.twins <- function( object, objectNameX, ... ) {
  ac <- paste0( "ac:", object$ac)
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, date, ac ) )
}

extractTags.partition <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )
  memb.exp <- paste0("memb.exp:", object$memb.exp)
  coeff <- paste0(c("dunn_coeff:", "normalized dunn_coeff:"), object$coeff)
  k.crisp <- paste0("k.crisp:", object$k.crisp)
  objective <- paste0(c("objective:", "tolerance:"), object$objective)
  conv <- object$convergence
  conv <- paste(names(conv), conv, sep=":")
  silinfo <- object$silinfo
  clus.avg.widths <- paste0('clus.avg.widths:', silinfo[[2]])
  avg.width <- paste0('avg.width:', silinfo[[3]])
  date <- paste0( "date:", now() )
  return( c( name, class, memb.exp, coeff, k.crisp,
             objective, conv, clus.avg.widths, avg.width, date) )
}

extractTags.glmnet <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )  
  dim <- paste0("dim:", object$dim)
  nulldev <- paste0("nulldev:", object$nulldev)
  npasses <- paste0("npasses:", object$npasses)
  offset <- paste0("offset:", object$offset)
  nobs <- paste0("nobs:",object$nobs)  
  date <- paste0( "date:", now() )
  return( c( name, class, dim, nulldev, npasses, offset, nobs, date ) )
}

extractTags.survfit <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )
  n <- paste0("n:", object$n)
  type <- paste0("type:", object$type)
  conf.type <- paste0("conf.type:", object$conf.type)
  conf.int <- paste0("conf.int:", object$conf.int)  
  strata <- object$strata
  strata <- paste0( "strata:", ifelse(!is.null(strata), strata, deparse(strata)))                  
  date <- paste0( "date:", now() )
  return( c( name, class, n, type, conf.type, conf.int, strata, date ) )
}
