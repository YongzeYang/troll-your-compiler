# troll-your-compiler - 编译时嘲讽你的GCC，而不是被GCC嘲讽！

一个超级抽象的GCC包装器，让你的程序反过来嘲讽编译器，而不是被编译器嘲讽！

For English version, [please click here](/readme.md).

## 项目目的

受够了被GCC指手画脚？厌倦了编译器的无休止唠叨？是时候让你的代码反击了！这个工具会拦截GCC的警告和错误信息，然后让你的程序用最抽象的网络梗"教育"编译器——从典孝急到祖安电竞，应有尽有。

## 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/YongzeYang/troll-your-compiler.git
cd troll-your-compiler

# 给脚本执行权限
chmod +x warn-gcc-cn.sh
```

### 基本用法

替换你的普通gcc编译：

```bash
# 传统方式（被编译器教训）
gcc -Wall test.cpp -o test

# 新方式（程序教训编译器！抽象圣经启动！）
./warn-gcc-cn.sh -Wall test.cpp -o test
/
```

### 日志记录功能

想要记录你的程序是如何教育GCC的？启用日志功能！

```bash
# 记录到默认文件 warn-gcc.log
./warn-gcc-cn.sh --log --sarcastic -Wall test.cpp -o test

# 记录到指定文件
./warn-gcc-cn.sh --log=my-battle.log --angry -Wall test.cpp -o test

```

日志内容示例：

```
=== [2024-01-15 14:30:25] 编译开始 ===
模式: sarcastic
命令: gcc -Wall test.cpp -o test

[2024-01-15 14:30:25] 警告回应[sarcastic]: 绷不住了🤣 GCC又在BB： 'unused variable 'counter''
[2024-01-15 14:30:25] 特定回应[sarcastic]: 变量不用怎么了？它在冥想！🧘‍♀️ 你懂个寄吧抽象编程？
[2024-01-15 14:30:25] 错误回应[sarcastic]: 典！太典了！GCC说这是'错误'🤡 'undefined function'
编译退出码: 1
=== [2024-01-15 14:30:25] 编译结束 ===
```

## 抽象模式

选择你程序在面对GCC时的网络人格：

### 典孝急模式 (--polite)
你的程序表面礼貌，内心麻木，用典孝急三连回击GCC：
```bash
./warn-gcc-cn.sh --polite -Wall test.cpp -o test
```
输出示例：
```
⚠️  test.cpp:86
    → 感恩GCC老师指点： 'more '%' conversions than data arguments '
    💬 GCC老师用心良苦，学生感激 🌈
```

可以[点击这里](/example_cn_polite.log)查看样例日志。

### 抽象圣经模式 (--sarcastic)
你的程序化身阴阳带师，用最抽象的话术嘲讽GCC：
```bash
./warn-gcc-cn.sh --sarcastic -Wall test.cpp -o test
```
输出示例：
```
⚠️  test.cpp:85
    → 寄！开香槟咯！GCC： 'format specifies type 'double' but the argument has type 'const char *' '
    💬 格式化？笑死，根本不需要😏
```

可以[点击这里](/example_cn_sarcastic.log)查看样例日志。

### 祖安电竞模式 (--angry)
你的程序化身祖安键仙，用最暴躁的电竞话术轰炸GCC：
```bash
./warn-gcc-cn.sh --angry -Wall test.cpp -o test
```
输出示例：
```
⚠️  test.cpp:35
    → 你🐎在天堂玩原神呢？GCC： 'implicit conversion from 'double' to 'value_type' (aka 'int') changes value from 3.14 to 3 '
    💬 再BB把你编译器卸了！💣

```

可以[点击这里](/example_cn_angry.log)查看样例日志。

## 完整使用示例

### 第一步：创建抽象测试代码

保存为 `test.cpp`：
```cpp
#include <iostream>
#include <vector>

