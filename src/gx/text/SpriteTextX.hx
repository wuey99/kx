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
package gx.text;
	
	import gx.assets.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class SpriteTextX extends XLogicObject {
		public var m_bitmap:Array<XBitmap>; // <XBitmap>
		public var x_sprite:Array<XDepthSprite>; // <XDepthSprite>
		public var m_text:String;
		public var m_totalWidth:Float;
	
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic>  /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_text = getArg (args, 0);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
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
		public override function cleanup ():Void {
			super.cleanup ();
			
			var i:Int;
			
			for (i in 0 ... m_bitmap.length) {
				m_bitmap[i].cleanup ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			m_bitmap = new Array<XBitmap> (); // <XBitmap>
			x_sprite = new Array<XDepthSprite> (); // <XDepthSprite>

			XType.initArray (m_bitmap, m_text.length, null);
			XType.initArray (x_sprite, m_text.length, null);
			
			for (i in 0 ... m_text.length) {
				var __c:Int = m_text.charCodeAt (i) - 32;
				if (__c >= 64) __c -= 32;
				m_bitmap[i] = new XBitmap ();
				m_bitmap[i].setup ();
				m_bitmap[i].initWithClassName (xxx, null, getFontName ());
				x_sprite[i] = __addSpriteAt (m_bitmap[i], 0, 0);
				x_sprite[i].setDepth (getDepth ());
			}
			
			updateSprites ();
			
			show ();
		}

	//------------------------------------------------------------------------------------------
		public function updateSprites ():Void {
			var __x:Float = 0;
			
			for (i in 0 ... m_text.length) {
				var __c:Int = m_text.charCodeAt (i) - 32;
				if (__c >= 64) __c -= 32;
				m_bitmap[i].gotoAndStop (__c + 1);
				x_sprite[i].setRegistration (m_bitmap[i].dx + __x, m_bitmap[i].dy);
				__x -= (getWidths ()[__c] + 2);
			}
			
			m_totalWidth = -__x;
		}

	//------------------------------------------------------------------------------------------
		public function getTotalWidth ():Float {
			return m_totalWidth;
		}
		
	//------------------------------------------------------------------------------------------
		public function getFontName ():String {
			return "";
		}
		
	//------------------------------------------------------------------------------------------
		public function getWidths ():Array<Float> /* <Float> */ {
			return [];
		}
		
	//------------------------------------------------------------------------------------------
		public function setText (__text:String):Void {
			__removeSprites ();

			m_text = __text;
			
			createSprites ();
		}
		
	//------------------------------------------------------------------------------------------
		public function __removeSprites ():Void {
			removeAllWorldSprites ();
			removeAllHudSprites ();
			removeAllXLogicObjects ();
			
			var i:Int;
			
			for (i in 0 ... m_bitmap.length) {
				m_bitmap[i].cleanup ();
			}
		}
		
	//------------------------------------------------------------------------------------------
		private function __addSpriteAt (__sprite:XBitmap, __x:Float, __y:Float):XDepthSprite {
			return addSpriteAt (__sprite, __x, __y);
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }