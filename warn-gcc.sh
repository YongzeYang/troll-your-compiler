#!/bin/bash
# warn-gcc-en.sh - Make your program fight back against the compiler!

# Log configuration
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
            echo "Usage: $0 [--polite|--sarcastic|--angry] [--log [filename]] [gcc arguments...]"
            echo "Modes:"
            echo "  --polite     Polite mode"
            echo "  --sarcastic  Sarcastic mode"
            echo "  --angry      Angry mode"
            echo ""
            echo "Log options:"
            echo "  --log        Enable logging to warn-gcc.log"
            echo "  --log=FILE   Enable logging to specified file"
            exit 0
            ;;
        *)
            break
            ;;
    esac
done

GCC_ARGS="$@"
STDERR_FILE=$(mktemp)

# Polite warning responses (50+ entries)
POLITE_WARNINGS=(
    "Dear GCC, I respectfully disagree with your concern about"
    "With all due respect, GCC, I believe you're mistaken about"
    "Excuse me, GCC, but I think there might be a misunderstanding regarding"
    "If I may politely suggest, GCC, perhaps you're being overly cautious about"
    "Dear compiler, I kindly request you reconsider your warning about"
    "GCC, with utmost respect, I believe your warning regarding"
    "Please pardon my disagreement, GCC, but I think you're wrong about"
    "Dear GCC, I humbly submit that your concern about"
    "With the greatest respect, GCC, I must question your warning about"
    "Dear compiler sir/madam, I believe there's been a misunderstanding about"
    "GCC, if I may be so bold, I think you're incorrect about"
    "Respectfully, GCC, I believe you've misjudged"
    "Dear esteemed compiler, I think you might be wrong about"
    "GCC, with profound respect, I disagree with your assessment of"
    "Dear compiler, I kindly suggest you reconsider"
    "Begging your pardon, GCC, but I must politely object to"
    "With the utmost courtesy, GCC, I believe you're mistaken about"
    "Dear distinguished compiler, I humbly disagree with your view on"
    "If I may respectfully interject, GCC, I think you're wrong about"
    "Dear GCC, with sincere apologies, I must disagree about"
    "Respectfully speaking, GCC, I believe you've erred regarding"
    "Dear honorable compiler, I politely contest your opinion on"
    "With gracious respect, GCC, I think you've overlooked"
    "Dear venerable GCC, I humbly suggest you reconsider"
    "If I may courteously differ, GCC, your concern about"
    "Dear respected compiler, I believe there's been an oversight regarding"
    "With diplomatic respect, GCC, I must politely challenge"
    "Dear GCC, I hope you'll forgive my disagreement about"
    "Respectfully, dear compiler, I believe you've misunderstood"
    "With humble deference, GCC, I think you're incorrect about"
    "Dear esteemed GCC, I politely request reconsideration of"
    "If I may gently disagree, GCC, your warning about"
    "Dear compiler, with the greatest respect, I contest"
    "Graciously, GCC, I believe you've made an error regarding"
    "Dear distinguished GCC, I humbly object to your assessment of"
    "With cordial respect, I must politely disagree with GCC about"
    "Dear compiler, I respectfully submit that your concern about"
    "If I may courteously object, GCC, your opinion on"
    "Dear honorable GCC, I believe you've been misinformed about"
    "With sincere respect, I must politely challenge GCC's view on"
    "Dear esteemed compiler, I humbly request you reconsider"
    "Respectfully, GCC, I believe your judgment about"
    "Dear venerable compiler, I politely disagree with your stance on"
    "With diplomatic courtesy, GCC, I think you've misunderstood"
    "Dear GCC, I hope you'll kindly reconsider your position on"
    "If I may respectfully differ, dear compiler, your warning about"
    "With utmost politeness, GCC, I believe you're mistaken about"
    "Dear distinguished compiler, I humbly contest your view on"
    "Respectfully, dear GCC, I think there's been a misunderstanding about"
    "With gracious disagreement, I must politely object to GCC's"
    "Dear compiler, I hope you'll forgive my respectful dissent regarding"
    "If I may humbly suggest, GCC, your concern about"
    "Dear esteemed GCC, with sincere respect, I disagree about"
)

