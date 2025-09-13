section .text
global issubset_sets
extern contains_in_set

issubset_sets:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    esi
    push    ecx
    push    edx

    mov     ebx, [ebp+8]    
    mov     esi, [ebp+12]   

    mov     ecx, [ebx + 8]  
    xor     edx, edx        

.loopA:
    cmp     edx, ecx
    jae     .all_included

    mov     eax, [ebx + 12] 
    mov     eax, [eax + edx*4]  

    push    eax             
    push    esi             
    call    contains_in_set
    add     esp, 8
    test    eax, eax
    jz      .not_subset

    inc     edx
    jmp     .loopA

.all_included:
    mov     eax, 1
    jmp     .cleanup

.not_subset:
    xor     eax, eax

.cleanup:
    pop     edx
    pop     ecx
    pop     esi
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret
