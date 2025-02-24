; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --force-update
; DO NOT EDIT -- This file was generated from test/CodeGen/CHERI-Generic/Inputs/optsize-preserve-tags-memcpy-crash.ll
; RUN: llc -mtriple=riscv32 --relocation-model=pic -target-abi il32pc64f -mattr=+xcheri,+cap-mode,+f < %s -o - | FileCheck %s
; The following code copying 31 bytes (with capability alignment) using the
; must_preserve_tags attribute used to trigger a "(Align < CapSize)" assertion
; inside diagnoseInefficientCheriMemOp() when compiling with -Oz.
; This function should not be called since the reason we are falling back to memcpy
; is that the load/store limit is reached (and not the alignment).
; However, the code was checking for limit reached using a simple `(CapSize * Limit) < Size`
; check which fails here since the last 15 bytes need four (8 + 4 + 2 + 1 bytes) copies on
; architectures where LLVM does not emit misaligned loads/stores.

define hidden void @optnone_preserve_tags_memcpy(i8 addrspace(200)* %dst, i8 addrspace(200)* %src) optnone noinline nounwind {
; CHECK-LABEL: optnone_preserve_tags_memcpy:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    clb a2, 30(ca1)
; CHECK-NEXT:    csb a2, 30(ca0)
; CHECK-NEXT:    clh a2, 28(ca1)
; CHECK-NEXT:    csh a2, 28(ca0)
; CHECK-NEXT:    clw a2, 24(ca1)
; CHECK-NEXT:    csw a2, 24(ca0)
; CHECK-NEXT:    clc ca2, 16(ca1)
; CHECK-NEXT:    csc ca2, 16(ca0)
; CHECK-NEXT:    clc ca2, 8(ca1)
; CHECK-NEXT:    csc ca2, 8(ca0)
; CHECK-NEXT:    clc ca1, 0(ca1)
; CHECK-NEXT:    csc ca1, 0(ca0)
; CHECK-NEXT:    cret
bb:
  tail call void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* noundef nonnull align 16 dereferenceable(31) %dst, i8 addrspace(200)* noundef nonnull align 16 dereferenceable(31) %src, i64 31, i1 false) must_preserve_cheri_tags
  ret void
}

define hidden void @optsize_preserve_tags_memcpy(i8 addrspace(200)* %dst, i8 addrspace(200)* %src) optsize nounwind {
; CHECK-LABEL: optsize_preserve_tags_memcpy:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    cincoffset csp, csp, -16
; CHECK-NEXT:    csc cra, 8(csp) # 8-byte Folded Spill
; CHECK-NEXT:    addi a2, zero, 31
; CHECK-NEXT:    mv a3, zero
; CHECK-NEXT:    ccall memcpy
; CHECK-NEXT:    clc cra, 8(csp) # 8-byte Folded Reload
; CHECK-NEXT:    cincoffset csp, csp, 16
; CHECK-NEXT:    cret
bb:
  tail call void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* noundef nonnull align 16 dereferenceable(31) %dst, i8 addrspace(200)* noundef nonnull align 16 dereferenceable(31) %src, i64 31, i1 false) must_preserve_cheri_tags
  ret void
}

define hidden void @default_preserve_tags_memcpy(i8 addrspace(200)* %dst, i8 addrspace(200)* %src) nounwind {
; CHECK-LABEL: default_preserve_tags_memcpy:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    clb a2, 30(ca1)
; CHECK-NEXT:    csb a2, 30(ca0)
; CHECK-NEXT:    clh a2, 28(ca1)
; CHECK-NEXT:    csh a2, 28(ca0)
; CHECK-NEXT:    clw a2, 24(ca1)
; CHECK-NEXT:    csw a2, 24(ca0)
; CHECK-NEXT:    clc ca2, 16(ca1)
; CHECK-NEXT:    csc ca2, 16(ca0)
; CHECK-NEXT:    clc ca2, 8(ca1)
; CHECK-NEXT:    csc ca2, 8(ca0)
; CHECK-NEXT:    clc ca1, 0(ca1)
; CHECK-NEXT:    csc ca1, 0(ca0)
; CHECK-NEXT:    cret
bb:
  tail call void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* noundef nonnull align 16 dereferenceable(31) %dst, i8 addrspace(200)* noundef nonnull align 16 dereferenceable(31) %src, i64 31, i1 false) must_preserve_cheri_tags
  ret void
}

