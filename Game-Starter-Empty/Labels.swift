import SpriteKit

class ScoreLabel: SKLabelNode{
    
    func makeLabel(score: Int, view: SKView?){

        // set the text and positions of hte label
        self.text = "Score: \(score)"
        self.position.x = self.fontSize + 40
        self.position.y = view!.bounds.height - self.fontSize
        self.zPosition = -1
        self.name = "scoreLabel"
    }
}


class tapLabel: SKLabelNode{
    func missLabel(){
        self.name =  "miss"
        self.text = "Miss"
        self.fontName = "AvenirNext-Bold"
        
    }
    
    func pointLabel(score: Int) {
        self.position = position
        self.name = "score"
        self.text = "\(score)"
        self.fontName = "AvenirNext-Bold"
    }
}

class gameOverLabel: SKLabelNode {
    func makeLabel(view: SKView?){
        
        self.text = "GAME OVER"
        self.fontName = "AvenirNext-Bold"
        self.fontSize = 45
        self.position.x = view!.bounds.width/2
        self.position.y =  view!.bounds.height/2
        self.name = "game over"
    }
}
