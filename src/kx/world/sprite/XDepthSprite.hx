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
package kx.world.sprite;

	import kx.world.*;

	// begin include "..\\..\\flash.h";
	import openfl.display.*;
	// end include "..\\..\\flash.h";
	import openfl.geom.*;
	import openfl.utils.*;
	
//------------------------------------------------------------------------------------------	
	class XDepthSprite extends XSprite {
		public var m_depth:Float;
		public var m_depth2:Float;
		public var m_relativeDepthFlag:Bool;
		public var m_sprite:DisplayObject;
		public var x_layer:XSpriteLayer;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
			
			clear ();
		}

//------------------------------------------------------------------------------------------
		public function clear ():Void {
			while (numChildren > 0) {
				removeChildAt (0);
			}
		}
			
//------------------------------------------------------------------------------------------
		public function addSprite (
			__sprite:DisplayObject,
			__depth:Float,
			__layer:XSpriteLayer,
			__relative:Bool = false
			):Void {
				
			m_sprite = __sprite;
			x_layer = __layer;
			setDepth (__depth);
// !!!
			childList.addChild (__sprite);
			visible = false;
			relativeDepthFlag = __relative;
		}

//------------------------------------------------------------------------------------------
		public function replaceSprite (__sprite:DisplayObject):Void {
			clear ();
			
			m_sprite = __sprite;
			
			childList.addChild (__sprite);
			
			visible = true;
		}
		
//------------------------------------------------------------------------------------------
		/* @:override get, set visible Bool */
		
		public override function get_visible ():Bool {
			return super.visible;
		}
		
		public override function set_visible (__visible:Bool): Bool {
			super.visible = __visible;
			
			m_sprite.visible = __visible;
			
			return __visible;
			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------	
		public function setDepth (__depth:Float):Void {
			m_depth = __depth;
			depth2 = __depth;
		}		
		
//------------------------------------------------------------------------------------------	
		public function getDepth ():Float {
			return m_depth;
		}
		
//------------------------------------------------------------------------------------------
		public var depth (get, set):Float;
		
		public function get_depth ():Float {
			return m_depth;
		}
	
		public function set_depth (__depth:Float): Float {
			m_depth = __depth;
			depth2 = __depth;
			
			return __depth;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public function getRelativeDepthFlag ():Bool {
			return m_relativeDepthFlag;
		}
		
//------------------------------------------------------------------------------------------
		public function setRelativeDepthFlag (__relative:Bool):Void {
			m_relativeDepthFlag = __relative;
		}

//------------------------------------------------------------------------------------------
		public var relativeDepthFlag (get, set):Bool;
		
		public function get_relativeDepthFlag ():Bool {
			return m_relativeDepthFlag;
		}
		
		public function set_relativeDepthFlag (__relative:Bool): Bool {
			m_relativeDepthFlag = __relative;
			
			return __relative;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var depth2 (get, set):Float;
		
		public function get_depth2 ():Float {
			return m_depth2;
		}
		
		public function set_depth2 (__depth:Float): Float {
			if (__depth != m_depth2) {
				m_depth2 = __depth;
				x_layer.forceSort = true;
			}
			
			return m_depth2;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
