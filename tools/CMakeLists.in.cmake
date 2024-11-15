# Acquire CMake environment.
cmake_minimum_required(VERSION 3.21.0...3.28.1)
include_guard()
include("include/Policies.cmake")
include("include/Project.cmake")

# This project can be used via 'git subtree' or copy&paste, where git cannot provide the version number.
set(PROJECT_VERSION "@PROJECT_VERSION@")

project(
    CMakeEssential
    DESCRIPTION "Essential CMake snippets for software development with modern CMake"
    VERSION "${PROJECT_VERSION}"
    HOMEPAGE_URL "https://github.com/UnePierre/cmake-essential"
    LANGUAGES NONE)
project_message_context()

set(provided_snippets
    @LIST_OF_PROVIDED_SNIPPETS@)

if(PROJECT_IS_TOP_LEVEL)
    include(CMakePackageConfigHelpers)

    enable_language(C OPTIONAL)
    include(GNUInstallDirs)
    set(INSTALL_LIBDIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")

    # Search for include/*.cmake and check against the list of provided_snippets.
    file(
        GLOB found_snippets CONFIGURE_DEPENDS
        LIST_DIRECTORIES false
        RELATIVE "${CMAKE_CURRENT_LIST_DIR}/include"
        "include/*.cmake")
    list(SORT found_snippets CASE INSENSITIVE)
    if(NOT provided_snippets STREQUAL found_snippets)
        message(AUTHOR_WARNING "The lists of provided (${provided_snippets}) and found snippets (${found_snippets}) differ, taking the latter!")
        set(provided_snippets ${found_snippets})
    endif()
    
    # Make all provided snippets available in this project for itself.
    foreach(snippet ${provided_snippets})
        include("include/${snippet}")
    endforeach()

    # If the source is a git working copy itself, i.e. if this project isn't used as a git subtree...
    git_dir(git_dir)
    if(CMAKE_CURRENT_LIST_DIR STREQUAL git_dir)
        # Control PROJECT_VERSION against `git describe`.
        get_version_from_git_describe(git_project_version DESCRIPTION git_description DIRTY is_dirty)
        message(STATUS "git describe: ${git_description}")

        if(NOT PROJECT_VERSION VERSION_EQUAL git_project_version)
            message(AUTHOR_WARNING "PROJECT_VERSION (${PROJECT_VERSION}) differs from `git describe` (${git_project_version}).")
            set(PROJECT_VERSION "${git_project_version}")
        endif()

        if(is_dirty)
            git_status(AUTHOR_WARNING)
        endif()
    endif()

    message_context(README)
    configure_file(docs/README.in.adoc "${CMAKE_CURRENT_LIST_DIR}/README.adoc" @ONLY)
    configure_file(README.adoc README.adoc COPYONLY)
    configure_file(data/vecteezy_pyramid_289688.svg data/vecteezy_pyramid_289688.svg COPYONLY)
    install(FILES README.adoc DESTINATION "${INSTALL_LIBDIR}" RENAME README)
    install(FILES README.adoc DESTINATION "${CMAKE_INSTALL_DOCDIR}" OPTIONAL)
    end_message_context()

    message_context(CMakeLists.txt)
    set(LIST_OF_PROVIDED_SNIPPETS ${provided_snippets})
    list(JOIN LIST_OF_PROVIDED_SNIPPETS "\n    " LIST_OF_PROVIDED_SNIPPETS)
    configure_file(tools/CMakeLists.in.cmake "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" @ONLY)
    configure_file(CMakeLists.txt CMakeLists.txt COPYONLY)
    install(FILES CMakeLists.txt DESTINATION "${INSTALL_LIBDIR}")
    end_message_context()

    message_context(CMakeEssential.cmake)
    set(INCLUDE_PROVIDED_SNIPPETS ${provided_snippets})
    list(TRANSFORM INCLUDE_PROVIDED_SNIPPETS PREPEND "include(\"\${CMAKE_CURRENT_LIST_DIR}/include/")
    list(TRANSFORM INCLUDE_PROVIDED_SNIPPETS APPEND "\")")
    list(JOIN INCLUDE_PROVIDED_SNIPPETS "\n" INCLUDE_PROVIDED_SNIPPETS)
    configure_file(tools/CMakeEssential.in.cmake "${CMAKE_CURRENT_LIST_DIR}/CMakeEssential.cmake" @ONLY)
    configure_file(CMakeEssential.cmake CMakeEssential.cmake COPYONLY)
    install(FILES CMakeEssential.cmake DESTINATION "${INSTALL_LIBDIR}")
    end_message_context()

    message_context(CMakeEssentialConfig.cmake)
    configure_package_config_file(tools/CMakeEssentialConfig.in.cmake "${CMAKE_CURRENT_LIST_DIR}/CMakeEssentialConfig.cmake" INSTALL_DESTINATION "${INSTALL_LIBDIR}")
    install(FILES CMakeEssentialConfig.cmake DESTINATION "${INSTALL_LIBDIR}")
    end_message_context()

    message_context(CMakeEssentialConfigVersion.cmake)
    write_basic_package_version_file("${CMAKE_CURRENT_LIST_DIR}/CMakeEssentialConfigVersion.cmake" VERSION ${PROJECT_VERSION} COMPATIBILITY SameMajorVersion ARCH_INDEPENDENT)
    install(FILES CMakeEssentialConfigVersion.cmake DESTINATION "${INSTALL_LIBDIR}")
    end_message_context()

    message_context("include/*")
    foreach(snippet ${provided_snippets})
        install(FILES "include/${snippet}" DESTINATION "${INSTALL_LIBDIR}/include")
    endforeach()
    end_message_context()
endif()

end_project_message_context()
