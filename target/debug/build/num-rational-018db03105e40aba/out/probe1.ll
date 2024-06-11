; ModuleID = 'probe1.49af9c0d38e45cc1-cgu.0'
source_filename = "probe1.49af9c0d38e45cc1-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"core::fmt::Arguments<'_>" = type { { ptr, i64 }, { ptr, i64 }, { ptr, i64 } }
%"alloc::string::String" = type { %"alloc::vec::Vec<u8>" }
%"alloc::vec::Vec<u8>" = type { { ptr, i64 }, i64 }
%"core::ptr::metadata::PtrRepr<[u8]>" = type { [2 x i64] }
%"alloc::alloc::Global" = type {}
%"core::option::Option<(core::ptr::non_null::NonNull<u8>, core::alloc::layout::Layout)>" = type { [1 x i64], i64, [1 x i64] }

@alloc_2a62ba4d4fa46537b277796d74f8c568 = private unnamed_addr constant <{}> zeroinitializer, align 8
@alloc_91c7fa63c3cfeaa3c795652d5cf060e4 = private unnamed_addr constant <{ [12 x i8] }> <{ [12 x i8] c"invalid args" }>, align 1
@alloc_560206a49c61adca6f3f0639a12632eb = private unnamed_addr constant <{ ptr, [8 x i8] }> <{ ptr @alloc_91c7fa63c3cfeaa3c795652d5cf060e4, [8 x i8] c"\0C\00\00\00\00\00\00\00" }>, align 8
@alloc_d8903244a5ce2223171f09ce435d6272 = private unnamed_addr constant <{ [66 x i8] }> <{ [66 x i8] c"/builddir/build/BUILD/rustc-1.72.1-src/library/core/src/fmt/mod.rs" }>, align 1
@alloc_0fea811f0f3290777012925a19edf2fb = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_d8903244a5ce2223171f09ce435d6272, [16 x i8] c"B\00\00\00\00\00\00\005\01\00\00\0D\00\00\00" }>, align 8
@alloc_99abb1372b949f64f5a35bb418a4f0bf = private unnamed_addr constant <{ [71 x i8] }> <{ [71 x i8] c"/builddir/build/BUILD/rustc-1.72.1-src/library/core/src/alloc/layout.rs" }>, align 1
@alloc_2eb7ede3ecfb650804281cb383103c27 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_99abb1372b949f64f5a35bb418a4f0bf, [16 x i8] c"G\00\00\00\00\00\00\00\BF\01\00\00)\00\00\00" }>, align 8
@str.0 = internal constant [25 x i8] c"attempt to divide by zero"
@__rust_no_alloc_shim_is_unstable = external global i8
@alloc_ffa3cdb3ae88e54a1cc225f31dd07672 = private unnamed_addr constant <{ ptr, [8 x i8] }> <{ ptr @alloc_2a62ba4d4fa46537b277796d74f8c568, [8 x i8] zeroinitializer }>, align 8
@alloc_53973d2fe29b4adba8bb7390b5678745 = private unnamed_addr constant <{ [8 x i8] }> zeroinitializer, align 8

; core::fmt::Arguments::as_str
; Function Attrs: inlinehint nonlazybind uwtable
define internal { ptr, i64 } @_ZN4core3fmt9Arguments6as_str17h88ec003ec7ecf0c9E(ptr align 8 %self) unnamed_addr #0 {
start:
  %_2 = alloca { { ptr, i64 }, { ptr, i64 } }, align 8
  %0 = alloca { ptr, i64 }, align 8
  %1 = getelementptr inbounds { ptr, i64 }, ptr %self, i32 0, i32 0
  %_3.0 = load ptr, ptr %1, align 8, !nonnull !2, !align !3, !noundef !2
  %2 = getelementptr inbounds { ptr, i64 }, ptr %self, i32 0, i32 1
  %_3.1 = load i64, ptr %2, align 8, !noundef !2
  %3 = getelementptr inbounds %"core::fmt::Arguments<'_>", ptr %self, i32 0, i32 1
  %4 = getelementptr inbounds { ptr, i64 }, ptr %3, i32 0, i32 0
  %_4.0 = load ptr, ptr %4, align 8, !nonnull !2, !align !3, !noundef !2
  %5 = getelementptr inbounds { ptr, i64 }, ptr %3, i32 0, i32 1
  %_4.1 = load i64, ptr %5, align 8, !noundef !2
  %6 = getelementptr inbounds { ptr, i64 }, ptr %_2, i32 0, i32 0
  store ptr %_3.0, ptr %6, align 8
  %7 = getelementptr inbounds { ptr, i64 }, ptr %_2, i32 0, i32 1
  store i64 %_3.1, ptr %7, align 8
  %8 = getelementptr inbounds { { ptr, i64 }, { ptr, i64 } }, ptr %_2, i32 0, i32 1
  %9 = getelementptr inbounds { ptr, i64 }, ptr %8, i32 0, i32 0
  store ptr %_4.0, ptr %9, align 8
  %10 = getelementptr inbounds { ptr, i64 }, ptr %8, i32 0, i32 1
  store i64 %_4.1, ptr %10, align 8
  %11 = getelementptr inbounds { ptr, i64 }, ptr %_2, i32 0, i32 0
  %_19.0 = load ptr, ptr %11, align 8, !nonnull !2, !align !3, !noundef !2
  %12 = getelementptr inbounds { ptr, i64 }, ptr %_2, i32 0, i32 1
  %_19.1 = load i64, ptr %12, align 8, !noundef !2
  %_16 = icmp eq i64 %_19.1, 0
  br i1 %_16, label %bb1, label %bb3

bb3:                                              ; preds = %start
  %13 = getelementptr inbounds { ptr, i64 }, ptr %_2, i32 0, i32 0
  %_21.0 = load ptr, ptr %13, align 8, !nonnull !2, !align !3, !noundef !2
  %14 = getelementptr inbounds { ptr, i64 }, ptr %_2, i32 0, i32 1
  %_21.1 = load i64, ptr %14, align 8, !noundef !2
  %_13 = icmp eq i64 %_21.1, 1
  br i1 %_13, label %bb4, label %bb2

bb1:                                              ; preds = %start
  %15 = getelementptr inbounds { { ptr, i64 }, { ptr, i64 } }, ptr %_2, i32 0, i32 1
  %16 = getelementptr inbounds { ptr, i64 }, ptr %15, i32 0, i32 0
  %_20.0 = load ptr, ptr %16, align 8, !nonnull !2, !align !3, !noundef !2
  %17 = getelementptr inbounds { ptr, i64 }, ptr %15, i32 0, i32 1
  %_20.1 = load i64, ptr %17, align 8, !noundef !2
  %_7 = icmp eq i64 %_20.1, 0
  br i1 %_7, label %bb5, label %bb2

bb2:                                              ; preds = %bb1, %bb4, %bb3
  store ptr null, ptr %0, align 8
  br label %bb7

bb4:                                              ; preds = %bb3
  %18 = getelementptr inbounds { { ptr, i64 }, { ptr, i64 } }, ptr %_2, i32 0, i32 1
  %19 = getelementptr inbounds { ptr, i64 }, ptr %18, i32 0, i32 0
  %_22.0 = load ptr, ptr %19, align 8, !nonnull !2, !align !3, !noundef !2
  %20 = getelementptr inbounds { ptr, i64 }, ptr %18, i32 0, i32 1
  %_22.1 = load i64, ptr %20, align 8, !noundef !2
  %_10 = icmp eq i64 %_22.1, 0
  br i1 %_10, label %bb6, label %bb2

bb6:                                              ; preds = %bb4
  %21 = getelementptr inbounds { ptr, i64 }, ptr %_2, i32 0, i32 0
  %_23.0 = load ptr, ptr %21, align 8, !nonnull !2, !align !3, !noundef !2
  %22 = getelementptr inbounds { ptr, i64 }, ptr %_2, i32 0, i32 1
  %_23.1 = load i64, ptr %22, align 8, !noundef !2
  %s = getelementptr inbounds [0 x { ptr, i64 }], ptr %_23.0, i64 0, i64 0
  %23 = getelementptr inbounds { ptr, i64 }, ptr %s, i32 0, i32 0
  %_24.0 = load ptr, ptr %23, align 8, !nonnull !2, !align !4, !noundef !2
  %24 = getelementptr inbounds { ptr, i64 }, ptr %s, i32 0, i32 1
  %_24.1 = load i64, ptr %24, align 8, !noundef !2
  %25 = getelementptr inbounds { ptr, i64 }, ptr %0, i32 0, i32 0
  store ptr %_24.0, ptr %25, align 8
  %26 = getelementptr inbounds { ptr, i64 }, ptr %0, i32 0, i32 1
  store i64 %_24.1, ptr %26, align 8
  br label %bb7

bb7:                                              ; preds = %bb5, %bb2, %bb6
  %27 = getelementptr inbounds { ptr, i64 }, ptr %0, i32 0, i32 0
  %28 = load ptr, ptr %27, align 8, !align !4, !noundef !2
  %29 = getelementptr inbounds { ptr, i64 }, ptr %0, i32 0, i32 1
  %30 = load i64, ptr %29, align 8
  %31 = insertvalue { ptr, i64 } poison, ptr %28, 0
  %32 = insertvalue { ptr, i64 } %31, i64 %30, 1
  ret { ptr, i64 } %32

