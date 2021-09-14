if(
    NOT DEFINED ROOT
    OR NOT DEFINED ARCH
)
    message(
        FATAL_ERROR
        "Assert: ROOT = ${ROOT}; ARCH = ${ARCH}"
    )
endif()

set(
    BUILD
    0
)

if(DEFINED ENV{BUILD_NUMBER})
    set(
        BUILD
        $ENV{BUILD_NUMBER}
    )
endif()

set(
    TAG
    ""
)

if(DEFINED ENV{TAG})
    set(
        TAG
        "$ENV{TAG}"
    )
else()
    find_package(
        Git
    )

    if(Git_FOUND)
        execute_process(
            COMMAND
                ${GIT_EXECUTABLE} rev-parse --short HEAD
            OUTPUT_VARIABLE
                TAG
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        set(
            TAG
            "_${TAG}"
        )
    endif()
endif()

include(
    "${CMAKE_CURRENT_LIST_DIR}/version.cmake"
)

set(
	ARCH
	"anycpu"
)

set(
    PACKAGE_NAME
    "rapidjson-${ROGII_RAPIDJSON_VERSION}-${ARCH}-${BUILD}${TAG}"
)

set(
    CMAKE_INSTALL_PREFIX
    ${ROOT}/${PACKAGE_NAME}
)

set(
    DEBUG_PATH
    "${CMAKE_CURRENT_LIST_DIR}/../build/debug_${ARCH}"
)

file(
    MAKE_DIRECTORY
    "${DEBUG_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -G Ninja -DRAPIDJSON_BUILD_DOC=OFF -DRAPIDJSON_BUILD_EXAMPLES=OFF -DRAPIDJSON_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} ../..
    WORKING_DIRECTORY
        "${DEBUG_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" --build . --target install
    WORKING_DIRECTORY
        "${DEBUG_PATH}"
)

file(
    COPY
        ${CMAKE_CURRENT_LIST_DIR}/package.cmake
    DESTINATION
        "${ROOT}/${PACKAGE_NAME}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -E tar cf "${PACKAGE_NAME}.7z" --format=7zip -- "${PACKAGE_NAME}"
    WORKING_DIRECTORY
        "${ROOT}"
)
