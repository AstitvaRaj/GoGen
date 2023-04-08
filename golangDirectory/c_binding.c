#include "go_generated_dll.h"
  __declspec(dllexport)   int*  CPrintStruct (CStructA struct_a)
 {
return Go_PrintStruct(   struct_a);
}
  __declspec(dllexport) void CHelloFromGolang (CStructA x)
 {
 Go_HelloFromGolang(   x);
}
 __declspec(dllexport)   int*  CPrintStringInGolang (char* s)
 {
return Go_PrintStringInGolang(   s);
}
  __declspec(dllexport)   int*  CSum (int a,int b)
 {
return Go_Sum(   a, b);
}
 __declspec(dllexport)   int*  CMultiply (int a,int b)
 {
return Go_Multiply(   a, b);
}
 __declspec(dllexport)   int*  CSubtraction (int a,int b)
 {
return Go_Subtraction(   a, b);
}

int main(){return 0;}