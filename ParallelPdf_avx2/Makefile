DIR       = XEON
CXXFLAGS  = ##CXXFLAGS  = -O3 $(BITS) -fPIC -funroll-all-loops -finline-functions -ipo -no-prec-div -fast-transcendentals -xHost
# -debug all
SOFLAGS  = -shared
INCLUDE  = -I../
SOLIBS = -lnuma
BITS      = -m64

ifndef ARCHFLAGS
    ifneq ($(MAKECMDGOALS), clean)
        $(error $$ARCHFLAGS not defined)
    endif
endif

# ARCH_FLAGS = -mavx2
CXXFLAGS = $(BITS) $(ARCHFLAGS) -fPIC -funroll-loops -finline-functions -Ofast -fPIC -ftree-loop-if-convert-stores -fvisibility-inlines-hidden -std=gnu++11 -ftree-vectorizer-verbose=1 -fopt-info-vec -Wall --param vect-max-version-for-alias-checks=100 -fipa-pta -DWARNINGMSG $(OPTFLAGS)

LDFLAGS = -static-libgcc -ldl -lirc

CXX       = g++

INCLUDE   += -I$(PWD)
OPENMP    = -fopenmp

MAIN    := main
LIB     := libMain_$(DIR).so
CXXLIST := $(filter-out $(MAIN).cxx,$(wildcard *.cxx))
HHLIST  := $(filter-out common.h, $(patsubst %.cxx,%.h,$(CXXLIST)))
OBJLIST := $(patsubst %.cxx,$(DIR)/%.o,$(CXXLIST))

.SUFFIXES: .cxx .o .h .so .cpp

.PHONY: tests


all: $(MAIN)_$(DIR)

tests: tests/Data_t tests/State_t tests/PdfScheduler_t tests/CBuffer_t


$(DIR)/%.o: %.cxx %.h
	@echo "Compiling $<"
	@mkdir -p $(DIR)
	$(CXX) $(CXXFLAGS) $(OPENMP) $(ROOTINC) $(INCLUDE) -c $< -o $@

$(LIB): $(OBJLIST)
	@echo "Making library..."
	$(CXX) $(CXXFLAGS) $(OPENMP) $(SOFLAGS) $^ -o $@

$(MAIN)_$(DIR): $(MAIN).cxx $(LIB) models/*.h
	@echo "Making executable..."
	$(CXX) $(CXXFLAGS) $(OPENMP) $(ROOTINC) $(INCLUDE) $(ROOTLIB) $(SOLIBS) $<  ./$(LIB) -o $@ $(LDFLAGS)

tests/%: %.cpp
	@echo "Building test $<"
	@mkdir -p tests
	$(CXX) $(CXXFLAGS) $(OPENMP) $(ROOTINC) $(INCLUDE) $(ROOTLIB) $(SOLIBS) $<  ./$(LIB) -o $@ $(LDFLAGS)


valgrind:
	valgrind --tool=callgrind --simulate-cache=yes --collect-jumps=yes --separate-threads=yes --simulate-hwpref=yes --cacheuse=yes ./main_XEON -n 100000 -b 1000 -i 100

clean:
	rm -rf *~ */*~ *.o *.out *.xnlog $(LIB) $(MAIN)_$(DIR) *.inc *.pomp.* $(DIR) tests
