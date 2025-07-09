#include <iostream>
#include <vector>
#include <string>
#include <cstdio>

// Undefined function declarations
void mysterious_function();
int undefined_calculation(int x);

int main() {
    // Unused variables - various types
    int unused_counter = 42;
    double forgotten_pi = 3.14159;
    char lonely_char = 'x';
    std::string unused_message = "Hello, world!";
    bool unused_flag = true;
    float unused_ratio = 2.5f;
    long unused_number = 123456789L;
    
    // Uninitialized variables
    int uninitialized_int;
    double uninitialized_double;
    char uninitialized_char;
    
    // Using uninitialized variables
    std::cout << "Uninitialized: " << uninitialized_int << std::endl;
    
    // Implicit function declarations - calling undeclared functions
    undefined_function_call();
    another_mystery_function(42, "test");
    
    // Type mismatches
    std::vector<int> numbers;
    numbers.push_back("not a number");  // string to int vector
    numbers.push_back(3.14);            // double to int
    
    // Format string issues
    printf("Number: %s\n", 42);         // %s with int
    printf("String: %d\n", "hello");    // %d with string
    printf("Float: %d\n", 3.14);        // %d with float
    
    // Comparison issues
    if (unused_counter = 50) {          // assignment instead of comparison
        std::cout << "Assignment in condition" << std::endl;
    }
    
    // Return value issues
    return;  // should be return 0;
    
    // Unreachable code
    std::cout << "This will never execute" << std::endl;
    unused_counter = 100;
    
    // Syntax errors
    int x = 5  // missing semicolon
    int y = 10;
    
    // More unused variables
    const char* unused_string = "forgotten";
    unsigned int unused_uint = 999;
    short unused_short = 42;
}

// Problematic function definition
int problematic_function() {
    int result;  // uninitialized
    int another_unused = 77;
    return result;  // returning uninitialized value
}

// Function that should return a value but doesn't have return statement
int missing_return_function() {
    int value = 42;
    // missing return statement
}

// Unused parameters
void unused_parameter_function(int used_param, int unused_param, double another_unused) {
    std::cout << "Only using: " << used_param << std::endl;
    // unused_param and another_unused are not used
}

// More format issues
void format_problems() {
    printf("%d %s %f\n", "wrong", 42, "types");
    printf("Too few args: %d %d %d\n", 1, 2);  // missing arguments
    printf("Too many args: %d\n", 1, 2, 3);    // extra arguments
}