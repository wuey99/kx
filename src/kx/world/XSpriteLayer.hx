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
package kx.world;

	import kx.collections.*;
	import kx.type.*;
	import kx.world.sprite.*;
	
	// begin include "..\\flash.h";
	import openfl.display.*;
	// end include "..\\flash.h";
	
//------------------------------------------------------------------------------------------	
	class XSpriteLayer extends XSprite {
		private var m_XDepthSpriteMap:Map<XDepthSprite, Int>; // <XDepthSprite, Int>
		
		public var forceSort:Bool;
		
		public var list:Array<XDepthSprite>;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
			
			m_XDepthSpriteMap = new Map<XDepthSprite, Int> (); // <XDepthSprite, Int>
			
			list = new Array<XDepthSprite> (/* 2000 */);
			for (i in 0 ... 2000) {
				list.push (null);
			}
			
			forceSort = false;
		}

//------------------------------------------------------------------------------------------
		public override function setup ():Void {		
		 	super.setup ();
		}
				
//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
			
			while (numChildren > 0) {
				removeChildAt(0);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function addSprite (__sprite:DisplayObject, __depth:Float, __visible:Bool = false):XDepthSprite {
			var __depthSprite:XDepthSprite = cast xxx.getXDepthSpritePoolManager ().borrowObject (); /* as XDepthSprite */
			
			__depthSprite.setup ();
			__depthSprite.visible2 = true;
			__depthSprite.alpha = 1.0;
			__depthSprite.clear ();
			__depthSprite.addSprite (__sprite, __depth, this);
			__depthSprite.visible = __visible;
			__depthSprite.xxx = xxx;
			__depthSprite.scaleX = __depthSprite.scaleY = 1.0;
			
			addChild (__depthSprite);
				
			m_XDepthSpriteMap.set (__depthSprite, 0);
			
			return __depthSprite;
		}	

//------------------------------------------------------------------------------------------
		public function addDepthSprite (__depthSprite:XDepthSprite):XDepthSprite {	
			addChild (__depthSprite);
				
			m_XDepthSpriteMap.set (__depthSprite, 0);
			
			return __depthSprite;
		}
		
//------------------------------------------------------------------------------------------
		public function removeSprite (__depthSprite:XDepthSprite):Void {
			if (m_XDepthSpriteMap.exists (__depthSprite)) {
				__depthSprite.cleanup ();
				
				removeChild (__depthSprite);
				
				xxx.getXDepthSpritePoolManager ().returnObject (__depthSprite);
							
				m_XDepthSpriteMap.remove (__depthSprite);
			}
		}
	
//------------------------------------------------------------------------------------------
		public function moveSprite (__depthSprite:XDepthSprite):Void {
			if (m_XDepthSpriteMap.exists (__depthSprite)) {
				removeChild (__depthSprite);
				
				m_XDepthSpriteMap.remove (__depthSprite);
			}
		}
			
//------------------------------------------------------------------------------------------	
		public function depthSort ():Void {
			var length:Int = 0;
			
				XType.clearArray (list);
			
			for (__key__ in m_XDepthSpriteMap.keys ()) {
				function (sprite:Dynamic /* */):Void {
					list[length++] = sprite;
				} (__key__);
			}
		
				list.sort (
					function (a:XDepthSprite, b:XDepthSprite):Int {
						return Std.int (a.depth2 - b.depth2);
					}
				);				
			
			var i:Int;

			for (i in 0 ... length) {
				setChildIndex (list[i], i);
			}
		}
		
//------------------------------------------------------------------------------------------
// see: http://guihaire.com/code/?p=894
//------------------------------------------------------------------------------------------	
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
