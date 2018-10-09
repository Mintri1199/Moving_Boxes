import GameplayKit


class BetterGameScene: SKScene{
    
    var bubble: Bubble?
    var score = 0
    var label: ScoreLabel?
    var tap: tapLabel?
    var done: gameOverLabel?
    
    override func didMove(to view: SKView) {
        createScoreLabel()
        
        self.run(gameFunction(), withKey: "k")
    }
    
    override func update(_ currentTime: TimeInterval) {
        pointLoss()
        if score < 0{
            removeAction(forKey: "k")
            // Clear all boxes when game over is hit
            while childNode(withName: "square") != nil{
                childNode(withName: "square")?.removeFromParent()
            }
            gameOver()
        }
    }
    
    // Game function
    func gameFunction() -> SKAction{
        let action = SKAction.run {
            self.makeSquare()
        }
        let wait = SKAction.wait(forDuration: Double.random(in: 1 ... 3 ))
        let seq = SKAction.sequence([action, wait])
        let re = SKAction.repeatForever(seq)
        return re
    }
    // Create the box along with it's actions
    func makeSquare(){
        bubble = Bubble()
        addChild(bubble!)
        bubble?.Actions(view: self.view)
        
    }
    // Create the on tap score label
    func createScoreLabel(){
        guard let view = self.view else {
            return
        }
        label = ScoreLabel()
        label?.makeLabel(score: score, view: view)
        addChild(label!)
    }
    
    // Create a fadeOut score label when the player tap on the box
    func createOnTapScoreLabel(location: CGPoint){
        tap = tapLabel()
        tap?.pointLabel(score: score)
        tap?.position = location
        addChild(tap!)
        let wait = SKAction.wait(forDuration: 0.5)
        let fadeOUT = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.run {
            self.childNode(withName: "score")?.removeFromParent()
        }
        let seq = SKAction.sequence([wait, fadeOUT, remove])
        tap?.run(seq)
        
    }
    
    // Create miss label when the player doesn't tap on the box
    func createOnTapMissLabel(location: CGPoint){
        tap = tapLabel()
        tap?.missLabel()
        tap?.position = location
        addChild(tap!)
        let wait = SKAction.wait(forDuration: 0.5)
        let fadeOUT = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.run {
            self.childNode(withName: "miss")?.removeFromParent()
        }
        let seq = SKAction.sequence([wait, fadeOUT, remove])
        tap?.run(seq)
    }
    
    // Flag that allow the gameOverLabel to display once
    private var didShowGameOver = false
    
    func gameOver() {
        guard didShowGameOver == false, let view = self.view  else {
            return
        }
        done = gameOverLabel()
        done?.makeLabel(view: view)
        addChild(done!)
        didShowGameOver = true
    }
    
    // Function to handle changing label
    func pointLoss(){
        label = ScoreLabel()
        bubble = Bubble()
        // Need to figure out how to use the bubble's delete function
        if childNode(withName: "square")?.position.y == self.view?.bounds.height{
            childNode(withName: "square")?.removeFromParent()
            score -= 1
            childNode(withName: "scoreLabel")?.removeFromParent()
            label?.makeLabel(score: score, view: self.view)
            addChild(label!)
        }
    }
    
    // Function the react with the user's touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tap = tapLabel()
        if let touch = touches.first{
            
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if node.name == "square"{
                node.removeFromParent()
                score += 1
                self.createOnTapScoreLabel(location: location)
                childNode(withName: "scoreLabel")?.removeFromParent()
                createScoreLabel()
            }else if node.name == "game over"{ // Trigger restart function when the player tap on gameOverLabel
                score = 0
                childNode(withName: "game over")?.removeFromParent()
                childNode(withName: "scoreLabel")?.removeFromParent()
                didShowGameOver = false
                createScoreLabel()
                self.run(gameFunction(), withKey: "k")
            }else{ // Miss label is at the bottom to prevent appearing when the player tap on gameOverLabel
                self.createOnTapMissLabel(location: location)
            }
        }
    }
}
