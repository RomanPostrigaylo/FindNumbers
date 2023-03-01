//
//  GameViewController.swift
//  FindNumbers
//
//  Created by Роман Постригайло on 25.02.2023.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var nextDigit: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    lazy var game = Game(countItems: buttons.count,time: 30) { [weak self] status, seconds in
        guard let self = self else {return}
        self.timerLabel.text = seconds.secondsToString()
        self.updateInfoGame(with: status)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()

    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else {return}
        game.check(index:buttonIndex)
        
        updateUI()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
        setupScreen()
    }
    
    // Изменение цыфры на кнопке
    private func setupScreen(){
        for index in game.items.indices{
            buttons[index].setTitle(game.items[index].title, for: .normal)
            //buttons[index].isHidden = false
            buttons[index].alpha = 1
            buttons[index].isEnabled = true
        }
        
        nextDigit.text = game.nextItem?.title
    }
    
    private func updateUI(){
        for index in game.items.indices{
           // buttons[index].isHidden = game.items[index].isFound
            buttons[index].alpha = game.items[index].isFound ? 0 : 1
            buttons[index].isEnabled = !game.items[index].isFound
            if game.items[index].isError{
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.buttons[index].backgroundColor = .red
                } completion: { [weak self] (_) in
                    self?.buttons[index].backgroundColor = .black
                    self?.game.items[index].isError = false
                }
            }
        }
        
        nextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame (with status:StatusGame){
        switch status {
            
        case .start:
            statusLabel.text = "Понеслась"
            statusLabel.textColor = .black
            newGameButton.isHidden = true
            
        case .win:
            statusLabel.text = "Красава"
            statusLabel.textColor = .green
            newGameButton.isHidden = false
            
        case .lose:
            statusLabel.text = "Потрачено"
            statusLabel.textColor = .red
            newGameButton.isHidden = false
        }
    }
    
}
