; ModuleID = 'probe5.1aca95070ec46e-cgu.0'
source_filename = "probe5.1aca95070ec46e-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@alloc_170584c489ae0e9fe2807ee469dbb21e = private unnamed_addr constant <{ [66 x i8] }> <{ [66 x i8] c"/builddir/build/BUILD/rustc-1.72.1-src/library/core/src/num/mod.rs" }>, align 1
@alloc_038affb91dab29788ef5cfa90b620028 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_170584c489ae0e9fe2807ee469dbb21e, [16 x i8] c"B\00\00\00\00\00\00\00w\04\00\00\05\00\00\00" }>, align 8
@str.0 = internal constant [25 x i8] c"attempt to divide by zero"

; probe5::probe
; Function Attrs: nonlazybind uwtable
define void @_ZN6probe55probe17hfc9c079ed57112f6E() unnamed_addr #0 {
start:
  %0 = call i1 @llvm.expect.i1(i1 false, i1 false)
  br i1 %0, label %panic.i, label %"_ZN4core3num21_$LT$impl$u20$u32$GT$10div_euclid17h458f5d88d33e6bc9E.exit"

panic.i:                                          ; preds = %start
; call core::panicking::panic
  call void @_ZN4core9panicking5panic17h2193f8fbbe16bdc6E(ptr align 1 @str.0, i64 25, ptr align 8 @alloc_038affb91dab29788ef5cfa90b620028) #3
  unreachable

"_ZN4core3num21_$LT$impl$u20$u32$GT$10div_euclid17h458f5d88d33e6bc9E.exit": ; preds = %start
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare i1 @llvm.expect.i1(i1, i1) #1

; core::panicking::panic
; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_ZN4core9panicking5panic17h2193f8fbbe16bdc6E(ptr align 1, i64, ptr align 8) unnamed_addr #2

attributes #0 = { nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(none) }
attributes #2 = { cold noinline noreturn nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #3 = { noreturn }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 2, !"RtLibUseGOT", i32 1}
