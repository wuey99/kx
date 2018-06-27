//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "X-Engine"
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
package kx.text;

	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class XTextLogicObject extends XLogicObject {
		public var m_text:XTextSprite;
		public var x_text:XDepthSprite;
		
		public var script:XTask;
		public var gravity:XTask;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			gravity = addEmptyTask ();
			script = addEmptyTask ();
			
			gravity.gotoTask (getPhysicsTaskX (0.25));
			
			initScript ();
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
				
					function ():Void {
					}, 
				
				XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
		}

		//------------------------------------------------------------------------------------------
		public function initScript ():Void {
			Idle_Script ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setupText (
			__width:Float=32,
			__height:Float=32,
			__text:String="",
			__fontName:String="Aller",
			__fontSize:Int=12,
			__color:Int=0x000000,
			__bold:Bool=false
		):Void {
			
			if (x_text != null) {
				removeXTextSprite (m_text);
				
				__removeSprite (x_text);
			}
			
			m_text = createXTextSprite (
				// width
				__width,
				// height
				__height,
				// text
				__text,
				// font name
				__fontName,
				// font size
				__fontSize,
				// color
				__color,
				// bold
				__bold
			);
			
			x_text = __addSpriteAt (m_text, 0, 0);
			
			show ();			
		}

		//------------------------------------------------------------------------------------------
		private function __removeSprite (__sprite:XDepthSprite):Void {
			removeSprite (__sprite);
			
			removeSpriteFromHud (__sprite);
		}
		
		//------------------------------------------------------------------------------------------
		private function __addSpriteAt (__sprite:XTextSprite, __dx:Float=0, __dy:Float=0):XDepthSprite {
			return addSpriteAt (__sprite, __dx, __dy);	
		}
		
		//------------------------------------------------------------------------------------------
		public var text (get, set):XTextSprite;
		
		public function get_text ():XTextSprite {
			return m_text;
		}
		
		public function set_text (__val:XTextSprite): XTextSprite {
			return null;			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public function autoCalcSize ():Void {
			m_text.autoCalcSize ();
		}

		//------------------------------------------------------------------------------------------
		public function autoCalcWidth ():Void {
			m_text.autoCalcWidth ();
		}
		
		//------------------------------------------------------------------------------------------
		public function autoCalcHeight ():Void {
			m_text.autoCalcHeight ();
		}
		
		//------------------------------------------------------------------------------------------
		public function centerOnX (__x:Float, __width:Float):Void {	
			oX = __x + (__width - m_text.width)/2;
		}
		
		//------------------------------------------------------------------------------------------
		public function centerOnY (__y:Float, __height:Float):Void {
			oY = __y + (__height - m_text.height)/2;
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
		}
		
		//------------------------------------------------------------------------------------------
		public function getPhysicsTaskX (DECCEL:Float):Array<Dynamic> /* <Dynamic> */ {
			return [
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					updatePhysics,	
					XTask.GOTO, "loop",
				
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public function Idle_Script ():Void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
						
							function ():Void {
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