; ModuleID = 'weldstreaming/weldstreaming/main.c'
source_filename = "weldstreaming/weldstreaming/main.c"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.13.0"

%struct.__sFILE = type { i8*, i32, i32, i16, i16, %struct.__sbuf, i32, i8*, i32 (i8*)*, i32 (i8*, i8*, i32)*, i64 (i8*, i64, i32)*, i32 (i8*, i8*, i32)*, %struct.__sbuf, %struct.__sFILEX*, i32, [3 x i8], [1 x i8], %struct.__sbuf, i32, i64 }
%struct.__sFILEX = type opaque
%struct.__sbuf = type { i8*, i32 }

@.str = private unnamed_addr constant [18 x i8] c"Starting stream.\0A\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c">\00", align 1
@.str.2 = private unnamed_addr constant [23 x i8] c"\0AEOF read. Exiting...\0A\00", align 1
@__stderrp = external global %struct.__sFILE*, align 8
@.str.3 = private unnamed_addr constant [45 x i8] c"Input could not be interpreted as a number!\0A\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main(i32, i8**) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  %6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str, i32 0, i32 0))
  call void @weld_loop(void (i32*)* @stdio_stream_src, void (i32)* @stdio_stream_sink)
  ret i32 0
}

declare i32 @printf(i8*, ...) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @weld_loop(void (i32*)*, void (i32)*) #0 {
  %3 = alloca void (i32*)*, align 8
  %4 = alloca void (i32)*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store void (i32*)* %0, void (i32*)** %3, align 8
  store void (i32)* %1, void (i32)** %4, align 8
  br label %7

; <label>:7:                                      ; preds = %2, %7
  %8 = load void (i32*)*, void (i32*)** %3, align 8
  call void %8(i32* %5)
  %9 = load i32, i32* %5, align 4
  %10 = mul nsw i32 %9, 2
  store i32 %10, i32* %6, align 4
  %11 = load void (i32)*, void (i32)** %4, align 8
  %12 = load i32, i32* %6, align 4
  call void %11(i32 %12)
  br label %7
                                                  ; No predecessors!
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @stdio_stream_src(i32*) #0 {
  %2 = alloca i32*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i64, align 8
  store i32* %0, i32** %2, align 8
  br label %5

; <label>:5:                                      ; preds = %1, %29
  %6 = call i8* @readline(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i8* %6, i8** %3, align 8
  %7 = load i8*, i8** %3, align 8
  %8 = icmp eq i8* %7, null
  br i1 %8, label %9, label %11

; <label>:9:                                      ; preds = %5
  %10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.2, i32 0, i32 0))
  call void @exit(i32 0) #3
  unreachable

; <label>:11:                                     ; preds = %5
  %12 = load i8*, i8** %3, align 8
  %13 = call i32 @add_history(i8* %12)
  %14 = call i32* @__error()
  store i32 0, i32* %14, align 4
  %15 = load i8*, i8** %3, align 8
  %16 = call i64 @strtol(i8* %15, i8** null, i32 0)
  store i64 %16, i64* %4, align 8
  %17 = load i8*, i8** %3, align 8
  call void @free(i8* %17)
  %18 = call i32* @__error()
  %19 = load i32, i32* %18, align 4
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %21, label %25

; <label>:21:                                     ; preds = %11
  %22 = load i64, i64* %4, align 8
  %23 = trunc i64 %22 to i32
  %24 = load i32*, i32** %2, align 8
  store i32 %23, i32* %24, align 4
  ret void

; <label>:25:                                     ; preds = %11
  %26 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %27 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %26, i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.3, i32 0, i32 0))
  br label %28

; <label>:28:                                     ; preds = %25
  br label %29

; <label>:29:                                     ; preds = %28
  br label %5
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @stdio_stream_sink(i32) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0), i32 %3)
  ret void
}

declare i8* @readline(i8*) #1

; Function Attrs: noreturn
declare void @exit(i32) #2

declare i32 @add_history(i8*) #1

declare i32* @__error() #1

declare i64 @strtol(i8*, i8**, i32) #1

declare void @free(i8*) #1

declare i32 @fprintf(%struct.__sFILE*, i8*, ...) #1

attributes #0 = { noinline nounwind optnone ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noreturn "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{!"Apple LLVM version 9.1.0 (clang-902.0.39.1)"}
