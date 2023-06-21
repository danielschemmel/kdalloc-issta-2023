#include <stdio.h>
#include <stdlib.h>

int main() {
  int *x = malloc(sizeof(int));
  *x = 1;
  free(x); // Bug: object freed too early

  int *y = malloc(sizeof(int));
  *y = 2;

  printf("%p:␣%d\n%p:␣%d\n", x, *x, y, *y);
  free(y);
}