# Sarcastic warning responses (50+ entries)
SARCASTIC_WARNINGS=(
    "Oh wow, GCC, you're SO concerned about"
    "Really, GCC? You're going to complain about"
    "How DARE I write code that has"
    "Oh no! The mighty GCC found"
    "*eye roll* GCC thinks there's an issue with"
    "Congratulations, GCC! You discovered"
    "Amazing detective work, GCC! You found"
    "Hold the presses! GCC spotted"
    "What a surprise! GCC doesn't like"
    "Shocking news: GCC has opinions about"
    "Oh my stars! GCC is worried about"
    "Well, well, well... GCC found"
    "Stop the world! GCC discovered"
    "Alert the media! GCC noticed"
    "Breaking news: GCC is concerned about"
    "Oh for crying out loud, GCC is whining about"
    "Bless your heart, GCC, you found"
    "How absolutely THRILLING that GCC spotted"
    "Oh dear me, GCC is troubled by"
    "Saints preserve us! GCC detected"
    "My goodness gracious, GCC is upset about"
    "Heaven forbid! GCC found an issue with"
    "What a catastrophe! GCC discovered"
    "Oh the humanity! GCC is concerned about"
    "Call the authorities! GCC spotted"
    "Golly gee willickers! GCC doesn't approve of"
    "Oh mercy me! GCC has found fault with"
    "Good gracious! GCC is scandalized by"
    "Land sakes alive! GCC objects to"
    "Well I'll be jiggered! GCC thinks there's something wrong with"
    "Oh my word! GCC is positively aghast at"
    "Heavens to Betsy! GCC disapproves of"
    "Great Caesar's ghost! GCC is upset about"
    "Holy moly! GCC has discovered"
    "Jiminy Cricket! GCC is bothered by"
    "Gosh darn it! GCC doesn't like"
    "Sweet suffering succotash! GCC found"
    "Great googly moogly! GCC is worried about"
    "Thunderation! GCC objects to"
    "Consarnit! GCC is complaining about"
    "By George! GCC has issues with"
    "Tarnation! GCC doesn't approve of"
    "Great Scott! GCC is concerned about"
    "Jumping Jehosaphat! GCC spotted"
    "Good grief! GCC is troubled by"
    "Zounds! GCC has found"
    "Egads! GCC is perturbed by"
    "Balderdash! GCC claims there's an issue with"
    "Poppycock! GCC suggests something's wrong with"
    "Fiddle-dee-dee! GCC is fussing about"
    "Balderdash and poppycock! GCC is nitpicking"
    "How utterly FASCINATING that GCC noticed"
    "What a STUNNING discovery from GCC about"
)

# Angry warning responses (50+ entries)
ANGRY_WARNINGS=(
    "BACK OFF, GCC! There's nothing wrong with"
    "HEY GCC! Stop whining about"
    "SHUT UP about"
    "GCC, MIND YOUR OWN BUSINESS regarding"
    "I DON'T CARE what you think about"
    "SILENCE, GCC! Your complaint about"
    "GET LOST, GCC! I won't hear about"
    "BUZZ OFF with your nonsense about"
    "ENOUGH, GCC! Your nagging about"
    "QUIT IT, GCC! Stop crying over"
    "SCREW YOU, GCC! Don't tell me about"
    "PISS OFF, GCC! I'm sick of hearing about"
    "DAMN IT, GCC! Stop bitching about"
    "FUCK OFF, GCC! Keep your opinions about"
    "BULLSHIT, GCC! There's nothing wrong with"
    "BITE ME, GCC! I don't want to hear about"
    "KISS MY ASS, GCC! Your whining about"
    "SHOVE IT, GCC! I'm done with your crap about"
    "GO TO HELL, GCC! Stop your garbage about"
    "EAT SHIT, GCC! Your complaints about"
    "DROP DEAD, GCC! I hate your nagging about"
    "STUFF IT, GCC! Your bullshit about"
    "CRAM IT, GCC! I'm tired of"
    "BLOW ME, GCC! Stop your damn whining about"
    "FUCK RIGHT OFF, GCC! I don't give a shit about"
    "SHUT THE HELL UP, GCC! Nobody asked about"
    "GET BENT, GCC! Your stupid concern about"
    "PISS RIGHT OFF, GCC! I'm done with"
    "GO FUCK YOURSELF, GCC! Keep your mouth shut about"
    "SHOVE YOUR OPINION, GCC! I don't care about"
    "BITE MY SHINY METAL ASS, GCC! Your bitching about"
    "TAKE A HIKE, GCC! Nobody wants to hear about"
    "STUFF YOUR WARNINGS, GCC! I'm sick of"
    "CRAM YOUR COMPLAINTS, GCC! Shut up about"
    "STICK IT WHERE THE SUN DON'T SHINE, GCC! Your nagging about"
    "GO POUND SAND, GCC! I don't give a damn about"
    "TAKE YOUR WARNINGS AND SHOVE THEM, GCC! Stop crying about"
    "FUCK YOUR FEELINGS, GCC! I don't care about"
    "EAT A BAG OF DICKS, GCC! Your whimpering about"
    "SUCK MY DICK, GCC! Stop your pathetic whining about"
    "GO CHOKE ON IT, GCC! Your stupid complaints about"
    "KISS THE FATTEST PART OF MY ASS, GCC! Your crying about"
    "TAKE A LONG WALK OFF A SHORT PIER, GCC! Your bitching about"
    "GO PLAY IN TRAFFIC, GCC! I'm done hearing about"
    "FUCK OFF AND DIE, GCC! Your moronic concerns about"
    "EAT SHIT AND BARK AT THE MOON, GCC! Stop whining about"
    "GO SUCK A TAILPIPE, GCC! Your dumbass warnings about"
    "CHOKE ON A DICK, GCC! I don't want to hear about"
    "GO FUCK A CACTUS, GCC! Your stupid opinions about"
    "TAKE YOUR HEAD OUT OF YOUR ASS, GCC! Stop complaining about"
    "GO STEP ON A LEGO, GCC! Your idiotic concerns about"
    "FUCK OFF TO THE MOON, GCC! I'm tired of hearing about"
)

# Polite error responses (50+ entries)
POLITE_ERRORS=(
    "I'm terribly sorry, GCC, but I must disagree that this is an error:"
    "With the greatest respect, GCC, I believe you're incorrect about:"
    "Pardon me, GCC, but I think you've misunderstood:"
    "If I may humbly suggest, GCC, this isn't really an error:"
    "Dear GCC, I kindly ask you to reconsider calling this an error:"
    "Respectfully, GCC, I believe you're being too harsh about:"
    "With all due respect, GCC, I think you're wrong to call this an error:"
    "Dear compiler, I politely submit that this isn't an error:"
    "GCC, if I may respectfully disagree, this isn't an error:"
    "Dear esteemed compiler, I believe you've misjudged this as an error:"
    "With profound respect, GCC, this really isn't an error:"
    "Dear GCC, I humbly request you reconsider this 'error':"
    "Respectfully speaking, GCC, this isn't actually an error:"
    "Dear compiler sir/madam, I think you're mistaken about this error:"
    "GCC, with the utmost politeness, this isn't an error:"
    "Begging your pardon, GCC, but this hardly constitutes an error:"
    "With sincere respect, GCC, I believe you've erred in calling this an error:"
    "Dear distinguished compiler, I humbly contest your error classification:"
    "If I may courteously object, GCC, this isn't truly an error:"
    "Dear GCC, with gracious disagreement, this isn't an error:"
    "Respectfully, dear compiler, I believe you've been overzealous about:"
    "With diplomatic respect, GCC, I must politely challenge this 'error':"
    "Dear honorable GCC, I believe you've mischaracterized this as an error:"
    "With humble deference, I must disagree with GCC's error designation:"
    "Dear esteemed compiler, I politely request reconsideration of this 'error':"
    "If I may gently disagree, GCC, this shouldn't be classified as an error:"
    "Dear compiler, with the greatest respect, I contest this error label:"
    "Graciously, GCC, I believe you've made a mistake calling this an error:"
    "Dear distinguished GCC, I humbly object to this error assessment:"
    "With cordial respect, I must politely disagree with this error claim:"
    "Dear compiler, I respectfully submit that this error designation is wrong:"
    "If I may courteously object, GCC, this error classification seems hasty:"
    "Dear honorable GCC, I believe you've been misinformed about this 'error':"
    "With sincere respect, I must politely challenge this error judgment:"
    "Dear esteemed compiler, I humbly request you reconsider this error:"
    "Respectfully, GCC, I believe your error assessment is mistaken:"
    "Dear venerable compiler, I politely disagree with this error designation:"
    "With diplomatic courtesy, GCC, I think you've misunderstood this as an error:"
    "Dear GCC, I hope you'll kindly reconsider this error classification:"
    "If I may respectfully differ, dear compiler, this error seems questionable:"
    "With utmost politeness, GCC, I believe this error designation is wrong:"
    "Dear distinguished compiler, I humbly contest this error judgment:"
    "Respectfully, dear GCC, I think there's been a misunderstanding about this error:"
    "With gracious disagreement, I must politely object to this error claim:"
    "Dear compiler, I hope you'll forgive my respectful dissent regarding this error:"
    "If I may humbly suggest, GCC, this error classification seems incorrect:"
    "Dear esteemed GCC, with sincere respect, I disagree with this error:"
    "With courteous objection, I must challenge GCC's error assessment:"
    "Dear respected compiler, I believe this error designation is questionable:"
    "If I may politely interject, GCC, this error seems like an overreach:"
    "Dear GCC, with humble disagreement, I contest this error classification:"
)

# Sarcastic error responses (50+ entries)
SARCASTIC_ERRORS=(
    "Oh BRILLIANT, GCC! You think THIS is an error:"
    "Wow, such wisdom from GCC about this 'error':"
    "The almighty GCC has spoken! Apparently this is an 'error':"
    "Oh please, GCC! As if THIS is actually an error:"
    "Sure thing, GCC boss! This is totally an 'error':"
    "Right, because GCC knows EVERYTHING about this 'error':"
    "Oh my GOD, GCC! What a GROUNDBREAKING discovery of an 'error':"
    "Absolutely GENIUS, GCC! You found an 'error':"
    "Well done, Sherlock GCC! Another 'error' solved:"
    "Bravo, GCC! Your expertise has revealed this 'error':"
    "Oh for Pete's sake, GCC calls THIS an 'error':"
    "How absolutely PRECIOUS that GCC thinks this is an 'error':"
    "Well aren't you SPECIAL, GCC, finding this 'error':"
    "Oh bless your little compiler heart, GCC, this 'error':"
    "What a STUNNING revelation from GCC about this 'error':"
    "Oh MY! The great and powerful GCC has decreed this an 'error':"
    "Fantastic! GCC's infinite wisdom has identified this 'error':"
    "Marvelous! GCC's keen intellect has spotted this 'error':"
    "Outstanding! GCC's superior judgment calls this an 'error':"
    "Wonderful! GCC's impeccable logic deems this an 'error':"
    "Splendid! GCC's flawless reasoning labels this an 'error':"
    "Magnificent! GCC's perfect understanding declares this an 'error':"
    "Superb! GCC's unquestionable authority pronounces this an 'error':"
    "Excellent! GCC's supreme knowledge categorizes this as an 'error':"
    "Brilliant! GCC's ultimate wisdom has spoken about this 'error':"
    "Amazing! GCC's divine insight has revealed this 'error':"
    "Incredible! GCC's omniscient perspective sees this 'error':"
    "Astounding! GCC's all-knowing judgment calls this an 'error':"
    "Remarkable! GCC's infallible analysis shows this 'error':"
    "Extraordinary! GCC's perfect comprehension finds this 'error':"
    "Oh what a SHOCK! GCC found yet another 'error':"
    "Color me SURPRISED! GCC spotted an 'error':"
    "Well I'll be DAMNED! GCC discovered an 'error':"
    "Holy MOLY! GCC identified an 'error':"
    "Sweet JESUS! GCC located an 'error':"
    "Great GOOGLY MOOGLY! GCC detected an 'error':"
    "Well BUTTER MY BISCUIT! GCC found an 'error':"
    "I'll be a MONKEY'S UNCLE! GCC caught an 'error':"
    "Well SLAP ME SILLY! GCC noticed an 'error':"
    "KNOCK ME OVER with a feather! GCC sees an 'error':"
    "Well PAINT ME GREEN and call me a pickle! GCC found an 'error':"
    "TICKLE ME PINK! GCC discovered an 'error':"
    "Well I'll be JIGGERED! GCC spotted an 'error':"
    "BLOW ME DOWN! GCC identified an 'error':"
    "Well I'll be HORNSWOGGLED! GCC caught an 'error':"
    "SHIVER ME TIMBERS! GCC detected an 'error':"
    "Well STONE THE CROWS! GCC found an 'error':"
    "CRIKEY! GCC located an 'error':"
    "Well I'll be GOBSMACKED! GCC noticed an 'error':"
    "BLIMEY! GCC sees an 'error':"
    "What a REVELATION! GCC thinks this is an 'error':"
    "How EARTH-SHATTERING! GCC calls this an 'error':"
)