define hidden void @optnone_preserve_tags_memmove(i8 addrspace(200)* %dst, i8 addrspace(200)* %src) optnone noinline nounwind {
; CHECK-LABEL: optnone_preserve_tags_memmove:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    clc ca6, 0(ca1)
; CHECK-NEXT:    clc ca3, 8(ca1)
; CHECK-NEXT:    clc ca4, 16(ca1)
; CHECK-NEXT:    clw a5, 24(ca1)
; CHECK-NEXT:    clh a2, 28(ca1)
; CHECK-NEXT:    clb a1, 30(ca1)
; CHECK-NEXT:    csb a1, 30(ca0)
; CHECK-NEXT:    csh a2, 28(ca0)
; CHECK-NEXT:    csw a5, 24(ca0)
; CHECK-NEXT:    csc ca4, 16(ca0)
; CHECK-NEXT:    csc ca3, 8(ca0)
; CHECK-NEXT:    csc ca6, 0(ca0)
; CHECK-NEXT:    cret
bb:
  tail call void @llvm.memmove.p200i8.p200i8.i64(i8 addrspace(200)* noundef nonnull align 16 dereferenceable(31) %dst, i8 addrspace(200)* noundef nonnull align 16 dereferenceable(31) %src, i64 31, i1 false) must_preserve_cheri_tags
  ret void
}

define hidden void @optsize_preserve_tags_memmove(i8 addrspace(200)* %dst, i8 addrspace(200)* %src) optsize nounwind {
; CHECK-LABEL: optsize_preserve_tags_memmove:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    cincoffset csp, csp, -16
; CHECK-NEXT:    csc cra, 8(csp) # 8-byte Folded Spill
; CHECK-NEXT:    addi a2, zero, 31
; CHECK-NEXT:    mv a3, zero
; CHECK-NEXT:    ccall memmove
; CHECK-NEXT:    clc cra, 8(csp) # 8-byte Folded Reload
; CHECK-NEXT:    cincoffset csp, csp, 16
; CHECK-NEXT:    cret
bb:
  tail call void @llvm.memmove.p200i8.p200i8.i64(i8 addrspace(200)* noundef nonnull align 16 dereferenceable(31) %dst, i8 addrspace(200)* noundef nonnull align 16 dereferenceable(31) %src, i64 31, i1 false) must_preserve_cheri_tags
  ret void
}

define hidden void @default_preserve_tags_memmove(i8 addrspace(200)* %dst, i8 addrspace(200)* %src) nounwind{
; CHECK-LABEL: default_preserve_tags_memmove:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    clw a6, 24(ca1)
; CHECK-NEXT:    clc ca3, 0(ca1)
; CHECK-NEXT:    clh a4, 28(ca1)
; CHECK-NEXT:    clb a5, 30(ca1)
; CHECK-NEXT:    clc ca2, 16(ca1)
; CHECK-NEXT:    csc ca3, 0(ca0)
; CHECK-NEXT:    clc ca1, 8(ca1)
; CHECK-NEXT:    csc ca1, 8(ca0)
; CHECK-NEXT:    csc ca2, 16(ca0)
; CHECK-NEXT:    csb a5, 30(ca0)
; CHECK-NEXT:    csh a4, 28(ca0)
; CHECK-NEXT:    csw a6, 24(ca0)
; CHECK-NEXT:    cret
bb:
  tail call void @llvm.memmove.p200i8.p200i8.i64(i8 addrspace(200)* noundef nonnull align 16 dereferenceable(31) %dst, i8 addrspace(200)* noundef nonnull align 16 dereferenceable(31) %src, i64 31, i1 false) must_preserve_cheri_tags
  ret void
}

declare void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* noalias nocapture writeonly, i8 addrspace(200)* noalias nocapture readonly, i64, i1 immarg) addrspace(200)
declare void @llvm.memmove.p200i8.p200i8.i64(i8 addrspace(200)* noalias nocapture writeonly, i8 addrspace(200)* noalias nocapture readonly, i64, i1 immarg) addrspace(200)
