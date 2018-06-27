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
	
	import kx.type.*;
	import kx.xml.*;
	
//------------------------------------------------------------------------------------------	
	class XResourceName {
		private var m_className:String;
		private var m_resourceName:String;
		private var m_manifestName:String;
				
//------------------------------------------------------------------------------------------
// fullName examples:
//
// XLogicObject:XLogicObject  -  Resource Name, Class Name
// :XLogicObject:XLogicObject  -  Resource Name, Class Name
// Project:XLogicObject:XLogicObject  -   Manifest Name, Resource Name, Class Name
//------------------------------------------------------------------------------------------
		public function new (__fullName:String) {
			// super ();
			
			var s:Array<String> /* <String> */ = __fullName.split (":");
			
			if (s.length == 1) {
				m_manifestName = "";
				m_resourceName = s[0];
				m_className = "";
			
				if (m_resourceName.charAt (0) != "$") {
					throw (XType.createError ("className not valid: " + __fullName));					
				}
			}
			else if (s.length == 2) {
				m_manifestName = "";
				m_resourceName = s[0];
				m_className = s[1];
			}
			else if (s.length == 3) {
				m_manifestName = s[0];
				m_resourceName = s[1];
				m_className = s[2];
			}
			else
			{
				throw (XType.createError ("className not valid: " + __fullName));				
			}
		}
		
//------------------------------------------------------------------------------------------
		public var manifestName (get, set):String;
		
		public function get_manifestName ():String {
			return m_manifestName;
		}
		
		public function set_manifestName (__val:String): String {
			return "";			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public var resourceName (get, set):String;
		
		public function get_resourceName ():String {
			return m_resourceName;
		}
		
		public function set_resourceName (__val:String): String {
			return "";			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public var className (get, set):String;
		
		public function get_className ():String {
			return m_className;
		}
		
		public function set_className (__val:String): String {
			return "";			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
// }