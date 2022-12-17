//
//  main.swift
//  MPP_Lab2.1
//
//  Created by Vlad Vrublevsky on 17.12.2022.
//

import Foundation

let chart1 = Order()

do {
    try chart1.doTransactionally({
        chart1.addElement(label: "Part #1", percentage: 25)
        chart1.addElement(label: "Part #2", percentage: 75)
    })
} catch {
    print(error)
}

for e in chart1.elements {
    print("\(e.label), \(e.percentage)%")
}

let chart2 = Order()

do {
    try chart2.doTransactionally({
        chart2.addElement(label: "Part #1", percentage: 25)
        chart2.addElement(label: "Part #2", percentage: 80)
    })
} catch {
    print(error)
}
