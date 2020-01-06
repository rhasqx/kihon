cmake_minimum_required(VERSION 3.11)
project(doc NONE)
add_subdirectory(csv2tex)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/hiragana.pdf ${CMAKE_CURRENT_BINARY_DIR}/hiragana.pdf COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/katakana.pdf ${CMAKE_CURRENT_BINARY_DIR}/katakana.pdf COPYONLY)

add_custom_command(
    OUTPUT
        ${CMAKE_CURRENT_BINARY_DIR}/COMMIT
    COMMAND
        ${CMAKE_SOURCE_DIR}/commit.sh > ${CMAKE_CURRENT_BINARY_DIR}/COMMIT
    WORKING_DIRECTORY
        ${CMAKE_SOURCE_DIR}
)

add_custom_command(
    OUTPUT
        ${CMAKE_CURRENT_BINARY_DIR}/tokens.tex
    COMMAND
        csv2tex/csv2tex -i ${CMAKE_SOURCE_DIR}/lib/seeds/vhs-heilbronn.csv > ${CMAKE_CURRENT_BINARY_DIR}/tokens.tex
    DEPENDS
        csv2tex
)

add_custom_command(
    OUTPUT
        ${CMAKE_CURRENT_BINARY_DIR}/nihonngo.pdf
    COMMAND
        xelatex ${CMAKE_CURRENT_SOURCE_DIR}/nihonngo.tex
    COMMAND
        xelatex ${CMAKE_CURRENT_SOURCE_DIR}/nihonngo.tex
    DEPENDS
        csv2tex
        ${CMAKE_CURRENT_BINARY_DIR}/COMMIT
        ${CMAKE_CURRENT_BINARY_DIR}/tokens.tex
)

add_custom_target(clean_temporary_tex
    COMMAND
        ${CMAKE_COMMAND} -E remove
            ${CMAKE_CURRENT_BINARY_DIR}/COMMIT
            ${CMAKE_CURRENT_BINARY_DIR}/tokens.tex
)

add_custom_target(nihonngo ALL
    DEPENDS
        clean_temporary_tex
        ${CMAKE_CURRENT_BINARY_DIR}/nihonngo.pdf
)
