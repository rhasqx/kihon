cmake_minimum_required(VERSION 3.11)
project(doc NONE)
add_subdirectory(csv2tex)

add_custom_command(
    OUTPUT
        tokens.tex
    COMMAND
        csv2tex/csv2tex
            -i ${CMAKE_SOURCE_DIR}/lib/seeds/nihonngo.csv
            > tokens.tex
    DEPENDS
        csv2tex
)

add_custom_command(
    OUTPUT
        ${CMAKE_CURRENT_BINARY_DIR}/nihonngo.tex
    COMMAND
        ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_SOURCE_DIR}/nihonngo.tex
            ${CMAKE_CURRENT_BINARY_DIR}/nihonngo.tex
    MAIN_DEPENDENCY
        ${CMAKE_CURRENT_SOURCE_DIR}/nihonngo.tex
)

add_custom_command(
    OUTPUT
        ${CMAKE_CURRENT_BINARY_DIR}/nihonngo.pdf
    COMMAND
        xelatex nihonngo.tex
    DEPENDS csv2tex
        ${CMAKE_CURRENT_BINARY_DIR}/nihonngo.tex
        ${CMAKE_CURRENT_BINARY_DIR}/tokens.tex
)

add_custom_target(clean_temporary_tex ALL
    COMMAND
        ${CMAKE_COMMAND} -E remove
            ${CMAKE_CURRENT_BINARY_DIR}/tokens.tex
            ${CMAKE_CURRENT_BINARY_DIR}/nihonngo.tex
)

add_custom_target(nihonngo ALL
    DEPENDS
        clean_temporary_tex
        ${CMAKE_CURRENT_BINARY_DIR}/nihonngo.pdf
)