bb5:                                              ; preds = %bb1
  %33 = getelementptr inbounds { ptr, i64 }, ptr %0, i32 0, i32 0
  store ptr @alloc_2a62ba4d4fa46537b277796d74f8c568, ptr %33, align 8
  %34 = getelementptr inbounds { ptr, i64 }, ptr %0, i32 0, i32 1
  store i64 0, ptr %34, align 8
  br label %bb7
}

; core::fmt::Arguments::new_v1
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN4core3fmt9Arguments6new_v117ha5db560f608cab3bE(ptr sret(%"core::fmt::Arguments<'_>") %0, ptr align 8 %pieces.0, i64 %pieces.1, ptr align 8 %args.0, i64 %args.1) unnamed_addr #0 {
start:
  %_16 = alloca { ptr, i64 }, align 8
  %_14 = alloca { ptr, i64 }, align 8
  %_12 = alloca %"core::fmt::Arguments<'_>", align 8
  %_3 = alloca i8, align 1
  %_4 = icmp ult i64 %pieces.1, %args.1
  br i1 %_4, label %bb1, label %bb2

bb2:                                              ; preds = %start
  %_9 = add i64 %args.1, 1
  %_7 = icmp ugt i64 %pieces.1, %_9
  %1 = zext i1 %_7 to i8
  store i8 %1, ptr %_3, align 1
  br label %bb3

bb1:                                              ; preds = %start
  store i8 1, ptr %_3, align 1
  br label %bb3

bb3:                                              ; preds = %bb1, %bb2
  %2 = load i8, ptr %_3, align 1, !range !5, !noundef !2
  %3 = trunc i8 %2 to i1
  br i1 %3, label %bb4, label %bb5

bb5:                                              ; preds = %bb3
  store ptr null, ptr %_14, align 8
  %4 = getelementptr inbounds { ptr, i64 }, ptr %0, i32 0, i32 0
  store ptr %pieces.0, ptr %4, align 8
  %5 = getelementptr inbounds { ptr, i64 }, ptr %0, i32 0, i32 1
  store i64 %pieces.1, ptr %5, align 8
  %6 = getelementptr inbounds { ptr, i64 }, ptr %_14, i32 0, i32 0
  %7 = load ptr, ptr %6, align 8, !align !3, !noundef !2
  %8 = getelementptr inbounds { ptr, i64 }, ptr %_14, i32 0, i32 1
  %9 = load i64, ptr %8, align 8
  %10 = getelementptr inbounds %"core::fmt::Arguments<'_>", ptr %0, i32 0, i32 2
  %11 = getelementptr inbounds { ptr, i64 }, ptr %10, i32 0, i32 0
  store ptr %7, ptr %11, align 8
  %12 = getelementptr inbounds { ptr, i64 }, ptr %10, i32 0, i32 1
  store i64 %9, ptr %12, align 8
  %13 = getelementptr inbounds %"core::fmt::Arguments<'_>", ptr %0, i32 0, i32 1
  %14 = getelementptr inbounds { ptr, i64 }, ptr %13, i32 0, i32 0
  store ptr %args.0, ptr %14, align 8
  %15 = getelementptr inbounds { ptr, i64 }, ptr %13, i32 0, i32 1
  store i64 %args.1, ptr %15, align 8
  ret void

bb4:                                              ; preds = %bb3
  store ptr null, ptr %_16, align 8
  %16 = getelementptr inbounds { ptr, i64 }, ptr %_12, i32 0, i32 0
  store ptr @alloc_560206a49c61adca6f3f0639a12632eb, ptr %16, align 8
  %17 = getelementptr inbounds { ptr, i64 }, ptr %_12, i32 0, i32 1
  store i64 1, ptr %17, align 8
  %18 = getelementptr inbounds { ptr, i64 }, ptr %_16, i32 0, i32 0
  %19 = load ptr, ptr %18, align 8, !align !3, !noundef !2
  %20 = getelementptr inbounds { ptr, i64 }, ptr %_16, i32 0, i32 1
  %21 = load i64, ptr %20, align 8
  %22 = getelementptr inbounds %"core::fmt::Arguments<'_>", ptr %_12, i32 0, i32 2
  %23 = getelementptr inbounds { ptr, i64 }, ptr %22, i32 0, i32 0
  store ptr %19, ptr %23, align 8
  %24 = getelementptr inbounds { ptr, i64 }, ptr %22, i32 0, i32 1
  store i64 %21, ptr %24, align 8
  %25 = getelementptr inbounds %"core::fmt::Arguments<'_>", ptr %_12, i32 0, i32 1
  %26 = getelementptr inbounds { ptr, i64 }, ptr %25, i32 0, i32 0
  store ptr @alloc_2a62ba4d4fa46537b277796d74f8c568, ptr %26, align 8
  %27 = getelementptr inbounds { ptr, i64 }, ptr %25, i32 0, i32 1
  store i64 0, ptr %27, align 8
; call core::panicking::panic_fmt
  call void @_ZN4core9panicking9panic_fmt17h8cf040903fbd6815E(ptr %_12, ptr align 8 @alloc_0fea811f0f3290777012925a19edf2fb) #12
  unreachable
}

; core::ops::function::FnOnce::call_once
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN4core3ops8function6FnOnce9call_once17h71f222674f3eba1dE(ptr sret(%"alloc::string::String") %0, ptr align 1 %1, i64 %2) unnamed_addr #0 {
start:
  %_2 = alloca { ptr, i64 }, align 8
  %3 = getelementptr inbounds { ptr, i64 }, ptr %_2, i32 0, i32 0
  store ptr %1, ptr %3, align 8
  %4 = getelementptr inbounds { ptr, i64 }, ptr %_2, i32 0, i32 1
  store i64 %2, ptr %4, align 8
  %5 = getelementptr inbounds { ptr, i64 }, ptr %_2, i32 0, i32 0
  %6 = load ptr, ptr %5, align 8, !nonnull !2, !align !4, !noundef !2
  %7 = getelementptr inbounds { ptr, i64 }, ptr %_2, i32 0, i32 1
  %8 = load i64, ptr %7, align 8, !noundef !2
; call alloc::str::<impl alloc::borrow::ToOwned for str>::to_owned
  call void @"_ZN5alloc3str56_$LT$impl$u20$alloc..borrow..ToOwned$u20$for$u20$str$GT$8to_owned17h2c700728a67ffecaE"(ptr sret(%"alloc::string::String") %0, ptr align 1 %6, i64 %8)
  ret void
}

; core::ptr::drop_in_place<alloc::string::String>
; Function Attrs: nonlazybind uwtable
define void @"_ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h6070ef0a1b5c9d63E"(ptr align 8 %_1) unnamed_addr #1 {
start:
; call core::ptr::drop_in_place<alloc::vec::Vec<u8>>
  call void @"_ZN4core3ptr46drop_in_place$LT$alloc..vec..Vec$LT$u8$GT$$GT$17heecea49e0ba5b0d3E"(ptr align 8 %_1)
  ret void
}

; core::ptr::drop_in_place<alloc::vec::Vec<u8>>
; Function Attrs: nonlazybind uwtable
define void @"_ZN4core3ptr46drop_in_place$LT$alloc..vec..Vec$LT$u8$GT$$GT$17heecea49e0ba5b0d3E"(ptr align 8 %_1) unnamed_addr #1 personality ptr @rust_eh_personality {
start:
  %0 = alloca { ptr, i32 }, align 8
; invoke <alloc::vec::Vec<T,A> as core::ops::drop::Drop>::drop
  invoke void @"_ZN70_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h875950b1b8273404E"(ptr align 8 %_1)
          to label %bb4 unwind label %cleanup

bb3:                                              ; preds = %cleanup
; invoke core::ptr::drop_in_place<alloc::raw_vec::RawVec<u8>>
  invoke void @"_ZN4core3ptr53drop_in_place$LT$alloc..raw_vec..RawVec$LT$u8$GT$$GT$17he3f0c680d8327335E"(ptr align 8 %_1) #13
          to label %bb1 unwind label %terminate

cleanup:                                          ; preds = %start
  %1 = landingpad { ptr, i32 }
          cleanup
  %2 = extractvalue { ptr, i32 } %1, 0
  %3 = extractvalue { ptr, i32 } %1, 1
  %4 = getelementptr inbounds { ptr, i32 }, ptr %0, i32 0, i32 0
  store ptr %2, ptr %4, align 8
  %5 = getelementptr inbounds { ptr, i32 }, ptr %0, i32 0, i32 1
  store i32 %3, ptr %5, align 8
  br label %bb3

bb4:                                              ; preds = %start
; call core::ptr::drop_in_place<alloc::raw_vec::RawVec<u8>>
  call void @"_ZN4core3ptr53drop_in_place$LT$alloc..raw_vec..RawVec$LT$u8$GT$$GT$17he3f0c680d8327335E"(ptr align 8 %_1)
  ret void

terminate:                                        ; preds = %bb3
  %6 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
  %7 = extractvalue { ptr, i32 } %6, 0
  %8 = extractvalue { ptr, i32 } %6, 1
; call core::panicking::panic_cannot_unwind
  call void @_ZN4core9panicking19panic_cannot_unwind17h4e1d030604f42bd5E() #14
  unreachable

