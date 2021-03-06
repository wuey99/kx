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
package kx.xmap;

// X classes
	import kx.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	
	import openfl.display.*;
	import openfl.events.*;
	import openfl.text.*;
	import openfl.utils.*;

//------------------------------------------------------------------------------------------
	class XMapItemView extends XLogicObject {
		private var m_sprite:XMovieClip;
		private var x_sprite:XDepthSprite;
		private var m_frame:Int;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_frame = args[1];
			
			__createSprites (args[0]);
		}

//------------------------------------------------------------------------------------------
// create sprite
//------------------------------------------------------------------------------------------
		private function __createSprites (__spriteClassName:String):Void {
			m_sprite = createXMovieClip (__spriteClassName);
			x_sprite = addSprite (m_sprite);
			
			if (m_frame != 0) {
				gotoAndStop (m_frame);
			}
			else
			{
				gotoAndStop (1);
			}
		}

//------------------------------------------------------------------------------------------
		public function getTotalFrames ():Int {
			return m_sprite.getTotalFrames ();	
		}	
		
//------------------------------------------------------------------------------------------
		public override function gotoAndPlay (__frame:Int):Void {
			m_sprite.gotoAndStop (__frame);
		}
		
//------------------------------------------------------------------------------------------
		public override function gotoAndStop (__frame:Int):Void {
			m_sprite.gotoAndStop (__frame);
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
