OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)

INCLUDE memory_map.ld

STACK_SIZE = DEFINED(STACK_SIZE) ? STACK_SIZE : DEFINED(__stack_size__) ? __stack_size__ : 0x2000;

/* Section Definitions */
SECTIONS
{
    .text :
    {
        . = ALIGN(4);
        _stext = .;
        KEEP(*(.vectors .vectors.*))
        *(.text .text.*)
        *(.rodata .rodata*)
        . = ALIGN(4);
    } > approm

    /* .ARM.exidx is sorted, so has to go in its own output section.  */
    PROVIDE_HIDDEN (__exidx_start = .);
    .ARM.exidx :
    {
      *(.ARM.exidx* .gnu.linkonce.armexidx.*)
    } > approm
    PROVIDE_HIDDEN (__exidx_end = .);

    . = ALIGN(4);
    _etext = .;

    /* .bss section which is used for uninitialized data */
    .bss (NOLOAD) :
    {
        _bss = .;
        . = ALIGN(4);
        _sbss = . ;
        *(.bss .bss.*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = . ;
    } > ram

    .data : AT (_etext)
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data .data.*);
        . = ALIGN(4);
        _edata = .;
    } > ram

    /* stack section */
    .stack (NOLOAD):
    {
        . = ALIGN(8);
        _sstack = .;
        . = . + STACK_SIZE;
        . = ALIGN(8);
        _estack = .;
    } > ram

    . = ALIGN(4);
    _end = . ;
}
