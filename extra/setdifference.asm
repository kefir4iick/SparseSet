section .text
global setdifference_sets
extern contains_in_set
extern insert_into_set

setdifference_sets:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    esi
    push    edi
    push    ecx
    push    edx

    mov     ebx, [ebp+8]   
    mov     esi, [ebp+12]   
    mov     edi, [ebp+16]   

    mov     ecx, [ebx + 8]  
    xor     edx, edx        

.loopA:
    cmp     edx, ecx
    jae     .done

    mov     eax, [ebx + 12] 
    mov     eax, [eax + edx*4]  

    push    eax             
    push    esi             
    call    contains_in_set
    add     esp, 8
    test    eax, eax
    jnz     .skip_insert

    mov     eax, [ebx + 12]
    mov     eax, [eax + edx*4]

    push    eax           
    push    edi            
    call    insert_into_set
    add     esp, 8

.skip_insert:
    inc     edx
    jmp     .loopA

.done:
    pop     edx
    pop     ecx
    pop     edi
    pop     esi
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret
