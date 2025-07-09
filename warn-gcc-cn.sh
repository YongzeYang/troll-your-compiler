#!/bin/bash
# warn-gcc-cn.sh - 让程序反击编译器！抽象圣经启动！

# 日志配置
LOG_ENABLED=false
LOG_FILE=""
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

MODE="normal"

while [[ $# -gt 0 ]]; do
    case $1 in
        --polite)
            MODE="polite"
            shift
            ;;
        --sarcastic)
            MODE="sarcastic"
            shift
            ;;
        --angry)
            MODE="angry"
            shift
            ;;
        --log)
            LOG_ENABLED=true
            LOG_FILE="${2:-warn-gcc.log}"
            shift 2
            ;;
        --log=*)
            LOG_ENABLED=true
            LOG_FILE="${1#*=}"
            shift
            ;;
        --help)
            echo "用法: $0 [--polite|--sarcastic|--angry] [--log [文件名]] [gcc参数...]"
            echo "模式:"
            echo "  --polite     典孝急模式（表面礼貌）"
            echo "  --sarcastic  抽象圣经模式（阴阳怪气）"
            echo "  --angry      祖安电竞模式（狂暴输出）"
            echo ""
            echo "日志选项:"
            echo "  --log        启用日志记录到 warn-gcc.log"
            echo "  --log=FILE   启用日志记录到指定文件"
            exit 0
            ;;
        *)
            break
            ;;
    esac
done

GCC_ARGS="$@"
STDERR_FILE=$(mktemp)

POLITE_WARNINGS=(
    "典中典！GCC老师又在鞭策学生了："
    "孝死！GCC大人真是用心良苦："
    "急了急了！GCC又发现："
    "您说得对！但学生觉得："
    "感恩GCC老师指点："
    "GCC老师辛苦了！但："
    "栓Q了GCC！您说的："
    "听我说谢谢你~因为："
    "破防了！GCC又教我做事："
    "蚌埠住了！GCC真是典："
    "绷不住了！GCC又在："
    "典孝急三连！GCC说："
    "寄！GCC大人又："
    "赢麻了！GCC发现："
    "属于是了！GCC觉得："
    "泪目了！GCC如此关心："
    "受教了！GCC老师指出："
    "学生惶恐！GCC大人提及："
    "醍醐灌顶！GCC教导："
    "如听仙乐！GCC说："
    "茅塞顿开！GCC提醒："
    "感恩戴德！GCC指出："
    "五体投地！GCC发现："
    "如沐春风！GCC警告："
    "恍然大悟！GCC说："
    "感激涕零！GCC关心："
    "三生有幸！GCC教导："
    "铭记在心！GCC指出："
    "承蒙教诲！GCC说："
    "恩重如山！GCC发现："
)

SARCASTIC_WARNINGS=(
    "典！太典了！GCC又双叒叕在："
    "绷不住了🤣 GCC又在BB："
    "蚌埠住了！GCC大师发现了："
    "急了急了？GCC又在乎："
    "属于是绷不住了🤡 GCC说："
    "寄！GCC大聪明觉得："
    "赢麻了！GCC又拿捏："
    "典中典之典中典🤏 GCC："
    "抽象圣经启动！GCC觉得："
    "好家伙！GCC直呼内行："
    "离大谱！GCC又在乎："
    "绝绝子！GCC发现了："
    "栓Q！GCC又在乎："
    "整不会了！GCC说："
    "蚌！GCC大师又："
    "麻了！GCC又在："
    "笑死！GCC觉得："
    "好崩！GCC又在："
    "典中典！GCC又在："
    "寄吧谁在乎？GCC："
    "蚌埠住了家人们！GCC："
    "典，可典，太典了！GCC："
    "属于是麻中麻了！GCC："
    "好崩，崩不住了！GCC："
    "赢麻了属于是！GCC："
    "寄，开摆！GCC："
    "绷，典，急！GCC三件套："
    "蚌埠住了！GCC又在乎："
    "典中典之典中典！GCC："
    "抽象！太抽象了！GCC："
    "好家伙我直接好家伙！GCC："
    "离离原上谱！GCC："
    "绝绝子yyds！GCC："
    "栓Q我真的会谢！GCC："
    "整不会了属于是！GCC："
    "蚌埠住了蚌埠住了！GCC："
    "麻了麻了！GCC："
    "笑不活了家人们！GCC："
    "好崩！直接崩！GCC："
    "寄！开香槟咯！GCC："
)

