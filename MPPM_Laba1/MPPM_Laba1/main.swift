//
//  main.swift
//  MPPM_Laba1
//
//  Created by Vlad Vrublevsky on 28.10.2022.
//

import Foundation

var source_vector: [String:[Int]] = ["a": [1, 2, 3, 4, 5], "b": [1, 2, 3, 4, 5, 6, 7, 8], "c": [1, 2, 3, 4, 5, 6, 7, 8, 9] ]
let n = 3


func split(for size: Int, key: String, from: Int = 0, sourceArray: [Int]) -> [String:ArraySlice<Int>] {
    if sourceArray.count > size+from {
        return [from/size == 0 ? key: key+"\(from/size+1)": sourceArray[from..<size+from]].merging(
            split(for: size, key: key, from: size+from, sourceArray: sourceArray),
            uniquingKeysWith: { _,_ in [0] } )
    }
    return [from/size == 0 ? key: key+"\(from/size+1)": sourceArray[from...]]
}

func parse(from: Int = 0, size: Int, source_vector: [String:[Int]], index: Dictionary<String, [Int]>.Index) -> [String:ArraySlice<Int>] {
    if from + 1 < source_vector.count {
        return split(for: size, key: source_vector.keys[index], sourceArray: source_vector.values[index]).merging(
            parse(from: from+1, size: size, source_vector: source_vector, index: source_vector.index(after: index)),
            uniquingKeysWith: { _,_ in [0] } )
    }
    return split(for: size, key: source_vector.keys[index], sourceArray: source_vector.values[index])
}


print( parse(size: n, source_vector: source_vector, index: source_vector.startIndex).sorted(by: { $0.key < $1.key }) )

