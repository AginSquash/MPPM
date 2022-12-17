//
//  main.swift
//  MPP_Lab2.1
//
//  Created by Vlad Vrublevsky on 17.12.2022.
//

import Foundation

let chart1 = Order(balance: 500)

do {
    try chart1.doTransactionally({
        chart1.addElement(label: "Part #1", price: 25)
        chart1.addElement(label: "Part #2", price: 75)
    })
} catch {
    print(error)
}

do {
    try chart1.doTransactionally({
        chart1.addElement(label: "Part #3", price: 435)
    })
} catch {
    print(error)
}



print("chart 1")
for e in chart1.elements {
    print("\(e.label), \(e.price)$")
}

let chart2 = Order(balance: 500)

do {
    try chart2.doTransactionally({
        chart2.addElement(label: "Part #1", price: 25)
        chart2.addElement(label: "Part #2", price: 800)
    })
} catch {
    print(error)
}



print("chart 2")
for e in chart2.elements {
    print("\(e.label), \(e.price)$")
}
