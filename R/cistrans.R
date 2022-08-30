#' cis_trans
#'
#' @param x x
#'
#' @importFrom tibble as_tibble
#' @importFrom tidyr pivot_wider
#' @importFrom dplyr rename
#' @importFrom dplyr relocate
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom dplyr mutate
#' @export

cis_trans <- function(x) {
    if (!is.null(focus(x))) {
        stop('Please provide a contact matrix over the entire genome. Aborting now.')
    }
    cnts <- assay(x, 'raw') %>% 
        tibble::as_tibble() %>% 
        dplyr::relocate(c(seqnames1, seqnames2))
    cnts_dup <- cnts %>% 
        dplyr::rename(seqnames1 = seqnames2, seqnames2 = seqnames1) %>% 
        dplyr::relocate(c(seqnames1, seqnames2))
    cnts <- rbind(cnts, cnts_dup)
    res <- cnts %>% 
        dplyr::group_by(seqnames1, seqnames2) %>% 
        dplyr::summarize(n = sum(score)) %>% 
        dplyr::mutate(type = ifelse(seqnames1 == seqnames2, 'cis', 'trans')) %>% 
        dplyr::group_by(seqnames1, type) %>% 
        dplyr::rename(chr = seqnames1) %>%
        dplyr::summarize(n = sum(n)) %>% 
        tidyr::pivot_wider(names_from = type, values_from = n) %>% 
        dplyr::mutate(
            n_total = sum(cis + trans), 
            cis_pct = cis/n_total, 
            trans_pct = trans/n_total
        )
    return(res)
}