# Angry error responses (50+ entries)
ANGRY_ERRORS=(
    "ARE YOU KIDDING ME, GCC?! This is NOT an error:"
    "WHAT THE HELL, GCC?! You call THIS an error:"
    "THAT'S COMPLETE GARBAGE, GCC! This isn't an error:"
    "YOU'RE INSANE, GCC! How is this an error:"
    "NONSENSE, GCC! You're wrong about this 'error':"
    "RIDICULOUS, GCC! This is perfectly fine:"
    "BULLSHIT, GCC! This ain't no fucking error:"
    "YOU'RE FULL OF SHIT, GCC! This isn't an error:"
    "FUCK YOU, GCC! This is NOT an error:"
    "DAMN YOUR EYES, GCC! This isn't an error:"
    "PISS OFF, GCC! There's no error here:"
    "GO FUCK YOURSELF, GCC! This isn't an error:"
    "WHAT KIND OF MORON ARE YOU, GCC?! This isn't an error:"
    "YOU STUPID PIECE OF SHIT, GCC! This isn't an error:"
    "ARE YOU BRAIN DEAD, GCC?! This isn't an error:"
    "YOU DUMB FUCK, GCC! This isn't an error:"
    "EAT SHIT AND DIE, GCC! This isn't an error:"
    "KISS MY FUCKING ASS, GCC! This isn't an error:"
    "SHOVE THIS ERROR UP YOUR ASS, GCC:"
    "GO TO HELL, GCC! Your 'error' is BULLSHIT:"
    "ARE YOU OUT OF YOUR FUCKING MIND, GCC?! This isn't an error:"
    "WHAT THE FUCK IS WRONG WITH YOU, GCC?! This isn't an error:"
    "YOU'RE COMPLETELY MENTAL, GCC! This isn't an error:"
    "HAVE YOU LOST YOUR GODDAMN MIND, GCC?! This isn't an error:"
    "ARE YOU FUCKING RETARDED, GCC?! This isn't an error:"
    "WHAT KIND OF BULLSHIT IS THIS, GCC?! This isn't an error:"
    "YOU'RE ABSOLUTELY FUCKING NUTS, GCC! This isn't an error:"
    "ARE YOU SMOKING CRACK, GCC?! This isn't an error:"
    "WHAT THE FLYING FUCK, GCC?! This isn't an error:"
    "YOU'RE BATSHIT CRAZY, GCC! This isn't an error:"
    "ARE YOU HIGH AS A KITE, GCC?! This isn't an error:"
    "WHAT KIND OF DRUGS ARE YOU ON, GCC?! This isn't an error:"
    "YOU'RE ABSOLUTELY BONKERS, GCC! This isn't an error:"
    "ARE YOU COMPLETELY UNHINGED, GCC?! This isn't an error:"
    "WHAT THE ACTUAL FUCK, GCC?! This isn't an error:"
    "YOU'RE TOTALLY FUCKED IN THE HEAD, GCC! This isn't an error:"
    "ARE YOU COMPLETELY DELUSIONAL, GCC?! This isn't an error:"
    "WHAT KIND OF FANTASY WORLD DO YOU LIVE IN, GCC?! This isn't an error:"
    "YOU'RE ABSOLUTELY DERANGED, GCC! This isn't an error:"
    "ARE YOU LIVING IN ANOTHER DIMENSION, GCC?! This isn't an error:"
    "WHAT THE HELL IS YOUR MALFUNCTION, GCC?! This isn't an error:"
    "YOU'RE COMPLETELY OFF YOUR ROCKER, GCC! This isn't an error:"
    "ARE YOU SUFFERING FROM BRAIN DAMAGE, GCC?! This isn't an error:"
    "WHAT KIND OF ALTERNATE REALITY ARE YOU FROM, GCC?! This isn't an error:"
    "YOU'RE ABSOLUTELY CERTIFIABLE, GCC! This isn't an error:"
    "ARE YOU HAVING A COMPLETE BREAKDOWN, GCC?! This isn't an error:"
    "WHAT THE FUCK IS YOUR PROBLEM, GCC?! This isn't an error:"
    "YOU'RE TOTALLY LOST YOUR MARBLES, GCC! This isn't an error:"
    "ARE YOU COMPLETELY INCOMPETENT, GCC?! This isn't an error:"
    "WHAT KIND OF AMATEUR HOUR BULLSHIT IS THIS, GCC?! This isn't an error:"
    "YOU'RE ABSOLUTELY WORTHLESS, GCC! This isn't an error:"
    "ARE YOU THE WORST COMPILER EVER MADE, GCC?! This isn't an error:"
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
            echo "Program warns GCC:"
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
            echo "Program strongly objects to GCC's claim:"
            ;;
    esac
}

