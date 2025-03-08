# Search for dropbox location and export environment variable with its location
# if found. Invoke by sourcing it during the shell initialization.

# list of candidate paths
candidate_paths=(
  "${HOME}/Dropbox"
  "${WINHOME}/Dropbox"
  "/mnt/d/Dropbox"
  "/mnt/e/Dropbox"
)

# loop over candidate paths
flag=false
for dir in "${candidate_paths[@]}"; do
  if [[ -d "${dir}" ]]; then
    flag=true
    export DROPBOX="${dir}"
    break
  fi
done

# print error message if no match was found
"$flag" || echo "Dropbox location not found"

# clean up
unset candidate_paths dir flag

