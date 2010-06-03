
State: enum {
    s0
    s1
    s2
    s3
}

/**
   Simple mealy automaton which detects the '0010' sequence
 */
Mealy: class {
    
    state, nextState: State
    q: Bool
    
    process1: func (reset, clk: Bool) {
        if (reset) {
            state = State s0
        } else if(clk) {
            state = nextState
        }
    }
    
    process2: func (a: Bool) {
        nextState = state
        q = false
        
        match(state) {
            case State s0 =>
                nextState = (a ? State s0 : State s1)
            case State s1 =>
                nextState = (a ? State s0 : State s2)
            case State s2 =>
                if (a) nextState = State s3
            case State s3 =>
                if (a) {
                    nextState = State s0
                } else {
                    q = true
                    nextState = State s1
                }
        }
    }
    
}

m := Mealy new()
m process1(true, false)

str := "0000"

for (c in "0110011100101010001011000101000100100010010100010001") {
    str = str[1..4] + c
    m process2(c == '1')
    m process1(false, true)
    "last sequence = %s, state %d, output = %s" format(str, m state as Int, m q toString()) println()
}



