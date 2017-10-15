# asmKeylogger
lightweight NASM keylogger

## build the keylogger:

nasm -f elf keylogger.asm

ld -m elf_i386 -s -o keylogger keylogger.o

### To change the destination file, change the 'dest' string.


## warning:
This keylogger must be run as root.