int main() {
    // 未使用的变量（GCC会为此抱怨）
    int unused_counter = 42;
    double forgotten_pi = 3.14159;
    
    // 未初始化的变量（GCC最爱吐槽这个）
    int uninitialized_value;
    std::cout << "Value: " << uninitialized_value << std::endl;
    
    // 未定义函数调用（GCC会发疯）
    undefined_function();
    
    // 类型不匹配（GCC又要挑刺了）
    std::vector<int> numbers;
    numbers.push_back("not a number");
    
    return 0;
}
```

### 第二步：让你的GCC破防

```bash
# 典孝急三连教育
./warn-gcc-cn.sh --polite -Wall test.cpp -o test

# 抽象圣经洗礼
./warn-gcc-cn.sh --sarcastic -Wall test.cpp -o test

# 祖安电竞狂暴输出
./warn-gcc-cn.sh --angry -Wall test.cpp -o test
```

### 第三步：见证互怼战场！

你会见证这样的逆天抽象场景：
```
⚠️  test.cpp:6
    → 绷不住了🤣 GCC又在BB： 'unused variable 'unused_counter''
    💬 变量不用怎么了？它在冥想！🧘‍♀️ 你懂个寄吧抽象编程？

⚠️  test.cpp:10
    → 属于是绷不住了🤡 GCC说： 'may be used uninitialized'
    💬 没初始化？这叫量子叠加态！你懂个🔨？

🚨 test.cpp:13
    → 典！太典了！GCC说这是'错误'🤡 'undefined function'

```

## 便捷设置

### Shell别名
添加到你的 `~/.bashrc` 或 `~/.zshrc` 享受抽象人生：

```bash
# 抽象三巨头
alias gcc-polite='./warn-gcc-cn.sh --polite'
alias gcc-sarcastic='./warn-gcc-cn.sh --sarcastic'  
alias gcc-angry='./warn-gcc-cn.sh --angry'

# 重新加载shell
source ~/.bashrc
```

然后像网络大神一样使用：
```bash
gcc-sarcastic -Wall -O2 main.cpp -o main
gcc-angry -Wextra -pedantic mycode.cpp -o mycode
```

### Makefile集成
```makefile
# 让你的整个构建过程都充满抽象
CC = ./warn-gcc-cn.sh --sarcastic
CFLAGS = -Wall -Wextra -O2

my_program: main.cpp utils.cpp
	$(CC) $(CFLAGS) main.cpp utils.cpp -o my_program
```

### CMake集成
```cmake
# 将编译器设置为你的抽象增强包装器
set(CMAKE_C_COMPILER "/your/actual/path/warn-gcc-cn.sh --angry")
set(CMAKE_CXX_COMPILER "/your/actual/path/warn-gcc-cn.sh --angry")
```

## 高级抽象用法

### 持续集成抽象化
```yaml
# GitHub Actions 抽象你的编译器
- name: 抽象圣经构建
  run: ./warn-gcc-cn.sh --sarcastic -Wall src/*.cpp -o my_app
```

### IDE集成
大多数IDE允许自定义编译器路径。将你的设置为`warn-gcc-cn.sh`的完整路径，享受在开发过程中实时观看抽象battle！

### 团队建设抽象练习
```bash
# 让代码审查变成抽象大赏
./warn-gcc-cn.sh --angry -Wall -Wextra -pedantic team_member_code.cpp
```

## 贡献

有更抽象的梗？发现了bug？想要添加新的网络流行语？欢迎PR！

### 新功能抽象想法：
- **更多编译器支持**：让Clang也体验抽象
- **自定义梗库**：让用户创建自己的抽象话术
- **梗的进化**：随着警告累积越来越抽象
- **地域特色模式**：各地方言抽象版本
- **实时热梗更新**：跟上最新网络流行语

## License

MIT许可证 - 抽象快乐，让编译器寄了，愿你的代码永远典中典

## 重要抽象声明

这个工具纯粹是为了抽象娱乐和缓解编程压力而设计的。在严肃的开发环境中，请确实注意编译器警告——虽然它们很烦，但通常是对的（但别告诉GCC我们这么说了）。

然而，程序员的生活已经够苦了，偶尔抽象一下又不会怎样。负责任地使用，抽象地快乐，记住：是你写代码，不是编译器写你！

典！太典了！

(本项目构建过程中没有编译器收到伤害。)

---

*"在一个编译器教育程序员的世界里...一个程序员决定反向教育。"* 