bb1:                                              ; preds = %bb3
  %9 = load ptr, ptr %0, align 8, !noundef !2
  %10 = getelementptr inbounds { ptr, i32 }, ptr %0, i32 0, i32 1
  %11 = load i32, ptr %10, align 8, !noundef !2
  %12 = insertvalue { ptr, i32 } poison, ptr %9, 0
  %13 = insertvalue { ptr, i32 } %12, i32 %11, 1
  resume { ptr, i32 } %13
}

; core::ptr::drop_in_place<alloc::raw_vec::RawVec<u8>>
; Function Attrs: nonlazybind uwtable
define void @"_ZN4core3ptr53drop_in_place$LT$alloc..raw_vec..RawVec$LT$u8$GT$$GT$17he3f0c680d8327335E"(ptr align 8 %_1) unnamed_addr #1 {
start:
; call <alloc::raw_vec::RawVec<T,A> as core::ops::drop::Drop>::drop
  call void @"_ZN77_$LT$alloc..raw_vec..RawVec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17hecadc9e4d5d158b8E"(ptr align 8 %_1)
  ret void
}

; core::alloc::layout::Layout::array::inner
; Function Attrs: inlinehint nonlazybind uwtable
define internal { i64, i64 } @_ZN4core5alloc6layout6Layout5array5inner17hbcf6a2c2884d3b80E(i64 %element_size, i64 %align, i64 %n) unnamed_addr #0 {
start:
  %_20 = alloca i64, align 8
  %_15 = alloca i64, align 8
  %_10 = alloca { i64, i64 }, align 8
  %_4 = alloca i8, align 1
  %0 = alloca { i64, i64 }, align 8
  %1 = icmp eq i64 %element_size, 0
  br i1 %1, label %bb1, label %bb2

bb1:                                              ; preds = %start
  store i8 0, ptr %_4, align 1
  br label %bb3

bb2:                                              ; preds = %start
  store i64 %align, ptr %_15, align 8
  %_16 = load i64, ptr %_15, align 8, !range !6, !noundef !2
  %_17 = icmp uge i64 %_16, 1
  %_18 = icmp ule i64 %_16, -9223372036854775808
  %_19 = and i1 %_17, %_18
  call void @llvm.assume(i1 %_19)
  %_13 = sub i64 %_16, 1
  %_7 = sub i64 9223372036854775807, %_13
  %_8 = icmp eq i64 %element_size, 0
  %2 = call i1 @llvm.expect.i1(i1 %_8, i1 false)
  br i1 %2, label %panic, label %bb4

bb3:                                              ; preds = %bb4, %bb1
  %3 = load i8, ptr %_4, align 1, !range !5, !noundef !2
  %4 = trunc i8 %3 to i1
  br i1 %4, label %bb5, label %bb6

bb4:                                              ; preds = %bb2
  %_6 = udiv i64 %_7, %element_size
  %_5 = icmp ugt i64 %n, %_6
  %5 = zext i1 %_5 to i8
  store i8 %5, ptr %_4, align 1
  br label %bb3

panic:                                            ; preds = %bb2
; call core::panicking::panic
  call void @_ZN4core9panicking5panic17h2193f8fbbe16bdc6E(ptr align 1 @str.0, i64 25, ptr align 8 @alloc_2eb7ede3ecfb650804281cb383103c27) #12
  unreachable

bb6:                                              ; preds = %bb3
  %array_size = mul i64 %element_size, %n
  store i64 %align, ptr %_20, align 8
  %_21 = load i64, ptr %_20, align 8, !range !6, !noundef !2
  %_22 = icmp uge i64 %_21, 1
  %_23 = icmp ule i64 %_21, -9223372036854775808
  %_24 = and i1 %_22, %_23
  call void @llvm.assume(i1 %_24)
  %6 = getelementptr inbounds { i64, i64 }, ptr %_10, i32 0, i32 1
  store i64 %array_size, ptr %6, align 8
  store i64 %_21, ptr %_10, align 8
  %7 = getelementptr inbounds { i64, i64 }, ptr %_10, i32 0, i32 0
  %8 = load i64, ptr %7, align 8, !range !6, !noundef !2
  %9 = getelementptr inbounds { i64, i64 }, ptr %_10, i32 0, i32 1
  %10 = load i64, ptr %9, align 8, !noundef !2
  %11 = getelementptr inbounds { i64, i64 }, ptr %0, i32 0, i32 0
  store i64 %8, ptr %11, align 8
  %12 = getelementptr inbounds { i64, i64 }, ptr %0, i32 0, i32 1
  store i64 %10, ptr %12, align 8
  br label %bb7

bb5:                                              ; preds = %bb3
  store i64 0, ptr %0, align 8
  br label %bb7

bb7:                                              ; preds = %bb5, %bb6
  %13 = getelementptr inbounds { i64, i64 }, ptr %0, i32 0, i32 0
  %14 = load i64, ptr %13, align 8, !range !7, !noundef !2
  %15 = getelementptr inbounds { i64, i64 }, ptr %0, i32 0, i32 1
  %16 = load i64, ptr %15, align 8
  %17 = insertvalue { i64, i64 } poison, i64 %14, 0
  %18 = insertvalue { i64, i64 } %17, i64 %16, 1
  ret { i64, i64 } %18
}

; core::option::Option<T>::map_or_else
; Function Attrs: inlinehint nonlazybind uwtable
define void @"_ZN4core6option15Option$LT$T$GT$11map_or_else17h99d359fc77d4f35aE"(ptr sret(%"alloc::string::String") %0, ptr align 1 %1, i64 %2, ptr align 8 %default) unnamed_addr #0 personality ptr @rust_eh_personality {
start:
  %3 = alloca { ptr, i32 }, align 8
  %_10 = alloca i8, align 1
  %_9 = alloca i8, align 1
  %_7 = alloca { ptr, i64 }, align 8
  %self = alloca { ptr, i64 }, align 8
  %4 = getelementptr inbounds { ptr, i64 }, ptr %self, i32 0, i32 0
  store ptr %1, ptr %4, align 8
  %5 = getelementptr inbounds { ptr, i64 }, ptr %self, i32 0, i32 1
  store i64 %2, ptr %5, align 8
  store i8 1, ptr %_10, align 1
  store i8 1, ptr %_9, align 1
  %6 = load ptr, ptr %self, align 8, !noundef !2
  %7 = ptrtoint ptr %6 to i64
  %8 = icmp eq i64 %7, 0
  %_4 = select i1 %8, i64 0, i64 1
  %9 = icmp eq i64 %_4, 0
  br i1 %9, label %bb1, label %bb3

bb1:                                              ; preds = %start
  store i8 0, ptr %_10, align 1
; invoke alloc::fmt::format::{{closure}}
  invoke void @"_ZN5alloc3fmt6format28_$u7b$$u7b$closure$u7d$$u7d$17hc61c431e0d1d949bE"(ptr sret(%"alloc::string::String") %0, ptr align 8 %default)
          to label %bb5 unwind label %cleanup

bb3:                                              ; preds = %start
  %10 = getelementptr inbounds { ptr, i64 }, ptr %self, i32 0, i32 0
  %t.0 = load ptr, ptr %10, align 8, !nonnull !2, !align !4, !noundef !2
  %11 = getelementptr inbounds { ptr, i64 }, ptr %self, i32 0, i32 1
  %t.1 = load i64, ptr %11, align 8, !noundef !2
  store i8 0, ptr %_9, align 1
  %12 = getelementptr inbounds { ptr, i64 }, ptr %_7, i32 0, i32 0
  store ptr %t.0, ptr %12, align 8
  %13 = getelementptr inbounds { ptr, i64 }, ptr %_7, i32 0, i32 1
  store i64 %t.1, ptr %13, align 8
  %14 = getelementptr inbounds { ptr, i64 }, ptr %_7, i32 0, i32 0
  %15 = load ptr, ptr %14, align 8, !nonnull !2, !align !4, !noundef !2
  %16 = getelementptr inbounds { ptr, i64 }, ptr %_7, i32 0, i32 1
  %17 = load i64, ptr %16, align 8, !noundef !2
; invoke core::ops::function::FnOnce::call_once
  invoke void @_ZN4core3ops8function6FnOnce9call_once17h71f222674f3eba1dE(ptr sret(%"alloc::string::String") %0, ptr align 1 %15, i64 %17)
          to label %bb4 unwind label %cleanup

bb14:                                             ; preds = %cleanup
  %18 = load i8, ptr %_9, align 1, !range !5, !noundef !2
  %19 = trunc i8 %18 to i1
  br i1 %19, label %bb13, label %bb8

cleanup:                                          ; preds = %bb3, %bb1
  %20 = landingpad { ptr, i32 }
          cleanup
  %21 = extractvalue { ptr, i32 } %20, 0
  %22 = extractvalue { ptr, i32 } %20, 1
  %23 = getelementptr inbounds { ptr, i32 }, ptr %3, i32 0, i32 0
  store ptr %21, ptr %23, align 8
  %24 = getelementptr inbounds { ptr, i32 }, ptr %3, i32 0, i32 1
  store i32 %22, ptr %24, align 8
  br label %bb14

bb5:                                              ; preds = %bb1
  br label %bb11

bb11:                                             ; preds = %bb4, %bb5
  %25 = load i8, ptr %_9, align 1, !range !5, !noundef !2
  %26 = trunc i8 %25 to i1
  br i1 %26, label %bb10, label %bb6

bb4:                                              ; preds = %bb3
  br label %bb11

bb6:                                              ; preds = %bb10, %bb11
  %27 = load i8, ptr %_10, align 1, !range !5, !noundef !2
  %28 = trunc i8 %27 to i1
  br i1 %28, label %bb12, label %bb7

bb10:                                             ; preds = %bb11
  br label %bb6

bb7:                                              ; preds = %bb12, %bb6
  ret void

bb12:                                             ; preds = %bb6
  br label %bb7

bb8:                                              ; preds = %bb13, %bb14
  %29 = load i8, ptr %_10, align 1, !range !5, !noundef !2
  %30 = trunc i8 %29 to i1
  br i1 %30, label %bb15, label %bb9

bb13:                                             ; preds = %bb14
  br label %bb8

bb9:                                              ; preds = %bb15, %bb8
  %31 = load ptr, ptr %3, align 8, !noundef !2
  %32 = getelementptr inbounds { ptr, i32 }, ptr %3, i32 0, i32 1
  %33 = load i32, ptr %32, align 8, !noundef !2
  %34 = insertvalue { ptr, i32 } poison, ptr %31, 0
  %35 = insertvalue { ptr, i32 } %34, i32 %33, 1
  resume { ptr, i32 } %35

bb15:                                             ; preds = %bb8
  br label %bb9

bb2:                                              ; No predecessors!
  unreachable
}

; <T as alloc::slice::hack::ConvertVec>::to_vec
; Function Attrs: inlinehint nonlazybind uwtable
define void @"_ZN52_$LT$T$u20$as$u20$alloc..slice..hack..ConvertVec$GT$6to_vec17hbd4809921e2805d0E"(ptr sret(%"alloc::vec::Vec<u8>") %0, ptr align 1 %s.0, i64 %s.1) unnamed_addr #0 personality ptr @rust_eh_personality {
start:
  %1 = alloca { ptr, i32 }, align 8
  %v = alloca %"alloc::vec::Vec<u8>", align 8
; invoke alloc::raw_vec::RawVec<T,A>::allocate_in
  %2 = invoke { ptr, i64 } @"_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$11allocate_in17hbd127687d744670bE"(i64 %s.1, i1 zeroext false)
          to label %bb4 unwind label %cleanup

bb3:                                              ; preds = %cleanup
  br i1 false, label %bb2, label %bb1

cleanup:                                          ; preds = %start
  %3 = landingpad { ptr, i32 }
          cleanup
  %4 = extractvalue { ptr, i32 } %3, 0
  %5 = extractvalue { ptr, i32 } %3, 1
  %6 = getelementptr inbounds { ptr, i32 }, ptr %1, i32 0, i32 0
  store ptr %4, ptr %6, align 8
  %7 = getelementptr inbounds { ptr, i32 }, ptr %1, i32 0, i32 1
  store i32 %5, ptr %7, align 8
  br label %bb3

bb4:                                              ; preds = %start
  %_13.0 = extractvalue { ptr, i64 } %2, 0
  %_13.1 = extractvalue { ptr, i64 } %2, 1
  %8 = getelementptr inbounds { ptr, i64 }, ptr %v, i32 0, i32 0
  store ptr %_13.0, ptr %8, align 8
  %9 = getelementptr inbounds { ptr, i64 }, ptr %v, i32 0, i32 1
  store i64 %_13.1, ptr %9, align 8
  %10 = getelementptr inbounds %"alloc::vec::Vec<u8>", ptr %v, i32 0, i32 1
  store i64 0, ptr %10, align 8
  %self = load ptr, ptr %v, align 8, !nonnull !2, !noundef !2
  %11 = mul i64 %s.1, 1
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %self, ptr align 1 %s.0, i64 %11, i1 false)
  %12 = getelementptr inbounds %"alloc::vec::Vec<u8>", ptr %v, i32 0, i32 1
  store i64 %s.1, ptr %12, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %0, ptr align 8 %v, i64 24, i1 false)
  ret void

bb1:                                              ; preds = %bb2, %bb3
  %13 = load ptr, ptr %1, align 8, !noundef !2
  %14 = getelementptr inbounds { ptr, i32 }, ptr %1, i32 0, i32 1
  %15 = load i32, ptr %14, align 8, !noundef !2
  %16 = insertvalue { ptr, i32 } poison, ptr %13, 0
  %17 = insertvalue { ptr, i32 } %16, i32 %15, 1
  resume { ptr, i32 } %17

bb2:                                              ; preds = %bb3
  br label %bb1
}

; alloc::fmt::format
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN5alloc3fmt6format17h3a2eceea53cb6c94E(ptr sret(%"alloc::string::String") %0, ptr %args) unnamed_addr #0 {
start:
  %_4 = alloca ptr, align 8
; call core::fmt::Arguments::as_str
  %1 = call { ptr, i64 } @_ZN4core3fmt9Arguments6as_str17h88ec003ec7ecf0c9E(ptr align 8 %args)
  %_2.0 = extractvalue { ptr, i64 } %1, 0
  %_2.1 = extractvalue { ptr, i64 } %1, 1
  store ptr %args, ptr %_4, align 8
  %2 = load ptr, ptr %_4, align 8, !nonnull !2, !align !3, !noundef !2
; call core::option::Option<T>::map_or_else
  call void @"_ZN4core6option15Option$LT$T$GT$11map_or_else17h99d359fc77d4f35aE"(ptr sret(%"alloc::string::String") %0, ptr align 1 %_2.0, i64 %_2.1, ptr align 8 %2)
  ret void
}

; alloc::fmt::format::{{closure}}
; Function Attrs: inlinehint nonlazybind uwtable
define void @"_ZN5alloc3fmt6format28_$u7b$$u7b$closure$u7d$$u7d$17hc61c431e0d1d949bE"(ptr sret(%"alloc::string::String") %0, ptr align 8 %1) unnamed_addr #0 {
start:
  %_2 = alloca %"core::fmt::Arguments<'_>", align 8
  %_1 = alloca ptr, align 8
  store ptr %1, ptr %_1, align 8
  %_3 = load ptr, ptr %_1, align 8, !nonnull !2, !align !3, !noundef !2
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %_2, ptr align 8 %_3, i64 48, i1 false)
; call alloc::fmt::format::format_inner
  call void @_ZN5alloc3fmt6format12format_inner17h0a1842759b6533d6E(ptr sret(%"alloc::string::String") %0, ptr %_2)
  ret void
}

; alloc::str::<impl alloc::borrow::ToOwned for str>::to_owned
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @"_ZN5alloc3str56_$LT$impl$u20$alloc..borrow..ToOwned$u20$for$u20$str$GT$8to_owned17h2c700728a67ffecaE"(ptr sret(%"alloc::string::String") %0, ptr align 1 %self.0, i64 %self.1) unnamed_addr #0 {
start:
  %bytes = alloca %"alloc::vec::Vec<u8>", align 8
; call <T as alloc::slice::hack::ConvertVec>::to_vec
  call void @"_ZN52_$LT$T$u20$as$u20$alloc..slice..hack..ConvertVec$GT$6to_vec17hbd4809921e2805d0E"(ptr sret(%"alloc::vec::Vec<u8>") %bytes, ptr align 1 %self.0, i64 %self.1)
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %0, ptr align 8 %bytes, i64 24, i1 false)
  ret void
}

; alloc::alloc::Global::alloc_impl
; Function Attrs: inlinehint nonlazybind uwtable
define internal { ptr, i64 } @_ZN5alloc5alloc6Global10alloc_impl17h033536c39fcb20b8E(ptr align 1 %self, i64 %0, i64 %1, i1 zeroext %zeroed) unnamed_addr #0 {
start:
  %2 = alloca i8, align 1
  %_85 = alloca { ptr, i64 }, align 8
  %_84 = alloca %"core::ptr::metadata::PtrRepr<[u8]>", align 8
  %_69 = alloca ptr, align 8
  %_68 = alloca ptr, align 8
  %_61 = alloca i64, align 8
  %_46 = alloca i64, align 8
  %_36 = alloca { ptr, i64 }, align 8
  %_35 = alloca %"core::ptr::metadata::PtrRepr<[u8]>", align 8
  %_22 = alloca i64, align 8
  %_18 = alloca { ptr, i64 }, align 8
  %self4 = alloca ptr, align 8
  %self3 = alloca ptr, align 8
  %_12 = alloca ptr, align 8
  %layout2 = alloca { i64, i64 }, align 8
  %layout1 = alloca { i64, i64 }, align 8
  %raw_ptr = alloca ptr, align 8
  %data = alloca ptr, align 8
  %_6 = alloca { ptr, i64 }, align 8
  %3 = alloca { ptr, i64 }, align 8
  %layout = alloca { i64, i64 }, align 8
  %4 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 0
  store i64 %0, ptr %4, align 8
  %5 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 1
  store i64 %1, ptr %5, align 8
  %6 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 1
  %size = load i64, ptr %6, align 8, !noundef !2
  %7 = icmp eq i64 %size, 0
  br i1 %7, label %bb2, label %bb1

bb2:                                              ; preds = %start
  %self5 = load i64, ptr %layout, align 8, !range !6, !noundef !2
  store i64 %self5, ptr %_22, align 8
  %_23 = load i64, ptr %_22, align 8, !range !6, !noundef !2
  %_24 = icmp uge i64 %_23, 1
  %_25 = icmp ule i64 %_23, -9223372036854775808
  %_26 = and i1 %_24, %_25
  call void @llvm.assume(i1 %_26)
  %ptr = inttoptr i64 %_23 to ptr
  store ptr %ptr, ptr %data, align 8
  %_33 = load ptr, ptr %data, align 8, !noundef !2
  store ptr %_33, ptr %_36, align 8
  %8 = getelementptr inbounds { ptr, i64 }, ptr %_36, i32 0, i32 1
  store i64 0, ptr %8, align 8
  %9 = getelementptr inbounds { ptr, i64 }, ptr %_36, i32 0, i32 0
  %10 = load ptr, ptr %9, align 8, !noundef !2
  %11 = getelementptr inbounds { ptr, i64 }, ptr %_36, i32 0, i32 1
  %12 = load i64, ptr %11, align 8, !noundef !2
  %13 = getelementptr inbounds { ptr, i64 }, ptr %_35, i32 0, i32 0
  store ptr %10, ptr %13, align 8
  %14 = getelementptr inbounds { ptr, i64 }, ptr %_35, i32 0, i32 1
  store i64 %12, ptr %14, align 8
  %15 = getelementptr inbounds { ptr, i64 }, ptr %_35, i32 0, i32 0
  %ptr.0 = load ptr, ptr %15, align 8, !noundef !2
  %16 = getelementptr inbounds { ptr, i64 }, ptr %_35, i32 0, i32 1
  %ptr.1 = load i64, ptr %16, align 8, !noundef !2
  %17 = getelementptr inbounds { ptr, i64 }, ptr %_6, i32 0, i32 0
  store ptr %ptr.0, ptr %17, align 8
  %18 = getelementptr inbounds { ptr, i64 }, ptr %_6, i32 0, i32 1
  store i64 %ptr.1, ptr %18, align 8
  %19 = getelementptr inbounds { ptr, i64 }, ptr %_6, i32 0, i32 0
  %20 = load ptr, ptr %19, align 8, !nonnull !2, !noundef !2
  %21 = getelementptr inbounds { ptr, i64 }, ptr %_6, i32 0, i32 1
  %22 = load i64, ptr %21, align 8, !noundef !2
  %23 = getelementptr inbounds { ptr, i64 }, ptr %3, i32 0, i32 0
  store ptr %20, ptr %23, align 8
  %24 = getelementptr inbounds { ptr, i64 }, ptr %3, i32 0, i32 1
  store i64 %22, ptr %24, align 8
  br label %bb10

bb1:                                              ; preds = %start
  br i1 %zeroed, label %bb3, label %bb4

bb10:                                             ; preds = %bb9, %bb7, %bb2
  %25 = getelementptr inbounds { ptr, i64 }, ptr %3, i32 0, i32 0
  %26 = load ptr, ptr %25, align 8, !noundef !2
  %27 = getelementptr inbounds { ptr, i64 }, ptr %3, i32 0, i32 1
  %28 = load i64, ptr %27, align 8
  %29 = insertvalue { ptr, i64 } poison, ptr %26, 0
  %30 = insertvalue { ptr, i64 } %29, i64 %28, 1
  ret { ptr, i64 } %30

bb4:                                              ; preds = %bb1
  %31 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 0
  %32 = load i64, ptr %31, align 8, !range !6, !noundef !2
  %33 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 1
  %34 = load i64, ptr %33, align 8, !noundef !2
  %35 = getelementptr inbounds { i64, i64 }, ptr %layout2, i32 0, i32 0
  store i64 %32, ptr %35, align 8
  %36 = getelementptr inbounds { i64, i64 }, ptr %layout2, i32 0, i32 1
  store i64 %34, ptr %36, align 8
  %37 = load volatile i8, ptr @__rust_no_alloc_shim_is_unstable, align 1
  store i8 %37, ptr %2, align 1
  %_51 = load i8, ptr %2, align 1, !noundef !2
  %38 = getelementptr inbounds { i64, i64 }, ptr %layout2, i32 0, i32 1
  %_55 = load i64, ptr %38, align 8, !noundef !2
  %self6 = load i64, ptr %layout2, align 8, !range !6, !noundef !2
  store i64 %self6, ptr %_61, align 8
  %_62 = load i64, ptr %_61, align 8, !range !6, !noundef !2
  %_63 = icmp uge i64 %_62, 1
  %_64 = icmp ule i64 %_62, -9223372036854775808
  %_65 = and i1 %_63, %_64
  call void @llvm.assume(i1 %_65)
  %39 = call ptr @__rust_alloc(i64 %_55, i64 %_62) #15
  store ptr %39, ptr %raw_ptr, align 8
  br label %bb5

bb3:                                              ; preds = %bb1
  %40 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 0
  %41 = load i64, ptr %40, align 8, !range !6, !noundef !2
  %42 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 1
  %43 = load i64, ptr %42, align 8, !noundef !2
  %44 = getelementptr inbounds { i64, i64 }, ptr %layout1, i32 0, i32 0
  store i64 %41, ptr %44, align 8
  %45 = getelementptr inbounds { i64, i64 }, ptr %layout1, i32 0, i32 1
  store i64 %43, ptr %45, align 8
  %46 = getelementptr inbounds { i64, i64 }, ptr %layout1, i32 0, i32 1
  %_41 = load i64, ptr %46, align 8, !noundef !2
  %self7 = load i64, ptr %layout1, align 8, !range !6, !noundef !2
  store i64 %self7, ptr %_46, align 8
  %_47 = load i64, ptr %_46, align 8, !range !6, !noundef !2
  %_48 = icmp uge i64 %_47, 1
  %_49 = icmp ule i64 %_47, -9223372036854775808
  %_50 = and i1 %_48, %_49
  call void @llvm.assume(i1 %_50)
  %47 = call ptr @__rust_alloc_zeroed(i64 %_41, i64 %_47) #15
  store ptr %47, ptr %raw_ptr, align 8
  br label %bb5

bb5:                                              ; preds = %bb3, %bb4
  %ptr8 = load ptr, ptr %raw_ptr, align 8, !noundef !2
  store ptr %ptr8, ptr %_69, align 8
  %ptr9 = load ptr, ptr %_69, align 8, !noundef !2
  %_71 = ptrtoint ptr %ptr9 to i64
  %_67 = icmp eq i64 %_71, 0
  %_66 = xor i1 %_67, true
  br i1 %_66, label %bb14, label %bb15

bb15:                                             ; preds = %bb5
  store ptr null, ptr %self4, align 8
  br label %bb16

bb14:                                             ; preds = %bb5
  store ptr %ptr8, ptr %_68, align 8
  %48 = load ptr, ptr %_68, align 8, !nonnull !2, !noundef !2
  store ptr %48, ptr %self4, align 8
  br label %bb16

bb16:                                             ; preds = %bb14, %bb15
  %49 = load ptr, ptr %self4, align 8, !noundef !2
  %50 = ptrtoint ptr %49 to i64
  %51 = icmp eq i64 %50, 0
  %_76 = select i1 %51, i64 0, i64 1
  %52 = icmp eq i64 %_76, 0
  br i1 %52, label %bb17, label %bb18

bb17:                                             ; preds = %bb16
  store ptr null, ptr %self3, align 8
  br label %bb19

bb18:                                             ; preds = %bb16
  %v = load ptr, ptr %self4, align 8, !nonnull !2, !noundef !2
  store ptr %v, ptr %self3, align 8
  br label %bb19

bb19:                                             ; preds = %bb18, %bb17
  %53 = load ptr, ptr %self3, align 8, !noundef !2
  %54 = ptrtoint ptr %53 to i64
  %55 = icmp eq i64 %54, 0
  %_78 = select i1 %55, i64 1, i64 0
  %56 = icmp eq i64 %_78, 0
  br i1 %56, label %bb21, label %bb20

bb21:                                             ; preds = %bb19
  %v10 = load ptr, ptr %self3, align 8, !nonnull !2, !noundef !2
  store ptr %v10, ptr %_12, align 8
  br label %bb6

bb20:                                             ; preds = %bb19
  store ptr null, ptr %_12, align 8
  br label %bb6

bb6:                                              ; preds = %bb20, %bb21
  %57 = load ptr, ptr %_12, align 8, !noundef !2
  %58 = ptrtoint ptr %57 to i64
  %59 = icmp eq i64 %58, 0
  %_16 = select i1 %59, i64 1, i64 0
  %60 = icmp eq i64 %_16, 0
  br i1 %60, label %bb7, label %bb9

