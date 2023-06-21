#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>

struct node {
  struct node *lhs, *rhs;
  char const *key;
}* root = NULL;

static uint64_t priority(void *p) {
  uint64_t h = 0xcbf29ce484222325;
  for (size_t i = 0; i < sizeof(p); ++i)
    h = (h ^ ((unsigned char *)&p)[i]) * 0x100000001B3;
  return h;
}

void insert(struct node **n, char const *str) {
  if (!*n) {
    *n = calloc(1, sizeof(struct node));
    (*n)->key = str;
  } else {
    int cmp = strcmp(str, (*n)->key);
    if (cmp < 0) {
      insert(&(*n)->lhs, str);
      if (priority((*n)->lhs) < priority(*n)) {
        struct node *lhs = (*n)->lhs;
        (*n)->lhs = lhs->rhs;
        lhs->rhs = (*n);
        *n = lhs;
      }
    } else if (cmp > 0) {
      insert(&(*n)->rhs, str);
      if (priority((*n)->rhs) < priority(*n)) {
        struct node *rhs = (*n)->rhs;
        (*n)->rhs = rhs->lhs;
        rhs->lhs = (*n);
        *n = rhs;
      }
    }
  }
}

int main() {
  char sym2[2], sym3[2];
  sym2[1] = '\0';
  sym3[1] = '\0';
  read(0, sym2, 1);
  read(0, sym3, 1);
  
  insert(&root, strdup("1"));
  insert(&root, sym2);
  insert(&root, sym3);
  
  assert(strcmp(root->key, "1") == 0);
}
