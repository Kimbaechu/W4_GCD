import UIKit

let serialQueue = DispatchQueue(label: "serialQueue", qos: .userInteractive)
let serialQueue2 = DispatchQueue(label: "serialQueue2", qos: .default)
let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)

func serialQueueA() {

    serialQueue.async {
        print(#function, Thread.current)
        for i in 1...10 {
            print("❤️", i)
        }
    }
}

serialQueueA()

func serialQueueB() {

    serialQueue.async {
        print(#function, Thread.current)
        for i in 1...10 {
            print("💚", i)
        }
    }
}

serialQueueB()


func serialQueueC() {

    serialQueue2.async {
        print(#function, Thread.current)
        for i in 1...10 {
            print("💛", i)
        }
    }
}

serialQueueC()



func concurrentQueueA() {

    concurrentQueue.async {
        print(#function, Thread.current)
        for i in 1...10 {
            print("❤️", i)
        }
    }
}

func concurrentQueueB() {

    concurrentQueue.async {
        print(#function, Thread.current)
        for i in 1...10 {
            print("💛", i)
        }
    }
}
concurrentQueueA()

concurrentQueueB()



