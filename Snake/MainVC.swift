//
//  MainVC.swift
//  Snake
//
//  Created by Dmitiy Golovnia on 15.11.2021.
//

import UIKit

class MainVC: UIViewController {
    
    //MARK: Variables
    private let columns: Int = 30
    private let rows: Int = 20
    private var allBoxes: [Position: UIView] = [:]
    private var direction: Direction = .up
    private var headPosition: Position?
    private var tailPosition: Position?
    
    
    //MAKR: UI Elements
    var fieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureStartPositions()
    }
    
    
    //MARK: Setup
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(fieldStackView)
        NSLayoutConstraint.activate([
            fieldStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            fieldStackView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.5),
            fieldStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fieldStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupField() {
        for column in 0..<columns {
            let rowStackView = UIStackView()
            rowStackView.distribution = .fillEqually
            for row in 0..<rows {
                let box = UIView()
                rowStackView.addArrangedSubview(box)
                let boxPositon = Position(row: row, column: column)
                allBoxes[boxPositon] = box
            }
            fieldStackView.addArrangedSubview(rowStackView)
        }
    }
    
    func configureStartPositions() {
        let centerRow = rows / 2
        let centerColumn = columns / 2
        headPosition = Position(row: centerRow, column: centerColumn)
        tailPosition = Position(row: centerRow + 1, column: centerColumn)
        startAnimation()
    }
    
    
    //MARK: Logic
    func startAnimation() {
        Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
    
    func nextPosition() -> Position {
        guard let headPosition = headPosition else { fatalError("headPosition not find") }
        direction = nextDirection(currentDirection: direction)
        let newPosition: Position
        switch direction {
        case .up:
            newPosition = headPosition.column == 0
            ? Position(row: headPosition.row, column: columns - 1)
            : Position(row: headPosition.row, column: headPosition.column - 1)
        case .down:
            newPosition = headPosition.column == columns - 1
            ? Position(row: headPosition.row, column: 0)
            : Position(row: headPosition.row, column: headPosition.column + 1)
        case .left:
            newPosition = headPosition.row == 0
            ? Position(row: rows - 1, column: headPosition.column)
            : Position(row: headPosition.row - 1, column: headPosition.column)
        case .right:
            newPosition = headPosition.row == rows - 1
            ? Position(row: 0, column: headPosition.column)
            : Position(row: headPosition.row - 1, column: headPosition.column)
        }
        return newPosition
    }
    
    func nextDirection(currentDirection: Direction) -> Direction {
        switch currentDirection {
        case .up: return [Direction.up, .right, .left].randomElement() ?? .up
        case .down: return [Direction.down, .right, .left].randomElement() ?? .down
        case .left: return [Direction.up, .down, .left].randomElement() ?? .left
        case .right: return [Direction.up, .right, .down].randomElement() ?? .right
        }
    }
    

    //MARK: Handlers
    @objc
    private func animate() {
        guard let headPosition = headPosition,
              let tailPosition = tailPosition,
              let headBox = allBoxes[headPosition],
              let tailBox = allBoxes[tailPosition] else { return }
        let nextPosition = nextPosition()
        guard let newHeadBox = allBoxes[nextPosition],
              let newTailBox = allBoxes[headPosition] else { return }
        [headBox, tailBox].forEach { $0.backgroundColor = .white }
        newHeadBox.backgroundColor = .systemBlue
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            newTailBox.backgroundColor = .systemIndigo
        }
        self.tailPosition = headPosition
        self.headPosition = nextPosition
    }
    
}
