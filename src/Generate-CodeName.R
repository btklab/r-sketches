#!/usr/bin/env Rscript

#
# Generate-CodeName.R - A wrapper script for the 'codename' package.
#
# This script generates a project codename, such as "Warty Warthog",
# which is the format used by Ubuntu. It allows specifying a seed for
# reproducibility and a type for the codename pattern.
#

# --- 1. Load Dependencies ---
# Suppress startup messages from libraries for a cleaner command-line output.
suppressWarnings(library('optparse'))
suppressWarnings(library('codename'))

# --- 2. Handle No-Argument Case ---
# If the script is run without any arguments, display usage information and exit.
# This makes the script's functionality discoverable for first-time users.
if (length(commandArgs(TRUE)) == 0) {
  cat("Synopsis:\n")
  cat("  Rscript Generate-CodeName.R [options]\n\n")
  cat("Description:\n")
  cat("  Generates a project codename using the 'codename' package.\n\n")
  cat("Example:\n")
  cat("  # Generate a codename with a specific seed and type\n")
  cat("  Rscript Generate-CodeName.R --seed=20251005 --type=ubuntu\n\n")
  cat("  # Generate a codename using the default type ('ubuntu')\n")
  cat("  Rscript Generate-CodeName.R -s 20251005\n\n")
  cat("  # List all available codename types\n")
  cat("  Rscript Generate-CodeName.R --list-types\n\n")
  cat("  # For more options, see help:\n")
  cat("  Rscript Generate-CodeName.R --help\n")
  quit(status=0)
}

# --- 3. Define Command-Line Options ---
# The 'optparse' library provides a clean way to define and parse command-line flags.
option_list <- list(
  make_option(c("-s", "--seed"), type="character", default=format(Sys.Date(), "%Y%m%d"),
              help="A seed for codename generation [default: %default (current date)]", metavar="character"),
  make_option(c("-t", "--type"), type="character", default="ubuntu",
              help="The type of codename (e.g., ubuntu, pokemon) [default: %default]", metavar="character"),
  make_option("--list-types", action="store_true", default=FALSE,
              help="List available codename types and exit"),
  make_option(c("-m", "--message"), action="store_true", default=FALSE,
              help="Show message")
)

# --- 4. Parse Arguments ---
# Create a parser and parse the arguments provided by the user.
# The `parse_args` function also automatically handles the --help flag.
opt_parser <- OptionParser(option_list=option_list)
opts <- parse_args(opt_parser)

# --- 5. Handle --list-types Flag ---
# If the user wants to see the available types, print them and exit immediately.
# This action takes precedence over generating a codename.
if (opts$`list-types`) {
  cat("Available codename types:\n")
  # The 'codename::codenames' is a named list where each name is a valid type.
  types <- c("any", "ubuntu", "gods", "wu-tang", "nicka")
  # Print each type on a new line for readability.
  cat(paste("  -", types), sep="\n")
  quit(status=0)
}

# --- 6. Set Seed for Reproducibility ---
# Using a seed ensures that the same input (seed number) will always produce
# the same output (codename). This is crucial for consistent results.
# We convert the seed, which could be a string like "20251005", to a number.
seed_value <- as.numeric(opts$seed)

# It's good practice to validate user input.
# If the seed can't be converted to a number, it's invalid. We'll warn the user
# and proceed without a specific seed, allowing the system's default RNG state.
if (is.na(seed_value)) {
  warning(paste("Invalid seed value:", opts$seed, ". Using default random seed."))
} else {
  set.seed(seed_value)
}


# --- 7. Generate and Print Codename ---
# The core logic of the script. The 'codename' function does the heavy lifting.
# The 'ubuntu' type, for example, combines a random adjective with a random animal name.
project_name <- codename(type = opts$type)

# Print the final result to standard output, followed by a newline for clean formatting.
if (opts$`message`) {
    codename_message()
}
cat(project_name, "\n")

