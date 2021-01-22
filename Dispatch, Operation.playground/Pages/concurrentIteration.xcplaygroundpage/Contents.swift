//: [Previous](@previous)

import Foundation

var start = DispatchTime.now()
for i in 0..<100 {
    print(i, terminator: " ")
}
var end = DispatchTime.now()
print("\n")
print("for loop :", start.distance(to: end))


print("\n")
//반복순서가 중요하지 않을 때 속도 개선가능
start = .now()
DispatchQueue.concurrentPerform(iterations: 100) { i in
    print(i, terminator: " ")
}
end = .now()
print("\n")
print("concurrentPerform :", start.distance(to: end))


//: [Next](@next)
