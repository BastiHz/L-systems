L_system <- function(axiom, rules, n, all = FALSE) {
    symbols <- strsplit(axiom, "")[[1]]
    rules <- lapply(rules, function(r) strsplit(r, "")[[1]])
    if (all) result <- list()
    for (i in seq_len(n)) {
        new_symbols <- c()
        for (char in symbols) {
            new_char <- rules[[char]]
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

a <- "X"
r <- list(
    X = "F+[[X]-X]-F[-FX]+X",
    F = "FF"
)

L_system(a, r, 4)
L_system(a, r, 4, TRUE)


# TODO: Funktion zum plotten schreiben.


plot_L_system <- function(string, turn_angle) {
    # F: forward
    # -: left
    # +: right
    # [: save
    # ]: load

    # turn_angle must be in radians

    x <- y <- 0
    direction <- 0  # 0 = right, pi/2 = up, pi = right, pi*3/2 = down

    symbols <- strsplit(string, "")[[1]]
    for (char in symbols) {
        if (char == "F") {
            x <- x + cos(direction)
            y <- y + sin(direction)
        } else if (char == "-") {
            direction <- direction + turn_angle
        } else if (char == "+") {
            direction <- direction - turn_angle
        } else if (char == "[") {
            # save position and direction
        } else if (char == "]") {
            # load position and direction
        }
    }

}