bb7:                                              ; preds = %bb6
  %ptr11 = load ptr, ptr %_12, align 8, !nonnull !2, !noundef !2
  store ptr %ptr11, ptr %_85, align 8
  %61 = getelementptr inbounds { ptr, i64 }, ptr %_85, i32 0, i32 1
  store i64 %size, ptr %61, align 8
  %62 = getelementptr inbounds { ptr, i64 }, ptr %_85, i32 0, i32 0
  %63 = load ptr, ptr %62, align 8, !noundef !2
  %64 = getelementptr inbounds { ptr, i64 }, ptr %_85, i32 0, i32 1
  %65 = load i64, ptr %64, align 8, !noundef !2
  %66 = getelementptr inbounds { ptr, i64 }, ptr %_84, i32 0, i32 0
  store ptr %63, ptr %66, align 8
  %67 = getelementptr inbounds { ptr, i64 }, ptr %_84, i32 0, i32 1
  store i64 %65, ptr %67, align 8
  %68 = getelementptr inbounds { ptr, i64 }, ptr %_84, i32 0, i32 0
  %ptr.012 = load ptr, ptr %68, align 8, !noundef !2
  %69 = getelementptr inbounds { ptr, i64 }, ptr %_84, i32 0, i32 1
  %ptr.113 = load i64, ptr %69, align 8, !noundef !2
  %70 = getelementptr inbounds { ptr, i64 }, ptr %_18, i32 0, i32 0
  store ptr %ptr.012, ptr %70, align 8
  %71 = getelementptr inbounds { ptr, i64 }, ptr %_18, i32 0, i32 1
  store i64 %ptr.113, ptr %71, align 8
  %72 = getelementptr inbounds { ptr, i64 }, ptr %_18, i32 0, i32 0
  %73 = load ptr, ptr %72, align 8, !nonnull !2, !noundef !2
  %74 = getelementptr inbounds { ptr, i64 }, ptr %_18, i32 0, i32 1
  %75 = load i64, ptr %74, align 8, !noundef !2
  %76 = getelementptr inbounds { ptr, i64 }, ptr %3, i32 0, i32 0
  store ptr %73, ptr %76, align 8
  %77 = getelementptr inbounds { ptr, i64 }, ptr %3, i32 0, i32 1
  store i64 %75, ptr %77, align 8
  br label %bb10

bb9:                                              ; preds = %bb6
  store ptr null, ptr %3, align 8
  br label %bb10

bb8:                                              ; No predecessors!
  unreachable
}

; alloc::raw_vec::RawVec<T,A>::allocate_in
; Function Attrs: nonlazybind uwtable
define { ptr, i64 } @"_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$11allocate_in17hbd127687d744670bE"(i64 %capacity, i1 zeroext %0) unnamed_addr #1 personality ptr @rust_eh_personality {
start:
  %1 = alloca { ptr, i32 }, align 8
  %_51 = alloca ptr, align 8
  %_33 = alloca ptr, align 8
  %_32 = alloca ptr, align 8
  %self = alloca ptr, align 8
  %_27 = alloca ptr, align 8
  %result = alloca { ptr, i64 }, align 8
  %_12 = alloca { i64, i64 }, align 8
  %_8 = alloca { i64, i64 }, align 8
  %_4 = alloca i8, align 1
  %2 = alloca { ptr, i64 }, align 8
  %alloc = alloca %"alloc::alloc::Global", align 1
  %init = alloca i8, align 1
  %3 = zext i1 %0 to i8
  store i8 %3, ptr %init, align 1
  br i1 false, label %bb1, label %bb2

bb2:                                              ; preds = %start
  %_5 = icmp eq i64 %capacity, 0
  %4 = zext i1 %_5 to i8
  store i8 %4, ptr %_4, align 1
  br label %bb3

bb1:                                              ; preds = %start
  store i8 1, ptr %_4, align 1
  br label %bb3

bb3:                                              ; preds = %bb1, %bb2
  %5 = load i8, ptr %_4, align 1, !range !5, !noundef !2
  %6 = trunc i8 %5 to i1
  br i1 %6, label %bb4, label %bb5

bb5:                                              ; preds = %bb3
; invoke core::alloc::layout::Layout::array::inner
  %7 = invoke { i64, i64 } @_ZN4core5alloc6layout6Layout5array5inner17hbcf6a2c2884d3b80E(i64 1, i64 1, i64 %capacity)
          to label %bb22 unwind label %cleanup

bb4:                                              ; preds = %bb3
  store ptr inttoptr (i64 1 to ptr), ptr %_33, align 8
  %8 = load ptr, ptr %_33, align 8, !nonnull !2, !noundef !2
  store ptr %8, ptr %_32, align 8
  %9 = load ptr, ptr %_32, align 8, !nonnull !2, !noundef !2
  store ptr %9, ptr %2, align 8
  %10 = getelementptr inbounds { ptr, i64 }, ptr %2, i32 0, i32 1
  store i64 0, ptr %10, align 8
  br label %bb18

bb21:                                             ; preds = %cleanup
  br i1 true, label %bb20, label %bb19

cleanup:                                          ; preds = %bb6, %bb9, %bb16, %bb11, %bb12, %bb5
  %11 = landingpad { ptr, i32 }
          cleanup
  %12 = extractvalue { ptr, i32 } %11, 0
  %13 = extractvalue { ptr, i32 } %11, 1
  %14 = getelementptr inbounds { ptr, i32 }, ptr %1, i32 0, i32 0
  store ptr %12, ptr %14, align 8
  %15 = getelementptr inbounds { ptr, i32 }, ptr %1, i32 0, i32 1
  store i32 %13, ptr %15, align 8
  br label %bb21

bb22:                                             ; preds = %bb5
  store { i64, i64 } %7, ptr %_8, align 8
  %16 = load i64, ptr %_8, align 8, !range !7, !noundef !2
  %17 = icmp eq i64 %16, 0
  %_9 = select i1 %17, i64 1, i64 0
  %18 = icmp eq i64 %_9, 0
  br i1 %18, label %bb8, label %bb6

bb8:                                              ; preds = %bb22
  %19 = getelementptr inbounds { i64, i64 }, ptr %_8, i32 0, i32 0
  %layout.0 = load i64, ptr %19, align 8, !range !6, !noundef !2
  %20 = getelementptr inbounds { i64, i64 }, ptr %_8, i32 0, i32 1
  %layout.1 = load i64, ptr %20, align 8, !noundef !2
  store i64 -9223372036854775807, ptr %_12, align 8
  %21 = load i64, ptr %_12, align 8, !range !8, !noundef !2
  %22 = icmp eq i64 %21, -9223372036854775807
  %_15 = select i1 %22, i64 0, i64 1
  %23 = icmp eq i64 %_15, 0
  br i1 %23, label %bb10, label %bb9

bb6:                                              ; preds = %bb22
; invoke alloc::raw_vec::capacity_overflow
  invoke void @_ZN5alloc7raw_vec17capacity_overflow17h38e98ea3430a1a20E() #12
          to label %unreachable unwind label %cleanup

bb10:                                             ; preds = %bb8
  %24 = load i8, ptr %init, align 1, !range !5, !noundef !2
  %25 = trunc i8 %24 to i1
  %_18 = zext i1 %25 to i64
  %26 = icmp eq i64 %_18, 0
  br i1 %26, label %bb12, label %bb11

bb9:                                              ; preds = %bb8
; invoke alloc::raw_vec::capacity_overflow
  invoke void @_ZN5alloc7raw_vec17capacity_overflow17h38e98ea3430a1a20E() #12
          to label %unreachable unwind label %cleanup

bb12:                                             ; preds = %bb10
; invoke <alloc::alloc::Global as core::alloc::Allocator>::allocate
  %27 = invoke { ptr, i64 } @"_ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$8allocate17hd76e99ef919e382aE"(ptr align 1 %alloc, i64 %layout.0, i64 %layout.1)
          to label %bb13 unwind label %cleanup

bb11:                                             ; preds = %bb10
; invoke <alloc::alloc::Global as core::alloc::Allocator>::allocate_zeroed
  %28 = invoke { ptr, i64 } @"_ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$15allocate_zeroed17hea5c924aa9cd1345E"(ptr align 1 %alloc, i64 %layout.0, i64 %layout.1)
          to label %bb14 unwind label %cleanup

bb13:                                             ; preds = %bb12
  store { ptr, i64 } %27, ptr %result, align 8
  br label %bb15

bb15:                                             ; preds = %bb14, %bb13
  %29 = load ptr, ptr %result, align 8, !noundef !2
  %30 = ptrtoint ptr %29 to i64
  %31 = icmp eq i64 %30, 0
  %_23 = select i1 %31, i64 1, i64 0
  %32 = icmp eq i64 %_23, 0
  br i1 %32, label %bb17, label %bb16

bb14:                                             ; preds = %bb11
  store { ptr, i64 } %28, ptr %result, align 8
  br label %bb15

bb17:                                             ; preds = %bb15
  %33 = getelementptr inbounds { ptr, i64 }, ptr %result, i32 0, i32 0
  %ptr.0 = load ptr, ptr %33, align 8, !nonnull !2, !noundef !2
  %34 = getelementptr inbounds { ptr, i64 }, ptr %result, i32 0, i32 1
  %ptr.1 = load i64, ptr %34, align 8, !noundef !2
  store ptr %ptr.0, ptr %self, align 8
  %_50 = load ptr, ptr %self, align 8, !noundef !2
  store ptr %_50, ptr %_51, align 8
  %35 = load ptr, ptr %_51, align 8, !nonnull !2, !noundef !2
  store ptr %35, ptr %_27, align 8
  %36 = load ptr, ptr %_27, align 8, !nonnull !2, !noundef !2
  store ptr %36, ptr %2, align 8
  %37 = getelementptr inbounds { ptr, i64 }, ptr %2, i32 0, i32 1
  store i64 %capacity, ptr %37, align 8
  br label %bb18

bb16:                                             ; preds = %bb15
; invoke alloc::alloc::handle_alloc_error
  invoke void @_ZN5alloc5alloc18handle_alloc_error17hb6dacc58213cdde5E(i64 %layout.0, i64 %layout.1) #12
          to label %unreachable unwind label %cleanup

