section .text
global insert_into_set

extern contains_in_set

insert_into_set:
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
    jae     .error

    mov     ebx, [esi+12]       
    test    ebx, ebx
    jz      .error
    mov     ebx, [esi+16]       
    test    ebx, ebx
    jz      .error

    mov     ecx, [esi+8]       
    mov     edx, [esi+4]        
    cmp     ecx, edx
    jae     .error

    push    edi                 
    push    esi                 
    call    contains_in_set
    add     esp, 8
    test    eax, eax
    jnz     .success

    mov     ebx, [esi+12]       
    mov     [ebx + ecx*4], edi  

    mov     ebx, [esi+16]       
    mov     [ebx + edi*4], ecx  

    inc     dword [esi+8]       

.success:
    mov     eax, 1
    jmp     .done

.error:
    xor     eax, eax

.done:
    pop     edi
    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret
