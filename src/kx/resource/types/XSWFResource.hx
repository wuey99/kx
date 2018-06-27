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
package kx.resource.types;

	import openfl.display.*;
	import openfl.events.*;
	import openfl.net.URLLoader;
	import openfl.net.URLLoaderDataFormat;
	import openfl.net.URLRequest;
	import openfl.system.*;
	import openfl.utils.*;
	
	import kx.resource.*;
	import kx.resource.manager.*;
	import kx.type.*;
	import kx.xml.*;
	
//------------------------------------------------------------------------------------------		
	class XSWFResource extends XResource {
		private var m_loader:Loader = null;
		private var m_loadComplete:Bool;
		private var m_parent:Sprite;
		private var m_resourceManager:XSubResourceManager;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
	
//------------------------------------------------------------------------------------------	
		public function resourceManager ():XSubResourceManager {
			return m_resourceManager;
		}	
		
//------------------------------------------------------------------------------------------
		public override function kill ():Void {
			trace (": XResource: kill: ");
			
			m_parent.removeChild (m_loader);
			m_loader.unloadAndStop ();
			m_loader = null;
			m_loadComplete = false;
		}

//------------------------------------------------------------------------------------------
		public function getDefinition (__className:String):Class<Dynamic> /* <Dynamic> */ {
			return null;
		}
		
//------------------------------------------------------------------------------------------
		private function __getClassByName (__className:String, __resourceName:String=""):Class<Dynamic> /* <Dynamic> */ {
			var c:Class<Dynamic>; // <Dynamic>
			
			try {
				c = cast getDefinition (__className);
				
//				trace (": oooooooo: ", getQualifiedClassName (c));
			}
			catch (e:Dynamic) {
// how should we handle this error?
				throw (XType.createError ("unable to resolve: " + __className + " in " + __resourceName + ", error: " + e));
			}	
			
			return c;
		}
		
//------------------------------------------------------------------------------------------
		public override function getClassByName (__fullName:String):Class<Dynamic> /* <Dynamic> */ {
			if (m_loader == null) {
				loadResource ();
			}
			
			if (!m_loadComplete) {
				return null;
			}
			
			var r:XResourceName = new XResourceName (__fullName);
			
			var __resourceName:String = r.resourceName;
			var __className:String = r.className;
			
			var c:Class<Dynamic> /* <Dynamic> */ = __getClassByName (__className, __resourceName);	
			
			return c;
		}
		
//------------------------------------------------------------------------------------------
		public override function getAllClasses ():Array<Class<Dynamic>> /* <Class<Dynamic>> */ {
			if (m_loader == null) {
				loadResource ();
			}
			
			if (!m_loadComplete) {
				return null;
			}
			
			var i:Int;
			var __classNames:Array<String> /* <String> */ = getAllClassNames ();
			var __classes:Array<Class<Dynamic>>  /* <Class<Dynamic>> */ = new Array<Class<Dynamic>>  (); // <Class<Dynamic>> 
			
			for (i in 0 ... __classNames.length) {
				var c:Class<Dynamic>; // <Dynamic>
				
				c = __getClassByName (__classNames[i]);
				
				__classes.push (c);			
			}
			
			return __classes;
		}
				
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }