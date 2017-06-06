# Put your source files here (or *.c, etc)
C_SRC=main.c system_stm32f4xx.c stm32f4xx_it.c
# Library code
C_SRC += stm32f4xx_gpio.c stm32f4xx_rcc.c stm32f4xx_usart.c stm32f4xx_can.c misc.c

# add startup file to build
ASM_SRC += $(STM_COMMON)/Libraries/CMSIS/Device/ST/STM32F4xx/Source/Templates/TrueSTUDIO/startup_stm32f427_437xx.s 

# Binaries will be generated with this name (.elf, .bin, .hex, etc)
PROJ_NAME=gwm

# Put your STM32F4 library code directory here
STM_COMMON=../..

# Normally you shouldn't need to change anything below this line!
#######################################################################################

CC=/opt/gcc-arm-none-eabi-5_4-2016q3/bin/arm-none-eabi-gcc
OBJCOPY=/opt/gcc-arm-none-eabi-5_4-2016q3/bin/arm-none-eabi-objcopy

DEFS  = -DSTM32F427_437xx -DUSE_STDPERIPH_DRIVER
CFLAGS += -g -O2 -Wall -Tstm32_flash.ld 
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16

INC += -I.
INC += -I$(STM_COMMON)/Libraries/CMSIS/Device/ST/STM32F4xx/Include
INC += -I$(STM_COMMON)/Libraries/CMSIS/Include
INC += -I$(STM_COMMON)/Libraries/STM32F4xx_StdPeriph_Driver/inc

C_OBJS 		= $(C_SRC:.c=.o)
ASM_OBJS 	= $(ASM_SRC:.s=.o)

vpath %.c \
$(STM_COMMON)/Libraries/STM32F4xx_StdPeriph_Driver/src \


all: $(PROJ_NAME).elf

$(PROJ_NAME).elf: $(C_OBJS) $(ASM_OBJS)
	$(CC) $(DEFS) $(INC) $(CFLAGS) $(C_OBJS) $(ASM_OBJS) -o $(PROJ_NAME).elf 
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

$(C_OBJS):%.o:%.c
	$(CC) $(DEFS) $(INC) $(CFLAGS) -c $< -o $@
$(ASM_OBJS):%.o:%.s
	$(CC) $(DEFS) $(INC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f *.o $(PROJ_NAME).elf $(PROJ_NAME).hex $(PROJ_NAME).bin
