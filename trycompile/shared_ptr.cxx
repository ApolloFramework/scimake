/**
 * $Id$
 *
 * Copyright &copy; 2013-2014, Tech-X Corporation, Boulder, CO.
 * Arbitrary redistribution allowed provided this copyright remains.
 */

#include <sci_shared_ptr>

struct S {
  int i;
};

int main(int argc, char** argv) {
  sci_shared_ptr<S> sptr;
  return 0;
}
