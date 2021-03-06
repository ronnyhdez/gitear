#' @import httr
#' @import jsonlite
#'
#' @description Returns list the current user's organizations
#' @title Returns the organizations of the user
#' 
#' @param base_url The base URL for your gitea server (no trailing '/')
#' @param api_key The user's API token key for the gitea service
#'
#'@export
get_organizations <- function(base_url, api_key){
    if (missing(base_url)) {
        warning("Please add a valid URL")
    } else if (missing(api_key)) {
        warning("Please add a valid API token")
    } else
        try({
            base_url <- sub("/$", "", base_url)
            gitea_url <- file.path(base_url, "api/v1", 
                                   sub("^/", "", "/user/orgs"))
            
            authorization <- paste("token", api_key)
            r <- GET(gitea_url, add_headers(Authorization = authorization),
                     accept_json())
            
            # To convert http errors to R errors
            stop_for_status(r)

            content_organizations <- content(r, as = "text")
            content_organizations <- fromJSON(content_organizations)
            
            return(content_organizations)
        })
}