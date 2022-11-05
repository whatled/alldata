#
# Locate and configure the Google Protocol Buffers library
#
# Adds the following targets:
#
#  protobuf::libprotobuf - Protobuf library
#  protobuf::libprotobuf-lite - Protobuf lite library
#  protobuf::libprotoc - Protobuf Protoc Library
#  protobuf::protoc - protoc executable
#

#
# Generates C++ sources from the .proto files
#
# protobuf_generate_cpp (<SRCS> <HDRS> <DEST> [<ARGN>...])
#
#  SRCS - variable to define with autogenerated source files
#  HDRS - variable to define with autogenerated header files
#  DEST - directory where the source files will be created
#  ARGN - .proto files
#
function(PROTOBUF_GENERATE_CPP SRCS HDRS PROTO_ROOT BUILD_DIR SRCS_DEST HDRS_DEST)
    if(NOT ARGN)
        message(SEND_ERROR "Error: PROTOBUF_GENERATE_CPP() called without any proto files")
        return()
    endif()

    if(DEFINED PROTOBUF_IMPORT_DIRS)
        foreach(DIR ${PROTOBUF_IMPORT_DIRS})
            get_filename_component(ABS_PATH ${DIR} ABSOLUTE)
            list(FIND _protobuf_include_path ${ABS_PATH} _contains_already)
            if(${_contains_already} EQUAL -1)
                list(APPEND _protobuf_include_path -I ${ABS_PATH})
            endif()
        endforeach()
    endif()

    set(${SRCS})
    set(${HDRS})
    foreach(FIL ${ARGN})
        get_filename_component(ABS_FIL ${FIL} ABSOLUTE)
        get_filename_component(ABS_PATH ${ABS_FIL} PATH)
        get_filename_component(FIL_WE ${FIL} NAME_WE)
        file(RELATIVE_PATH REL ${PROTO_ROOT} ${ABS_PATH})

        add_custom_command(
                OUTPUT "${SRCS_DEST}/${REL}/${FIL_WE}.pb.cc" "${HDRS_DEST}/${REL}/${FIL_WE}.pb.h"
                DEPENDS ${ABS_FIL} protobuf::protoc
                COMMAND protobuf::protoc --cpp_out ${BUILD_DIR} ${_protobuf_include_path} ${ABS_FIL}
                COMMAND cp ${BUILD_DIR}/${REL}/${FIL_WE}.pb.cc ${SRCS_DEST}/${REL}/
                COMMAND cp ${BUILD_DIR}/${REL}/${FIL_WE}.pb.h ${HDRS_DEST}/${REL}/
                COMMENT "Running C++ protocol buffer compiler on ${FIL}"
                VERBATIM)

        list(APPEND ${SRCS} "${SRCS_DEST}/${REL}/${FIL_WE}.pb.cc")
        list(APPEND ${HDRS} "${HDRS_DEST}/${REL}/${FIL_WE}.pb.h")
    endforeach()

    set_source_files_properties(${${SRCS}} ${${HDRS}} PROPERTIES GENERATED TRUE)
    set(${SRCS} ${${SRCS}} PARENT_SCOPE)
    set(${HDRS} ${${HDRS}} PARENT_SCOPE)
endfunction()

# By default have PROTOBUF_GENERATE_CPP macro pass -I to protoc
# for each directory where a proto file is referenced.
if(NOT DEFINED PROTOBUF_GENERATE_CPP_APPEND_PATH)
    set(PROTOBUF_GENERATE_CPP_APPEND_PATH TRUE)
endif()

# Find the include directory
find_path(PROTOBUF_INCLUDE_DIR google/protobuf/service.h)
mark_as_advanced(PROTOBUF_INCLUDE_DIR)

# The Protobuf library
find_library(PROTOBUF_LIBRARY NAMES protobuf)
mark_as_advanced(PROTOBUF_LIBRARY)
add_library(protobuf::libprotobuf UNKNOWN IMPORTED)
set_target_properties(protobuf::libprotobuf PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES ${PROTOBUF_INCLUDE_DIR}
        INTERFACE_LINK_LIBRARIES pthread
        IMPORTED_LOCATION ${PROTOBUF_LIBRARY})

# The Protobuf lite library
find_library(PROTOBUF_LITE_LIBRARY NAMES protobuf-lite)
mark_as_advanced(PROTOBUF_LITE_LIBRARY)
add_library(protobuf::libprotobuf-lite UNKNOWN IMPORTED)
set_target_properties(protobuf::libprotobuf-lite PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES ${PROTOBUF_INCLUDE_DIR}
        INTERFACE_LINK_LIBRARIES pthread
        IMPORTED_LOCATION ${PROTOBUF_LITE_LIBRARY})

# The Protobuf Protoc Library
find_library(PROTOBUF_PROTOC_LIBRARY NAMES protoc)
mark_as_advanced(PROTOBUF_PROTOC_LIBRARY)
add_library(protobuf::libprotoc UNKNOWN IMPORTED)
set_target_properties(protobuf::libprotoc PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES ${PROTOBUF_INCLUDE_DIR}
        INTERFACE_LINK_LIBRARIES protobuf::libprotobuf
        IMPORTED_LOCATION ${PROTOBUF_PROTOC_LIBRARY})

# Find the protoc Executable
find_program(PROTOBUF_PROTOC_EXECUTABLE NAMES protoc)
mark_as_advanced(PROTOBUF_PROTOC_EXECUTABLE)
add_executable(protobuf::protoc IMPORTED)
set_target_properties(protobuf::protoc PROPERTIES IMPORTED_LOCATION ${PROTOBUF_PROTOC_EXECUTABLE})

include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Protobuf DEFAULT_MSG PROTOBUF_LIBRARY PROTOBUF_INCLUDE_DIR PROTOBUF_PROTOC_EXECUTABLE)
