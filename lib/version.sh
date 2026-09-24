# version_gt A B: succeeds when version A is strictly greater than version B.
#
# Compares major.minor.patch numerically; on a tie, a release outranks a
# prerelease. Two prereleases of the same core are never ordered: the action
# only compares a release against another version, so it never needs to.
version_gt() {
  local IFS=.
  local -a a=(${1%%-*}) b=(${2%%-*})
  local i
  for i in 0 1 2; do
    # 10# keeps a leading zero from being read as octal
    if (( 10#${a[i]} > 10#${b[i]} )); then return 0; fi
    if (( 10#${a[i]} < 10#${b[i]} )); then return 1; fi
  done
  [[ "$1" != *-* && "$2" == *-* ]]
}
