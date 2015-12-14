
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
    var <- paste0( "coefname:", names( object$coefficients ) )
    rank <- paste0( "numeric rank:", object$rank )
    df.residual <- paste0( "residual DF:", object$df.residual )
    date <- paste0( "date:", now() )
    return( c( name, class, var, rank, df.residual, date ) )
}

extractTags.summary.lm <- function( object, objectNameX, ... ) {  
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )  
  sigma <- paste0( "sigma:", round( object$sigma, 4 ) )
  df <- paste0( "df:", paste0( object$df, collapse = " " ) )
  r.squared <- paste0( "R^2:", round( object$r.squared, 4 ) )
  adj.r.squared <- paste0( "adjusted R^2:", round( object$adj.r.squared, 4 ) )
  f_stat <- object$fstatistic
#   f_stat[1] <- round( f_stat[1], 1 )
#   f.statistic <- paste0( "F-statistic:", paste(f_stat, c("on", "and", "DF"), collapse = " ") )
  f.statistic <- paste0( "F-statistic:",  round( f_stat[1], 1 ))
  f.statistic.df <-paste0("F-statistic DF:", f_stat[-1])
  date <- paste0( "date:", now() )
  return( c( name, class, sigma, df, r.squared,
             adj.r.squared, f.statistic, f.statistic.df, date ) )
}

extractTags.htest <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )
  method <- paste0( "method:", object$method )
  data_name <- paste0( "data.name:", object$data.name)
  n_value <- object$null.value
  n_value <- paste0("null.value:", names(n_value), "=", n_value ) 
  alt <- paste0( "alternative:", object$alternative )
  stat <- paste0("statistic:", object$statistic ) 
  param <- object$parameter
  if (!is.null(param)){
    param <- paste0("parameter:", paste0(names(param), "=", param))    
  } else {
    param <- paste0("parameter:", deparse(param))
  } 
  p_value <- paste0("p.value:", object$p.value)
  intervals <- object$conf.int
  if (!is.null(intervals)){
    intervals <- round(intervals, 6)
    intervals <- paste0(attributes(intervals)$conf.level*100, " percent conf.int.:[", intervals[1],", ", intervals[2],"]")
  } else {
    intervals <- paste0("conf.int.:", deparse(intervals))
  }
  estim <- object$estimate  
  if (!is.null(estim)){
    estim <- round(estim, 6)
    estim <- paste0("estimate:", estim)
  } else {
    estim <- paste0("estimate:", deparse(estim))
  }
  date <- paste0( "date:", now() )
  return( c( name, class, method, data_name, n_value, alt,
             stat, param, p_value, intervals, estim, date ) )
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
  LD <- object$scaling
  LD <- paste(outer(rownames(LD), colnames(LD), FUN = paste), LD, sep=":")
  svd <- paste0("svd:", round(object$svd, 3))
  date <- paste0( "date:", now() )
  return( c( name, class, N, lev, counts, prior, LD, svd, date ) )
}

extractTags.qda <- function( object, objectNameX, ... ) {
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  N <- paste0("N:", object$N)
  lev <- paste0("levels:", object$lev)
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
  objective <- paste0( "objective:", object$objective )
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, date, objective ) )
}

extractTags.glmnet <- function( object, objectNameX, ... ) {
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, date ) )
}

extractTags.survfit <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )
  n <- paste0("n:", survfit1$n)
  type <- paste0("type:", survfit1$type)
  conf_type <- paste0("conf.type:", survfit1$conf.type)
  conf_int <- paste0("conf.int:", survfit1$conf.int)  
  strata <- object$strata
  strata <- paste0( "strata:", ifelse(!is.null(strata), strata, deparse(strata)))                  
  date <- paste0( "date:", now() )
  return( c( name, class, n, type, conf_type, conf_int, strata, date ) )
}
