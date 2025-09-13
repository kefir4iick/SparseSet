section .text
    global initialize_set
    global destroy_set
    global get_size_set
    global get_dense_ptr_set
    global get_sparse_ptr_set
    global get_capacity_set
    global get_maxVal_set

    extern malloc
    extern free

initialize_set:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    push    edx
    push    esi
    push    edi

    mov     esi, [ebp + 8]     
    mov     eax, [ebp + 12]     
    mov     ebx, [ebp + 16]     

    mov     [esi + 0], eax      
    mov     [esi + 4], ebx      

    mov     dword [esi + 8], 0  

    mov     ecx, ebx
    shl     ecx, 2              
    push    ecx
    call    malloc
    add     esp, 4
    test    eax, eax
    jz      .malloc_fail_early
    mov     [esi + 12], eax     

    mov     ecx, [esi + 0]      
    inc     ecx                 
    shl     ecx, 2              
    push    ecx
    call    malloc
    add     esp, 4
    test    eax, eax
    jz      .malloc_sparse_failed
    mov     [esi + 16], eax     

    cld                         
    mov     edi, eax            
    mov     ecx, [esi + 0]     
    inc     ecx                 
    mov     eax, 0xFFFFFFFF     
    rep     stosd              

    mov     eax, 1
    jmp     .done

.malloc_sparse_failed:
    mov     eax, [esi + 12]
    test    eax, eax
    jz      .malloc_fail_early2
    push    eax
    call    free
    add     esp, 4

.malloc_fail_early2:
    mov     dword [esi + 12], 0
    mov     dword [esi + 16], 0
    mov     dword [esi + 8], 0
    xor     eax, eax
    jmp     .cleanup_and_return

.malloc_fail_early:
    mov     dword [esi + 12], 0
    mov     dword [esi + 16], 0
    mov     dword [esi + 8], 0
    xor     eax, eax
    jmp     .cleanup_and_return
    
.cleanup_and_return:
    pop     edi
    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret

.done:
    pop     edi
    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret

destroy_set:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    push    edx

    mov     ebx, [ebp + 8]    

    mov     eax, [ebx + 12]     
    test    eax, eax
    jz      .no_dense_to_free
    push    eax
    call    free
    add     esp, 4

.no_dense_to_free:
    mov     eax, [ebx + 16]     
    test    eax, eax
    jz      .no_sparse_to_free
    push    eax
    call    free
    add     esp, 4

.no_sparse_to_free:
    mov     dword [ebx + 0], 0
    mov     dword [ebx + 4], 0
    mov     dword [ebx + 8], 0
    mov     dword [ebx + 12], 0
    mov     dword [ebx + 16], 0

    mov     eax, 0

    pop     edx
    pop     ecx
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret

get_size_set:
    push    ebp
    mov     ebp, esp
    mov     eax, [ebp + 8]      
    mov     eax, [eax + 8]      
    mov     esp, ebp
    pop     ebp
    ret

get_dense_ptr_set:
    push    ebp
    mov     ebp, esp
    mov     eax, [ebp + 8]
    mov     eax, [eax + 12]     
    mov     esp, ebp
    pop     ebp
    ret

get_sparse_ptr_set:
    push    ebp
    mov     ebp, esp
    mov     eax, [ebp + 8]
    mov     eax, [eax + 16]     
    mov     esp, ebp
    pop     ebp
    ret

get_capacity_set:
    push    ebp
    mov     ebp, esp
    mov     eax, [ebp + 8]
    mov     eax, [eax + 4]      
    mov     esp, ebp
    pop     ebp
    ret

get_maxVal_set:
    push    ebp
    mov     ebp, esp
    mov     eax, [ebp + 8]
    mov     eax, [eax + 0]      
    mov     esp, ebp
    pop     ebp
    ret
