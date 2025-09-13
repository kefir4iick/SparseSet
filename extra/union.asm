section .text
global union_sets
extern insert_into_set

union_sets:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    esi
    push    edi
    push    ecx
    push    edx

    mov     ebx, [ebp + 8]    
    mov     esi, [ebp + 12]   
    mov     edi, [ebp + 16]   
    
    test    ebx, ebx
    jz      .done
    test    esi, esi
    jz      .done
    test    edi, edi
    jz      .done

    mov     ecx, [ebx + 8]    
    xor     eax, eax          
    test    ecx, ecx
    jz      .copyB_start      

.copyA_loop:
    cmp     eax, ecx
    jae     .copyB_start

    mov     edx, [ebx + 12]   
    test    edx, edx
    jz      .copyB_start      
    
    mov     edx, [edx + eax*4] 

    push    eax
    push    ecx
    push    edx               
    push    edi               
    call    insert_into_set
    add     esp, 8
    pop     ecx
    pop     eax

    inc     eax
    jmp     .copyA_loop

.copyB_start:
    mov     ecx, [esi + 8]    
    xor     eax, eax
    test    ecx, ecx
    jz      .done           

.copyB_loop:
    cmp     eax, ecx
    jae     .done

    mov     edx, [esi + 12]   
    test    edx, edx
    jz      .done             
    
    mov     edx, [edx + eax*4] 

    push    eax
    push    ecx
    push    edx               
    push    edi               
    call    insert_into_set
    add     esp, 8
    pop     ecx
    pop     eax

    inc     eax
    jmp     .copyB_loop

.done:
    pop     edx
    pop     ecx
    pop     edi
    pop     esi
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret
