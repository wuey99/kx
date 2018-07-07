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
package kx.resource.manager;
	
	import kx.collections.*;
	import kx.resource.*;
	import kx.task.*;
	import kx.type.*;
	import kx.xmap.*;
	import kx.XApp;
	import kx.xml.*;
	
	import openfl.display.*;
	import openfl.events.Event;
	import openfl.net.URLLoader;
	import openfl.net.URLRequest;
	import openfl.system.*;
	
//------------------------------------------------------------------------------------------
// XProjectManager
//
// manages the main project which can contain one more more sub-projects
//------------------------------------------------------------------------------------------	
	class XProjectManager {
		private var m_XApp:XApp;
		private var m_parent:Sprite;
		private var m_rootPath:String;
		private var m_projectName:String;
		private var m_loadComplete:Bool;
		private var m_projectXML:XSimpleXMLNode;
		private var m_loaderContextFactory:Dynamic /* Function */;
		private var m_subResourceManagers:Array<XSubResourceManager>; // <XSubResourceManager>
		private var m_completionCallback:Dynamic /* Function */;
		private var m_embeddedResources:Map<String, Class<Dynamic>>; // <String, Class<Dynamic>>
				
//------------------------------------------------------------------------------------------		
		public function new (__XApp:XApp) {
			// super ();

			m_XApp = __XApp;
			m_loadComplete = true;
			m_projectXML = null;
			m_embeddedResources = new Map<String, Class<Dynamic>> (); // <String, Class<Dynamic>>
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function kill ():Void {
			reset ();
		}
		
//------------------------------------------------------------------------------------------
		public function reset ():Void {
			var i:Int;
			
			for (i in 0 ... m_subResourceManagers.length) {
				m_subResourceManagers[i].kill ();
			}
			
			while (m_subResourceManagers.length > 0) {
				m_subResourceManagers.pop ();
			}
		}
				
//------------------------------------------------------------------------------------------
		public function setupFromURL (
			__parent:Sprite,
			__rootPath:String,
			__projectName:String,
			__completionCallback:Dynamic /* Function */,
			__loaderContextFactory:Dynamic /* Function */
			):Void {
				
			m_parent = __parent;
			m_subResourceManagers = new Array<XSubResourceManager> (); // <XSubResourceManager>
			setBothPaths (__rootPath, __projectName);
			m_loaderContextFactory = __loaderContextFactory;
			loadProjectFromURL (__rootPath, __projectName, __completionCallback);
		}

//------------------------------------------------------------------------------------------	
		public function setLoaderContextFactory (__loaderContextFactory:Dynamic /* Function */):Void {
			m_loaderContextFactory = __loaderContextFactory;
		}

//------------------------------------------------------------------------------------------	
		public function loaderContextFactory ():Dynamic /* Function */ {
			return m_loaderContextFactory;
		}
				
//------------------------------------------------------------------------------------------	
		public function loadProjectFromURL (
			__rootPath:String,
			__projectName:String,
			__completionCallback:Dynamic /* Function */):Bool {
										
//------------------------------------------------------------------------------------------					
     	   function __completeHandler(event:Event):Void {
				try {
	     	   		var __loader:URLLoader = cast event.target; /* as URLLoader */
     	   		  
     	   		  	var xml:XSimpleXMLNode = new XSimpleXMLNode (__loader.data);
     	   		  	m_projectXML = xml;
     	   		  	
					__importManifests ();
     	   		}
     	   		catch (e:Dynamic) {
     	   			throw (XType.createError ("Not a valid XML file"));
     	   		}
     	   		
				m_loadComplete = true;
			}
			
//------------------------------------------------------------------------------------------
			function __loadProjectFromURL (__url:String):URLLoader {
				var __loader:URLLoader = new URLLoader ();
				var __urlReq:URLRequest = new URLRequest (__url);
	
				__loader.load (__urlReq);
				
				return __loader;
			}
		
//------------------------------------------------------------------------------------------
			if (!m_loadComplete) {
				return false;
			}
			
			reset ();
			
			if (__projectName != null) {
				m_loadComplete = false;
				
				m_rootPath = __rootPath;
				
				var __loader:URLLoader = __loadProjectFromURL (m_rootPath + __projectName);
				__loader.addEventListener (Event.COMPLETE, __completeHandler);
			}
			
			m_completionCallback = __completionCallback;
			
			return true;
		}

//------------------------------------------------------------------------------------------	
		public function setBothPaths (__rootPath:String, __projectName:String):Void {
			m_rootPath = __rootPath;
			m_projectName = __projectName;
		}
		
//------------------------------------------------------------------------------------------
		public function setRootPath (__rootPath:String):Void {
			m_rootPath = __rootPath;
		}

//------------------------------------------------------------------------------------------
		public function getRootPath ():String {
			return m_rootPath;
		}
		
//------------------------------------------------------------------------------------------
		public function setupFromXML (
			__parent:Sprite,
			__rootPath:String,
			__xml:XSimpleXMLNode,
			__completionCallback:Dynamic /* Function */,
			__loaderContextFactory:Dynamic /* Function */
			):Void {
				
			m_parent = __parent;
			m_subResourceManagers = new Array<XSubResourceManager> (); // <XSubResourceManager>
			m_loaderContextFactory = __loaderContextFactory;
			loadProjectFromXML (__rootPath, __xml, __completionCallback);
		}
		
//------------------------------------------------------------------------------------------
		public function setupFromXMLString (
			__parent:Sprite,
			__rootPath:String,
			__xmlString:String,
			__completionCallback:Dynamic /* Function */,
			__loaderContextFactory:Dynamic /* Function */
		):Void {
			
			m_parent = __parent;
			m_subResourceManagers = new Array<XSubResourceManager> (); // <XSubResourceManager>
			m_loaderContextFactory = __loaderContextFactory;
			loadProjectFromXML (__rootPath, new XSimpleXMLNode (__xmlString), __completionCallback);
		}
		
//------------------------------------------------------------------------------------------
		public function loadProjectFromXML (
			__rootPath:String,
			__xml:XSimpleXMLNode,
			__completionCallback:Dynamic /* Function */):Bool {
				
			reset ();
			
			m_loadComplete = false;
			
			m_rootPath = __rootPath;	
			m_completionCallback = __completionCallback;
			m_projectXML = __xml;
			
			__importManifests ();
			
			m_loadComplete = true;
			
			return true;
		}
		
//------------------------------------------------------------------------------------------
		private function __importManifests ():Void {	
			var __xmlList:Array<XSimpleXMLNode> = m_projectXML.child ("manifest");
			
			var i:Int;
				
			for (i in 0 ... __xmlList.length) {
				var __subResourceManager:XSubResourceManager = new XSubResourceManager ();
				
				var __manifestList:Array<XSimpleXMLNode> = __xmlList[i].child ("*");
				var __manifest:XSimpleXMLNode = null;
				if (__manifestList.length > 0) {
					__manifest = __manifestList[0];	
				}
	
				if (__manifest == null) {
					__subResourceManager.setupFromURL (
						this,
						m_parent,
						getRootPath (),
						__xmlList[i].attribute ("name"),
						null,
						loaderContextFactory ()
						);
				}
				else
				{
					__subResourceManager.setupFromXML (
						this,
						m_parent,
						getRootPath (),
						__manifest,
						null,
						loaderContextFactory ()
						);				
				}
					
				addSubResourceManager (__subResourceManager);
			}
			
			m_XApp.getXTaskManager ().addTask ([		
					XTask.LABEL, "__wait",		
						XTask.FLAGS, function (__XTask:XTask):Void {
							__XTask.setFlagsBool (resourceManagerReady ());
						},
						
						XTask.WAIT, 0x0100,
						
						XTask.BNE, "__wait",
					
					function ():Void {
						if (m_completionCallback != null) {
							m_completionCallback ();
						}
					},
					
				XTask.RETN,
			]);
		}
		
//------------------------------------------------------------------------------------------
		public function addSubResourceManager (__subResourceManager:XSubResourceManager):Void {
			m_subResourceManagers.push (__subResourceManager);
		}

//------------------------------------------------------------------------------------------
		public function addEmbeddedResource (__resourcePath:String, __swfBytes:Class<Dynamic> /* <Dynamic> */):Void {
			m_embeddedResources.set (__resourcePath, __swfBytes);
		}

//------------------------------------------------------------------------------------------
		public function findEmbeddedResource (__resourcePath:String):Class<Dynamic> /* <Dynamic> */ {
			return cast m_embeddedResources.get (__resourcePath) /* as Class<Dynamic> */ /* <Dynamic> */;
		}
					
//------------------------------------------------------------------------------------------
		public function getProject ():XSimpleXMLNode {
			return m_projectXML;
		}
		
//------------------------------------------------------------------------------------------
		public function resourceManagerReady ():Bool {
			if (!m_loadComplete) {
				return false;
			}
			
			var i:Int;
			var r:XSubResourceManager;
			var c:Class<Dynamic>; // <Dynamic>
			
			for (i in 0 ... m_subResourceManagers.length) {
				r = m_subResourceManagers[i];
				
				if (!r.resourceManagerReady ()) {
					return false;
				}
			}
			
			return true;
		}

//------------------------------------------------------------------------------------------
		public function deleteManifest (__xml:XSimpleXMLNode):Void {
//			not implemented in HaXe
		}		
		
//------------------------------------------------------------------------------------------
		public function insertManifest (__xmlItem:XSimpleXMLNode, __xmlToInsert:XSimpleXMLNode):Void {			
			if (__xmlItem == null) {
				return;
			}
				
			if (__xmlItem.localName () == "resource") {
				__xmlItem.insertChildAfter (__xmlItem, __xmlToInsert);
			}
		}

//------------------------------------------------------------------------------------------
		public function resourceManagers ():Array<XSubResourceManager> /* <XSubResourceManager> */ {
			return m_subResourceManagers;
		}

//------------------------------------------------------------------------------------------
		public function getResourceManagerByName (__name:String):XSubResourceManager {
			for (i in 0 ... m_subResourceManagers.length) {
				if (m_subResourceManagers[i].getName () == __name) {
					return cast m_subResourceManagers[i] /* as XSubResourceManager */;
				}
			}

			return null;
		}
	
//------------------------------------------------------------------------------------------
// looks up Class based on the full class name
//------------------------------------------------------------------------------------------
		public function getClassByName (__className:String):Class<Dynamic> /* <Dynamic> */ {
			try {
				return __getClassByName (__className);
			}
			catch (e:Dynamic) {
				try {
					return __getClassByName ("ErrorImages:undefinedClass");
				}
				catch (e:Dynamic) {
					throw (e);
				}
			}
			
			return null;
		}
		
		private function __getClassByName (__className:String):Class<Dynamic> /* <Dynamic> */ {
			if (!resourceManagerReady ()) {
				return null;
			}
			
			if (__className == "XLogicObjectXMap:XLogicObjectXMap") {
				return XLogicObjectXMap;
			}
			
			var i:Int;
			var r:XSubResourceManager;
			var c:Class<Dynamic>; // <Dynamic>
			
			for (i in 0 ... m_subResourceManagers.length) {
				r = m_subResourceManagers[i];
				
				try {
					c = r.getClassByName (__className);
				}
				catch (e:Dynamic) {
					var error:String = "className not found in manifest";
					
					if (XType.errorMessage (e).substring (0, error.length) == error) {
						continue;
					}
					else
					{
						throw (e);
					}
				}
				
				return c;
			}
			
			throw (XType.createError ("className not found in any manifest: " + __className));
		}	

//------------------------------------------------------------------------------------------
// unloads a Class based on the full class name
//------------------------------------------------------------------------------------------
		public function unloadClassByName (__className:String):Bool {
			if (!resourceManagerReady ()) {
				return false;
			}
			
			var i:Int;
			var r:XSubResourceManager;
			var results:Bool;
			
			for (i in 0 ... m_subResourceManagers.length) {
				r = m_subResourceManagers[i];
				
				try {
					results = r.unloadClassByName (__className);
				}
				catch (e:Dynamic) {
					var error:String = "className not found in manifest";
					
					if (e.message.substring (0, error.length) == error) {
						continue;
					}
					else
					{
						throw (e);
					}
				}
				
				return results;
			}
			
			throw (XType.createError ("className not found in any manifest: " + __className));
		}
		
//------------------------------------------------------------------------------------------
		public function	cacheClassNames ():Bool {
			if (!resourceManagerReady ()) {
				return false;
			}
			
			var i:Int;
			var r:XSubResourceManager;
			
			for (i in 0 ... m_subResourceManagers.length) {
				r = m_subResourceManagers[i];
				
				trace (": resourceManager: ", r);
				
				r.cacheClassNames (r.getManifest ().child ("folder")[0].child ("*"));
			}
			
			return true;
		}	
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
// }