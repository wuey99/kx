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
package kx.resource;

	import kx.resource.manager.*;
	import kx.xml.*;
	
	import openfl.display.*;
	import openfl.events.*;
	import openfl.system.*;
	
//------------------------------------------------------------------------------------------	
	class XResource {
		private var m_resourcePath:String;
		private var m_resourceXML:XSimpleXMLNode;
		private var m_count:Int;

//------------------------------------------------------------------------------------------
		public function new () {
			m_count = 0;
		}
		
//------------------------------------------------------------------------------------------
		public function setup (
			__resourcePath:String, __resourceXML:XSimpleXMLNode,
			__parent:Sprite,
			__resourceManager:XSubResourceManager
			):Void {
		}
			
//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}
		
//------------------------------------------------------------------------------------------		
		public function loadResource ():Void {		
		}
		
//------------------------------------------------------------------------------------------
		public function kill ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public var count (get, set):Int;
		
		public function get_count ():Int {
			return m_count;
		}
		
		public function set_count (__val:Int): Int {
			m_count = __val;
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function getResourcePath ():String {
			return m_resourcePath;
		}

//------------------------------------------------------------------------------------------
		public function getResourceXML ():XSimpleXMLNode {
			return m_resourceXML;
		}

//------------------------------------------------------------------------------------------
		public function getAllClassNames ():Array<String> /* <String> */ {
			var __xmlList:Array<XSimpleXMLNode> = m_resourceXML.child ("*");
			var i:Int;
			var __classNames:Array<String>  /* <String> */ = new Array<String>  (); // <String> 
						
			for (i in 0 ... __xmlList.length) {
				__classNames.push (__xmlList[i].attribute ("name"));	
			}
			
			return __classNames;
		}
		
//------------------------------------------------------------------------------------------
		public function getClassByName (__className:String):Class<Dynamic> /* <Dynamic> */ {
			return null;
		}
		
//------------------------------------------------------------------------------------------
		public function getAllClasses ():Array<Class<Dynamic>> /* <Class<Dynamic>> */ {
			return null;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }