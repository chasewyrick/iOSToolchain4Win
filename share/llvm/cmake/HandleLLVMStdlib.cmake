# This CMake module is responsible for setting the standard library to libc++
# if the user has requested it.

if(NOT DEFINED LLVM_STDLIB_HANDLED)
  set(LLVM_STDLIB_HANDLED ON)

  if(CMAKE_COMPILER_IS_GNUCXX)
    set(LLVM_COMPILER_IS_GCC_COMPATIBLE ON)
  elseif( MSVC )
    set(LLVM_COMPILER_IS_GCC_COMPATIBLE OFF)
  elseif( "${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang" )
    set(LLVM_COMPILER_IS_GCC_COMPATIBLE ON)
  endif()

  function(append_if condition value)
    if(${condition})
      foreach(variable ${ARGN})
        set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
      endforeach(variable)
    endif()
  endfunction()

  include(CheckCXXCompilerFlag)
  if(LLVM_ENABLE_LIBCXX)
    if(LLVM_COMPILER_IS_GCC_COMPATIBLE)
      check_cxx_compiler_flag("-stdlib=libc++" CXX_SUPPORTS_STDLIB)
      append_if(CXX_SUPPORTS_STDLIB "-stdlib=libc++" CMAKE_CXX_FLAGS)
      append_if(CXX_SUPPORTS_STDLIB "-stdlib=libc++" CMAKE_EXE_LINKER_FLAGS)
      append_if(CXX_SUPPORTS_STDLIB "-stdlib=libc++" CMAKE_SHARED_LINKER_FLAGS)
      append_if(CXX_SUPPORTS_STDLIB "-stdlib=libc++" CMAKE_MODULE_LINKER_FLAGS)
    else()
      message(WARNING "Not sure how to specify libc++ for this compiler")
    endif()
  endif()
endif()