//
//  GameManager.swift
//
//  Created by Ryan Dieno on 2018-02-15.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit
import AVFoundation

// Manager to handle scene management, audio and shaders
class GameManager {
    let glkView: GLKView
    var scene: Scene {didSet{ scene.manager = self }}
    var shaderProgram: ShaderProgram
    
    var backgroundMusicPlayer: AVAudioPlayer?
    var popEffect: AVAudioPlayer?
    
    init(view: GLKView, scene: Scene, shaderProgram: ShaderProgram) {
        self.glkView = view
        self.scene = scene
        self.shaderProgram = shaderProgram
        self.scene.manager = self
    }
    
    // sets up opengl rendering buffer and renders the current scene
    func render(with parentModelViewMatrix: GLKMatrix4) {
        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        glEnable(GLenum(GL_DEPTH_TEST))
        glEnable(GLenum(GL_CULL_FACE))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        self.scene.render(with: GLKMatrix4Identity)
    }
    
    // creates an instance of our game manager and initializes the initial scene
    static func gameManager(of view: GLKView) -> GameManager {
        guard let context = EAGLContext(api: .openGLES2) else { fatalError("Cannot create an EAGLContext") }
        view.context = context
        view.drawableDepthFormat = .format16
        EAGLContext.setCurrent(view.context)
        
        let program = ShaderProgram.init(vertexShader: "SimpleVertexShader.glsl",
                                           fragmentShader: "SimpleFragmentShader.glsl")
        
        let scene = MainMenuScene(shaderProgram: program, view: view)
        
        program.projectionMatrix = GLKMatrix4MakePerspective(
            GLKMathDegreesToRadians(85.0),
            GLfloat(view.bounds.size.width / view.bounds.size.height),
            1,
            300)
        
        return GameManager(view: view, scene: scene, shaderProgram: program)
    }
    
    func playBackgroundMusic(file: String) {
        guard let player = self.preloadSoundEffect(file: file) else { return }
        player.numberOfLoops = -1
        player.play()
        self.backgroundMusicPlayer = player
    }
    
    func setPopEffect(file: String) {
        self.popEffect = self.preloadSoundEffect(file: file)
    }
    
    func preloadSoundEffect(file: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil), let player = try? AVAudioPlayer(contentsOf: url) else { return nil }
        player.prepareToPlay()
        return player
    }
    
    func playPopEffect() {
        self.popEffect?.play()
    }
}
