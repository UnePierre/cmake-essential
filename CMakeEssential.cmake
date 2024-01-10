include(FeatureSummary)
set_package_properties(
    CMakeEssential PROPERTIES
    DESCRIPTION "Essential CMake snippets for software development with modern CMake"
    URL "https://github.com/UnePierre/cmake-essential"
    TYPE RECOMMENDED)

# Provided snippets:
include("${CMAKE_CURRENT_LIST_DIR}/include/Ccache.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/include/Git.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/include/MessageContext.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/include/ParseArguments.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/include/Policies.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/include/Project.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/include/TestByCompilation.cmake")
