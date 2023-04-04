
char *HelloFromGolang();
void PrintStringInGolang(char *s);
int *Sum(int a, int b);
int *Multiply(int a, int b);
int *Subtraction(int a, int b);

typedef struct structB
{
    int a;
    int b;
} structB;

typedef struct structA
{
    int a;
    structB b;
} structA;

int *PrintStruct(structA struct_a);
