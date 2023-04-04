#include "c_binding.h"
#include "generated_dll.h"
__declspec(dllexport) char *HelloFromGolang()
{
  return Go_HelloFromGolang();
}
__declspec(dllexport) void PrintStringInGolang(char *s)
{
  Go_PrintStringInGolang(s);
}
__declspec(dllexport) int *Sum(int a, int b)
{
  return Go_Sum(a, b);
}
__declspec(dllexport) int *Multiply(int a, int b)
{
  return Go_Multiply(a, b);
}
__declspec(dllexport) int *Subtraction(int a, int b)
{
  return Go_Subtraction(a, b);
}
__declspec(dllexport) int *PrintStruct(structA struct_a)
{
  return Go_PrintStruct(struct_a);
}
