import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        print("I'm inside the viewDidLoad() method!")
        print(1, 2, 3, 4, 5)
        print(1, 2, 3, 4, 5, separator: "-")
        print("Some message", terminator: "")
        print("Some other message")

        assert(1 == 1, "Maths failure")
        //assert(1 == 2, "Maths failure")
        assert(myReallySlowMethod() == true, "The slow method returned false, which is a really bad thing!")

        for i in 1 ... 100 {
            print("I'm at \(i)")
        }
    }

    func myReallySlowMethod() -> Bool {
        #if DEBUG
        true
        #else
        false
        #endif
    }
}
