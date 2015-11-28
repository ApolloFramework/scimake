/**
 * $Id$
 *
 * Copyright &copy; 2012-2015, Tech-X Corporation, Boulder, CO.
 * All rights reserved.
 *
 * Determine whether the compiler knows std::abs<double>.
 */

#include <cmath>

int main(int argc, char** argv) {
  double a = 0;
  double b = std::abs(a);
  return 0;
}

