#!/bin/bash -e

kokkos_build_type="${1}"

if [ ! -d "${TEST_SOURCE_DIR}/phaseFieldMPI/heffte" ]
then
  echo "Missing googletest for testing, downloading...."
  git clone https://github.com/google/googletest.git ${TEST_SOURCE_DIR}/googletest
fi

cmake_options=(
    -D CMAKE_PREFIX_PATH="${ELEMENTS_INSTALL_DIR};${KOKKOS_INSTALL_DIR}"
)

if [ "$kokkos_build_type" = "none" ]; then
    cmake_options+=(
        -D Matar_ENABLE_KOKKOS=OFF
    )
else
    cmake_options+=(
        -D Matar_ENABLE_KOKKOS=ON
    )
fi

# Print CMake options for reference
echo "CMake Options: ${cmake_options[@]}"

# Configure test
cmake "${cmake_options[@]}" -B "${TEST_BUILD_DIR}" -S "${TEST_SOURCE_DIR}"

# Build test
make -C "${TEST_BUILD_DIR}" -j${ELEMENTS_BUILD_CORES}

cd $basedir
