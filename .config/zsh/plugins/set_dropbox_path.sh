# Exports an environment variable DROPBOX containing the location of the dropbox folder.
# Intended to be *sourced* during the shell initialization. Works with both bash and zsh.

# list of candidate paths
candidate_paths=(
  "/mnt/c/Users/rober/Dropbox"
  "/mnt/d/Dropbox"
)

# loop over candidate paths
flag=false
for dir in "${candidate_paths[@]}"; do
  if [[ -d "$dir" ]]; then
    flag=true
    export DROPBOX="$dir"
    break
  fi
done

# print error message if no match was found
"$flag" || echo "Dropbox location not found"

# cleaning up
unset candidate_paths dir flag

