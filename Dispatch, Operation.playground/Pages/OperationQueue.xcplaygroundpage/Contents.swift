//: [Previous](@previous)

import Foundation

let operationQueue = OperationQueue()

func operate() {
    operationQueue.addOperation {
        autoreleasepool {
        for i in 1...10 {
            print("❤️", i)
        }
        }
    }
    
    let blockOperation = BlockOperation {
        autoreleasepool {
        for i in 1...10 {
            print("💚", i)
        }
        }
    }
    //blockOperation.start()
    operationQueue.addOperation(blockOperation)
    
    blockOperation.addExecutionBlock {
        autoreleasepool {
        for i in 1...10 {
            print("💛", i)
        }
        }
    }
    
    blockOperation.completionBlock = {
        print("DONE")
    }
}

operate()
//: [Next](@next)
