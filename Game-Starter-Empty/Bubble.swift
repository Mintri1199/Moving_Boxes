import SpriteKit


class Bubble: SKSpriteNode {
    
    init() {
        // Random values for random color
        let red:CGFloat = CGFloat(Double.random(in: 0.0 ... 1.0))
        let green:CGFloat = CGFloat(Double.random(in: 0.0 ... 1.0))
        let blue:CGFloat = CGFloat(Double.random(in: 0.0 ... 1.0))
        
        //let texture = SKTexture(imageNamed: "square")
        let color = UIColor(red:red, green: green, blue: blue, alpha: 1.0)
        let size = CGSize(width: 60, height: 60)
        
        super.init(texture: nil, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Actions(view: SKView?){
        guard let screen = view else{
            return
        }
        // Set the variables for the box
        let randomTime = Double.random(in: 1 ... 2)
        let randomPosition = CGFloat.random(in: 30 ... screen.bounds.width - 30)
        let randomDodging = CGFloat.random(in: 30 ... screen.bounds.width - 30)
        
        // Set the basic actions of the box
        let moveUP = SKAction.moveTo(y: screen.bounds.height, duration: randomTime)
        
        // Set unique attributes for the box
        let dodging = SKAction.moveTo(x: randomDodging, duration: Double.random(in: 0.5 ... 0.8))
        let wait = SKAction.wait(forDuration: Double.random(in: 0.5 ... 0.8))
        let dodgingSequence =  SKAction.sequence([wait, dodging])
        
        // Group the two sequences
        let group = SKAction.group([moveUP, dodgingSequence])
        
        self.position.x = randomPosition
        self.name = "square"
        
        self.run(group)
    }
    
    func delete(score: Int, view: SKView) -> Int{
        if self.position.y == view.bounds.height{
            childNode(withName: "scoreLabel")?.removeFromParent()
            self.removeFromParent()
            return score - 1
        }
        return score
    }
    
}
