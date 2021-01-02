MEMORY 
{
    CODE    (rx) : ORIGIN = 0x0000, LENGTH = 0x000200
    BSS     (rw) : ORIGIN = 0x100000, LENGTH = 0xF300
}

SECTIONS
{
    code :
    {
        *(code CODE)
    } 
    . = ALIGN(32);
    bss (NOLOAD): 
    {
        *(bss BSS)
    }>BSS
}