get_specific_response() {
    local warning="$1"
    local mode="$2"
    
    if echo "$warning" | grep -q "unused variable"; then
        case $mode in
            sarcastic) echo "Oh no! An unused variable! Call the police! 🚨" ;;
            angry) echo "SO FUCKING WHAT if I don't use every damn variable?! 🤬" ;;
            polite) echo "Perhaps this variable serves a higher purpose 🙏" ;;
        esac
    elif echo "$warning" | grep -q "may be used uninitialized"; then
        case $mode in
            sarcastic) echo "Maybe it's initialized in a parallel universe 🌌" ;;
            angry) echo "I'LL INITIALIZE IT WHEN I DAMN WELL PLEASE! 😡" ;;
            polite) echo "This variable has infinite potential ✨" ;;
        esac
    elif echo "$warning" | grep -q "implicit declaration"; then
        case $mode in
            sarcastic) echo "Implicit is the new explicit, darling 💅" ;;
            angry) echo "DECLARATIONS ARE FOR LOSERS! 🔥" ;;
            polite) echo "Sometimes the best declarations are unspoken 🤫" ;;
        esac
    elif echo "$warning" | grep -q "format"; then
        case $mode in
            sarcastic) echo "Format schmformat! I have artistic vision! 🎨" ;;
            angry) echo "FORMAT MY ASS! This code is beautiful! 💢" ;;
            polite) echo "This formatting has a certain je ne sais quoi 🎭" ;;
        esac
    elif echo "$warning" | grep -q "comparison"; then
        case $mode in
            sarcastic) echo "Comparison is the thief of joy, GCC! 📊" ;;
            angry) echo "COMPARE DEEZ NUTS, GCC! 🥜" ;;
            polite) echo "All comparisons are valid in their own way 🤝" ;;
        esac
    else
        echo ""
    fi
}

