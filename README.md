
<!-- README.md is generated from README.Rmd. Please edit that file -->
cursorjumper
============

Package 'cursorjumper' is intended to be used as RStudio addin for moving cursor to the end of predefined strings ("jumping over") during writing R code. This is mostly useful when binded to some keyboard shortcut ('Ctrl+K' seems to be a good option) so that you can move cursor without leaving ["home row keys"](https://en.wikipedia.org/wiki/Touch_typing#Home_row). For how to set up keyboard shortcuts for addins read [this page](https://rstudio.github.io/rstudioaddins/#keyboard-shorcuts).

The initial idea behind this addin was to adjust for RStudio mechanism of matching parenthesis/quotes autoinsert. Although this is a useful feature, after autoinsert cursor is put inside parenthesis/quotes (which is a good behavior). In order to move out of them you need to reach with your right hand to the arrow keys, type right arrow key (probably several times), and move back to "home row keys". This action is common and, therefore, tiresome.

With 'cursorjumper' you can define keyboard shortcut to "move out" from inside of autocompleted symbols. This package has some reasonable default strings to be omitted. See examples.

Installation
------------

'cursorjumper' isn't available from CRAN. You can install development version with:

``` r
# install.packages("remotes")
remotes::install_github("echasnovski/cursorjumper")
```

Examples
--------

In all examples `|^|` denote current cursor position.

### Default jumping

Default jumping is chosen based on default RStudio autocreation of matching parenthesis and quotes with combination of most common R code strings. It moves maximum to the right in order to jump to a "reasonably furthest" destination.

#### Default jumping 1

``` default-jumping-1
# Type call to mean
x <- mean|^|

# Type (
x <- mean(|^|)

# Type `mean()` argument
x <- mean(1:10|^|)

# Instead of moving hands from "home row", type keyboard shortcut for "jump()"
# and move out of ()
x <- mean(1:10)|^|
```

#### Default jumping 2

Default jumping is set to jump "reasonably far":

``` default-jumping-2-1
# Type "
"|^|"

# Type string
"abcde|^|"

# Type keyboard shortcut for "jump()"
"abcde"|^|
```

``` default-jumping-2-2
# Type "mtcars", [, [, " to extract list element by name
mtcars[["|^|"]]

# Type element name
mtcars[["vs|^|"]]

# Type keyboard shortcut for "jump()". Instead of jumping only over second "
# cursor jumps as far as over "]]
mtcars[["vs"]]|^|
```

### Custom jumping

You can define your one set of string to be jumped over. In 'cursorjumper' they are called "barrier strings". Here are the default barrier strings (divided with ","):

    #> "]], ']], )]], ]], "], '], )], "), '), ]), (), [], {}, '', "", ``, ), ], }, ', ", `

To set and get barrier strings there are `set_barrier_strings()` and `get_barrier_strings()` functions:

``` r
cursorjumper::set_barrier_strings(c("function", "abc", "a"))
```

To return to default barrier strings use `NULL` as input to `set_barrier_strings()`.

#### Custom jumping 1

``` custom-jumping-1
# Current typing situation
|^|function(x = 1)

# After executing `jump()` with custom barrier strings
function|^|(x = 1)
```

#### Custom jumping 2

If multiple barrier strings are matched, the first one is used:

``` custom-jumping-2
# Current typing situation
|^|abcde

# After executing `jump()` with custom barrier strings cursor jumps over "abc"
# because it comes earlier in barrier strings than "a"
abc|^|de
```
