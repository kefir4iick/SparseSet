section .text
global remove_from_set

extern contains_in_set

remove_from_set:
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

    push    edi
    push    esi
    call    contains_in_set
    add     esp, 8
    test    eax, eax
    jz      .done

    mov     ebx, [esi+16]       
    mov     ecx, [ebx + edi*4]  

    mov     edx, [esi+8]
    dec     edx
    mov     [esi+8], edx

    mov     ebx, [esi+12]
    mov     eax, [ebx + edx*4] 

    mov     [ebx + ecx*4], eax  

    mov     ebx, [esi+16]
    mov     [ebx + eax*4], ecx  

    mov     dword [ebx + edi*4], 0FFFFFFFFh 

.done:
    pop     edi
    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret
