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
package kx.display;
	
	//------------------------------------------------------------------------------------------	
	class DisplayObjectContainer5 {
		public var parent:DisplayObjectContainer5;
		
		public var m_children:Array<DisplayObjectContainer5>; // <DisplayObjectContainer5>
		
		//------------------------------------------------------------------------------------------
		public function new () {
			m_children = new Array<DisplayObjectContainer5> (); // <DisplayObjectContainer5>
		}
	
		//------------------------------------------------------------------------------------------	
		public function setup ():Void {
		}
		
		//------------------------------------------------------------------------------------------	
		public function cleanup ():Void {
		}
		
		//------------------------------------------------------------------------------------------	
		public function addChild (__child:DisplayObjectContainer5):DisplayObjectContainer5 {
			if (__child.parent != null) {
				__child.parent.removeChild (__child);
			}
			
			__child.parent = this;
			
			m_children.push (__child);
			
			return __child;
		}
		
		//------------------------------------------------------------------------------------------		
		public function addChildAt (__child:DisplayObjectContainer5, __index:Int):DisplayObjectContainer5 {
			if (__child.parent != null) {
				__child.parent.removeChild (__child);
			}
			
			__child.parent = this;
			
			m_children.splice (__index, 0, __child);
			
			return __child;
		}
		
		//------------------------------------------------------------------------------------------
		public function contains (__child:DisplayObjectContainer5):Bool {
			return false;
		}
		
		//------------------------------------------------------------------------------------------	
		public function getChildAt (__index:Int):DisplayObjectContainer5 {
			if (__index >= 0 && __index < m_children.length) {
				return m_children[__index];
			}
			else
			{
				return null;
			}
		}
		
		//------------------------------------------------------------------------------------------	
		public function getChildIndex (__child:DisplayObjectContainer5):Int {
			return m_children.indexOf (__child);
		}
		
		//------------------------------------------------------------------------------------------	
		public function removeChild (__child:DisplayObjectContainer5):DisplayObjectContainer5 {
			return removeChildAt (m_children.indexOf (__child));
		}
		
		//------------------------------------------------------------------------------------------	
		public function removeChildAt (__index:Int):DisplayObjectContainer5 {
			if (__index < 0 || __index >= m_children.length) {
				return null;
			}
			else
			{
				var __child:DisplayObjectContainer5 = m_children[__index];
				
				__child.cleanup ();
				
				__child.parent = null;
				
				m_children.splice (__index, 1);
			}
		}
		
		//------------------------------------------------------------------------------------------	
		public function setChildIndex (__child:DisplayObjectContainer5, __dstIndex:Int):Void {
			var __srcIndex:Int = m_children.indexOf (__child);
			
			if (__srcIndex == -1) {
				return;
			}
			
			m_children.splice (__srcIndex, 1);
			
			if (__srcIndex < __dstIndex) {
				__dstIndex--;
			}
			
			m_children.splice (__dstIndex, 0, __child);
		}
		
		//------------------------------------------------------------------------------------------	
		public var numChildren (get, set):Int;
		
		public function get_numChildren ():Int {
			return m_children.length;
		}
		
		public function set_numChildren (__val:Int): Int {
			
			return 0;			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------	
		public var mouseChildren (get, set):Bool;
		
		public function get_mouseChildren ():Bool {
			return false;
		}
		
		public function set_mouseChildren (__val:Bool): Bool {
			
			return false;			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public var mouseEnabled (get, set):Bool;
		
		public function get_mouseEnabled ():Bool {
			return false;
		}
	
		public function set_mouseEnabled (__val:Bool): Bool {
	
			return false;			
		}
		/* @:end */
	
	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------
// }