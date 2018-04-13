//
//  PrologueScene.swift
//  Prison_exe
//
//  Created by Carl Kuang on 2018-04-05.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

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
    
    var gameArea: CGSize
    let sceneOffset: Float
    var previousTouchLocation = CGPoint.zero
    var totalTime: Double
    var currentTextIndex: Int = -1
    var currentTextTime: Double = 0
    var texts = [
        ["First One\nAAA", 2.0],
        ["Second One\nTest", 5.0],
        ["Third One", 3.0],
    ]
    
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

        super.init(name: "PrologueScene", shaderProgram: shaderProgram)

        // create the initial scene position so (x,y): (0, 0) is the center of the screen
        self.position = GLKVector3Make(Float(-self.gameArea.width / 2),
                                       Float(-self.gameArea.height / 2),
                                       -self.sceneOffset)
        
        self.rotationX = GLKMathDegreesToRadians(0)
        
        // text holder
        self.children.append(TextHolder)
        self.children.append(BottomTextHolder)

        setText("Tap to skip", BottomTextHolder, 0.03, 0.03)
    }
    
    func setText(_ text : String, _ container : Node, _ yInit : Float, _ fontScale : Float)
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
                
                let g = GlyphNode(shader: fontShader, texture: fontGlitch.Texture, width: texWidth * fontScale, height: texHeight * fontScale, startX: startX, startY: startY, endX: endX, endY: endY)
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
            if (texts.count > currentTextIndex && currentTextTime > texts[currentTextIndex][1] as! Double)
            {
                currentTextTime = 0;
            }
            else
            {
                currentTextTime += dt;
            }
        }
        
        if (currentTextTime == 0)
        {
            currentTextIndex += 1;
            
            if (texts.count > currentTextIndex)
            {
                setText(texts[currentTextIndex][0] as! String, TextHolder, Float(self.gameArea.height / 2), 0.05)
                // todo: play audio
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
        
        let gs = GameScene.init(shaderProgram: shaderProgram)
        gs.lineShaderProgram = self.manager?.lineShaderProgram
        self.manager?.scene = gs
    }
    
}

