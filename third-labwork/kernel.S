.syntax unified
.cpu cortex-m4
.thumb
#define A #10
#define B #10
#define C #5

// Global memory locations.
.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word __stack_start 
.word __kernel_reset__+1
    .size vtable_kernel, .-vtable_kernel

.section .rodata
    data: .asciz "kernel started!\n"
    final: .asciz "Value in register #1: "
.section .text
__kernel_reset__:
    ldr r0, = data
    bl dbgput_line
    
    // calculate 
    mov r1, A
    mov r2, B
    mov r3, C
    mov r5, 0
  
    // (a-b)
    sub r4, r1, r2
    // if (a-b) >= 0
    cmp r4, #0
    ite ge
    // res = a + b
    addGE r5, r1, r2
    // res = a - b
    subLT r5, r1, r2
    // res = res / c
    sdiv r5, r5, r3
    
    ldr r0, = final
    bl dbgput
    mov r0, r5
    bl dbgput_num
    
    end:
    b end
