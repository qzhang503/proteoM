### Also in proteoQ

#' Prefix form of colnames(x)[c(2, 5, ...)] for use in pipes
#'
#' \code{names_pos<-} rename the columns at the indexes of \code{pos}.
#'
#' @param x A data frame.
#' @param pos Numeric.  The index of columns for name change.
#' @param value Characters.  The new column names.
#' @return The data frame with new names.
#'
#' @import dplyr
#' @importFrom magrittr %>% %T>% %$% %<>%
`names_pos<-` <- function(x, pos, value) 
{
  names(x)[pos] <- value
  x
}


#' Finds the columns of reporter-ion intensity.
#'
#' @param TMT_plex Numeric; the multiplexity of TMT, i.e., 10, 11 etc.
find_int_cols <- function (TMT_plex) 
{
  col_int <- if (TMT_plex == 18L) 
    c("I126", "I127N", "I127C", "I128N", "I128C", "I129N", "I129C",
      "I130N", "I130C", "I131N", "I131C",
      "I132N", "I132C", "I133N", "I133C", "I134N", "I134C", "I135N") 
  else if (TMT_plex == 16L) 
    c("I126", "I127N", "I127C", "I128N", "I128C", "I129N", "I129C",
      "I130N", "I130C", "I131N", "I131C",
      "I132N", "I132C", "I133N", "I133C", "I134N")
  else if (TMT_plex == 11L) 
    c("I126", "I127N", "I127C", "I128N", "I128C", "I129N", "I129C",
      "I130N", "I130C", "I131N", "I131C")
  else if (TMT_plex == 10L) 
    c("I126", "I127N", "I127C", "I128N", "I128C", "I129N", "I129C",
      "I130N", "I130C", "I131")
  else if(TMT_plex == 6L) 
    c("I126", "I127", "I128", "I129", "I130", "I131")
  else 
    NULL
}


#' Re-order columns in a data frame
#'
#' \code{ins_cols_after} re-orders columns in a data frame.
#'
#' @param df A data frame.
#' @param idx_bf A column index for the insertion of columns after.
#' @param idx_ins Column index(es) for the columns to be inserted after
#'   \code{idx_bf}.
#' @import dplyr
#' @importFrom stringr str_split
#' @importFrom magrittr %>% %T>% %$% %<>%
ins_cols_after <- function(df = NULL, idx_bf = ncol(df), idx_ins = NULL) 
{
  if (is.null(df)) 
    stop("`df` cannot be `NULL`.", call. = FALSE)
  
  if (is.null(idx_ins)) 
    return(df)
  
  if (idx_bf >= ncol(df)) 
    return(df)
  
  col_nms <- names(df)[idx_ins]
  
  dplyr::bind_cols(
    df[, 1:idx_bf, drop = FALSE],
    df[, idx_ins, drop = FALSE],
    dplyr::select(df[, (idx_bf + 1):ncol(df), drop = FALSE], -col_nms))
}


#' Pad columns to a placeholder data frame.
#'
#' @param df The original data frame.
#' @param df2 The data frame to be inserted.
#' @param idx The index of \code{df} column for \code{df2} to be inserted
#'   (after).
add_cols_at <- function(df, df2, idx) 
{
  if (idx < 0L)
    stop("Column index ", idx, " cannot be negative.")
  
  bf <- if (idx == 0L) 
    NULL
  else 
    df[, seq_len(idx), drop = FALSE]
  
  af <- if ((idx + 1L) <= ncol(df)) 
    df[, (idx + 1L) : ncol(df), drop = FALSE]
  else 
    NULL
  
  dplyr::bind_cols(
    bf,
    df2,
    af)
}


