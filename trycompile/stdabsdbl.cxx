/**
 * $Id$
 * 
 * Copyright &copy; 2014-2014, Tech-X Corporation
 *
 * Determine whether the compiler knows std::abs<double>.
 */

#include <cmath>

int main(int argc, char** argv) {
  double a = 0;
  double b = std::abs(a);
  return 0;
}

