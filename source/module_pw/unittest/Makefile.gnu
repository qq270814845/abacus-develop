
#==========================
# Compiler information 
#==========================
CPLUSPLUS     = g++
CPLUSPLUS_MPI = mpicxx
CUDA_COMPILE = nvcc
OBJ_DIR = pw_obj
NP      = 12

#==========================
# Options
#==========================
#Only MPI
HONG = -D__MPI -D__NORMAL

#Mix Precision
#HONG = -D__MIX_PRECISION -D__NORMAL

#Cuda
#HONG = -D__MPI -D__CUDA -D__NORMAL

#Cuda & Mix Precision
#HONG = -D__MPI -D__CUDA -D__MIX_PRECISION -D__NORMAL

#==========================
# Objects
#==========================
VPATH=../../src_parallel\
:../../module_base\
:../

PW_OBJS_0=intarray.o\
matrix.o\
matrix3.o\
tool_quit.o\
mymath3.o\
timer.o\
global_variable.o\
parallel_global.o\
pw_basis.o\
pw_distributer.o\
pw_gatherscatter.o\
pw_init.o\
pw_transform.o\
pw_distributeg.o\
pw_distributeg_method1.o\
fft.o

PW_OBJS=$(patsubst %.o, ${OBJ_DIR}/%.o, ${PW_OBJS_0})

##==========================
## FFTW package needed 
##==========================
#Use fftw package
FFTW_DIR = /home/qianrui/gnucompile/g_fftw-3.3.8
FFTW_LIB_DIR     = ${FFTW_DIR}/lib
FFTW_INCLUDE_DIR = ${FFTW_DIR}/include
FFTW_LIB         = -L${FFTW_LIB_DIR} -lfftw3 -Wl,-rpath=${FFTW_LIB_DIR}



##==========================
## CUDA needed 
##==========================
# CUDA_DIR = /usr/local/cuda-11.0
# CUDA_INCLUDE_DIR	= ${CUDA_DIR}/include 
# CUDA_LIB_DIR		= ${CUDA_DIR}/lib64
# CUDA_LIB			= -L${CUDA_LIB_DIR} -lcufft -lcublas -lcudart

LIBS = ${FFTW_LIB} ${CUDA_LIB}
OPTS = -I${FFTW_INCLUDE_DIR} ${HONG} -Ofast -std=c++11 -Wall -g 
#==========================
# MAKING OPTIONS
#==========================
pw : 
	@ make init
	@ make -j $(NP) parallel

init :
	@ if [ ! -d $(OBJ_DIR) ]; then mkdir $(OBJ_DIR); fi
	@ if [ ! -d $(OBJ_DIR)/README ]; then echo "This directory contains all of the .o files" > $(OBJ_DIR)/README; fi

parallel : ${PW_OBJS}
	${CPLUSPLUS_MPI} ${OPTS} test1.cpp test_tool.cpp ${PW_OBJS}  ${LIBS} -o test1.exe 
	${CPLUSPLUS_MPI} ${OPTS} test2.cpp test_tool.cpp ${PW_OBJS}  ${LIBS} -o test2.exe 
	${CPLUSPLUS_MPI} ${OPTS} test3.cpp test_tool.cpp ${PW_OBJS}  ${LIBS} -o test3.exe 

${OBJ_DIR}/%.o:%.cpp
	${CPLUSPLUS_MPI} ${OPTS} -c ${HONG} $< -o $@

.PHONY:clean
clean:
	@ if [ -d $(OBJ_DIR) ]; then rm -rf $(OBJ_DIR); fi
	@ if [ -e test1.exe ]; then rm -f test1.exe; fi
	@ if [ -e test2.exe ]; then rm -f test2.exe; fi
	@ if [ -e test3.exe ]; then rm -f test3.exe; fi
