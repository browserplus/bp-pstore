#####
# A CMake build file for the ruby PSTORE service which allows you to
# persistently store lots of data on the client side.
# 
# Author: Steve Spencer
# (c) Yahoo 2007, all rights reserved
#####

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# looser syntax
SET(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS 1)

SET(serviceName PStore)

SET(SCRIPT_FILE phash.rb)

# Name our project
PROJECT(${serviceName}Ruby)

# desired output directory
SET (outputDir "${CMAKE_CURRENT_BINARY_DIR}/${serviceName}")

# build up the service dir
FILE(MAKE_DIRECTORY ${outputDir})

CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/manifest.json"
               "${outputDir}/manifest.json")  

SET(srcs ${SCRIPT_FILE})
SET(allDeps)

FOREACH(src ${srcs})
  SET(mySrc "${CMAKE_CURRENT_SOURCE_DIR}/${src}")
  SET(myDst "${outputDir}/${src}")

  ADD_CUSTOM_COMMAND(
    OUTPUT ${myDst}
    DEPENDS ${mySrc}		  
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${mySrc} ${myDst}
  )
  SET(allDeps ${allDeps} ${myDst})
ENDFOREACH()

ADD_CUSTOM_TARGET(${serviceName} ALL DEPENDS ${allDeps})

# Pre-build step, build our externals
#
ADD_CUSTOM_TARGET(
    ${serviceName}Externals ALL
    COMMAND ruby build.rb
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../external"
    COMMENT Building externals...)
ADD_DEPENDENCIES(${serviceName} ${serviceName}Externals)