bb18:                                             ; preds = %bb4, %bb17
  %38 = getelementptr inbounds { ptr, i64 }, ptr %2, i32 0, i32 0
  %39 = load ptr, ptr %38, align 8, !nonnull !2, !noundef !2
  %40 = getelementptr inbounds { ptr, i64 }, ptr %2, i32 0, i32 1
  %41 = load i64, ptr %40, align 8, !noundef !2
  %42 = insertvalue { ptr, i64 } poison, ptr %39, 0
  %43 = insertvalue { ptr, i64 } %42, i64 %41, 1
  ret { ptr, i64 } %43

unreachable:                                      ; preds = %bb6, %bb9, %bb16
  unreachable

bb7:                                              ; No predecessors!
  unreachable

bb19:                                             ; preds = %bb20, %bb21
  %44 = load ptr, ptr %1, align 8, !noundef !2
  %45 = getelementptr inbounds { ptr, i32 }, ptr %1, i32 0, i32 1
  %46 = load i32, ptr %45, align 8, !noundef !2
  %47 = insertvalue { ptr, i32 } poison, ptr %44, 0
  %48 = insertvalue { ptr, i32 } %47, i32 %46, 1
  resume { ptr, i32 } %48

bb20:                                             ; preds = %bb21
  br label %bb19
}

; alloc::raw_vec::RawVec<T,A>::current_memory
; Function Attrs: nonlazybind uwtable
define void @"_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$14current_memory17h80ca07570631e9b5E"(ptr sret(%"core::option::Option<(core::ptr::non_null::NonNull<u8>, core::alloc::layout::Layout)>") %0, ptr align 8 %self) unnamed_addr #1 {
start:
  %_26 = alloca ptr, align 8
  %self2 = alloca ptr, align 8
  %self1 = alloca ptr, align 8
  %_11 = alloca ptr, align 8
  %_10 = alloca { ptr, { i64, i64 } }, align 8
  %layout = alloca { i64, i64 }, align 8
  %_2 = alloca i8, align 1
  br i1 false, label %bb1, label %bb2

bb2:                                              ; preds = %start
  %1 = getelementptr inbounds { ptr, i64 }, ptr %self, i32 0, i32 1
  %_4 = load i64, ptr %1, align 8, !noundef !2
  %_3 = icmp eq i64 %_4, 0
  %2 = zext i1 %_3 to i8
  store i8 %2, ptr %_2, align 1
  br label %bb3

bb1:                                              ; preds = %start
  store i8 1, ptr %_2, align 1
  br label %bb3

bb3:                                              ; preds = %bb1, %bb2
  %3 = load i8, ptr %_2, align 1, !range !5, !noundef !2
  %4 = trunc i8 %3 to i1
  br i1 %4, label %bb4, label %bb5

bb5:                                              ; preds = %bb3
  %5 = getelementptr inbounds { ptr, i64 }, ptr %self, i32 0, i32 1
  %rhs = load i64, ptr %5, align 8, !noundef !2
  %size = mul nuw i64 1, %rhs
  %6 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 1
  store i64 %size, ptr %6, align 8
  store i64 1, ptr %layout, align 8
  %self3 = load ptr, ptr %self, align 8, !nonnull !2, !noundef !2
  store ptr %self3, ptr %self2, align 8
  %_25 = load ptr, ptr %self2, align 8, !noundef !2
  store ptr %_25, ptr %_26, align 8
  %7 = load ptr, ptr %_26, align 8, !nonnull !2, !noundef !2
  store ptr %7, ptr %self1, align 8
  %self4 = load ptr, ptr %self1, align 8, !nonnull !2, !noundef !2
  store ptr %self4, ptr %_11, align 8
  %8 = load ptr, ptr %_11, align 8, !nonnull !2, !noundef !2
  store ptr %8, ptr %_10, align 8
  %9 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 0
  %10 = load i64, ptr %9, align 8, !range !6, !noundef !2
  %11 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 1
  %12 = load i64, ptr %11, align 8, !noundef !2
  %13 = getelementptr inbounds { ptr, { i64, i64 } }, ptr %_10, i32 0, i32 1
  %14 = getelementptr inbounds { i64, i64 }, ptr %13, i32 0, i32 0
  store i64 %10, ptr %14, align 8
  %15 = getelementptr inbounds { i64, i64 }, ptr %13, i32 0, i32 1
  store i64 %12, ptr %15, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %0, ptr align 8 %_10, i64 24, i1 false)
  br label %bb6

bb4:                                              ; preds = %bb3
  %16 = getelementptr inbounds %"core::option::Option<(core::ptr::non_null::NonNull<u8>, core::alloc::layout::Layout)>", ptr %0, i32 0, i32 1
  store i64 0, ptr %16, align 8
  br label %bb6

bb6:                                              ; preds = %bb4, %bb5
  ret void
}

; <alloc::alloc::Global as core::alloc::Allocator>::deallocate
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @"_ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$10deallocate17h946697eb0143f282E"(ptr align 1 %self, ptr %ptr, i64 %0, i64 %1) unnamed_addr #0 {
start:
  %_14 = alloca i64, align 8
  %layout1 = alloca { i64, i64 }, align 8
  %layout = alloca { i64, i64 }, align 8
  %2 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 0
  store i64 %0, ptr %2, align 8
  %3 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 1
  store i64 %1, ptr %3, align 8
  %4 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 1
  %_4 = load i64, ptr %4, align 8, !noundef !2
  %5 = icmp eq i64 %_4, 0
  br i1 %5, label %bb2, label %bb1

bb2:                                              ; preds = %start
  br label %bb3

bb1:                                              ; preds = %start
  %6 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 0
  %7 = load i64, ptr %6, align 8, !range !6, !noundef !2
  %8 = getelementptr inbounds { i64, i64 }, ptr %layout, i32 0, i32 1
  %9 = load i64, ptr %8, align 8, !noundef !2
  %10 = getelementptr inbounds { i64, i64 }, ptr %layout1, i32 0, i32 0
  store i64 %7, ptr %10, align 8
  %11 = getelementptr inbounds { i64, i64 }, ptr %layout1, i32 0, i32 1
  store i64 %9, ptr %11, align 8
  %12 = getelementptr inbounds { i64, i64 }, ptr %layout1, i32 0, i32 1
  %_9 = load i64, ptr %12, align 8, !noundef !2
  %self2 = load i64, ptr %layout1, align 8, !range !6, !noundef !2
  store i64 %self2, ptr %_14, align 8
  %_15 = load i64, ptr %_14, align 8, !range !6, !noundef !2
  %_16 = icmp uge i64 %_15, 1
  %_17 = icmp ule i64 %_15, -9223372036854775808
  %_18 = and i1 %_16, %_17
  call void @llvm.assume(i1 %_18)
  call void @__rust_dealloc(ptr %ptr, i64 %_9, i64 %_15) #15
  br label %bb3

bb3:                                              ; preds = %bb1, %bb2
  ret void
}

; <alloc::alloc::Global as core::alloc::Allocator>::allocate_zeroed
; Function Attrs: inlinehint nonlazybind uwtable
define internal { ptr, i64 } @"_ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$15allocate_zeroed17hea5c924aa9cd1345E"(ptr align 1 %self, i64 %layout.0, i64 %layout.1) unnamed_addr #0 {
start:
; call alloc::alloc::Global::alloc_impl
  %0 = call { ptr, i64 } @_ZN5alloc5alloc6Global10alloc_impl17h033536c39fcb20b8E(ptr align 1 %self, i64 %layout.0, i64 %layout.1, i1 zeroext true)
  %1 = extractvalue { ptr, i64 } %0, 0
  %2 = extractvalue { ptr, i64 } %0, 1
  %3 = insertvalue { ptr, i64 } poison, ptr %1, 0
  %4 = insertvalue { ptr, i64 } %3, i64 %2, 1
  ret { ptr, i64 } %4
}

; <alloc::alloc::Global as core::alloc::Allocator>::allocate
; Function Attrs: inlinehint nonlazybind uwtable
define internal { ptr, i64 } @"_ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$8allocate17hd76e99ef919e382aE"(ptr align 1 %self, i64 %layout.0, i64 %layout.1) unnamed_addr #0 {
start:
; call alloc::alloc::Global::alloc_impl
  %0 = call { ptr, i64 } @_ZN5alloc5alloc6Global10alloc_impl17h033536c39fcb20b8E(ptr align 1 %self, i64 %layout.0, i64 %layout.1, i1 zeroext false)
  %1 = extractvalue { ptr, i64 } %0, 0
  %2 = extractvalue { ptr, i64 } %0, 1
  %3 = insertvalue { ptr, i64 } poison, ptr %1, 0
  %4 = insertvalue { ptr, i64 } %3, i64 %2, 1
  ret { ptr, i64 } %4
}

