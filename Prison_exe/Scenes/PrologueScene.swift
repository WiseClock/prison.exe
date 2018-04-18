//
//  PrologueScene.swift
//  Prison_exe
//
//  Created by Carl Kuang on 2018-04-05.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit
import AVFoundation

extension String {
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
}

class PrologueScene: Scene
{
    let fontGlitch : Font;
    let fontShader : ShaderProgram;
    let TextHolder : Node;
    let BottomTextHolder : Node;
    
    let gs: GameScene
    
    var gameArea: CGSize
    let sceneOffset: Float
    var previousTouchLocation = CGPoint.zero
    var totalTime: Double
    var currentTextIndex: Int = -1
    var currentTextTime: Double = 0
    var texts = [
        ["Year 21XX", 3.7, "op1_3.599s.mp3"],
        ["Under the guidance of the\nNeo-Terra Government", 3.9, "op2_3.776s.mp3"],
        ["Peace has come to Humanity", 3.4, "op3_3.234s.mp3"],
        ["But not all is well\nin this world", 3.3, "op4_3.168s.mp3"],
        ["The people paid a terrible\ncost to secure this safety", 4.6, "op5_4.468s.mp3"],
        ["One's fate is decided at birth", 3.6, "op6_3.415s.mp3"],
        ["You are either born into\none of the ten families\nof the Council", 5.1, "op7_5.009s.mp3"],
        ["Or born a slave, with\nno power over your\nown future", 5.6, "op8_5.445s.mp3"],
        ["But not all is lost", 2.6, "op9_2.487s.mp3"],
        ["Secret Resistance\ngroup ASCALON fights\nin the shadows", 4.8, "op10_4.642s.mp3"],
        ["To restore freedom\nto peoplekind", 3.0, "op11_2.841s.mp3"],
        ["Now they have dispatched their\nfinest operative", 3.8, "op12_3.699s.mp3"],
        ["To infiltrate Neo-Terra's\nCyber-prison - SAMSARA", 5.1, "op13_4.905s.mp3"],
        ["Their misson", 2.1, "op14_1.909s.mp3"],
        ["Release all prisoners\nfree their minds\nand strike back at Neo-Terra", 7.7, "op15_7.530s.mp3"],
        ["The first step?", 2.3, "op16_2.178s.mp3"],
        ["Getting through\nSAMSARA's firewalls...", 6.1, "op17_5.960s.mp3"],
    ]
    var player: AVAudioPlayer? = nil
    
    init(shaderProgram: ShaderProgram)
    {
        
        // setup a virtual game size so we have a manageable work area
        self.gameArea = CGSize(width: 27, height: 48)
        
        // calculate scene offset to determine how far back we need to move the camera
        let x = self.gameArea.height / 2
        let y = tanf(GLKMathDegreesToRadians(85/2))
        self.sceneOffset = Float(x) / y
        
        self.totalTime = 0
        
        fontShader = ShaderProgram.init(vertexShader: "FontShader.vsh", fragmentShader: "FontShader.fsh")
        fontShader.projectionMatrix = shaderProgram.projectionMatrix
        fontGlitch = Font.loadFont("Glitch Font", "glitchFont.txt", "glitchFont.png")
        TextHolder = Node.init(name: "TextHolder", shaderProgram: shaderProgram)
        BottomTextHolder = Node.init(name: "TextHolder", shaderProgram: shaderProgram)

        gs = GameScene.init(shaderProgram: shaderProgram)
        
        super.init(name: "PrologueScene", shaderProgram: shaderProgram)
        
        gs.lineShaderProgram = self.manager?.lineShaderProgram

        // create the initial scene position so (x,y): (0, 0) is the center of the screen
        self.position = GLKVector3Make(Float(-self.gameArea.width / 2),
                                       Float(-self.gameArea.height / 2),
                                       -self.sceneOffset)
        
        self.rotationX = GLKMathDegreesToRadians(0)
        
        // text holder
        self.children.append(TextHolder)
        self.children.append(BottomTextHolder)

        setText("Tap to skip", BottomTextHolder, 0.03, 0.03, true)
    }
    
    func setText(_ text : String, _ container : Node, _ yInit : Float, _ fontScale : Float, _ forceSolid : Bool = false)
    {
        container.children.removeAll(keepingCapacity: false)
        
        let ratioX: Float = 1.0 / Float(fontGlitch.ScaleW);
        let ratioY: Float = 1.0 / Float(fontGlitch.ScaleH);
        let lineHeight: Float = Float(fontGlitch.LineHeight) * fontScale
        let base: Float = Float(fontGlitch.Base) * fontScale
        
        let lines = text.components(separatedBy: .newlines)
        var lineOffset: Float = Float(lines.count) * lineHeight / 2
        for line in lines
        {
            var zIndexOffset: Float = 0
            var totalWidth: Float = 0
            for ascii in line.asciiArray
            {
                if (fontGlitch.Glyphs[Int(ascii)] == nil)
                {
                    continue;
                }
                totalWidth += fontGlitch.Glyphs[Int(ascii)]!.AdvanceX * fontScale
            }
            
            var currentX: Float = -totalWidth / 2
            
            for ascii in line.asciiArray
            {
                if (fontGlitch.Glyphs[Int(ascii)] == nil)
                {
                    continue;
                }
                let fg : FontGlyph = fontGlitch.Glyphs[Int(ascii)]!
                let x = fg.X
                let y = fg.Y
                let width = fg.AdvanceX * fontScale
                let texWidth = fg.Width
                let texHeight = fg.Height
                let texOffX = fg.OffsetX
                let texOffY = fg.OffsetY
                
                let startX: Float = x * ratioX;
                let startY: Float = 1 - (y + texHeight) * ratioY;
                let endX: Float = startX + texWidth * ratioX;
                let endY: Float = startY + texHeight * ratioY;
                
                let g = GlyphNode(shader: fontShader, texture: fontGlitch.Texture, width: texWidth * fontScale, height: texHeight * fontScale, startX: startX, startY: startY, endX: endX, endY: endY, forceSolid: forceSolid)
                g.position = GLKVector3Make(Float(self.gameArea.width / 2) + currentX + texOffX * fontScale,
                                            yInit + lineOffset + (lineHeight - base) + (lineHeight - texOffY * fontScale - texHeight * fontScale),
                                            zIndexOffset)
                container.children.append(g)
                currentX += width
                zIndexOffset -= 0.01 // hack, to make the transparent-blending working
            }
            lineOffset -= lineHeight
        }
    }
    
    override func updateWithDelta(_ dt: TimeInterval) {
        super.updateWithDelta(dt)
        self.totalTime += dt
        
        if (currentTextIndex >= 0)
        {
            if (currentTextTime > texts[currentTextIndex][1] as! Double)
            {
                currentTextTime = 0;
            }
            else
            {
                glUseProgram(fontShader.programHandle)
                if (currentTextTime <= 0.5)
                {
                    glUniform1f(glGetUniformLocation(fontShader.programHandle, "u_Transparency"), GLfloat(currentTextTime * 2))
                }
                else if (currentTextTime >= texts[currentTextIndex][1] as! Double - 0.5)
                {
                    glUniform1f(glGetUniformLocation(fontShader.programHandle, "u_Transparency"), GLfloat((texts[currentTextIndex][1] as! Double - 0.5 - currentTextTime) * 2 + 1))
                }
                else
                {
                    glUniform1f(glGetUniformLocation(fontShader.programHandle, "u_Transparency"), GLfloat(1))
                }
                
                currentTextTime += dt;
            }
        }
        
        if (currentTextTime == 0)
        {
            currentTextIndex += 1;
            
            if (texts.count > currentTextIndex)
            {
                if (self.player != nil)
                {
                    self.player!.stop()
                }
                setText(texts[currentTextIndex][0] as! String, TextHolder, Float(self.gameArea.height / 2), 0.04)
                // todo: play audio
                let file = texts[currentTextIndex][2] as! String
                let url = Bundle.main.url(forResource: file, withExtension: nil)
                let player = try? AVAudioPlayer(contentsOf: url!)
                player!.prepareToPlay()
                self.player = player!
                self.player!.play()
            }
            else
            {
                currentTextIndex -= 1;
                showGameScene()
            }
        }
    }
    
    // convert a touch location to actual game space coordinates
    func touchLocationToGameArea(_ touchLocation: CGPoint) -> CGPoint {
        guard let manager = self.manager else { return .zero }
        let ratio = manager.glkView.frame.size.height / self.gameArea.height
        let x = touchLocation.x / ratio
        let y = (manager.glkView.frame.size.height - touchLocation.y) / ratio
        return CGPoint(x: x, y: y)
    }
    
    override func touchGestureSwipedLeft(_ sender: UISwipeGestureRecognizer) {
    }
    
    override func touchGestureSwipedRight(_ sender: UISwipeGestureRecognizer) {
    }
    
    override func touchGestureSwipedUp(_ sender: UISwipeGestureRecognizer) {
    }
    
    override func touchGestureSwipedDown(_ sender: UISwipeGestureRecognizer) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // self.contentView.removeFromSuperview()
        
        //self.manager?.scene = GameScene.init(shaderProgram: (self.manager?.shaderProgram)!)
        //self.manager?.playBtnNoise();
        
        showGameScene()
    }
    
    func showGameScene()
    {
        self.manager?.playBackgroundMusic(file: "game.mp3")
        self.manager?.scene = gs
        self.manager?.scorelabel?.isHidden = false
    }
    
}

