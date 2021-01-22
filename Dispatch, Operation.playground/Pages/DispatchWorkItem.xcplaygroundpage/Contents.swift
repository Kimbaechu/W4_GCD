//: [Previous](@previous)

import Foundation

let myGroup = DispatchGroup()
let serialQueue = DispatchQueue(label: "serialQueue")
let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)

let workItem = DispatchWorkItem {
    print(Thread.current)
    for i in 1...10 {
        print("❤️", i)
    }
}

//workItem.perform()
//
//serialQueue.async(group: myGroup) {
//    print(Thread.current)
//    for i in 1...10 {
//        print("ㅊ", i)
//    }
//}
//
//myGroup.notify(queue: .main) {
//    print("DONE - 1")
//}
//
//serialQueue.async(group: myGroup ,execute: workItem)

//serialQueue.async(execute: workItem)

//workItem.notify(queue: .main) {
//    print("DONE")
//}

//serialQueue.async(execute: workItem)
//print("#1")
//workItem.wait()
//print("#2")


DispatchQueue.main.async(execute: workItem)
//: [Next](@next)
