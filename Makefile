# cc -o nvram nvram.c -framework CoreFoundation -framework IOKit -Wall

UNAME_S := $(shell uname -s)

# CC
ifeq ($(UNAME_S),Darwin)
	CC := clang -arch x86_64
else
	CC := g++
endif

# Folders
SRCDIR := src
BUILDDIR := build
TARGETDIR := bin

# Targets
EXECUTABLE := nvram
TARGET := $(TARGETDIR)/$(EXECUTABLE)

# Final Paths
INSTALLBINDIR := /usr/local/bin

# Code Lists
SRCEXT := c
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))

# Folder Lists
# Note: Intentionally excludes the root of the include folder so the lists are clean
#INCDIRS := $(shell find include/**/* -name '*.h' -exec dirname {} \; | sort | uniq)
#INCLIST := $(patsubst include/%,-I include/%,$(INCDIRS))
#BUILDLIST := $(patsubst include/%,$(BUILDDIR)/%,$(INCDIRS))

# Shared Compiler Flags
CFLAGS := -c -Wall
INC :=
LIB := -framework CoreFoundation -framework IOKit

# Platform Specific Compiler Flags
# ifeq ($(UNAME_S),Linux)
#	CFLAGS += -std=gnu++11 -O2 # -fPIC
# else
#	CFLAGS += -std=c++11 -stdlib=libc++ -O2
# endif

$(TARGET): $(OBJECTS)
	@mkdir -p $(TARGETDIR)
	@echo "Linking..."
	@echo "  Linking $(TARGET)"; $(CC) $^ -o $(TARGET) $(LIB)

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(BUILDDIR)
	@echo "Compiling $<..."; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

clean:
	@echo "Cleaning $(TARGET)..."; $(RM) -r $(BUILDDIR) $(TARGET) $(TARGETDIR)

install:
	@echo "Installing $(EXECUTABLE)..."; cp $(TARGET) $(INSTALLBINDIR)

distclean:
	@echo "Removing $(EXECUTABLE)"; rm $(INSTALLBINDIR)/$(EXECUTABLE)

.PHONY: clean
