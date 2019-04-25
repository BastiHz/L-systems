L_system <- function(axiom, rules, n, all = FALSE) {
    symbols = strsplit(axiom, "")[[1]]
    rules <- lapply(rules, function(r) strsplit(r, "")[[1]])
    if (all) result <- list()
    for (i in seq_len(n)) {
        new_symbols = c()
        for (char in symbols) {
            new_char = rules[[char]]
            if (is.null(new_char)) next
            new_symbols <- c(new_symbols, new_char)
        }
        symbols <- new_symbols
        if (all) result[[i]] <- symbols
    }
    if (all) {
        return(lapply(result, paste0, collapse = ""))
    } else {
        return(paste0(symbols, collapse = ""))
    }
}

a = "A"
r = list(
    A = "ABA",
    B = "BBB"
)

L_system(a, r, 4)
L_system(a, r, 4, TRUE)