#' Replace columns in the original PSM table.
#'
#' The column index(es) need to be continuous.
#'
#' @param df The original data frame.
#' @param df2 The data columns to replace those in \code{df}.
#' @param idxs The sequences of column indexes in \code{df}. Note that
#'   \code{idxs} need to be a continuous sequences.
replace_cols_at <- function(df, df2, idxs) 
{
  ncol <- ncol(df)
  
  if (!all(idxs >= 1L))
    stop("Not all indexes are greater or equal to one.")
  
  if (!all(idxs <= ncol))
    stop("Not all indexes are smaller or equal to the number of columns.")
  
  idxs <- sort(idxs)
  stopifnot(all.equal(idxs - idxs[1] + 1L, seq_along(idxs)))
  
  bf <- if (idxs[1] >= 2L) 
    df[, 1:(idxs[1]-1L), drop = FALSE]
  else 
    NULL
  
  af <- if (idxs[length(idxs)] < ncol(df)) 
    df[, (idxs[length(idxs)]+1L):ncol(df), drop = FALSE]
  else 
    NULL
  
  dplyr::bind_cols(
    bf,
    df2,
    af)
}


#' Relocate column "to_move" immediately after column "col_before".
#'
#' @param df The original data frame.
#' @param to_move The column to be moved.
#' @param col_before The anchor column to which the \code{to_move} will be moved
#'   after.
reloc_col_after <- function(df, to_move = "after_anchor", col_before = "anchor") 
{
  if (!(to_move %in% names(df) && col_before %in% names(df))) 
    return(df)
  
  if (to_move == col_before) 
    return(df)
  
  df2 <- dplyr::select(df, one_of(to_move))
  df <- dplyr::select(df, -one_of(to_move))
  
  idx <- which(names(df) == col_before)
  df <- add_cols_at(df, df2, idx)
  
  invisible(df)
}


#' Relocate column "to_move" immediately after the last column.
#'
#' @inheritParams reloc_col_after
reloc_col_after_last <- function (df, to_move = "after_anchor") 
{
  col_last <- names(df)[ncol(df)]
  reloc_col_after(df, to_move, col_last)
}


#' Relocate column "to_move" immediately after the first column.
#'
#' @inheritParams reloc_col_after
reloc_col_after_first <- function(df, to_move = "after_anchor") 
{
  col_first <- names(df)[1]
  reloc_col_after(df, to_move, col_first)
}


#' Relocate column "to_move" immediately before anchor column "col_after".
#'
#' The same as \code{reloc_col}.
#'
#' @param df The original data frame.
#' @param to_move The column to be moved.
#' @param col_after The anchor column to which the \code{to_move} will be moved
#'   before.
reloc_col_before <- function(df, to_move = "before_anchor",
                             col_after = "anchor") 
{
  if (!(to_move %in% names(df) && col_after %in% names(df))) 
    return(df)
  
  df2 <- dplyr::select(df, one_of(to_move))
  df <- dplyr::select(df, -one_of(to_move))
  
  idx <- which(names(df) == col_after)
  
  df <- add_cols_at(df, df2, idx - 1)
  
  invisible(df)
}


#' Relocate column "to_move" immediately before the last column.
#'
#' @inheritParams reloc_col_after
reloc_col_before_last <- function(df, to_move = "after_anchor") 
{
  col_last <- names(df)[ncol(df)]
  reloc_col_before(df, to_move, col_last)
}


#' Relocate column "to_move" immediately before the first column.
#'
#' @inheritParams reloc_col_after
reloc_col_before_first <- function (df, to_move = "after_anchor") 
{
  col_first <- names(df)[1]
  reloc_col_before(df, to_move, col_first)
}


#' Helper: find the column name before \code{to_move}.
#'
#' To keep columns at the same order after descriptive summary.
#'
#' @inheritParams reloc_col_after
find_preceding_colnm <- function(df, to_move) 
{
  if (!to_move %in% names(df)) 
    stop("Column ", to_move, " not found.", call. = FALSE)

  ind_bf <- which(names(df) == to_move) - 1L
  
  if (ind_bf == 0L) 
    names(df)[1]
  else 
    names(df)[ind_bf]
}


