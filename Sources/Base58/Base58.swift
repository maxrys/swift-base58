import Foundation

/*
        base58 alphabet
    ┌──────┬─────┬────────┐
    │ char │ dec │ binary │
    ├──────┼─────┼────────┤
    │    1 │   0 │ 000000 │
    │    2 │   1 │ 000001 │
    │    3 │   2 │ 000010 │
    │    4 │   3 │ 000011 │
    │    5 │   4 │ 000100 │
    │    6 │   5 │ 000101 │
    │    7 │   6 │ 000110 │
    │    8 │   7 │ 000111 │
    │    9 │   8 │ 001000 │
    │    A │   9 │ 001001 │
    │    B │  10 │ 001010 │
    │    C │  11 │ 001011 │
    │    D │  12 │ 001100 │
    │    E │  13 │ 001101 │
    │    F │  14 │ 001110 │
    │    G │  15 │ 001111 │
    │    H │  16 │ 010000 │
    │    J │  17 │ 010001 │
    │    K │  18 │ 010010 │
    │    L │  19 │ 010011 │
    │    M │  20 │ 010100 │
    │    N │  21 │ 010101 │
    │    P │  22 │ 010110 │
    │    Q │  23 │ 010111 │
    │    R │  24 │ 011000 │
    │    S │  25 │ 011001 │
    │    T │  26 │ 011010 │
    │    U │  27 │ 011011 │
    │    V │  28 │ 011100 │
    │    W │  29 │ 011101 │
    │    X │  30 │ 011110 │
    │    Y │  31 │ 011111 │
    │    Z │  32 │ 100000 │
    │    a │  33 │ 100001 │
    │    b │  34 │ 100010 │
    │    c │  35 │ 100011 │
    │    d │  36 │ 100100 │
    │    e │  37 │ 100101 │
    │    f │  38 │ 100110 │
    │    g │  39 │ 100111 │
    │    h │  40 │ 101000 │
    │    i │  41 │ 101001 │
    │    j │  42 │ 101010 │
    │    k │  43 │ 101011 │
    │    m │  44 │ 101100 │
    │    n │  45 │ 101101 │
    │    o │  46 │ 101110 │
    │    p │  47 │ 101111 │
    │    q │  48 │ 110000 │
    │    r │  49 │ 110001 │
    │    s │  50 │ 110010 │
    │    t │  51 │ 110011 │
    │    u │  52 │ 110100 │
    │    v │  53 │ 110101 │
    │    w │  54 │ 110110 │
    │    x │  55 │ 110111 │
    │    y │  56 │ 111000 │
    │    z │  57 │ 111001 │
    └──────┴─────┴────────┘
*/

private let base58fastEncodeAlphabet = [
    "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "A", "B", "C", "D", "E", "F", "G", "H", "J",
    "K", "L", "M", "N", "P", "Q", "R", "S", "T",
    "U", "V", "W", "X", "Y", "Z",
    "a", "b", "c", "d", "e", "f", "g", "h", "i",
    "j", "k", "m", "n", "o", "p", "q", "r", "s",
    "t", "u", "v", "w", "x", "y", "z"
]

public func encode(source: Data) -> String {
    var result = ""

    let jMax = ((source.count * 138) / 100) + 1
    var jCurMax = 0

    var zeroCount = 0
    var data:[UInt8] = []
    var buffer = [UInt8](
        repeating: 0,
        count: jMax
    )

    for byte in source {
        if byte == 0 && data.count == 0 {
            zeroCount += 1
            continue
        } else {
            data.append(byte)
        }
    }

    for byte in data {
        var current    = Int(byte)
        var currentMod = 0
        var currentDiv = 0
        var j          = 0
        repeat {
            current    = current + 256 * Int(buffer[j])
            currentMod = current % 58
            currentDiv = current / 58
            current    = currentDiv
            buffer[j]  = UInt8(currentMod)
            j += 1
        } while j < jMax && (currentDiv > 0 || j < jCurMax)
        jCurMax = j
    }

    while buffer.last == 0 {
        buffer.removeLast()
    }

    if zeroCount > 0 {
        buffer += [UInt8](
            repeating: 0,
            count: zeroCount
        )
    }

    for byte in buffer {
        result = base58fastEncodeAlphabet[Int(byte)] + result
    }

    return result
}