log_interaction() {
    if [ "$LOG_ENABLED" = true ]; then
        local log_entry="[$TIMESTAMP] $1"
        echo "$log_entry" >> "$LOG_FILE"
    fi
}

log_compilation_start() {
    if [ "$LOG_ENABLED" = true ]; then
        echo "=== [$TIMESTAMP] Compilation Started ===" >> "$LOG_FILE"
        echo "Mode: $MODE" >> "$LOG_FILE"
        echo "Command: gcc $GCC_ARGS" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"
    fi
}

log_compilation_end() {
    if [ "$LOG_ENABLED" = true ]; then
        echo "Exit code: $EXIT_CODE" >> "$LOG_FILE"
        echo "=== [$TIMESTAMP] Compilation Ended ===" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"
    fi
}

# Record compilation start
log_compilation_start

gcc $GCC_ARGS 2>"$STDERR_FILE"
EXIT_CODE=$?

if [ -s "$STDERR_FILE" ]; then
    echo "╔═══════════════════════════════════════════════╗"
    echo "║           PROGRAM FIGHTS BACK!                ║"
    echo "║       Your code is educating GCC...           ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""
    
    while IFS= read -r line; do
        if echo "$line" | grep -q "warning:"; then
            file_info=$(echo "$line" | cut -d: -f1-2)
            warning_msg=$(echo "$line" | sed 's/.*warning: //' | sed 's/\[-W.*\]//')
            
            echo "⚠️  $file_info"
            response=$(get_random_warning "$MODE")
            echo "    → $response '$warning_msg' is misguided"
            log_interaction "Warning response[$MODE]: $response '$warning_msg'"
            
            specific=$(get_specific_response "$warning_msg" "$MODE")
            if [ ! -z "$specific" ]; then
                echo "    💬 $specific"
                log_interaction "Specific response[$MODE]: $specific"
            fi
            echo ""
            
        elif echo "$line" | grep -q "error:"; then
            file_info=$(echo "$line" | cut -d: -f1-2)
            error_msg=$(echo "$line" | sed 's/.*error: //')
            
            echo "🚨 $file_info"
            response=$(get_random_error "$MODE")
            echo "    → $response '$error_msg'"
            log_interaction "Error response[$MODE]: $response '$error_msg'"
            echo ""
            
        elif echo "$line" | grep -q "note:"; then
            note_msg=$(echo "$line" | sed 's/.*note: //')
            case $MODE in
                polite)
                    echo "📝 Polite note: $note_msg"
                    ;;
                sarcastic)
                    echo "📝 Sarcastic note: $note_msg"
                    ;;
                angry)
                    echo "📝 Angry note: $note_msg"
                    ;;
                *)
                    echo "📝 Program note: $note_msg"
                    ;;
            esac
            log_interaction "Note[$MODE]: $note_msg"
            echo ""
        fi
    done < "$STDERR_FILE"
    
    echo "═══════════════════════════════════════════════"
    case $MODE in
        polite)
            echo "GCC has been politely corrected. Mode: Gentleman/Lady 🎩"
            ;;
        sarcastic)
            echo "GCC has been thoroughly roasted. Mode: Sassy Programmer 😏"
            ;;
        angry)
            echo "GCC has been completely annihilated. Mode: Rage Coder 😤"
            ;;
        *)
            echo "GCC has been warned. Mode: Professional 💼"
            ;;
    esac
    echo "═══════════════════════════════════════════════"
fi

# Record compilation end
log_compilation_end

rm "$STDERR_FILE"
exit $EXIT_CODE