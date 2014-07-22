getBitLy <- function(url, mytoken, escape=TRUE) {
  if (escape)
      url <- curlEscape(url)
  resp <- GET(paste0(
    "https://api-ssl.bitly.com/v3/shorten?access_token=", mytoken, 
    "&longUrl=",url))
  resparsed <- fromJSON(rawToChar(resp$content))
  list(status = resparsed$status_txt,
                bitly = resparsed$data$url)
}

