# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/victo/Downloads/lab1_code/default

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/victo/Downloads/lab1_code/build

# Include any dependencies generated for this target.
include CMakeFiles/default.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/default.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/default.dir/flags.make

CMakeFiles/default.dir/lab1.cpp.o: CMakeFiles/default.dir/flags.make
CMakeFiles/default.dir/lab1.cpp.o: /home/victo/Downloads/lab1_code/default/lab1.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/victo/Downloads/lab1_code/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/default.dir/lab1.cpp.o"
	/bin/x86_64-linux-gnu-g++-10  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/default.dir/lab1.cpp.o -c /home/victo/Downloads/lab1_code/default/lab1.cpp

CMakeFiles/default.dir/lab1.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/default.dir/lab1.cpp.i"
	/bin/x86_64-linux-gnu-g++-10 $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/victo/Downloads/lab1_code/default/lab1.cpp > CMakeFiles/default.dir/lab1.cpp.i

CMakeFiles/default.dir/lab1.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/default.dir/lab1.cpp.s"
	/bin/x86_64-linux-gnu-g++-10 $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/victo/Downloads/lab1_code/default/lab1.cpp -o CMakeFiles/default.dir/lab1.cpp.s

CMakeFiles/default.dir/sha256.cpp.o: CMakeFiles/default.dir/flags.make
CMakeFiles/default.dir/sha256.cpp.o: /home/victo/Downloads/lab1_code/default/sha256.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/victo/Downloads/lab1_code/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/default.dir/sha256.cpp.o"
	/bin/x86_64-linux-gnu-g++-10  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/default.dir/sha256.cpp.o -c /home/victo/Downloads/lab1_code/default/sha256.cpp

CMakeFiles/default.dir/sha256.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/default.dir/sha256.cpp.i"
	/bin/x86_64-linux-gnu-g++-10 $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/victo/Downloads/lab1_code/default/sha256.cpp > CMakeFiles/default.dir/sha256.cpp.i

CMakeFiles/default.dir/sha256.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/default.dir/sha256.cpp.s"
	/bin/x86_64-linux-gnu-g++-10 $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/victo/Downloads/lab1_code/default/sha256.cpp -o CMakeFiles/default.dir/sha256.cpp.s

# Object files for target default
default_OBJECTS = \
"CMakeFiles/default.dir/lab1.cpp.o" \
"CMakeFiles/default.dir/sha256.cpp.o"

# External object files for target default
default_EXTERNAL_OBJECTS =

default: CMakeFiles/default.dir/lab1.cpp.o
default: CMakeFiles/default.dir/sha256.cpp.o
default: CMakeFiles/default.dir/build.make
default: CMakeFiles/default.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/victo/Downloads/lab1_code/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX executable default"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/default.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/default.dir/build: default

.PHONY : CMakeFiles/default.dir/build

CMakeFiles/default.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/default.dir/cmake_clean.cmake
.PHONY : CMakeFiles/default.dir/clean

CMakeFiles/default.dir/depend:
	cd /home/victo/Downloads/lab1_code/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/victo/Downloads/lab1_code/default /home/victo/Downloads/lab1_code/default /home/victo/Downloads/lab1_code/build /home/victo/Downloads/lab1_code/build /home/victo/Downloads/lab1_code/build/CMakeFiles/default.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/default.dir/depend
