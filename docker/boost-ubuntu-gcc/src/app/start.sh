#!/bin/bash

#
# Copyright (c) 2020 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

set -e

boost_version_underscore="$(echo "${BOOST_VERSION}" | sed -r 's/\./_/g')"
boost_root_dir="${BUILD_DIR}/boost_${boost_version_underscore}"

echo "Assuming root folder for sources is: ${boost_root_dir}"

if [[ -d "${boost_root_dir}" ]]; then
  echo "Found existing folder ${boost_root_dir}, assuming that sources are in place and skipping downloading and unpacking of sources"
else
  # Boost sources were not mounted or were not deployed yet
  boost_archive_file="${DOWNLOAD_DIR}/boost_${boost_version_underscore}.tar.gz"
  if [[ -f "${boost_archive_file}" ]]; then
    echo "Found existing file ${boost_archive_file}, assuming that sources are downloaded and skipping downloading of sources"
  else
    # Download Boost C++ Libraries
    boost_download_url="${BOOST_RELEASE_URL}/${BOOST_VERSION}/source/boost_${boost_version_underscore}.tar.gz"
    echo "Downloading Boost C++ Libraries (source code archive) from: ${boost_download_url} into: ${boost_archive_file}"
    curl -Lks -o "${boost_archive_file}" "${boost_download_url}"
  fi
  # Unpack Boost C++ Libraries
  echo "Extracting source code archive to: ${BUILD_DIR}"
  tar -xzf "${boost_archive_file}" -C "${BUILD_DIR}"
  echo "Extracted source code archive"
fi

b2_bin="${boost_root_dir}/b2"
b2_toolset="gcc"

# Build Boost.Build
boost_bootstrap="${boost_root_dir}/bootstrap.sh"
cd "${boost_root_dir}"
echo "Building Boost.Build engine"
"${boost_bootstrap}"

boost_linkages=("shared" "static")
runtime_linkages=("shared")

if [[ -n "${BOOST_LINKAGE+x}" ]]; then
  boost_linkages=("${BOOST_LINKAGE}")
fi

if [[ -n "${BOOST_RUNTIME_LINKAGE+x}" ]]; then
  runtime_linkages=("${BOOST_RUNTIME_LINKAGE}")
fi

target_dir_suffix="x64"
compiler_dir_suffix="gcc$(gcc -dumpversion | sed -r 's/^([[:digit:]]+)(\..*)?$/\1/;t;d')"
boost_install_dir="/stage/boost-${BOOST_VERSION}-${target_dir_suffix}-${compiler_dir_suffix}"
mkdir -p "${boost_install_dir}"

for boost_linkage in "${boost_linkages[@]}"; do
  for runtime_linkage in "${runtime_linkages[@]}"; do
    if [[ "${runtime_linkage}" = "static" ]] && [[ "${boost_linkage}" != "static" ]]; then
      # Nothing to do with this type of configuration - just skip it
      continue
    fi
    boost_runtime_linkage="${runtime_linkage}"
    cd "${boost_root_dir}"
    echo "Building Boost C++ Libraries with these parameters:"
    echo "B2_BIN               : ${b2_bin}"
    echo "B2_TOOLSET           : ${b2_toolset}"
    echo "BOOST_INSTALL_DIR    : ${boost_install_dir}"
    echo "BOOST_LINKAGE        : ${boost_linkage}"
    echo "BOOST_RUNTIME_LINKAGE: ${boost_runtime_linkage}"
    echo "B2_OPTIONS           : ${B2_OPTIONS}"
    "${b2_bin}" \
      --toolset="${b2_toolset}" \
      link="${boost_linkage}" \
      runtime-link="${boost_runtime_linkage}" \
      install \
      --prefix="${boost_install_dir}" \
      --layout=system \
      ${B2_OPTIONS}
  done
done

boost_dist_file="${TARGET_DIR}/$(basename "${boost_install_dir}").tar.gz"
tar -C "$(dirname "${boost_install_dir}")" -cvzf "${boost_dist_file}" "$(basename "${boost_install_dir}")"

echo "Build completed successfully. Archive with built Boost is located at ${boost_dist_file}"
