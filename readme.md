```markdown
# Warn-Compiler - Turn the Tables on GCC! 🔥

A hilarious GCC wrapper that lets your program warn the compiler instead of being warned by it!

对于简体中文版本，[请点击这里](/readme-cn.md)。

## Project Purpose

Tired of being nagged by your compiler? Fed up with GCC's constant whining? Time for your code to fight back! This tool intercepts GCC's warnings and errors, then lets your program "educate" the compiler with attitude - from polite corrections to savage roasts.

**Important Warranty**: Your compiler's feelings are not covered 💔

## Installation & Usage

### Quick Start (Because Who Reads Docs?)

```bash
# Clone this legendary repo
git clone https://github.com/yourusername/warn-gcc.git
cd warn-gcc

# Make it executable (obviously)
chmod +x warn-gcc-en.sh

# Replace your boring compilation
./warn-gcc-en.sh --sarcastic -Wall your_code.cpp -o your_program
```

### Pro Gamer Moves

```bash
# Set up aliases like a chad
alias gcc-gentleman='./warn-gcc-en.sh --polite'
alias gcc-savage='./warn-gcc-en.sh --sarcastic'  
alias gcc-berserker='./warn-gcc-en.sh --angry'

# Now destroy GCC in style
gcc-savage -Wall -Wextra my_perfectly_fine_code.cpp
```

### Logging Your Victories

Want to document your epic battles against GCC? Enable logging!

```
# Log the carnage
./warn-gcc-en.sh --log=epic_battles.log --angry -Wall main.cpp

# Share your victories with the world
cat epic_battles.log
```

## Attitude Modes

Choose your program's personality when dealing with that annoying compiler:

### Polite Mode (--polite)
Your program maintains class while diplomatically correcting GCC's "mistakes":
```bash
/your/actual/path/warn-gcc/warn-gcc.sh --polite -Wall test.cpp -o test
```
Sample output:
```
⚠️  test.cpp:12
    → Dear GCC, I respectfully disagree with your concern about 'unused variable 'unused_counter'' is misguided
    💬 Perhaps this variable serves a higher purpose 🙏
```

See example log file [here](/example_en_polite.log).

### Sarcastic Mode (--sarcastic)
Your program delivers cutting wit and devastating sarcasm:
```bash
/your/actual/path/warn-gcc/warn-gcc.sh --sarcastic -Wall test.cpp -o test
```
Sample output:
```
⚠️  test.cpp:12
    → Oh wow, GCC, you're SO concerned about 'unused variable 'unused_counter'' is misguided
    💬 Oh no! An unused variable! Call the police! 🚨
```

See example log file [here](/example_en_sarcastic.log).

### Angry Mode (--angry)
Your program unleashes absolute fury and creative profanity:
```bash
/your/actual/path/warn-gcc/warn-gcc.sh --angry -Wall test.cpp -o test
```
Sample output:
```
⚠️  test.cpp:12
    → BACK OFF, GCC! There's nothing wrong with 'unused variable 'unused_counter'' is misguided
    💬 SO FUCKING WHAT if I don't use every damn variable?! 🤬
```

See example log file [here](/example_en_angry_log.log).

## Complete Usage Example

### Step 1: Create Test Code with Intentional "Issues"

Save this as `test.cpp`:
```cpp
#include <iostream>
#include <vector>

int main() {
    // Unused variables (GCC will whine about these)
    int unused_counter = 42;
    double forgotten_pi = 3.14159;
    
    // Uninitialized variable (GCC loves to complain)
    int uninitialized_value;
    std::cout << "Value: " << uninitialized_value << std::endl;
    
    // Undefined function call (GCC will throw a fit)
    undefined_function();
    
    // Type mismatch (GCC being picky as usual)
    std::vector<int> numbers;
    numbers.push_back("not a number");
    
    return 0;
}
```

### Step 2: Watch Your Code Demolish GCC

```bash
# Polite diplomatic correction
/your/actual/path/warn-gcc/warn-gcc.sh --polite -Wall test.cpp -o test

# Sarcastic intellectual superiority
/your/actual/path/warn-gcc/warn-gcc.sh --sarcastic -Wall test.cpp -o test