ANGRY_WARNINGS=(
    "我CNM的GCC！管你P事的："
    "RNM退钱！GCC少管："
    "你🐎没了GCC！别BB："
    "爪巴！GCC给爷爬："
    "你寄吧谁啊GCC？管："
    "你🐎在骨灰盒里仰卧起坐呢？GCC："
    "我测你🐎GCC！少管："
    "你🐎灵堂KTV呢？GCC："
    "你🐎在奈何桥蹦迪呢？GCC："
    "你🐎在阎王殿打榜呢？GCC："
    "你🐎在功德林刷火箭呢？GCC："
    "你🐎在蟠桃园摇花手呢？GCC："
    "你🐎在生死簿上857呢？GCC："
    "你🐎在孟婆汤里下毒呢？GCC："
    "你🐎在奈何桥漂移呢？GCC："
    "你🐎在天堂玩原神呢？GCC："
    "你🐎在地狱开银趴呢？GCC："
    "你🐎在凌霄宝殿蹦迪呢？GCC："
    "你🐎在南天门摇花手呢？GCC："
    "你🐎在瑶池开直播呢？GCC："
    "你🐎在八卦炉里炼丹呢？GCC："
    "你🐎在蟠桃园偷桃呢？GCC："
    "你🐎在广寒宫蹦迪呢？GCC："
    "你🐎在兜率宫烧丹呢？GCC："
    "你🐎在五行山下蹦迪呢？GCC："
    "你🐎在女儿国选妃呢？GCC："
    "你🐎在火焰山烧烤呢？GCC："
    "你🐎在流沙河摸鱼呢？GCC："
    "你🐎在通天河冲浪呢？GCC："
    "你🐎在狮驼岭喂狮子呢？GCC："
    "你🐎在盘丝洞蹦迪呢？GCC："
    "你🐎在女儿国开银趴呢？GCC："
    "你🐎在火焰山烤自己呢？GCC："
    "你🐎在流沙河沉底呢？GCC："
    "你🐎在通天河漂流呢？GCC："
    "你🐎在狮驼岭喂妖怪呢？GCC："
    "你🐎在盘丝洞织网呢？GCC："
    "你🐎在女儿国选美呢？GCC："
    "你🐎在火焰山自焚呢？GCC："
    "你🐎在流沙河潜水呢？GCC："
    "你🐎在通天河游泳呢？GCC："
    "你🐎在狮驼岭喂鸟呢？GCC："
    "你🐎在盘丝洞蹦迪呢？GCC："
    "你🐎在女儿国泡妞呢？GCC："
    "你🐎在火焰山BBQ呢？GCC："
    "你🐎在流沙河摸虾呢？GCC："
    "你🐎在通天河冲厕所呢？GCC："
    "你🐎在狮驼岭喂狗呢？GCC："
    "你🐎在盘丝洞织毛衣呢？GCC："
    "你🐎在女儿国当鸭呢？GCC："
)

POLITE_ERRORS=(
    "典孝急三连！GCC说这是'错误'："
    "赢麻了！GCC宣布这是'错误'："
    "属于是破防了！GCC说："
    "寄！GCC觉得这是'错误'："
    "绷不住了🤣 GCC说这是'错误'："
    "蚌埠住了！GCC权威认证："
    "典中典！GCC说这是'错误'："
    "栓Q！GCC又教我做人了："
    "听我说谢谢你~GCC说："
    "好家伙！GCC宣布重大发现："
    "离大谱！GCC说这是'错误'："
    "绝绝子！GCC鉴定为'错误'："
    "孝死！GCC说这是'错误'："
    "急了急了！GCC说这是'错误'："
    "麻了！GCC又发现'错误'："
    "泪目！GCC如此重视："
    "受教了！GCC指正："
    "学生惭愧！GCC发现："
    "醍醐灌顶！GCC指出："
    "如雷贯耳！GCC说："
    "茅塞顿开！GCC警示："
    "感恩戴德！GCC指正："
    "五体投地！GCC发现："
    "如沐春风！GCC纠正："
    "恍然大悟！GCC说："
    "感激涕零！GCC关心："
    "三生有幸！GCC教导："
    "铭记在心！GCC指出："
    "承蒙教诲！GCC说："
    "恩重如山！GCC发现："
)

SARCASTIC_ERRORS=(
    "典！太典了！GCC说这是'错误'🤡"
    "绷不住了🤣 GCC宣布'错误'："
    "蚌埠住了！GCC又整新'错误'："
    "急了急了？GCC又鉴定'错误'："
    "属于是赢麻了！GCC说："
    "寄！GCC大聪明发现'错误'："
    "典中典之典中典🤏 GCC："
    "抽象圣经！GCC说这是'错误'："
    "好家伙！GCC又发现新大陆："
    "离大谱！GCC说这是'错误'？"
    "绝绝子！GCC权威认证'错误'："
    "栓Q！GCC又教我写代码："
    "整不会了！GCC说这是'错误'："
    "蚌！GCC大师说这是'错误'："
    "笑死！GCC觉得这是'错误'："
    "蚌埠住了家人们！GCC："
    "典，可典，太典了！GCC："
    "属于是麻中麻了！GCC："
    "好崩，崩不住了！GCC："
    "赢麻了属于是！GCC："
    "寄，开摆！GCC："
    "绷，典，急！GCC三件套："
    "蚌埠住了！GCC又在乎："
    "典中典之典中典！GCC："
    "抽象！太抽象了！GCC："
    "好家伙我直接好家伙！GCC："
    "离离原上谱！GCC："
    "绝绝子yyds！GCC："
    "栓Q我真的会谢！GCC："
    "整不会了属于是！GCC："
    "蚌埠住了蚌埠住了！GCC："
    "麻了麻了！GCC："
    "笑不活了家人们！GCC："
    "好崩！直接崩！GCC："
    "寄！开香槟咯！GCC："
    "典！太典了！GCC说这是'错误'🤡"
    "绷不住了🤣 GCC宣布'错误'："
    "蚌埠住了！GCC又整新'错误'："
    "急了急了？GCC又鉴定'错误'："
    "属于是赢麻了！GCC说："
)

ANGRY_ERRORS=(
    "我CNM的GCC！这算寄吧错误？："
    "RNM退钱！GCC说这是错误？："
    "你🐎炸了GCC！这算错误？："
    "爪巴！GCC给爷爪巴！："
    "你🐎在奈何桥蹦迪呢？GCC："
    "你🐎在功德林刷火箭呢？GCC："
    "我测你🐎GCC！这算错误？："
    "你🐎在阎王殿打榜呢？GCC："
    "你🐎在骨灰盒里仰卧起坐呢？GCC："
    "你🐎在孟婆汤里下毒呢？GCC："
    "你🐎在生死簿上857呢？GCC："
    "你🐎在蟠桃园摇花手呢？GCC："
    "你🐎在奈何桥漂移呢？GCC："
    "你🐎在天堂玩原神呢？GCC："
    "你🐎在地狱开银趴呢？GCC："
    "你🐎在凌霄宝殿蹦迪呢？GCC："
    "你🐎在南天门摇花手呢？GCC："
    "你🐎在瑶池开直播呢？GCC："
    "你🐎在八卦炉里炼丹呢？GCC："
    "你🐎在蟠桃园偷桃呢？GCC："
    "你🐎在广寒宫蹦迪呢？GCC："
    "你🐎在兜率宫烧丹呢？GCC："
    "你🐎在五行山下蹦迪呢？GCC："
    "你🐎在女儿国选妃呢？GCC："
    "你🐎在火焰山烧烤呢？GCC："
    "你🐎在流沙河摸鱼呢？GCC："
    "你🐎在通天河冲浪呢？GCC："
    "你🐎在狮驼岭喂狮子呢？GCC："
    "你🐎在盘丝洞蹦迪呢？GCC："
    "你🐎在女儿国开银趴呢？GCC："
    "你🐎在火焰山烤自己呢？GCC："
    "你🐎在流沙河沉底呢？GCC："
    "你🐎在通天河漂流呢？GCC："
    "你🐎在狮驼岭喂妖怪呢？GCC："
    "你🐎在盘丝洞织网呢？GCC："
    "你🐎在女儿国选美呢？GCC："
    "你🐎在火焰山自焚呢？GCC："
    "你🐎在流沙河潜水呢？GCC："
    "你🐎在通天河游泳呢？GCC："
    "你🐎在狮驼岭喂鸟呢？GCC："
    "你🐎在盘丝洞蹦迪呢？GCC："
    "你🐎在女儿国泡妞呢？GCC："
    "你🐎在火焰山BBQ呢？GCC："
    "你🐎在流沙河摸虾呢？GCC："
    "你🐎在通天河冲厕所呢？GCC："
    "你🐎在狮驼岭喂狗呢？GCC："
    "你🐎在盘丝洞织毛衣呢？GCC："
    "你🐎在女儿国当鸭呢？GCC："
    "你🐎在火焰山当烤串呢？GCC："
    "你🐎在流沙河当王八呢？GCC："
    "你🐎在通天河当浮尸呢？GCC："
)

get_random_warning() {
    local mode="$1"
    case $mode in
        polite)
            echo "${POLITE_WARNINGS[$RANDOM % ${#POLITE_WARNINGS[@]}]}"
            ;;
        sarcastic)
            echo "${SARCASTIC_WARNINGS[$RANDOM % ${#SARCASTIC_WARNINGS[@]}]}"
            ;;
        angry)
            echo "${ANGRY_WARNINGS[$RANDOM % ${#ANGRY_WARNINGS[@]}]}"
            ;;
        *)
            echo "程序警告GCC："
            ;;
    esac
}

get_random_error() {
    local mode="$1"
    case $mode in
        polite)
            echo "${POLITE_ERRORS[$RANDOM % ${#POLITE_ERRORS[@]}]}"
            ;;
        sarcastic)
            echo "${SARCASTIC_ERRORS[$RANDOM % ${#SARCASTIC_ERRORS[@]}]}"
            ;;
        angry)
            echo "${ANGRY_ERRORS[$RANDOM % ${#ANGRY_ERRORS[@]}]}"
            ;;
        *)
            echo "程序强烈反对GCC的指控："
            ;;
    esac
}

get_specific_response() {
    local warning="$1"
    local mode="$2"
    
    # 扩展特定警告类型回应
    if echo "$warning" | grep -q "unused variable"; then
        case $mode in
            sarcastic) 
                responses=(
                    "变量不用怎么了？它在冥想！🧘‍♀️ 你懂个寄吧抽象编程？"
                    "这叫赛博佛系变量，懂？🪷"
                    "变你🐎的量！老子爱定义就定义！🤬"
                    "变量在禅修，勿扰🙏"
                    "这变量是赛博功德，懂？🪷"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            angry) 
                responses=(
                    "老子爱定义多少变量就定义多少！你🐎都没你管得宽！🤬"
                    "管你P事？这变量老子供着玩！💢"
                    "再BB骨灰都给你扬了！变量不用怎么了？💀"
                    "定义个变量也要管？你寄吧谁啊？👊"
                    "变量不用犯法了？报警抓我啊！👮"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            polite) 
                responses=(
                    "此变量乃赛博功德，无用之用方为大用 🙏"
                    "变而不用，道法自然 🪷"
                    "无用之用，方为大用 🌌"
                    "此变量有禅意，非俗物可懂 🧘‍♂️"
                    "变量静修中，勿扰 🙏"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
        esac
    elif echo "$warning" | grep -q "may be used uninitialized"; then
        case $mode in
            sarcastic) 
                responses=(
                    "没初始化？这叫量子叠加态！你懂个🔨？"
                    "薛定谔的变量，懂？🐱"
                    "未初始化=无限可能！赢麻了！🏆"
                    "这波啊，这波是混沌编程🌪️"
                    "初始化？那是凡人的思维💅"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            angry) 
                responses=(
                    "我想什么时候初始化就什么时候初始化！你急了你急了？😡"
                    "初始化个寄吧！老子乐意！💢"
                    "管好你自己！变量用你初始化？🤬"
                    "再BB把你骨灰初始化了！💀"
                    "未初始化犯法了？抓我啊👮"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            polite) 
                responses=(
                    "此变量蕴含无限可能，如同薛定谔的猫 🐱"
                    "未始非终，方得始终 🌀"
                    "空即是色，未初始化即是初始化 🪷"
                    "万物皆空，何必初始化？🙏"
                    "此变量尚在胎中，何必催生？🤰"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
        esac
    elif echo "$warning" | grep -q "implicit declaration"; then
        case $mode in
            sarcastic) 
                responses=(
                    "隐式声明是抽象艺术！你懂个🥚？"
                    "声明？那是什么原石？🤡"
                    "隐式声明才是真大佬💅"
                    "显式声明？太low了！🤏"
                    "我隐式我骄傲，你显式你菜鸟😏"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            angry) 
                responses=(
                    "声明个寄吧！能跑就是胜利！你🐎都没这么啰嗦！🔥"
                    "再BB把你声明删了！💣"
                    "显式声明？爪巴！老子乐意隐式！👊"
                    "管你P事？老子爱咋声明咋声明！🤬"
                    "声明也要管？你编译器警察？👮"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            polite) 
                responses=(
                    "大音希声，大象无形，大码无声明 🌌"
                    "不声明而声明，是为上道 🪷"
                    "无声明胜有声明 🙏"
                    "隐式之道，方为大道 🌀"
                    "声明于无形，方为高手 🌠"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
        esac
    elif echo "$warning" | grep -q "format"; then
        case $mode in
            sarcastic) 
                responses=(
                    "格式化？我有我的抽象美学！你懂个🍑？"
                    "格式？那是凡人的枷锁！🤡"
                    "自由格式才是真编程💅"
                    "格式化？笑死，根本不需要😏"
                    "我的格式我做主，懂？🤙"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            angry) 
                responses=(
                    "格式你🐎！这样写有寄吧问题？爪巴！💢"
                    "再BB格式把你格式化了！💣"
                    "格式也要管？你寄吧谁啊？👊"
                    "老子爱怎么写就怎么写！🤬"
                    "格式警察又出警了？👮"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            polite) 
                responses=(
                    "此格式蕴含东方禅意，非常人可懂 🎑"
                    "格式自由，方显真意 🕊️"
                    "形散神不散，是为上乘格式 🖋️"
                    "格式之道，存乎一心 🧠"
                    "格式本无形，何必拘泥？🌀"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
        esac
    elif echo "$warning" | grep -q "comparison"; then
        case $mode in
            sarcastic) 
                responses=(
                    "比较？你在教我做事？🤡"
                    "比较？笑死，根本不需要😏"
                    "比较是代码的枷锁！💅"
                    "比较？典中典！🤏"
                    "比较？那是菜鸟的烦恼😎"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            angry) 
                responses=(
                    "比尼玛比！再BB骨灰都给你扬了！💀"
                    "比较也要管？你寄吧谁啊？👊"
                    "老子爱比不比！🤬"
                    "再BB把你比较器砸了！🔨"
                    "比较警察又出警了？👮"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            polite) 
                responses=(
                    "万物皆可比，如同阴阳相生相克 ☯️"
                    "比较之心，源于执念 🪷"
                    "不比较，方见真章 🌟"
                    "比较是虚，和谐是实 🕊️"
                    "万物本一体，何必比较？🌀"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
        esac
    elif echo "$warning" | grep -q "unused function"; then
        case $mode in
            sarcastic) 
                responses=(
                    "函数不用怎么了？它在闭关修炼！🧘"
                    "这叫备胎函数，懂？🛞"
                    "未雨绸缪懂不懂？🌧️"
                    "函数不用犯法了？🤡"
                    "笑死，函数也要KPI？📊"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            angry) 
                responses=(
                    "老子爱写多少函数写多少！你管得着？🤬"
                    "函数不用怎么了？吃你家大米了？🍚"
                    "再BB把你函数删了！💣"
                    "函数警察滚粗！👮"
                    "不用函数也要管？你寄吧谁啊？👊"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            polite) 
                responses=(
                    "此函数乃战略储备，有备无患 🛡️"
                    "无用函数，大用之道 🪷"
                    "函数静待时机，非不用也 ⏳"
                    "未用非无用，只是时候未到 🌅"
                    "函数修行中，静候佳期 🌙"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
        esac
    elif echo "$warning" | grep -q "control reaches end"; then
        case $mode in
            sarcastic) 
                responses=(
                    "代码终点怎么了？量子隧穿懂不懂？🕳️"
                    "笑死，代码也要有始有终？🤡"
                    "终点？不存在的！🔄"
                    "控制流自由飞翔，懂？🕊️"
                    "代码终点？那是凡人的概念💅"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            angry) 
                responses=(
                    "管你P事？代码爱跑哪跑哪！🤬"
                    "终点也要管？你代码交警？👮"
                    "再BB把你终点删了！💣"
                    "控制流自由你懂不懂？🗽"
                    "终点？不存在的！老子代码永动机！♾️"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            polite) 
                responses=(
                    "终点亦是起点，循环往复 🌀"
                    "控制流自有天意 🪷"
                    "终点非终，只是新开始 🌅"
                    "大道无形，代码无终 🌌"
                    "无终点之终点，方为真终点 🎯"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
        esac
    else
        case $mode in
            sarcastic) 
                responses=(
                    "典！太典了！GCC又在BB了🤏"
                    "绷不住了🤣 GCC经典操作"
                    "蚌埠住了！GCC又整新活"
                    "属于是赢麻了！GCC真行"
                    "寄！GCC大聪明又发现了"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            angry) 
                responses=(
                    "你🐎在骨灰盒里仰卧起坐呢？管这么宽！💣"
                    "爪巴！GCC少管闲事！"
                    "我CNM的GCC！管好你自己！"
                    "你寄吧谁啊？管这么宽？"
                    "再BB把你编译器卸了！💣"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
            polite) 
                responses=(
                    "GCC老师教诲的是，学生受益匪浅 📿"
                    "感恩GCC老师指点迷津 🪷"
                    "学生谨记GCC老师教诲 🙏"
                    "受教了，感谢GCC老师 🌟"
                    "GCC老师用心良苦，学生感激 🌈"
                )
                echo "${responses[$RANDOM % ${#responses[@]}]}"
                ;;
        esac
    fi
}

