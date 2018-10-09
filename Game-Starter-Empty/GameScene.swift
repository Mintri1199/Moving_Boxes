//
//  GameScene.swift
//  Game-Starter-Empty
//
//  Created by mitchell hudson on 9/13/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
	var score = 0
	let randomTime =  Double.random(in: 0.2 ... 1)
	
	override func didMove(to view: SKView) {
		// Called when the scene has been displayed
		label()
		self.run(gameloop(), withKey: "k")
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
		if score < 0{
			self.removeAction(forKey: "k")
			gameOver()
		}
	}
	
	func getRandomColor() -> UIColor {
		//Generate between 0 to 1
		let red:CGFloat = CGFloat(Double.random(in: 0.0 ... 1.0))
		let green:CGFloat = CGFloat(Double.random(in: 0.0 ... 1.0))
		let blue:CGFloat = CGFloat(Double.random(in: 0.0 ... 1.0))
		
		return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
	}
	
	// This function create and add the square node
	func createMovingSquare(){
		guard let view = self.view else{return}
		
		let square = SKSpriteNode(color: getRandomColor(), size: CGSize(width: 60, height: 60))
		
		let randomTime =  Double.random(in: 1 ... 2.5) // Set random time for the box to move up
		let moveUp = SKAction.moveTo(y: view.bounds.height, duration: randomTime)
		let remove =  SKAction.removeFromParent()
		let minus = SKAction.run {
			self.score -= 1
			self.childNode(withName: "label")!.removeFromParent()
			self.label()
		}
		let seq = SKAction.sequence([moveUp,remove,minus])
		let limit  = view.bounds.width-30
		
		square.name = "square"
		square.position.x = CGFloat.random(in: 30 ... limit)
		
		addChild(square)
		square.run(seq)
	}
	
	func label(){
		guard let view = self.view else {return}
		let label =  SKLabelNode(text: "Score: \(score)")
		
		label.name =  "label"
		label.position.y = view.bounds.height - label.fontSize
		label.position.x = 30 + label.fontSize
		
		addChild(label)
	}
	
	// Flag that prevent the game over label from adding node continuously
	private var didShowGameOver = false
	
	//The game loop function
	func gameloop() -> SKAction {
		let make = SKAction.run {
			self.createMovingSquare()
		}
		let wait = SKAction.wait(forDuration: randomTime)
		let seq = SKAction.sequence([wait, make])
		let repEndless = SKAction.repeatForever(seq)
		
		return repEndless
	}
	
	func gameOver() {
		guard let view = self.view,
			didShowGameOver == false else {return}
		
		let gameOverLabel = SKLabelNode(text: "Game Over")
		
		while childNode(withName: "square") != nil{
			childNode(withName: "square")?.removeFromParent()
		}
		
		gameOverLabel.name = "game over"
		
		gameOverLabel.fontSize = 45
		gameOverLabel.position.x = view.bounds.width/2
		gameOverLabel.position.y =  view.bounds.height/2
		
		addChild(gameOverLabel)
		didShowGameOver = true
	}
	
	func restart(){
		score = 0
		childNode(withName: "label")?.removeFromParent()
		childNode(withName: "game over")?.removeFromParent()
		didShowGameOver = false
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
		if let touch = touches.first{
			let location = touch.location(in: self)
			let node = atPoint(location)
			
			if node.name == "square"{
				node.removeFromParent()
				score += 1
				childNode(withName: "label")?.removeFromParent()
				self.label()
				
			}
			if node.name == "game over"{
				restart()
				label()
				self.run(gameloop(), withKey: "k")
			}
		}
		
	}
}