#' Flatten lists recursively
#'
#' @param x Lists
recur_flatten <- function (x) 
{
  if (!inherits(x, "list")) 
    list(x)
  else 
    .Internal(unlist(c(lapply(x, recur_flatten)), recursive = FALSE, 
                     use.names = FALSE))
}


### End of also in proteoQ



#' Splits data into chunks by length.
#'
#' @param data Input data.
#' @param n_chunks The number of chunks.
#' @param type The type of data for splitting.
#' @param ... Arguments for \link{findInterval}.
chunksplit <- function (data, n_chunks = 5L, type = c("list", "row"), ...)
{
  type <- match.arg(type)
  
  if (!type %in% c("list", "row"))
    stop("The value of \"type\" needs to be either \"list\" or \"row\".")

  if (n_chunks <= 1L) 
    return(data)
  
  if (type == "list") 
    len <- length(data)
  else if (type == "row") 
    len <- nrow(data)
  else 
    stop("Unknown type.", call. = TRUE)
  
  if (len == 0L) 
    return(data)
  
  labs <- levels(cut(1:len, n_chunks))
  
  x <- cbind(lower = floor(as.numeric( sub("\\((.+),.*", "\\1", labs))),
             upper = ceiling(as.numeric( sub("[^,]*,([^]]*)\\]", "\\1", labs))))
  
  grps <- findInterval(1:len, x[, 1], ...)
  
  split(data, grps)
}


#' Splits data into chunks with approximately equal sizes.
#'
#' @param nx Positive integer; an arbitrarily large number for data to be split
#'   into for estimating the cumulative sizes.
#' @inheritParams chunksplit
chunksplitLB <- function (data, n_chunks = 5L, nx = 100L, type = "list") 
{
  if (!type %in% c("list", "row"))
    stop("The value of \"type\" needs to be either \"list\" or \"row\".")

  if (n_chunks <= 1L) 
    return(data)
  
  if (type == "list") 
    len <- length(data)
  else if (type == "row") 
    len <- nrow(data)
  else 
    stop("Unknown type.", call. = TRUE)
  
  if (len == 0L) 
    return(data)
  
  # The finer groups by 'nx'
  grps_nx <- local({
    labsx <- levels(cut(1:len, nx))
    
    xx <- cbind(lower = floor(as.numeric( sub("\\((.+),.*", "\\1",
                                              labsx))),
                upper = ceiling(as.numeric( sub("[^,]*,([^]]*)\\]", "\\1",
                                                labsx))))
    
    findInterval(1:len, xx[, 1])
  })
  
  # The equated size for a chunk
  size_chunk <- local({
    size_nx <- data %>%
      split(., grps_nx) %>%
      lapply(object.size) %>%
      cumsum()
    
    size_nx[length(size_nx)]/n_chunks
  })
  
  #  Intervals
  grps <- local({
    size_data <- data %>%
      lapply(object.size) %>%
      cumsum()
    
    # the position indexes
    ps <- purrr::map_dbl(1:(n_chunks-1), function (x) {
      which(size_data < size_chunk * x) %>% `[`(length(.))
    })
    
    grps <- findInterval(1:len, ps)
  })
  
  split(data, grps)
}


#' Finds a file directory.
#'
#' With the option of creating a directory
#'
#' @param path A file path.
#' @param create Logical; if TRUE create the path if not yet existed.
find_dir <- function (path, create = FALSE) 
{
  if (length(path) != 1L)
    stop("Length of `path` is not exactly one: ", paste(path, collapse = ", "))

  path <- gsub("\\\\", "/", path)
  
  p1 <- fs::path_expand_r(path)
  p2 <- fs::path_expand(path)
  
  if (fs::dir_exists(p1)) {
    path <- p1
  } 
  else if (fs::dir_exists(p2)) {
    path <- p2
  } 
  else {
    if (create) {
      dir.create(file.path(path), recursive = TRUE, showWarnings = FALSE)
      path <- p1
    } 
    else {
      message(path, " not found.")
      path <- NULL
    }
  }
  
  path
}