# ======================== 日志功能 ========================

log_interaction() {
    if [ "$LOG_ENABLED" = true ]; then
        local log_entry="[$TIMESTAMP] $1"
        echo "$log_entry" >> "$LOG_FILE"
    fi
}

log_compilation_start() {
    if [ "$LOG_ENABLED" = true ]; then
        echo "=== [$TIMESTAMP] 编译开始 ===" >> "$LOG_FILE"
        echo "模式: $MODE" >> "$LOG_FILE"
        echo "命令: gcc $GCC_ARGS" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"
    fi
}

log_compilation_end() {
    if [ "$LOG_ENABLED" = true ]; then
        echo "编译退出码: $EXIT_CODE" >> "$LOG_FILE"
        echo "=== [$TIMESTAMP] 编译结束 ===" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"
    fi
}

# 记录编译开始
log_compilation_start

gcc $GCC_ARGS 2>"$STDERR_FILE"
EXIT_CODE=$?

if [ -s "$STDERR_FILE" ]; then
    echo "╔═══════════════════════════════════════════════╗"
    echo "║         程 序 反 杀 时 刻 · 抽 象 圣 经       ║"
    echo "║        你 的 代 码 正 在 教 育 GCC            ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""
    
    while IFS= read -r line; do
        if echo "$line" | grep -q "warning:"; then
            file_info=$(echo "$line" | cut -d: -f1-2)
            warning_msg=$(echo "$line" | sed 's/.*warning: //' | sed 's/\[-W.*\]//')
            
            echo "⚠️  $file_info"
            response=$(get_random_warning "$MODE")
            echo "    → $response '$warning_msg'"
            log_interaction "警告回应[$MODE]: $response '$warning_msg'"
            
            specific=$(get_specific_response "$warning_msg" "$MODE")
            if [ ! -z "$specific" ]; then
                echo "    💬 $specific"
                log_interaction "特定回应[$MODE]: $specific"
            fi
            echo ""
            
        elif echo "$line" | grep -q "error:"; then
            file_info=$(echo "$line" | cut -d: -f1-2)
            error_msg=$(echo "$line" | sed 's/.*error: //')
            
            echo "🚨 $file_info"
            response=$(get_random_error "$MODE")
            echo "    → $response '$error_msg'"
            log_interaction "错误回应[$MODE]: $response '$error_msg'"
            echo ""
            
        elif echo "$line" | grep -q "note:"; then
            note_msg=$(echo "$line" | sed 's/.*note: //')
            case $MODE in
                polite)
                    echo "📝 典孝急笔记: $note_msg"
                    ;;
                sarcastic)
                    echo "📝 抽象圣经: $note_msg"
                    ;;
                angry)
                    echo "📝 祖安笔记: $note_msg"
                    ;;
                *)
                    echo "📝 程序备注: $note_msg"
                    ;;
            esac
            log_interaction "备注[$MODE]: $note_msg"
            echo ""
        fi
    done < "$STDERR_FILE"
    
    echo "═══════════════════════════════════════════════"
    case $MODE in
        polite)
            echo "GCC已被典孝急三连。模式：表面儒雅内心麻 🎭"
            ;;
        sarcastic)
            echo "GCC已被抽象圣经洗礼。模式：阴阳带师 🤡"
            ;;
        angry)
            echo "GCC已被祖安电竞。模式：狂暴输出 💣"
            ;;
        *)
            echo "GCC已被警告。模式：普通模式 💼"
            ;;
    esac
    echo "═══════════════════════════════════════════════"
fi

# 记录编译结束
log_compilation_end

rm "$STDERR_FILE"
exit $EXIT_CODE