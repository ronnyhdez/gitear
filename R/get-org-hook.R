#' @import httr
#' @import jsonlite
#'
#' @description Get a hook
#' @title Return a hook
#' 
#' @param base_url The base URL for your gitea server (no trailing '/')
#' @param api_key The user's API token key for the gitea service
#' 
#' @param org Name of the organization
#' @param id_hook Id of the hook to get
#'
#'@export
get_org_hook <- function(base_url, api_key, org, id_hook){
    if (missing(base_url)) {
        warning("Please add a valid URL")
    } else if (missing(api_key)) {
        warning("Please add a valid API token")
    } else if (missing(org)) {
        warning("Please add a valid name of the organization")
    } else if (missing(id_hook)) {
        warning("Please add a id valid of hook")
    }else
        try({
            base_url <- sub("/$", "", base_url)
            gitea_url <- file.path(base_url, "api/v1", 
                                   sub("^/", "", "/orgs"), 
                                   org, "hooks", id_hook)
            
            authorization <- paste("token", api_key)
            r <- GET(gitea_url, add_headers(Authorization = authorization),
                     accept_json())
            
            # To convert http errors to R errors
            stop_for_status(r)
            
            content_org_hook <- content(r, as = "text")
            content_org_hook <- fromJSON(content_org_hook)
            content_org_hook <- as.data.frame(content_org_hook)
            
            return(content_org_hook)
        })
}