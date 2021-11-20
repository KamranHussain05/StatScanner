//
//  Calculator.cpp
//  StatsScanner
//
//  Created by Kamran on 11/20/21.
//

#include "Calculator.hpp"

int Calculator::add(int x, int y){
    return x+y;
}

int Calculator::subtract(int x, int y){
    return x-y;
}

int Calculator::multiply(int x, int y){
    return x*y;
}

int Calculator::divide(float x, float y){
    return x/y;
}

int Calculator::power(int x, int factor){
    return pow(x, factor);
}

int Calculator::sqrt(int x){
    return sqrtf(x);
}