; <alloc::vec::Vec<T,A> as core::ops::drop::Drop>::drop
; Function Attrs: nonlazybind uwtable
define void @"_ZN70_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h875950b1b8273404E"(ptr align 8 %self) unnamed_addr #1 {
start:
  %_11 = alloca { ptr, i64 }, align 8
  %_10 = alloca %"core::ptr::metadata::PtrRepr<[u8]>", align 8
  %self1 = load ptr, ptr %self, align 8, !nonnull !2, !noundef !2
  %0 = getelementptr inbounds %"alloc::vec::Vec<u8>", ptr %self, i32 0, i32 1
  %len = load i64, ptr %0, align 8, !noundef !2
  store ptr %self1, ptr %_11, align 8
  %1 = getelementptr inbounds { ptr, i64 }, ptr %_11, i32 0, i32 1
  store i64 %len, ptr %1, align 8
  %2 = getelementptr inbounds { ptr, i64 }, ptr %_11, i32 0, i32 0
  %3 = load ptr, ptr %2, align 8, !noundef !2
  %4 = getelementptr inbounds { ptr, i64 }, ptr %_11, i32 0, i32 1
  %5 = load i64, ptr %4, align 8, !noundef !2
  %6 = getelementptr inbounds { ptr, i64 }, ptr %_10, i32 0, i32 0
  store ptr %3, ptr %6, align 8
  %7 = getelementptr inbounds { ptr, i64 }, ptr %_10, i32 0, i32 1
  store i64 %5, ptr %7, align 8
  %8 = getelementptr inbounds { ptr, i64 }, ptr %_10, i32 0, i32 0
  %_2.0 = load ptr, ptr %8, align 8, !noundef !2
  %9 = getelementptr inbounds { ptr, i64 }, ptr %_10, i32 0, i32 1
  %_2.1 = load i64, ptr %9, align 8, !noundef !2
  ret void
}

; <alloc::raw_vec::RawVec<T,A> as core::ops::drop::Drop>::drop
; Function Attrs: nonlazybind uwtable
define void @"_ZN77_$LT$alloc..raw_vec..RawVec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17hecadc9e4d5d158b8E"(ptr align 8 %self) unnamed_addr #1 {
start:
  %_2 = alloca %"core::option::Option<(core::ptr::non_null::NonNull<u8>, core::alloc::layout::Layout)>", align 8
; call alloc::raw_vec::RawVec<T,A>::current_memory
  call void @"_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$14current_memory17h80ca07570631e9b5E"(ptr sret(%"core::option::Option<(core::ptr::non_null::NonNull<u8>, core::alloc::layout::Layout)>") %_2, ptr align 8 %self)
  %0 = getelementptr inbounds %"core::option::Option<(core::ptr::non_null::NonNull<u8>, core::alloc::layout::Layout)>", ptr %_2, i32 0, i32 1
  %1 = load i64, ptr %0, align 8, !range !7, !noundef !2
  %2 = icmp eq i64 %1, 0
  %_4 = select i1 %2, i64 0, i64 1
  %3 = icmp eq i64 %_4, 1
  br i1 %3, label %bb2, label %bb4

bb2:                                              ; preds = %start
  %ptr = load ptr, ptr %_2, align 8, !nonnull !2, !noundef !2
  %4 = getelementptr inbounds { ptr, { i64, i64 } }, ptr %_2, i32 0, i32 1
  %5 = getelementptr inbounds { i64, i64 }, ptr %4, i32 0, i32 0
  %layout.0 = load i64, ptr %5, align 8, !range !6, !noundef !2
  %6 = getelementptr inbounds { i64, i64 }, ptr %4, i32 0, i32 1
  %layout.1 = load i64, ptr %6, align 8, !noundef !2
; call <alloc::alloc::Global as core::alloc::Allocator>::deallocate
  call void @"_ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$10deallocate17h946697eb0143f282E"(ptr align 1 %self, ptr %ptr, i64 %layout.0, i64 %layout.1)
  br label %bb4

bb4:                                              ; preds = %bb2, %start
  ret void
}

; probe1::probe
; Function Attrs: nonlazybind uwtable
define void @_ZN6probe15probe17hcbb999270d381d33E() unnamed_addr #1 {
start:
  %0 = alloca { ptr, ptr }, align 8
  %_7 = alloca [1 x { ptr, ptr }], align 8
  %_3 = alloca %"core::fmt::Arguments<'_>", align 8
  %res = alloca %"alloc::string::String", align 8
  %_1 = alloca %"alloc::string::String", align 8
  store ptr @alloc_53973d2fe29b4adba8bb7390b5678745, ptr %0, align 8
  %1 = getelementptr inbounds { ptr, ptr }, ptr %0, i32 0, i32 1
  store ptr @"_ZN4core3fmt3num3imp55_$LT$impl$u20$core..fmt..LowerExp$u20$for$u20$isize$GT$3fmt17hd1cd63c16e5884fdE", ptr %1, align 8
  %2 = load ptr, ptr %0, align 8, !nonnull !2, !align !4, !noundef !2
  %3 = getelementptr inbounds { ptr, ptr }, ptr %0, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !nonnull !2, !noundef !2
  %5 = insertvalue { ptr, ptr } poison, ptr %2, 0
  %6 = insertvalue { ptr, ptr } %5, ptr %4, 1
  %_8.0 = extractvalue { ptr, ptr } %6, 0
  %_8.1 = extractvalue { ptr, ptr } %6, 1
  %7 = getelementptr inbounds [1 x { ptr, ptr }], ptr %_7, i64 0, i64 0
  %8 = getelementptr inbounds { ptr, ptr }, ptr %7, i32 0, i32 0
  store ptr %_8.0, ptr %8, align 8
  %9 = getelementptr inbounds { ptr, ptr }, ptr %7, i32 0, i32 1
  store ptr %_8.1, ptr %9, align 8
; call core::fmt::Arguments::new_v1
  call void @_ZN4core3fmt9Arguments6new_v117ha5db560f608cab3bE(ptr sret(%"core::fmt::Arguments<'_>") %_3, ptr align 8 @alloc_ffa3cdb3ae88e54a1cc225f31dd07672, i64 1, ptr align 8 %_7, i64 1)
; call alloc::fmt::format
  call void @_ZN5alloc3fmt6format17h3a2eceea53cb6c94E(ptr sret(%"alloc::string::String") %res, ptr %_3)
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %_1, ptr align 8 %res, i64 24, i1 false)
; call core::ptr::drop_in_place<alloc::string::String>
  call void @"_ZN4core3ptr42drop_in_place$LT$alloc..string..String$GT$17h6070ef0a1b5c9d63E"(ptr align 8 %_1)
  ret void
}

; core::fmt::num::imp::<impl core::fmt::LowerExp for isize>::fmt
; Function Attrs: nonlazybind uwtable
declare zeroext i1 @"_ZN4core3fmt3num3imp55_$LT$impl$u20$core..fmt..LowerExp$u20$for$u20$isize$GT$3fmt17hd1cd63c16e5884fdE"(ptr align 8, ptr align 8) unnamed_addr #1

; core::panicking::panic_fmt
; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_ZN4core9panicking9panic_fmt17h8cf040903fbd6815E(ptr, ptr align 8) unnamed_addr #2

; Function Attrs: nonlazybind uwtable
declare i32 @rust_eh_personality(i32, i32, i64, ptr, ptr) unnamed_addr #1

; core::panicking::panic_cannot_unwind
; Function Attrs: cold noinline noreturn nounwind nonlazybind uwtable
declare void @_ZN4core9panicking19panic_cannot_unwind17h4e1d030604f42bd5E() unnamed_addr #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite)
declare void @llvm.assume(i1 noundef) #4

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare i1 @llvm.expect.i1(i1, i1) #5

; core::panicking::panic
; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_ZN4core9panicking5panic17h2193f8fbbe16bdc6E(ptr align 1, i64, ptr align 8) unnamed_addr #2

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #6

; alloc::fmt::format::format_inner
; Function Attrs: nonlazybind uwtable
declare void @_ZN5alloc3fmt6format12format_inner17h0a1842759b6533d6E(ptr sret(%"alloc::string::String"), ptr) unnamed_addr #1

; Function Attrs: nounwind nonlazybind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable
declare noalias ptr @__rust_alloc(i64, i64 allocalign) unnamed_addr #7

; Function Attrs: nounwind nonlazybind allockind("alloc,zeroed,aligned") allocsize(0) uwtable
declare noalias ptr @__rust_alloc_zeroed(i64, i64 allocalign) unnamed_addr #8

; alloc::alloc::handle_alloc_error
; Function Attrs: cold noreturn nonlazybind uwtable
declare void @_ZN5alloc5alloc18handle_alloc_error17hb6dacc58213cdde5E(i64, i64) unnamed_addr #9

; alloc::raw_vec::capacity_overflow
; Function Attrs: noreturn nonlazybind uwtable
declare void @_ZN5alloc7raw_vec17capacity_overflow17h38e98ea3430a1a20E() unnamed_addr #10

; Function Attrs: nounwind nonlazybind allockind("free") uwtable
declare void @__rust_dealloc(ptr allocptr, i64, i64) unnamed_addr #11

attributes #0 = { inlinehint nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #1 = { nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #2 = { cold noinline noreturn nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #3 = { cold noinline noreturn nounwind nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #4 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite) }
attributes #5 = { nocallback nofree nosync nounwind willreturn memory(none) }
attributes #6 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #7 = { nounwind nonlazybind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #8 = { nounwind nonlazybind allockind("alloc,zeroed,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #9 = { cold noreturn nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #10 = { noreturn nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #11 = { nounwind nonlazybind allockind("free") uwtable "alloc-family"="__rust_alloc" "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #12 = { noreturn }
attributes #13 = { noinline }
attributes #14 = { noinline noreturn nounwind }
attributes #15 = { nounwind }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 2, !"RtLibUseGOT", i32 1}
!2 = !{}
!3 = !{i64 8}
!4 = !{i64 1}
!5 = !{i8 0, i8 2}
!6 = !{i64 1, i64 -9223372036854775807}
!7 = !{i64 0, i64 -9223372036854775807}
!8 = !{i64 0, i64 -9223372036854775806}
