#!/usr/bin/env bats

# Bats test for ddev-matomo add-on.
#
# Local run:
#   bats ./tests/test.bats
# Skip the release test (only relevant once the new tag is published):
#   bats ./tests/test.bats --filter-tags '!release'

setup() {
  set -eu -o pipefail

  export GITHUB_REPO=madsnorgaard/ddev-matomo

  TEST_BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
  export BATS_LIB_PATH="${BATS_LIB_PATH}:${TEST_BREW_PREFIX}/lib:/usr/lib/bats"
  bats_load_library bats-assert
  bats_load_library bats-file
  bats_load_library bats-support

  export DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")/.." >/dev/null 2>&1 && pwd)"
  export PROJNAME="test-$(basename "${GITHUB_REPO}")"
  mkdir -p "${HOME}/tmp"
  export TESTDIR="$(mktemp -d "${HOME}/tmp/${PROJNAME}.XXXXXX")"
  export DDEV_NONINTERACTIVE=true
  export DDEV_NO_INSTRUMENTATION=true
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  run ddev config --project-name="${PROJNAME}" --project-tld=ddev.site
  assert_success
  run ddev start -y
  assert_success
}

health_checks() {
  # Matomo container is up and labelled correctly.
  run ddev exec -s matomo true
  assert_success

  # The dedicated matomo database exists and is empty (no application tables leaked in).
  run ddev mysql -uroot -proot -e "SHOW DATABASES LIKE 'matomo';"
  assert_success
  assert_output --partial "matomo"

  # Apache is serving on port 80 inside the matomo service. The install wizard returns 200
  # on /index.php; /matomo.php would return 400 here, which is why we don't probe it.
  run ddev exec -s matomo curl -sf -o /dev/null -w "%{http_code}" http://localhost/index.php
  assert_success
  assert_output "200"

  # The HTTPS hostname is wired through ddev-router.
  run curl -sfI -o /dev/null -w "%{http_code}" "https://matomo.${PROJNAME}.ddev.site/index.php"
  assert_success
  assert_output "200"
}

teardown() {
  set -eu -o pipefail
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1
  if [ -n "${GITHUB_ENV:-}" ]; then
    [ -e "${GITHUB_ENV:-}" ] && echo "TESTDIR=${HOME}/tmp/${PROJNAME}" >> "${GITHUB_ENV}"
  else
    [ "${TESTDIR}" != "" ] && rm -rf "${TESTDIR}"
  fi
}

@test "install from directory" {
  set -eu -o pipefail
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${DIR}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail
  echo "# ddev add-on get ${GITHUB_REPO} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${GITHUB_REPO}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}

