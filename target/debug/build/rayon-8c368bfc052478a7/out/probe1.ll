; ModuleID = 'probe1.49af9c0d38e45cc1-cgu.0'
source_filename = "probe1.49af9c0d38e45cc1-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"core::iter::adapters::rev::Rev<core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>>" = type { %"core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>" }
%"core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>" = type { { i32, i32 }, i64, i8, [7 x i8] }

@alloc_4aead6e2018a46d0df208d5729447de7 = private unnamed_addr constant <{ [27 x i8] }> <{ [27 x i8] c"assertion failed: step != 0" }>, align 1
@alloc_a43ae6220900ea89a579b97506e36c79 = private unnamed_addr constant <{ [80 x i8] }> <{ [80 x i8] c"/builddir/build/BUILD/rustc-1.72.1-src/library/core/src/iter/adapters/step_by.rs" }>, align 1
@alloc_56ed190acad03b21dd8d64d8ca577b7d = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_a43ae6220900ea89a579b97506e36c79, [16 x i8] c"P\00\00\00\00\00\00\00!\00\00\00\09\00\00\00" }>, align 8

; core::iter::traits::iterator::Iterator::rev
; Function Attrs: inlinehint nonlazybind uwtable
define void @_ZN4core4iter6traits8iterator8Iterator3rev17hfbc236b99618b680E(ptr sret(%"core::iter::adapters::rev::Rev<core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>>") %0, ptr %self) unnamed_addr #0 {
start:
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %0, ptr align 8 %self, i64 24, i1 false)
  ret void
}

; core::iter::traits::iterator::Iterator::step_by
; Function Attrs: inlinehint nonlazybind uwtable
define void @_ZN4core4iter6traits8iterator8Iterator7step_by17h33a2d2a5bd43a349E(ptr sret(%"core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>") %0, i32 %self.0, i32 %self.1, i64 %step) unnamed_addr #0 {
start:
; call core::iter::adapters::step_by::StepBy<I>::new
  call void @"_ZN4core4iter8adapters7step_by15StepBy$LT$I$GT$3new17h9005562f85cdb41dE"(ptr sret(%"core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>") %0, i32 %self.0, i32 %self.1, i64 %step)
  ret void
}

; core::iter::adapters::step_by::StepBy<I>::new
; Function Attrs: inlinehint nonlazybind uwtable
define void @"_ZN4core4iter8adapters7step_by15StepBy$LT$I$GT$3new17h9005562f85cdb41dE"(ptr sret(%"core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>") %0, i32 %iter.0, i32 %iter.1, i64 %step) unnamed_addr #0 personality ptr @rust_eh_personality {
start:
  %1 = alloca { ptr, i32 }, align 8
  %_10 = alloca i8, align 1
  store i8 1, ptr %_10, align 1
  %_4 = icmp ne i64 %step, 0
  %_3 = xor i1 %_4, true
  br i1 %_3, label %bb1, label %bb2

bb2:                                              ; preds = %start
  store i8 0, ptr %_10, align 1
; invoke <T as core::iter::adapters::step_by::SpecRangeSetup<T>>::setup
  %2 = invoke { i32, i32 } @"_ZN76_$LT$T$u20$as$u20$core..iter..adapters..step_by..SpecRangeSetup$LT$T$GT$$GT$5setup17ha6c060dc6bb458caE"(i32 %iter.0, i32 %iter.1, i64 %step)
          to label %bb3 unwind label %cleanup

bb1:                                              ; preds = %start
; invoke core::panicking::panic
  invoke void @_ZN4core9panicking5panic17h2193f8fbbe16bdc6E(ptr align 1 @alloc_4aead6e2018a46d0df208d5729447de7, i64 27, ptr align 8 @alloc_56ed190acad03b21dd8d64d8ca577b7d) #4
          to label %unreachable unwind label %cleanup

bb6:                                              ; preds = %cleanup
  %3 = load i8, ptr %_10, align 1, !range !2, !noundef !3
  %4 = trunc i8 %3 to i1
  br i1 %4, label %bb5, label %bb4

cleanup:                                          ; preds = %bb1, %bb2
  %5 = landingpad { ptr, i32 }
          cleanup
  %6 = extractvalue { ptr, i32 } %5, 0
  %7 = extractvalue { ptr, i32 } %5, 1
  %8 = getelementptr inbounds { ptr, i32 }, ptr %1, i32 0, i32 0
  store ptr %6, ptr %8, align 8
  %9 = getelementptr inbounds { ptr, i32 }, ptr %1, i32 0, i32 1
  store i32 %7, ptr %9, align 8
  br label %bb6

