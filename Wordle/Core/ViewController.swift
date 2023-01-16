//
//  ViewController.swift
//  Wordle
//
//  Created by Afraz Siddiqui on 3/7/22.
//

import UIKit

// UI
// Keyboard
// Game board
// Orange/Green

class ViewController: BaseViewController {

    let answers = [
        "later",
        "bloke",
        "there",
        "ultra",
        "medal",
        "entry",
        "brave",
        "tiger",
        "split",
        "robot",
        "groan",
        "wagon",
        "witch",
        "drama",
        "disco",
        "blank",
        "asset",
        "build",
        "raise",
        "award",
        "slide",
        "spill",
        "chase",
        "shelf",
        "solid",
        "guilt",
        "belly",
        "false",
        "round",
        "panic",
        "hobby",
        "limit",
        "frank",
        "patch",
        "ferry",
        "stool",
        "total",
        "lunch",
        "rumor",
        "floor",
        "drill",
        "giant",
        "check",
        "carry",
        "crowd",
        "brick",
        "eagle",
        "doubt",
        "radio",
        "haunt",
        "model",
        "shaft",
        "plane",
        "trace"
    ]

    var answer = ""
    private var guesses: [[Character?]] = Array(
        repeating: Array(repeating: nil, count: 5),
        count: 6
    )

    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()
    
    var empty: Int = 30
    var currentTextCount: Int = 0
    
    var currentAnswer: String = ""
    var gameDone: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        answer = answers.randomElement() ?? "after"
        view.backgroundColor = .black
        addChildren()
    }

    private func addChildren() {
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)

        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        boardVC.datasource = self
        view.addSubview(boardVC.view)

        addConstraints()
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),

            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func judge() {
        
        var susuess: Bool = false

        if self.answer == self.currentAnswer {
            susuess = true
        }
        
        self.showSingleAlert(title: susuess ? "答對囉" : "答錯囉",
                             message: susuess ? "恭喜你答對囉" : "答錯囉，答案是\n\(self.answer)",
                             confirmTitle: "點我重新遊戲",
                             confirmAction: { [weak self] in
            self?.guesses = Array(repeating: Array(repeating: nil, count: 5),count: 6)
            self?.answer = self?.answers.randomElement() ?? "there"
            self?.currentTextCount = 0
            self?.currentAnswer = ""
            self?.boardVC.reloadData()
        })
        
        
    }
    
}

extension ViewController: KeyboardViewControllerDelegate {
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {

        // Update guesses
        var stop = false

        
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    currentTextCount += 1
                    self.currentAnswer.append(letter)
                    stop = true
                    break
                }
            }

            if stop {
                break
            }
        }

        boardVC.reloadData()

        if (self.empty == self.currentTextCount) || self.answer == self.currentAnswer {
            self.judge()
        }
    }
}

extension ViewController: BoardViewControllerDatasource {
    var currentGuesses: [[Character?]] {
        return guesses
    }

    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section

        let count = guesses[rowIndex].compactMap({ $0 }).count
        guard count == 5 else {
            return nil
        }

        let indexedAnswer = Array(answer)

        guard let letter = guesses[indexPath.section][indexPath.row],
              indexedAnswer.contains(letter) else {
            return nil
        }

        if indexedAnswer[indexPath.row] == letter {
            return .systemGreen
        }


        return .systemOrange
    }
}
