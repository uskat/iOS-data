
import UIKit

class FeedModel {
    private let secretWord = "111"
    
    func check(word: String) -> UIColor {
        return word == secretWord ? .systemGreen : .systemRed
    }
}
