//
//  Logic.swift
//  WordHuntApp
//
//  Created by Riley Koo on 5/20/24.
//

import SwiftUI
import UIKit

func isReal(word: String) -> Bool {
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

    return misspelledRange.location == NSNotFound
}

class box : ObservableObject, Equatable {
    var isSelected: Bool
    public var letter: Character
    var id: UUID
    func select() {
        isSelected = true
    }
    func deselect() {
        isSelected = false
    }
    init() {
        isSelected = false
        
        var letters = ""
        for entry in lettersRarity {
            for _ in 0..<entry.value {
                letters += entry.key
            }
        }
        
        letter = letters.randomElement()!
        id = UUID()
    }
    public static func ==(lhs: box, rhs: box) -> Bool {
        return lhs.id == rhs.id
    }
}

class grid {
    var boxes: [box]
    var lettersSelected: String
    var submittedWords: [String]
    func deselect() {
        for x in 0..<boxes.count {
            boxes[x].deselect()
        }
        lettersSelected = ""
    }
    func submit() -> Bool {
        if isReal(word: lettersSelected) {
            submittedWords.append(lettersSelected)
            deselect()
            return true
        }
        deselect()
        return false
    }
    init () {
        boxes = []
        for _ in 0..<gridSize*gridSize {
            boxes.append(box())
        }
        submittedWords = []
        lettersSelected = ""
    }
    func select(x: Int, y: Int) {
        if x < gridSize && y < gridSize && x > -1 && y > -1 {
            if !boxes[x + gridSize*y].isSelected {
                lettersSelected.append(boxes[x + gridSize*y].letter)
                boxes[x + gridSize*y].select()
            }
        }
    }
    func isNextTo(b1: box, b2: box) -> Bool {
        let indx1 = findBoxIndx(b: b1)
        let indx2 = findBoxIndx(b: b2)
        
        let horz = abs(indx1 % gridSize) - (indx2 % gridSize)
        let vert = abs(indx1 / gridSize) - (indx2 / gridSize)
        
        return (horz <= 1) && (vert <= 1) && (b1.id != b2.id)
    }
    func findBoxIndx(b: box) -> Int {
        for x in 0..<boxes.count {
            if boxes[x].id == b.id {
                return x
            }
        }
        return -1
    }
    func select(box: box) {
        let x = findBoxIndx(b: box)
        select(x: x%gridSize, y: x/gridSize)
    }
}
