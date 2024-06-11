cmake_minimum_required(VERSION 3.10)

project(cpuminer)

add_definitions("-s EXPORTED_RUNTIME_METHODS='[\"ccall\",\"cwrap\"]' ")
add_definitions("-s EXTRA_EXPORTED_RUNTIME_METHODS='[\"ccall\",\"cwrap\"]'")
add_definitions("-s EXPORTED_FUNCTIONS='[\"_cipher\"]' ")

#SET_TARGET_PROPERTIES(test PROPERTIES LINK_FLAGS "-s EXTRA_EXPORTED_RUNTIME_METHODS=['ccall', 'cwrap']")


set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXECUTABLE_SUFFIX ".js")

set(TD_LINKER_FLAGS "-Wl,--gc-sections -Wl,--exclude-libs,ALL") 
# 编译为可执行任务
add_executable(cpuminer-nodeapi nodeapi.c)
# 构建参数相关的，方便构建模块
target_link_libraries(cpuminer-nodeapi "-s MODULARIZE=1 -s EXPORTED_RUNTIME_METHODS='[\"ccall\",\"cwrap\"]' -s EXPORTED_FUNCTIONS='[\"_cipher\"]'")