bb3:                                              ; preds = %bb2
  %iter.01 = extractvalue { i32, i32 } %2, 0
  %iter.12 = extractvalue { i32, i32 } %2, 1
  %_9 = sub i64 %step, 1
  %10 = getelementptr inbounds { i32, i32 }, ptr %0, i32 0, i32 0
  store i32 %iter.01, ptr %10, align 8
  %11 = getelementptr inbounds { i32, i32 }, ptr %0, i32 0, i32 1
  store i32 %iter.12, ptr %11, align 4
  %12 = getelementptr inbounds %"core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>", ptr %0, i32 0, i32 1
  store i64 %_9, ptr %12, align 8
  %13 = getelementptr inbounds %"core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>", ptr %0, i32 0, i32 2
  store i8 1, ptr %13, align 8
  ret void

unreachable:                                      ; preds = %bb1
  unreachable

bb4:                                              ; preds = %bb5, %bb6
  %14 = load ptr, ptr %1, align 8, !noundef !3
  %15 = getelementptr inbounds { ptr, i32 }, ptr %1, i32 0, i32 1
  %16 = load i32, ptr %15, align 8, !noundef !3
  %17 = insertvalue { ptr, i32 } poison, ptr %14, 0
  %18 = insertvalue { ptr, i32 } %17, i32 %16, 1
  resume { ptr, i32 } %18

bb5:                                              ; preds = %bb6
  br label %bb4
}

; <T as core::iter::adapters::step_by::SpecRangeSetup<T>>::setup
; Function Attrs: inlinehint nonlazybind uwtable
define { i32, i32 } @"_ZN76_$LT$T$u20$as$u20$core..iter..adapters..step_by..SpecRangeSetup$LT$T$GT$$GT$5setup17ha6c060dc6bb458caE"(i32 %inner.0, i32 %inner.1, i64 %_step) unnamed_addr #0 {
start:
  %0 = insertvalue { i32, i32 } poison, i32 %inner.0, 0
  %1 = insertvalue { i32, i32 } %0, i32 %inner.1, 1
  ret { i32, i32 } %1
}

; probe1::probe
; Function Attrs: nonlazybind uwtable
define void @_ZN6probe15probe17hcbb999270d381d33E() unnamed_addr #1 {
start:
  %_3 = alloca { i32, i32 }, align 4
  %_2 = alloca %"core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>", align 8
  %_1 = alloca %"core::iter::adapters::rev::Rev<core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>>", align 8
  store i32 0, ptr %_3, align 4
  %0 = getelementptr inbounds { i32, i32 }, ptr %_3, i32 0, i32 1
  store i32 10, ptr %0, align 4
  %1 = getelementptr inbounds { i32, i32 }, ptr %_3, i32 0, i32 0
  %2 = load i32, ptr %1, align 4, !noundef !3
  %3 = getelementptr inbounds { i32, i32 }, ptr %_3, i32 0, i32 1
  %4 = load i32, ptr %3, align 4, !noundef !3
; call core::iter::traits::iterator::Iterator::step_by
  call void @_ZN4core4iter6traits8iterator8Iterator7step_by17h33a2d2a5bd43a349E(ptr sret(%"core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>") %_2, i32 %2, i32 %4, i64 2)
; call core::iter::traits::iterator::Iterator::rev
  call void @_ZN4core4iter6traits8iterator8Iterator3rev17hfbc236b99618b680E(ptr sret(%"core::iter::adapters::rev::Rev<core::iter::adapters::step_by::StepBy<core::ops::range::Range<i32>>>") %_1, ptr %_2)
  ret void
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: nonlazybind uwtable
declare i32 @rust_eh_personality(i32, i32, i64, ptr, ptr) unnamed_addr #1

; core::panicking::panic
; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_ZN4core9panicking5panic17h2193f8fbbe16bdc6E(ptr align 1, i64, ptr align 8) unnamed_addr #3

attributes #0 = { inlinehint nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #1 = { nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #2 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { cold noinline noreturn nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #4 = { noreturn }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 2, !"RtLibUseGOT", i32 1}
!2 = !{i8 0, i8 2}
!3 = !{}
