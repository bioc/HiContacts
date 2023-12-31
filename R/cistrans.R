#' cisTransRatio
#' 
#' Quickly computes a cis-trans ratio of interactions. 
#'
#' @param x A `HiCExperiment` object over the full genome
#' @return a tibble, listing for each chr. the % of cis/trans interactions
#'
#' @importFrom tibble as_tibble
#' @importFrom tidyr pivot_wider
#' @importFrom dplyr rename
#' @importFrom dplyr relocate
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom dplyr mutate
#' @export
#' @examples 
#' library(HiContacts)
#' full_contacts_yeast <- contacts_yeast(full = TRUE)
#' cisTransRatio(full_contacts_yeast)

cisTransRatio <- function(x) {
    if (!is.null(focus(x))) {
        stop('Please provide a contact matrix over the entire genome. Aborting now.')
    }
    gis <- InteractionSet::interactions(x)
    gis$score <- HiCExperiment::scores(x, 'count')
    cnts <- gis |> 
        tibble::as_tibble() |> 
        dplyr::relocate(c(seqnames1, seqnames2))
    cnts_dup <- cnts |> 
        dplyr::rename(seqnames1 = seqnames2, seqnames2 = seqnames1) |> 
        dplyr::relocate(c(seqnames1, seqnames2))
    cnts <- rbind(cnts, cnts_dup)
    res <- cnts |> 
        dplyr::group_by(seqnames1, seqnames2) |> 
        dplyr::summarize(n = sum(score, na.rm = TRUE)) |> 
        dplyr::mutate(type = ifelse(seqnames1 == seqnames2, 'cis', 'trans')) |> 
        dplyr::group_by(seqnames1, type) |> 
        dplyr::rename(chr = seqnames1) |>
        dplyr::summarize(n = sum(n, na.rm = TRUE)) |> 
        tidyr::pivot_wider(names_from = type, values_from = n) |> 
        dplyr::mutate(
            n_total = sum(cis + trans, na.rm = TRUE), 
            cis_pct = cis/n_total, 
            trans_pct = trans/n_total
        )
    return(res)
}