#' Creates a file directory.
#'
#' @inheritParams find_dir
create_dir <- function (path) find_dir(path, create = TRUE)


#' Saves the arguments in a function call
#'
#' @param path A (system) file path.
#' @param fun The name of function being saved.
#' @param time The time stamp.
save_call2 <- function(path, fun, time = NULL) 
{
  if (length(path) != 1L)
    stop("Length of `path` is not exactly one: ", paste(path, collapse = ", "))
  
  if (length(fun) != 1L)
    stop("Length of `fun` is not exactly one: ", paste(fun, collapse = ", "))

  call_pars <- mget(names(formals(fun)), envir = parent.frame(), inherits = FALSE)
  call_pars[names(call_pars) == "..."] <- NULL
  
  if (is.null(time)) {
    p2 <- create_dir(path)
    save(call_pars, file = file.path(p2, paste0(fun, ".rda")))
  } 
  else {
    if (length(time) != 1L)
      stop("Length of `time` is not exactly one: ", paste(time, collapse = ", "))

    p2 <- create_dir(file.path(path, fun))
    save(call_pars, file = file.path(p2, paste0(time, ".rda")))
  }
}


#' Finds the values of a list of arguments from caches.
#'
#' Back-compatibility: if \code{new_args} are not in an earlier version. The
#' \emph{default} value from the current version will be added to cached
#' results.
#'
#' @param args Arguments to be matched.
#' @param new_args vector of argument_name-default_value pairs; new arguments
#'   that are not in earlier versions.
#'
#' @inheritParams save_call2
#' @import dplyr purrr
#' @importFrom magrittr %>% %T>% %$%
#' @return The time stamp of a matched cache results.
find_callarg_vals <- function (time = NULL, path = NULL, fun = NULL,
                               args = NULL, new_args = NULL) 
{
  if (length(path) != 1L)
    stop("Length of `path` is not exactly one: ", paste(path, collapse = ", "))
  
  if (length(fun) != 1L)
    stop("Length of `fun` is not exactly one: ", paste(fun, collapse = ", "))

  file <- if (is.null(time)) file.path(path, fun) else file.path(path, fun, time)

  if (!file.exists(file)) 
    return(NULL)

  load(file = file)
  
  # --- back-compatibility
  if ((!is.null(new_args)) && is.null(names(new_args))) 
    stop("Need named vector for `new_args`.")
  
  if (!is.null(new_args)) {
    call_pars <- local({
      nargs <- c(# n_13c = 0L, min_ms1_charge = 2L, max_ms1_charge = 6L, 
                 new_args)
      
      for (i in seq_along(nargs)) {
        x <- nargs[i]
        nm <- names(x)
        val <- unname(x)
        
        # nm in "must-matched" args but not in earlier "call_pars"
        if ((nm %in% args) && (! nm %in% names(call_pars))) {
          if (is_nulllist(x))
            call_pars <- c(call_pars, x)
          else
            call_pars[[nm]] <- val
        }
      }
      
      call_pars
    })
  }

  nots <- which(! args %in% names(call_pars))
  
  if (length(nots)) 
    stop("Arguments '", paste(args[nots], collapse = ", "),
         "' not found in the latest call to `", fun, "`.\n", 
         "This is probably due to new argument implementation in `matchMS`.\n", 
         "Delete `", file.path(path, fun), "`", " and try again.", 
         call. = FALSE)

  call_pars[args]
}


