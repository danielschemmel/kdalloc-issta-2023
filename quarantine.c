#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
  void* addresses[10];

  for(size_t i = 0; i < sizeof(addresses)/sizeof(*addresses); ++i) {
    addresses[i] = malloc(1);
    free(addresses[i]);
  }

  printf("Allocated addresses:");
  for(size_t i = 0; i < sizeof(addresses)/sizeof(*addresses); ++i) {
    printf(" %p", addresses[i]);
  }
  printf("\n");
}