# Full nuclear option
/your/actual/path/warn-gcc/warn-gcc.sh --angry -Wall test.cpp -o test
```

### Step 3: Enjoy the Carnage!

You'll witness something beautiful like this:
```

⚠️  test.cpp:6
    → What a surprise! GCC doesn't like 'unused variable 'unused_counter'' is misguided
    💬 Oh no! An unused variable! Call the police! 🚨

⚠️  test.cpp:10
    → Amazing detective work, GCC! You found 'may be used uninitialized' is misguided
    💬 Maybe it's initialized in a parallel universe 🌌

🚨 test.cpp:13
    → Oh BRILLIANT, GCC! You think THIS is an error: 'undefined function'

═══════════════════════════════════════════════
GCC has been thoroughly roasted. Mode: Sassy Programmer 😏
═══════════════════════════════════════════════
```

## Convenience Setup

### Shell Aliases
Add these to your `~/.bashrc` or `~/.zshrc` for maximum convenience:

```bash
alias gcc-polite='/your/actual/path/warn-gcc/warn-gcc.sh --polite'
alias gcc-sassy='/your/actual/path/warn-gcc/warn-gcc.sh --sarcastic'  
alias gcc-rage='/your/actual/path/warn-gcc/warn-gcc.sh --angry'

# Reload your shell
source ~/.bashrc
```

Then use them like a boss:
```bash
gcc-sassy -Wall -O2 main.cpp -o main
gcc-rage -Wextra -pedantic mycode.cpp -o mycode
```

### Makefile Integration
```makefile
# Make your entire build process sassy
CC = /your/actual/path/warn-gcc/warn-gcc.sh --sarcastic
CFLAGS = -Wall -Wextra -O2

my_program: main.cpp utils.cpp
	$(CC) $(CFLAGS) main.cpp utils.cpp -o my_program
```

### CMake Integration
```cmake
# Set the compiler to your sass-enabled wrapper
set(CMAKE_C_COMPILER "/your/actual/path/warn-gcc/warn-gcc.sh --angry")
set(CMAKE_CXX_COMPILER "/your/actual/path/warn-gcc/warn-gcc.sh --angry")
```

## Advanced Usage Scenarios

### Continuous Integration Sass
```yaml
# GitHub Actions that roast your compiler
- name: Build with Attitude
  run: /your/actual/path/warn-gcc/warn-gcc.sh --sarcastic -Wall src/*.cpp -o my_app
```

### IDE Integration
Most IDEs allow custom compiler paths. Set yours to `/your/actual/path/warn-gcc/warn-gcc.sh` and enjoy watching your code talk back in real-time during development!

### Team Building Exercise
```bash
# Make code reviews more entertaining
/your/actual/path/warn-gcc/warn-gcc.sh --angry -Wall -Wextra -pedantic team_member_code.cpp
```

## Hall of Fame - Best Responses

Some legendary comebacks you might encounter:

**Polite Mode Classic:**
> "Dear GCC, I respectfully disagree with your concern about 'unused variable' - Perhaps this variable serves a higher purpose 🙏"

**Sarcastic Mode Gold:**
> "Hold the presses! GCC spotted 'format string mismatch' - Format schmformat! I have artistic vision! 🎨"

**Angry Mode Nuclear:**
> "FUCK OFF, GCC! Keep your opinions about 'implicit declaration' - DECLARATIONS ARE FOR LOSERS! 🔥"

## Contributing

Got better insults? Found a bug? Want to add support for other compilers? PRs are welcome!

### Ideas for New Features:
- **Clang Support**: Extend the sass to other compilers
- **Custom Response Files**: Let users create their own insult databases
- **Severity Escalation**: Get angrier as more warnings accumulate
- **Team Modes**: Different personalities for different team members
- **Historical Quotes**: Responses in the style of famous programmers

## License

MIT License - Have fun, make compilers cry, and may your code forever have the last word! 😄

## Important Disclaimer

This tool is designed purely for entertainment and stress relief. In serious development environments, please do pay attention to compiler warnings - they're usually right (but don't tell GCC we said that). 

However, life's too short to take everything seriously, and sometimes you need to remind your tools who's boss. Use responsibly, have fun, and remember: you write the code, not the compiler! 

---

*"In a world where compilers judge your code... one program dared to judge back."* 