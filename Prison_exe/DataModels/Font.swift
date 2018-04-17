//
//  Font.swift
//  Prison_exe
//
//  Created by Carl Kuang on 2018-04-12.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import Foundation

struct Font
{
    let Name : String
    let Texture : String
    
    var Glyphs = [Int : FontGlyph]()
    var LineHeight : Int = 33
    var Base : Int = 30
    var SpacingX : Int = 2
    var SpacingY : Int = 2
    var ScaleW : Int = 1
    var ScaleH : Int = 1
    
    init(_ name : String, _ texture: String)
    {
        self.Name = name
        self.Texture = texture
    }
    
    static func loadFont(_ name : String, _ file : String, _ texture : String) -> Font
    {
        var font : Font = Font.init(name, texture)
        
        do
        {
            let data = try String(contentsOfFile: Bundle.main.path(forResource: file, ofType: "")!, encoding: .utf8)
            let lines = data.components(separatedBy: .newlines)
            
            for line in lines
            {
                let parts = line.split(separator: " ")//, maxSplits: 1)
                
                if (line.hasPrefix("common "))
                {
                    for part in parts
                    {
                        if (part.contains("="))
                        {
                            let pair = part.split(separator: "=")
                            switch (pair[0])
                            {
                            case "lineHeight":
                                font.LineHeight = Int(pair[1])!
                                break;
                            case "base":
                                font.Base = Int(pair[1])!
                                break;
                            case "scaleW":
                                font.ScaleW = Int(pair[1])!
                                break;
                            case "scaleH":
                                font.ScaleH = Int(pair[1])!
                                break;
                            default:
                                break;
                            }
                        }
                    }
                }
                else if (line.hasPrefix("char "))
                {
                    var id : Int = 0
                    var x = Float(0), y = Float(0), width = Float(0), height = Float(0), offsetX = Float(0), offsetY = Float(0), advanceX = Float(0)
                    
                    for part in parts
                    {
                        if (part.contains("="))
                        {
                            let pair = part.split(separator: "=")
                            switch (pair[0])
                            {
                            case "id":
                                id = Int(pair[1])!
                                break;
                            case "x":
                                x = Float(pair[1])!
                                break;
                            case "y":
                                y = Float(pair[1])!
                                break;
                            case "xoffset":
                                offsetX = Float(pair[1])!
                                break;
                            case "yoffset":
                                offsetY = Float(pair[1])!
                                break;
                            case "xadvance":
                                advanceX = Float(pair[1])!
                                break;
                            case "width":
                                width = Float(pair[1])!
                                break;
                            case "height":
                                height = Float(pair[1])!
                                break;
                            default:
                                break;
                            }
                        }
                    }
                    
                    let glyph : FontGlyph = FontGlyph.init(id, x, y, width, height, offsetX, offsetY, advanceX, Character(UnicodeScalar(id)!))
                    font.Glyphs[id] = glyph
                }
            }
        }
        catch {}
        
        return font
    }
}
