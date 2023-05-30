darwin=false
FFLAGS_DEBUG_POSIX=-Wall -Wextra -fPIC -fmax-errors=1 -g -fcheck=bounds -fcheck=array-temps -fbacktrace -fcoarray=single
FFLAGS_RELEASE_POSIX=-O3 -funroll-loops -Wimplicit-interface -fPIC -fmax-errors=1 -fcoarray=single

ifeq ($(darwin), true)
	FFLAGS_DEBUG=-static $(FFLAGS_DEBUG_POSIX)
	FFLAGS_RELEASE=-static $(FFLAGS_RELEASE_POSIX)
else
	FFLAGS_DEBUG=$(FFLAGS_DEBUG_POSIX)
	FFLAGS_RELEASE=$(FFLAGS_RELEASE_POSIX)

endif

all:
	@echo $(FFLAGS_DEBUG)
	@echo $(FFLAGS_RELEASE)

