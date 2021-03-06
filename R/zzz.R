
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Welcome to proteoM.\n\n",
                        "============================================================================================\n",
                        # "NEW features (v1.1.8.3):\n",
                        # "[x] Incompatible with cached results from previous versions.\n\n",
                        "[x] For examples, enter \"?matchMS\".\n", 
                        # "[x] Optimized under R.4.1.3 (tested with R.4.2).\n",

                        # "[x] Utility `add_unimod` for custom entries of Unimod.\n",
                        # "[x] See also package `proteoQ` for downstream data QA and informatics.\n", 
                        # "\n",
                        
                        # "Notes:\n",
                        "[x] Suggested configuration for large datasets: 32GB RAM and 8-cores.\n",
                        # "[x] May need to remove previously cached results (or use a new .path_cache and .path_fasta).\n",
                        # "    (OOps an accidental relocation of amino-acid lookups to a parent directory) \n",
                        # "remotes::install_version(\"RSQLite\", version = \"2.2.5\")\n",
                        "============================================================================================\n")
}
