//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "GX-Engine"
//
// Copyright (c) 2014 Jimmy Huey (wuey99@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// <$end$/>
//------------------------------------------------------------------------------------------
package gx.messages.speechbubble;
	
	import openfl.display.*;
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	import gx.messages.level.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	
	//------------------------------------------------------------------------------------------
	class SpeechBubbleX extends XLogicObjectCX {
		public var m_sprite:MovieClip;
		public var x_sprite:XDepthSprite;
		
		public var script:XTask;
		
		public var m_bubbleWidth:Float;
		public var m_bubbleHeight:Float;
		
		public var m_bubblePointX:Float;
		public var m_bubblePointY:Float;
		
		public var m_left:Float;
		public var m_right:Float;
		
		public var m_cornerRadius:Float;
		
		public var m_fontName:String;
		public var m_fontSize:Int;
		public var m_padding:Int;
		
		public var m_bubbleMessageObject:LevelMessageX;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_bubbleWidth = getArg (args, 0);
			m_bubbleHeight = getArg (args, 1);
			
			m_bubblePointX = 20;
			m_bubblePointY = -160;
			
			m_left = 0;
			m_right = 0;
			
			m_cornerRadius = 20;
			
			m_fontName = "Aller";
			m_fontSize = 20;
			m_padding = 8;
			
			if (args.length > 3) {
				m_bubblePointX = getArg (args, 2);
				m_bubblePointY = getArg (args, 3);
				m_left = getArg (args, 4);
				m_right = getArg (args, 5);
				m_cornerRadius = getArg (args, 6);
				m_padding = getArg (args, 7);
				m_fontName = getArg (args, 8);
				m_fontSize = getArg (args, 9);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			createSprites ();
			
			script = addEmptyTask ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}
				
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			if (false /* CONFIG::starling */) {
			}
			else
			{
				m_sprite = new MovieClip ();
				x_sprite = addSpriteAt (m_sprite, 0, 0);
				x_sprite.setDepth (getDepth ());
				
				var g:Graphics = m_sprite.graphics;
				
				var m:Matrix = new Matrix();
				m.createGradientBox (m_bubbleWidth, m_bubbleHeight, 90*Math.PI/180, 80, 80);
				g.clear();
				g.lineStyle (2, 0x888888, 1, true);
				g.beginGradientFill (GradientType.LINEAR, [0xe0e0e0, 0xffffff], [1,1], [1,0xff],m);
				SpeechBubble.drawSpeechBubble (m_sprite, new Rectangle (m_bubblePointX, m_bubblePointY, m_bubbleWidth, m_bubbleHeight), m_cornerRadius, new Point (0, 0), m_left, m_right);
				g.endFill();
			
				var self:Dynamic /* */ = this;
				
				addTask ([
					XTask.WAIT, 0x0100,
					
					function ():Void {
						m_bubbleMessageObject = cast xxx.getXLogicManager ().initXLogicObject (
							// parent
							self,
							// logicObject
							cast new LevelMessageX () /* as XLogicObject */,
							// item, layer, depth
							null, getLayer (), getDepth () + 100,
							// x, y, z
							m_bubblePointX + m_padding, m_bubblePointY + m_padding, 0,
							// scale, rotation
							1.0, 0
						) /* as LevelMessageX */;
						
						addXLogicObject (m_bubbleMessageObject);
					},
					
					XTask.RETN,
				]);
			}
			
			show ();
		}

		//------------------------------------------------------------------------------------------
		public function setMessage (__message:String):Void {
			if (false /* CONFIG::starling */) {
			}
			else
			{
				m_bubbleMessageObject.setMessage (
					//						__message:String,
					__message,
					//						__size:Number,
					m_fontSize,
					//						__color:Number,
					0x404040,
					//						__width:Number,
					m_bubbleWidth - 16,
					//						__height:Number,
					m_bubbleHeight - 16,
					//						__alignment:String,
					"left",
					//						__spacing:Number,
					0.0,
					//						__leading:Number,
					0,
					//						__fontName:String,
					m_fontName
				);		
			}
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }