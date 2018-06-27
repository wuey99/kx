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
package gx.util ;
	
	import kx.*;
	import kx.task.*;
	import kx.text.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	
	import openfl.display.Stage;

//------------------------------------------------------------------------------------------
	class FrameRateAdjust extends XTextLogicObject {
		public var m_stage:Stage;
		public var m_frameSamples:Array<Float>; // <Float>
		public var m_maxSamples:Int;
		public var m_adjustedFrameRate:Float;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic>  /* <Dynamic> */):Void {
			super.setup (__xxx, args);
		}
		
//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			m_stage = stage;
			
			m_maxSamples = 16;
			
			m_frameSamples = new Array<Float> (); // <Float>
			XType.initArray (m_frameSamples, m_maxSamples, 0.0);
			
			for (i in 0 ... m_maxSamples) {
				m_frameSamples.push (xxx.getIdealFPS ());
			}
			
			m_adjustedFrameRate = xxx.getIdealFPS ();
			
			super.setupX ();
									
			oX = 96;
			oY = 8;
			
			return;
			
			xxx.addTimer1000Listener (
				function ():Void {
					setupText (
						// width
						700,
						// height
						32,
						// text
						"Target FPS: " + m_adjustedFrameRate + ", FPS: " + xxx.getFPS (),
						// font name
						"Aller",
						// font size
						16,
						// color
						0xe0e0e0,
						// bold
						true
					);
				}
			);
		}

//------------------------------------------------------------------------------------------
		private override function __removeSprite (__sprite:XDepthSprite):Void {
			removeSpriteFromHud (__sprite);
		}
		
//------------------------------------------------------------------------------------------
		private override function __addSpriteAt (__sprite:XTextSprite, __dx:Float=0, __dy:Float=0):XDepthSprite {
			return addSpriteToHudAt (__sprite, __dx, __dy);	
		}
		
//------------------------------------------------------------------------------------------
		public override function Idle_Script ():Void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0800,
							
							function ():Void {
								m_frameSamples.shift (); m_frameSamples.push (xxx.getFPS ());

								var __averageFrameRate:Float = 0;
								
								for (i in 0 ... m_maxSamples) {
									__averageFrameRate += m_frameSamples[i];	
								}
								
								m_adjustedFrameRate = Math.floor (Math.min (xxx.getIdealFPS (), __averageFrameRate / m_maxSamples + 3));
							},
							
							XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
					
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x1000,
							
							function ():Void {
								m_stage.frameRate = m_adjustedFrameRate;
							},
							
							XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
				},
				
				//------------------------------------------------------------------------------------------
				// animation
				//------------------------------------------------------------------------------------------	
				XTask.LABEL, "loop",	
					XTask.WAIT, 0x0100,	
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
		//------------------------------------------------------------------------------------------
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
// }
