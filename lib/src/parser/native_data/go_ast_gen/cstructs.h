#include <stdlib.h>

typedef struct node
{
  char *kind;
  void *fieldStruct;
} node;

typedef struct package
{
  char *name;
  void *file;
  int fileLen;
} package;

typedef struct file
{
  char *name;
  void *decl;
  int declLen;
} file;

typedef struct funcDecl
{
  char *name;
  void *funcTypes;
} funcDecl;

typedef struct funcType
{
  void *params;
  void *results;
} funcType;

typedef struct fieldList
{
  void *list;
  int listLen;
} fieldList;

typedef struct field
{
  void *names;
  int nameLen;
  void *types;
} field;

typedef struct ident
{
  char *name;
} ident;

typedef struct valueDecl
{
  char *name;
} valueDecl;

typedef struct type
{
  char *name;
  void *decl;
  int declsLength;
} type;

typedef struct genDecl
{
  char *token;
  void *specs;
  int specsLength;
} genDecl;

typedef struct importSpec
{
  void *name;
  char *kind;
  char *value;
} importSpec;

typedef struct typeSpec
{
  char *name;
  void *types;
} typeSpec;

typedef struct structType
{
  void *fields;
} structType;

void *getAstHead(char *path);

char *getModFileName(char *modFileLocation);