section .text
global search_in_set

search_in_set:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    push    edx
    push    esi
    push    edi

    mov     esi, [ebp+8]        
    mov     eax, [ebp+12]       
    mov     edi, eax

    mov     ecx, [esi]          
    cmp     edi, ecx
    jae     .not_found

    mov     ebx, [esi+16]       
    test    ebx, ebx
    jz      .not_found

    mov     ecx, [ebx + edi*4] 
    cmp     ecx, 0FFFFFFFFh
    je      .not_found

    mov     edx, [esi+8]       
    cmp     ecx, edx
    jae     .not_found

    mov     ebx, [esi+12]      
    mov     edx, [ebx + ecx*4]
    cmp     edx, edi
    jne     .not_found

    mov     eax, ecx           
    jmp     .done

.not_found:
    mov     eax, -1

.done:
    pop     edi
    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret
