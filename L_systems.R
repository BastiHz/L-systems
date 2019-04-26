L_system <- function(axiom, rules, n, all = FALSE) {
    symbols <- strsplit(axiom, "")[[1]]
    rules <- lapply(rules, function(r) strsplit(r, "")[[1]])
    if (all) result <- list()
    for (i in seq_len(n)) {
        new_symbols <- c()
        for (char in symbols) {
            new_char <- rules[[char]]
            if (is.null(new_char)) {
                new_char <- char
            }
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


plot_L_system <- function(string, turn_angle) {
    # FIXME: This function was hastily thrown together and is rather inefficient.

    # F: forward
    # -: left
    # +: right
    # [: save
    # ]: load

    # turn_angle must be in radians

    x <- y <- 0
    direction <- pi/2  # 0 = right, pi/2 = up, pi = right, pi*3/2 = down
    position_x_storage <- c()
    position_y_storage <- c()
    direction_storage <- c()
    saved_lines <- list()
    current_line_x <- x
    current_line_y <- y
    range_x <- range(x)
    range_y <- range(y)

    symbols <- strsplit(string, "")[[1]]
    for (char in symbols) {
        if (char == "F") {
            x <- x + cos(direction)
            y <- y + sin(direction)
            current_line_x <- c(current_line_x, x)
            current_line_y <- c(current_line_y, y)
            range_x <- range(range_x, x)
            range_y <- range(range_y, y)
        } else if (char == "-") {
            direction <- direction + turn_angle
        } else if (char == "+") {
            direction <- direction - turn_angle
        } else if (char == "[") {
            # save position and direction
            position_x_storage <- c(position_x_storage, x)
            position_y_storage <- c(position_y_storage, y)
            direction_storage <- c(direction_storage, direction)
        } else if (char == "]") {
            # load position and direction
            saved_lines[[length(saved_lines) + 1]] <- list(
                x = current_line_x,
                y = current_line_y
            )
            x <- tail(position_x_storage, 1)
            position_x_storage <- head(position_x_storage, -1)
            y <- tail(position_y_storage, 1)
            position_y_storage <- head(position_y_storage, -1)
            current_line_x <- x
            current_line_y <- y
            direction <- tail(direction_storage, 1)
            direction_storage <- head(direction_storage, -1)
        }
    }
    saved_lines[[length(saved_lines) + 1]] <- list(
        x = current_line_x,
        y = current_line_y
    )

    plot(NA, NA, xlim = range_x, ylim = range_y, asp = 1)
    for (line in saved_lines) {
        lines(line$x, line$y)
    }
    invisible(saved_lines)
}



a <- "X"
r <- list(
    "X" = "F+[[X]-X]-F[-FX]+X",
    "F" = "FF"
)
# r <- list(
#     "X" = "X+YF+",
#     "Y" = "-FX-Y"
# )
angle <- 25 / 180 * pi
# angle <- pi/2
L_system(a, r, 2)

plot_L_system(L_system(a, r, 10), angle)

# TODO: Improve efficiency