#' Finds the time stamp of a matched call from cached results.
#'
#' @param nms Names of arguments to be included in or excluded from matching.
#' @param type Logical; if TRUE, includes all arguments in \code{nms}. At FALSE,
#'   excludes all \code{nms}.
#' @param new_args Named vector; new arguments that are not in earlier versions.
#' @inheritParams find_callarg_vals
#' @return An empty object if no matches.
match_calltime <- function (path = "~/proteoM/.MSearches/Cache/Calls",
                            fun = "calc_pepmasses2",
                            nms = c("parallel", "out_path"),
                            type = c(TRUE, FALSE), 
                            new_args = NULL) 
{
  len_path <- length(path)
  
  if (!len_path)
    return(NULL)
  
  if (len_path > 1L)
    stop("Multiple pathes to cache folder.")
  
  if (length(fun) != 1L) 
    stop("Multiple functions: ", fun)

  if (length(type) > 1L) 
    type <- TRUE
  
  # if (!all(names(new_args) %in% nms))
  #   warning("Developer: not all new arguments defined in the required list.")
  
  # current values
  fml_nms <- names(formals(fun))
  
  args <- if (type) 
    mget(fml_nms[fml_nms %in% nms], envir = parent.frame(), inherits = FALSE)
  else 
    mget(fml_nms[! fml_nms %in% nms], envir = parent.frame(), inherits = FALSE)

  if (!length(args)) 
    stop("Arguments for matching is empty.", call. = FALSE)
  
  args <- lapply(args, function (x) if (is.list(x)) lapply(x, sort) else sort(x))
  
  times <- list.files(path = file.path(path, fun),
                      pattern = "\\.rda$",
                      all.files = TRUE)
  
  # cached values
  cached <- lapply(times, find_callarg_vals, path = path, fun = fun,
                   args = names(args), new_args = new_args)
  
  cached <- lapply(cached, function (x) lapply(x, function (v) {
    if (is.list(v)) lapply(v, sort) else sort(v)
  }))
  
  # matched
  oks <- lapply(cached, identical, args)
  oks <- unlist(oks, recursive = FALSE, use.names = FALSE)
  
  gsub("\\.rda$", "", times[oks])
}


#' Deletes files under a directory.
#'
#' The directory will be kept.
#' 
#' @param path A file path.
#' @param ignores The file extensions to be ignored.
#' @param ... Arguments for file.remove.
delete_files <- function (path, ignores = NULL, ...) 
{
  
  # Hadley Ch.19 Quasiquotation, note 97
  dots <- as.list(substitute(...()))
  recursive <- dots[["recursive"]]
  dots$recursive <- NULL
  
  if (is.null(recursive)) 
    recursive <- TRUE
  
  if (!is.logical(recursive)) 
    stop("Not logical `recursive`.")

  args <- c(list(path = file.path(path), recursive = recursive,
                 full.names = TRUE), dots)
  
  nms <- do.call(list.files, args)
  
  if (!is.null(ignores)) {
    nms <- local({
      dirs <- list.dirs(path, full.names = FALSE, recursive = recursive)
      dirs <- dirs[! dirs == ""]

      idxes_kept <- purrr::map_lgl(dirs, function (x) any(grepl(x, ignores)))
      
      nms_kept <- list.files(path = file.path(path, dirs[idxes_kept]),
                             recursive = TRUE, full.names = TRUE)
      
      nms[! nms %in% nms_kept]
    })
    
    nms <- local({
      exts <- gsub("^.*(\\.[^.]*)$", "\\1", nms)
      idxes_kept <- purrr::map_lgl(exts, function (x) any(grepl(x, ignores)))
      
      nms[!idxes_kept]
    })
  }
  
  if (length(nms)) 
    suppressMessages(file.remove(file.path(nms)))

  invisible(NULL)
}


