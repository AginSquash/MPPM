//
//  main.swift
//  MPPM_Laba2
//
//  Created by Vlad Vrublevsky on 02.12.2022.
//

import Foundation
import SwiftUI

class PieChart : Transactable  {
    
}

enum ErrorType: Error {
    case unexpected
    case unhandledError(status: OSStatus)
}

let myNotification = Notification.Name("MyNotification")
let myNotification2 = Notification.Name("MyNotification2")

let publisher = NotificationCenter.default
.publisher(for: myNotification, object: nil)

let publisher2 = NotificationCenter.default
.publisher(for: myNotification2, object: nil)

let center = NotificationCenter.default

// 1
var subscription = publisher
    .sink(receiveValue: sub)
 
func sub(_: Any) {
    print("Notification received from a publisher!")
}

// 2
center.post(name: myNotification, object: nil)
center.post(name: myNotification2, object: nil)
// 3
subscription.cancel()

print(type(of: publisher2.sink(receiveValue: sub)))

func theKostylWithError() throws {
    throw ErrorType.unexpected
    
    subscription = publisher2.sink(receiveValue: sub)
}

func changePublisher() {
    var errorValue: Error? = nil
    
    var errorBinding = Binding<Error?>(
        get: { errorValue },
        set: { errorValue = $0
                // reverse changes
        }
    )
    
    DispatchQueue.main.async {
        subscription.cancel()
        
       // errorBinding.wrappedValue = try? theKostylWithError()
    }
}
