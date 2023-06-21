#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
  long *x = malloc(sizeof(long));
  long *y = malloc(sizeof(long));

  *y = 0;
  x[4] = 42; // Bug: out of bounds access
  printf("This should be 0: %ld\n", *y);

  free(x);
  free(y);
}