#' Finds the time stamp(s) of MS1 precursors.
#' 
#' @param out_path An output path.
find_ms1_times <- function (out_path) 
{
  if (".time_stamp" %in% ls(envir = .GlobalEnv, all.names = TRUE)) {
    # may be incorrect `.time_stamp` from a previous session
    return(get(".time_stamp", envir = .GlobalEnv, inherits = FALSE))
  }
  
  file <- file.path(out_path, "Calls", ".cache_info.rds")
  
  if (file.exists(file)) {
    .cache_info <- qs::qread(file)
    .time_stamp <- .cache_info$.time_stamp
    
    if (is.null(.time_stamp))
      stop("Cannot find `.time_stamp`.")
    
    return(.time_stamp)
  }
  
  # not really used; may return(NULL)
  file2 <- file.path(out_path, "temp", "out_paths.rds")
  
  if (file.exists(file2)) {
    out_paths <- qs::qread(file2)
    
    .cache_infos <- 
      lapply(out_paths, function (x) qs::qread(file.path(x, "Calls", ".cache_info.rds")))

    # multiple time stamps (e.g. group searches)
    return(lapply(.cache_infos, function (x) x[[".time_stamp"]]))
  }
  else {
    stop("Cannot find `.time_stamp`.")
  }
}



#' Finds a global variable.
#'
#' Not yet used. The utility at first looks up the global environment then the
#' indicated file.
#'
#' @param x Variable name
#' @param file An file name as an alternative for looking up.
#' @seealso \link{find_ms1_times}
#' @examples
#' \donttest{
#' out_path <- "~/proteoM/example/"
#' cache <- file.path(out_path, "Calls/.cache_info.rds")
#' get_globalvar(".time_stamp", cache)
#' }
get_globalvar <- function (val = NULL, cache = NULL)
{
  if (is.null(val))
    stop("\"val\" cannot be NULL.")
  
  if (length(val) > 1L)
    stop("The length of \"val\" is not one.")
  
  ok <- exists(val, envir = .GlobalEnv, inherits = FALSE)
  
  if (ok)
    return(get(val, envir = .GlobalEnv, inherits = FALSE))
  
  if (is.null(cache))
    stop("\"cache\" cannot be NULL when without a global match.")
  
  if (length(cache) > 1L)
    stop("The length of \"cache\" is not one.")
  
  if (!file.exists(cache))
    stop("Object \"", val, " \" not found in ", cache, ".")
  
  ans <- qs::qread(cache)
  assign(x = val, val, envir = .GlobalEnv)
  
  ans[[val]]
}


#' Loads variable to the global environment.
#' 
#' Not yet used. 
#' 
#' @param file An file name as an alternative for looking up
#' @param overwrite If TRUE, overwrite the pre-existed global values with the
#'   cache values.
#' @seealso \link{find_ms1_times}
#' @examples
#' \donttest{
#' out_path <- "~/proteoM/example/"
#' cache <- file.path(out_path, "Calls/.cache_info.rds")
#' load_cache_info(cache)
#' }
load_cache_info <- function (cache = NULL, overwrite = TRUE)
{
  if (is.null(cache))
    stop("\"cache\" cannot be NULL.")
  
  if (length(cache) > 1L)
    stop("The length of \"cache\" is not one.")
  
  if (!file.exists(cache))
    stop("File not existed: ", cache)
  
  ans <- qs::qread(cache)
  
  for (i in seq_along(ans)) {
    nm <- names(ans[i])
    val <- ans[[i]]
    
    if (overwrite)
      assign(x = nm, val, envir = .GlobalEnv)
    else {
      if (!exists(nm, envir = .GlobalEnv, inherits = FALSE))
        assign(x = nm, val, envir = .GlobalEnv)
    }
  }
  
  invisible(ans)
}


#' Is a NULL list
#' 
#' @param x A list.
#' @examples 
#' is_nullist(list(a = NULL))
is_nulllist <- function (x)
{
  length(x) == 1L && is.null(x[[1]])
}


#' Adds a plain NULL entry to a list.
#' 
#' This is different to, for example, \code{x[["a"]] <- list(NULL)}.
#' 
#' @param l A list.
#' @param nm A character vector of name.
#' @examples 
#' l <- list(a = 2, b = 3)
#' add_nulllist(l, "m")
#' 
add_nulllist <- function (l, nm)
{
  l <- c(l, list(NULL))
  names(l)[length(l)] <- nm
  
  l
}


