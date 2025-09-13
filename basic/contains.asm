section .text
global contains_in_set

contains_in_set:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    push    edx
    push    esi

    mov     esi, [ebp+8]        
    mov     eax, [ebp+12]       
    mov     edx, eax

    mov     ecx, [esi]          
    cmp     edx, ecx
    jae     .not_found

    mov     ebx, [esi+16]       
    test    ebx, ebx
    jz      .not_found

    mov     ecx, [ebx + edx*4]  
    cmp     ecx, 0FFFFFFFFh
    je      .not_found

    mov     ebx, [esi+8]        
    cmp     ecx, ebx
    jae     .not_found

    mov     ebx, [esi+12]       
    mov     ebx, [ebx + ecx*4]
    cmp     ebx, edx
    jne     .not_found

    mov     eax, 1
    jmp     .done

.not_found:
    xor     eax, eax

.done:
    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret
