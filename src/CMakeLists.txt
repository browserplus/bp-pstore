#####
# A CMake build file for the PStore ruby service which allows you to
# persistently store lots of data on the client side.
# 
# Copyright 2009, Yahoo!
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
# 
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the
#     distribution.
# 
#  3. Neither the name of Yahoo! nor the names of its
#     contributors may be used to endorse or promote products derived
#     from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
# 
# Original Author: Steve Spencer
#####

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.1)

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
