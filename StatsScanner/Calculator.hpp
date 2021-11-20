//
//  Calculator.hpp
//  StatsScanner
//
//  Created by Kamran on 11/20/21.
//

#ifndef Calculator_hpp
#define Calculator_hpp

#include <stdio.h>
#include <iostream>
#include <math.h>

class Calculator {
public:
    int add(int x, int y);
    int subtract(int x, int y);
    int multiply(int x, int y);
    int divide(float x, float y);
    int power(int x, int pow);
    int sqrt(int x);
};

#endif /* Calculator_hpp */
