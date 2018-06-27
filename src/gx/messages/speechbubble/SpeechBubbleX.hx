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
	
	import gx.messages.level.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	
	import openfl.display.*;
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class SpeechBubbleX extends XLogicObjectCX {
		public var m_sprite:MovieClip;
		public var x_sprite:XDepthSprite;
		
		public var script:XTask;
		
		public var m_bubbleWidth:Float;
		public var m_bubbleHeight:Float;
		
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
				SpeechBubble.drawSpeechBubble (m_sprite, new Rectangle (20, -160, m_bubbleWidth, m_bubbleHeight), 20, new Point (0, 0));
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
							20 + 8, -160 + 8, 0,
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
					20,
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
					"Aller"
				);		
			}
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }