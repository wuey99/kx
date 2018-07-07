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
	import kx.world.sprite.XDepthSprite;
	
	import openfl.display.*;
	import openfl.events.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	// primarily used in TikiEdit
	//------------------------------------------------------------------------------------------
	class XMapItemCachedView extends XMapItemView {
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		// create sprite
		//------------------------------------------------------------------------------------------
		private override function __createSprites (__spriteClassName:String):Void {			
			m_sprite = XType.createInstance (xxx.getClass (__spriteClassName));
			m_sprite.cacheAsBitmap = true;	
// !STARLING!
			if (true /* CONFIG::flash */) {
				x_sprite = addSprite (m_sprite);
			}
			
			if (m_frame != 0) {
				gotoAndStop (m_frame);
			}
			else
			{
				gotoAndStop (1);
			}
		}

	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }