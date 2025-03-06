import std.stdio : writeln;
import std.range : iota;
import std.array : array;
import std.file : write;
import std.json;
import ldc.simd;

import std.math: pow, cbrt;

//version(LDC) {
//    import ldc.intrinsics;
//
//    pragma(LDC_intrinsic, "llvm.pow.f32")
//    float pow(float, float) nothrow;
//
//    pragma(LDC_intrinsic, "llvm.cbrt.f32")
//    float cbrt(float) nothrow;
//}

import simplebench;
enum float oneThird = 1.0 / 3.0;

T sum_pow(T)(T[] arr) {
    T res; 
    foreach(ref el; arr)
        res += pow(el, oneThird);
    return res;
}

T sum_cbrt(T)(T[] arr) {
    T res; 
    foreach(ref el; arr)
        res += cbrt(el);
    return res;
}

void test_sum_pow(float N)(ref Bencher bencher){
  float[] arr = N.iota.array;
  bencher.iter((){
      return sum_pow(arr);
  });
}

void test_sum_cbrt(float N)(ref Bencher bencher){
  float[] arr = N.iota.array;
  bencher.iter((){
      return sum_cbrt(arr);
  });
}

void main()
{
  JSONValue js_arr;
  js_arr.array = [];
  static foreach(double N; iota(1000,10_001,1_000)) {
    js_arr.array ~= BenchMain!(test_sum_pow!N, test_sum_cbrt!N).toJSON;
  }
  write("data.json", js_arr.toPrettyString(JSONOptions.specialFloatLiterals));
}
