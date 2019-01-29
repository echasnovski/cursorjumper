#' Jump over predefined barrier strings
#'
#' @details Execute this function to perform jump in [active document
#' context][rstudioapi::getActiveDocumentContext()]. It means that cursor
#' movement will be done in both source and console panels.
#'
#' Jump is done if any [set barrier strings][set_barrier_strings()] is found to
#' the right of the current cursor position (on the current line). If multiple
#' barrier strings are found then the first one is said "to be detected". After
#' that cursor is moved right after the detected barrier.
#'
#' **Note** that this function is usually helpful if binded to a keyboard
#' shortcut.
#'
#' @return Returns `TRUE` if there were no errors.
#'
#' @export
jump <- function() {
  cont <- rstudioapi::getActiveDocumentContext()

  barrier_strings <- get_barrier_strings()

  right_line <- get_right_line(context = cont)
  is_barrier_detected <- startsWith(x = right_line, prefix = barrier_strings)

  if (any(is_barrier_detected)) {
    # If there are several matches, the first one is used
    barrier_id <- which(is_barrier_detected)[1]

    execute_jump(context = cont, len = nchar(barrier_strings[barrier_id]))
  }

  TRUE
}

get_right_line <- function(context) {
  cur_pos <- get_position(context)
  cur_line <- context$contents[cur_pos[1]]

  substr(x = cur_line, start = cur_pos[2], stop = nchar(cur_line))
}

execute_jump <- function(context, len) {
  cur_pos <- get_position(context)
  new_pos <- cur_pos
  new_pos[2] <- new_pos[2] + len

  rstudioapi::setCursorPosition(position = new_pos)
}

get_position <- function(context) {
  context$selection[[1]]$range$end
}

#' Get and set barrier strings
#'
#' These functions get and set 'cursorjumper' barrier strings which will be used
#' in [jump()] for a decision making whether to perform a jump.
#'
#' @param barrier_strings A character vector for barrier strings (there should
#'   be no empty strings) or `NULL` (to reset to default values).
#'
#' @details **Note** that symbols in `barrier_strings` shouldn't be explicitly
#' escaped, i.e. they should be in the form present in RStudio.
#'
#' @return `set_barrier_strings()` returns call to [options()] after setting
#'   barrier strings. `get_barrier_strings()` returns currently set barrier
#'   strings (if nothing was set explicitly, it returns [default barrier
#'   strings][default_barrier_strings]).
#'
#' @examples
#' \dontrun{
#' # If nothing is set, it returns default barriers
#' barriers <- get_barrier_strings()
#'
#' # Here " symbol shouldn't be explicitly escaped
#' set_barrier_strings(c("a", '"]'))
#' get_barrier_strings()
#'
#' set_barrier_strings(barriers)
#' }
#' @name get-set-barrier-strings
NULL

#' @rdname get-set-barrier-strings
#' @export
set_barrier_strings <- function(barrier_strings) {
  if (is.null(barrier_strings)) {
    return(options(cursorjumper_barrier_strings = NULL))
  }

  if (!is.character(barrier_strings)) {
    stop("`barrier_strings` should be a character vector.", call. = FALSE)
  }
  if (any(barrier_strings == "")) {
    warning(
      "`barrier_strings` shouldn't have empty strings. They are removed.",
      call. = FALSE
    )
    barrier_strings <- barrier_strings[barrier_strings != ""]
  }

  options(cursorjumper_barrier_strings = barrier_strings)
}

#' @rdname get-set-barrier-strings
#' @export
get_barrier_strings <- function() {
  barrier_strings <- getOption("cursorjumper_barrier_strings")

  if (is.null(barrier_strings)) {
    default_barrier_strings
  } else {
    barrier_strings
  }
}

#' Default barrier strings
#'
#' Character vector of default barrier strings. Entries chosen based on default
#' RStudio autocreation of matching parenthesis and quotes.
#'
#' @export
default_barrier_strings <- c(
  # `]]` subset
  '"]]', "']]", ")]]", "]]",
  # `]` subset
  '"]', "']", ")]",
  # Autocreated pairs
  "()", "[]", "{}", "''", '""', "``",
  # End of autocreated pairs
   ")",  "]",  "}",  "'",  '"',  "`"
)
