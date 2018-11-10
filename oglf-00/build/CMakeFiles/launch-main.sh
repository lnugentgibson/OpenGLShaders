#!/bin/sh
bindir=$(pwd)
cd /home/lnugentgibson/Workspace/opengl3/oglf-00/main/
export 

if test "x$1" = "x--debugger"; then
	shift
	if test "xYES" = "xYES"; then
		echo "r  " > $bindir/gdbscript
		echo "bt" >> $bindir/gdbscript
		/usr/bin/gdb -batch -command=$bindir/gdbscript --return-child-result /home/lnugentgibson/Workspace/opengl3/oglf-00/build/main 
	else
		"/home/lnugentgibson/Workspace/opengl3/oglf-00/build/main"  
	fi
else
	"/home/lnugentgibson/Workspace/opengl3/oglf-00/build/main"  
fi
