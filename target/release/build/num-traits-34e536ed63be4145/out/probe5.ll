; ModuleID = 'probe5.3a1fbbbh-cgu.0'
source_filename = "probe5.3a1fbbbh-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"std::panic::Location" = type { [0 x i64], { [0 x i8]*, i64 }, [0 x i32], i32, [0 x i32], i32, [0 x i32] }

@alloc0 = private unnamed_addr constant <{ [75 x i8] }> <{ [75 x i8] c"/rustc/e4a60327063e82413eed50a10df3b7d19b77bda0/library/core/src/num/mod.rs" }>, align 1
@alloc1 = private unnamed_addr constant <{ i8*, [16 x i8] }> <{ i8* getelementptr inbounds (<{ [75 x i8] }>, <{ [75 x i8] }>* @alloc0, i32 0, i32 0, i32 0), [16 x i8] c"K\00\00\00\00\00\00\00\BC\02\00\00\05\00\00\00" }>, align 8
@str.0 = internal constant [25 x i8] c"attempt to divide by zero"

; probe5::probe
; Function Attrs: nonlazybind uwtable
define void @_ZN6probe55probe17h2d3453a7a66d8041E() unnamed_addr #0 {
start:
  %0 = call i1 @llvm.expect.i1(i1 false, i1 false)
  br i1 %0, label %panic.i, label %"_ZN4core3num21_$LT$impl$u20$u32$GT$10div_euclid17h02db00206118eca0E.exit"

panic.i:                                          ; preds = %start
; call core::panicking::panic
  call void @_ZN4core9panicking5panic17h3de4db67bd397eb3E([0 x i8]* nonnull align 1 bitcast ([25 x i8]* @str.0 to [0 x i8]*), i64 25, %"std::panic::Location"* align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @alloc1 to %"std::panic::Location"*))
  unreachable

"_ZN4core3num21_$LT$impl$u20$u32$GT$10div_euclid17h02db00206118eca0E.exit": ; preds = %start
  br label %bb1

bb1:                                              ; preds = %"_ZN4core3num21_$LT$impl$u20$u32$GT$10div_euclid17h02db00206118eca0E.exit"
  ret void
}

; Function Attrs: nofree nosync nounwind readnone willreturn
declare i1 @llvm.expect.i1(i1, i1) #1

; core::panicking::panic
; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_ZN4core9panicking5panic17h3de4db67bd397eb3E([0 x i8]* nonnull align 1, i64, %"std::panic::Location"* align 8 dereferenceable(24)) unnamed_addr #2

attributes #0 = { nonlazybind uwtable "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #1 = { nofree nosync nounwind readnone willreturn }
attributes #2 = { cold noinline noreturn nonlazybind uwtable "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 7, !"PIC Level", i32 2}
!1 = !{i32 2, !"RtLibUseGOT", i32 1}
