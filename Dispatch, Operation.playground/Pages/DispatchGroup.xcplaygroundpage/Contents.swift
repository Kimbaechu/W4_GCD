//: [Previous](@previous)

import Foundation

let myGroup = DispatchGroup()
let serialQueue = DispatchQueue(label: "serialQueue")
let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)


serialQueue.async(group: myGroup) {
    print(Thread.current)
    for i in 1...10 {
        print("❤️", i)
    }
}

serialQueue.async(group: myGroup) {
    print(Thread.current)
    for i in 1...10 {
        print("💚", i)
    }
}

myGroup.notify(queue: .main) {
    print("DONE - 1")
}

concurrentQueue.async(group: myGroup) {
    print(Thread.current)
    for i in 1...10 {
        print("💛", i)
    }
}


myGroup.notify(queue: .main) {
    print("DONE - 2")
}



//: [Next](@next)
