######################################
# For STM32F100C8 on Mars Eclipse using the ARM GNU toolchain
# Supports both the assembler and C startup code stubs
# Liam Goudge August 2016
#
# This is a more extensible Makefile than SignOfLife1 to enable
# larger future projects
#
################### Project name and sources #####################

NAME=NanoLibSemiHost

#MBP
#FOUNDATION = /Users/Liam/Eclipse/WorkspaceJan16/Foundation

#MM
FOUNDATION = /Users/Liam/Documents/LiamsDox/Personal/GeekingOut/SoftDvt/Embedded/EclipseMarsFeb2016/WorkspaceJan16/Foundation

C_SOURCES = $(FOUNDATION)/startup_Nano.S $(FOUNDATION)/semihost.c 	# Enter list of all the C source files here
S_SOURCES = $(FOUNDATION)/semihostDriver.S 	# Enter list of all the assembler source files here

OBJECTS = $(C_SOURCES:.c=.o) $(S_SOURCES:.S=.o)

################### File Locations #####################
include $(FOUNDATION)/filePath

# Compiler/Assembler/Linker Paths

CC=		$(PATH)arm-none-eabi-gcc
OD =	$(PATH)arm-none-eabi-objdump
NM =	$(PATH)arm-none-eabi-nm
AS =	$(PATH)arm-none-eabi-as
SZ =	$(PATH)arm-none-eabi-size

OBJDIR = Objects2
INCLUDES = -I./

################### Libraries #####################
# Library settings
USE_NANO=--specs=nano.specs --specs=rdimon.specs
USE_SEMIHOST=--specs=rdimon.specs -lc -lc -lrdimon
NO_SEMIHOST = -lgcc -lc -lm -nostartfiles
SIMPLE = -nostartfiles

################### GNU Flags #####################
# Compiler Flags
CFLAGS = -mcpu=cortex-m3 -mthumb -Wall -g -c

# Assembler Flags
ASFLAGS = -mcpu=cortex-m3 -mthumb

# Linker Flags 
LINKER_SCRIPT = $(FOUNDATION)/STM32F100C8v5.ld
LDFLAGS=-v -mthumb -mcpu=cortex-m3 $(USE_NANO) -T $(LINKER_SCRIPT) # Use nano embedded libraries

# Other Stuff
ODFLAGS = -h --syms -S
REMOVE = rm -f

################### Build Steps #####################

all: $(NAME).elf

$(NAME).elf: $(OBJECTS)
	@ echo "Link:" $^
	$(CC) $(LDFLAGS)  $^ -o $@
	/bin/rm -f *.o
	$(OD) $(ODFLAGS) $@ > $(NAME).lst
	$(SZ) --format=berkeley $@
	
.S.o:
	@ echo "asm:"
	$(CC) $(ASFLAGS) -o $@ -c $<

.c.o:
	@ echo "c:"
	$(CC) $(CFLAGS) -o $@ -c $<

clean:
	@ echo " "
	@ echo "Clean up"
	/bin/rm -f *.o *.elf *.lst

	

