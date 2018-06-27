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
	import kx.resource.types.*;
	import kx.type.*;
	import kx.xml.*;
	
	import openfl.display.*;
	import openfl.events.Event;
	import openfl.net.URLLoader;
	import openfl.net.URLRequest;
	import openfl.system.*;
	
	//------------------------------------------------------------------------------------------
	// XSubResourceManager
	//
	// A resource manager for external swf's.  On initialization, the resource manager is
	// provided with a Manifest, which is an XML file which maps a human-readable resource name
	// with a URL.  It's possible than in the future the resource look-up could be done server-side.
	//
	// Given a "resource name", the resource manager will attempt to locate the resource in memory
	// if it's not found in memory, it'll attempt to load it.  Currently, there's no provision
	// to unload resources.  In the future, we'll attempt to implement a system to better manage
	// in-memory resources. Some things under consideration:  An LRU system will discard selodmly
	// used assets.
	//------------------------------------------------------------------------------------------	
	class XSubResourceManager extends IResourceManager {
		private var m_manifestXML:XSimpleXMLNode;
		private var m_projectManager:XProjectManager;
		private var m_resourceMap:Map<String, XResource>; // <String, XResource>
		private var m_classMap:Map<String, XClass>; // <String, XClass>
		private var m_parent:Sprite;
		private var m_rootPath:String;
		private var m_manifestName:String;
		private var m_loadComplete:Bool;
		private var m_loaderContextFactory:Dynamic /* Function */;
		private var m_cachedClassName:Map<String, XSimpleXMLNode>; // <String, XSimpleXMLNode>
		
		public static var CLASS_TYPE:String = "classX";
		public static var RESOURCE_TYPE:String = "resource";
		public static var FOLDER_TYPE:String = "folder";
		
		//------------------------------------------------------------------------------------------		
		public function new () {
			super ();
			
			m_resourceMap = new Map<String, XResource> (); // <String, XResource>
			m_classMap = new Map<String, XClass> (); // <String, XClass>
			m_cachedClassName = new Map<String, XSimpleXMLNode> (); // <String, XSimpleXMLNode>
			
			m_loaderContextFactory = null;
			
			m_loadComplete = true;
			m_manifestXML = null;
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
			
			// unload .swf's here?
			m_resourceMap = new Map<String, XResource> (); //  <String, XResource>
			m_classMap = new Map<String, XClass> (); //  <String, XClass>
		}
		
		//------------------------------------------------------------------------------------------
		public function setupFromURL (
			__projectManager:XProjectManager,
			__parent:Sprite,
			__rootPath:String,
			__manifestName:String,
			__completionCallback:Dynamic /* Function */,
			__loaderContextFactory:Dynamic /* Function */
		):Void {
			
			m_projectManager = __projectManager;
			m_parent = __parent;
			setBothPaths (__rootPath, __manifestName);
			m_loaderContextFactory = __loaderContextFactory;
			
			loadManifestFromURL (__rootPath, __manifestName, __completionCallback);
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
		public function loadManifestFromURL (
			__rootPath:String,
			__manifestName:String,
			__completionCallback:Dynamic /* Function */):Bool {
				
			//-----------------------------------------------------------------------------------------
			var __loader:URLLoader;
			
			//------------------------------------------------------------------------------------------					
			function __completeHandler(event:Event):Void {
				try {
					var __loader:URLLoader = cast event.target; /* as URLLoader */
					
					var __xml:XSimpleXMLNode = new XSimpleXMLNode (__loader.data);
					
					setManifest (__xml);
				}
				catch (e:Dynamic) {
					throw (XType.createError ("Not a valid XML file"));
				}
				
				m_loadComplete = true;
			}
			
			//------------------------------------------------------------------------------------------
			function __loadManifestFromURL (__url:String):URLLoader {
				var __loader:URLLoader = new URLLoader ();
				var __urlReq:URLRequest = new URLRequest (__url);
				
				__loader.load (__urlReq);
				
				return __loader;
			}

			//------------------------------------------------------------------------------------------
			if (!m_loadComplete) {
				return false;
			}
			
			if (__manifestName != null) {
				m_loadComplete = false;
				
				m_rootPath = __rootPath;
				
				__loader = __loadManifestFromURL (m_rootPath + __manifestName);
				__loader.addEventListener (Event.COMPLETE, __completeHandler);
			}
			
			if (__completionCallback != null) {
				__loader.addEventListener (Event.COMPLETE, __completionCallback);
			}
			
			return true;
		}
		
		//------------------------------------------------------------------------------------------
		public function setupFromXML (
			__projectManager:XProjectManager,
			__parent:Sprite,
			__rootPath:String,
			__xml:XSimpleXMLNode,
			__completionCallback:Dynamic /* Function */,
			__loaderContextFactory:Dynamic /* Function */
		):Void {
			
			m_projectManager = __projectManager;
			m_parent = __parent;
			setBothPaths (__rootPath, "");
			m_loaderContextFactory = __loaderContextFactory;
			
			loadManifestFromXML (__rootPath, __xml, __completionCallback);
		}
		
		//------------------------------------------------------------------------------------------
		public function loadManifestFromXML (
			__rootPath:String,
			__xml:XSimpleXMLNode,
			__completionCallback:Dynamic /* Function */):Bool {
			
			m_loadComplete = false;
			
			m_rootPath = __rootPath;
			
			setManifest (__xml);
			
			if (__completionCallback != null) {
				__completionCallback ();
			}
			
			m_loadComplete = true;
			
			return true;		
		}
		
		//------------------------------------------------------------------------------------------
		public function findEmbeddedResource (__resourcePath:String):Class<Dynamic> /* <Dynamic> */ {
			return m_projectManager.findEmbeddedResource (__resourcePath);
		}
		
		//------------------------------------------------------------------------------------------
		public function setManifest (__xml:XSimpleXMLNode):Void {
			m_manifestXML = __xml;
		}
		
		//------------------------------------------------------------------------------------------	
		public function setBothPaths (__rootPath:String, __manifestName:String):Void {	
			m_rootPath = __rootPath;
			m_manifestName = __manifestName;
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
		public function getManifestName ():String {
			return m_manifestName;
		}
		
		//------------------------------------------------------------------------------------------
		public function getName ():String {
			return getManifestName ().substr(0, getManifestName ().lastIndexOf('.'));
		}
		
		//------------------------------------------------------------------------------------------
		public function getManifest ():XSimpleXMLNode {
			return m_manifestXML;
		}
		
		//------------------------------------------------------------------------------------------
		public function resourceManagerReady ():Bool {
			return m_loadComplete;
		}
		
		//------------------------------------------------------------------------------------------
		public override function deleteResourceXML (__xml:XSimpleXMLNode):Void {
//			not implemented in HaXe
		}		
		
		//------------------------------------------------------------------------------------------
		public override function insertResourceXML (__xmlItem:XSimpleXMLNode, __xmlToInsert:XSimpleXMLNode):Void {			
			if (__xmlItem == null) {
				return;
			}
			
			if (__xmlItem.localName () == XSubResourceManager.CLASS_TYPE) {
				__xmlItem.parent ().insertChildAfter (__xmlItem.parent (), __xmlToInsert);
			}
			
			if (__xmlItem.localName () == XSubResourceManager.RESOURCE_TYPE) {
				__xmlItem.parent ().insertChildAfter (__xmlItem, __xmlToInsert);
			}
			
			if (__xmlItem.localName () == XSubResourceManager.FOLDER_TYPE) {
				__xmlItem.appendChild (__xmlToInsert);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function findResourceXMLFromName (__resourceName:String):XSimpleXMLNode {	
			return findNodeFromResourceName (
				null,
				__resourceName,
				m_manifestXML.child ("folder")[0].child ("*")
			);
		}
		
		//------------------------------------------------------------------------------------------
		public function findResourceFromName (__resourceName:String):XResource {
			var __resourceXML:XSimpleXMLNode = findResourceXMLFromName (__resourceName);
			
			return __getXResourceFromPath (
				__resourceXML.attribute ("path") + "\\" +__resourceXML.attribute ("dst"),
				__resourceXML
			);
		}
		
		//------------------------------------------------------------------------------------------
		// looks up Class based on the full class name
		//------------------------------------------------------------------------------------------
		public override function getClassByName (__className:String):Class<Dynamic> /* <Dynamic> */ {
			if (!m_loadComplete) {
				return null;
			}
			
			trace (": XResourceManager:getClass (): ", __className);
			
			var __XClass:XClass = __resolveXClass (__className);
			
			var __class:Class<Dynamic> /* <Dynamic> */ = __XClass.getClass ();
			
			if (__class == null) {
				__class = __resolveClass (__XClass);
			}
			
			if (__class != null) {
				__XClass.count++;
				
				var __r:XResource = cast m_resourceMap.get (__XClass.getResourcePath ()); /* as XResource */
				__r.count++;
				
				trace (": getClassByName: loaded: ", __XClass.count, __r.count, __class);
			}
			
			return __class;
		}
		
		//------------------------------------------------------------------------------------------
		// unloads a class by name.  returns false if the resource hasn't been loaded yet. 
		// returns true if when the resource is successfully unloaded.
		//------------------------------------------------------------------------------------------
		public function unloadClassByName (__className:String):Bool {
			return false;
			
			if (!m_loadComplete) {
				return false;
			}
			
			var __XClass:XClass = __resolveXClass (__className);
			
			var __class:Class<Dynamic> /* <Dynamic> */ = __XClass.getClass ();
			
			if (__class == null) {
				__class = __resolveClass (__XClass);
				
				if (__class == null) {
					return false;
				}
			}
			
			__XClass.count--;
			
			var __r:XResource = cast m_resourceMap.get (__XClass.getResourcePath ()); /* as XResource */
			__r.count--;
			
			trace (": unloadClassName: ", __className, __XClass.count, __r.count);
			
			if (__XClass.count == 0) {
				m_classMap.remove (__className);
			}
			
			if (__r.count == 0) {
				__r.kill ();
				
				m_resourceMap.remove (__XClass.getResourcePath ());
			}
			
			return true;
		}
		
		//------------------------------------------------------------------------------------------
		// eventually replace:
		//
		// findNodeFromSrcName
		// findNodeFromResourceName
		// findNodeFromClassName
		//------------------------------------------------------------------------------------------
		public function iterateAllNodes (
			__match:XSimpleXMLNode,
			__xmlList:Array<XSimpleXMLNode>,
			__completionCallback:Dynamic /* Function */
		):XSimpleXMLNode {
			
			var i:Int;
			
			for (i in 0 ... __xmlList.length) {
				if (__xmlList[i].localName () == "folder") {
					var nuMatch:XSimpleXMLNode = iterateAllNodes (
						__match,
						__xmlList[i].child ("*"),
						__completionCallback
					);
					
					if (nuMatch != null) {
						__match = nuMatch;
					}
				}
				else
				{	
					var __results:Array<Dynamic> /* <Dynamic> */ = __completionCallback (__xmlList[i]);
					
					if (__results[0]) {
						__match = __results[1];
					}
				}
			}
			
			return __match;			
		}
		
		//------------------------------------------------------------------------------------------
		public function findNodeFromSrcName (
			__match:XSimpleXMLNode,
			__srcName:String,
			__xmlList:Array<XSimpleXMLNode>
		):XSimpleXMLNode {
			
			var i:Int, j:Int;
			
			for (i in 0 ... __xmlList.length) {
				if (__xmlList[i].localName () == "folder") {
					var nuMatch:XSimpleXMLNode = findNodeFromSrcName (
						__match,
						__srcName,
						__xmlList[i].child ("*")
					);
					
					if (nuMatch != null) {
						__match = nuMatch;
					}
				}
				else
				{				
					if (__srcName == __xmlList[i].attribute ("src")) {	
						__match = __xmlList[i];
					}
				}
			}
			
			return __match;
		}
		
		//------------------------------------------------------------------------------------------
		public function findNodeFromResourceName (
			__match:XSimpleXMLNode,
			__resourceName:String,
			__xmlList:Array<XSimpleXMLNode>
		):XSimpleXMLNode {
			
			var i:Int, j:Int;
			
			for (i in 0 ... __xmlList.length) {
				if (__xmlList[i].localName () == "folder") {
					var nuMatch:XSimpleXMLNode = findNodeFromResourceName (
						__match,
						__resourceName,
						__xmlList[i].child ("*")
					);
					
					if (nuMatch != null) {
						__match = nuMatch;
					}
				}
				else
				{
					if (__resourceName == __xmlList[i].attribute ("name")) {
						__match = __xmlList[i];
					}
				}
			}
			
			return __match;
		}
		
		//------------------------------------------------------------------------------------------
		public function findNodeFromXML (
			__match:XSimpleXMLNode,
			__xml:XSimpleXMLNode,
			__xmlList:Array<XSimpleXMLNode>
		):XSimpleXMLNode {
			
			var i:Int, j:Int;
			
			for (i in 0 ... __xmlList.length) {
				if (__xml == __xmlList[i]) {
					__match = __xmlList[i];
				}
				else if (__xmlList[i].localName () == "folder") {
					var nuMatch:XSimpleXMLNode = findNodeFromXML (
						__match,
						__xml,
						__xmlList[i].child ("*")
					);
					
					if (nuMatch != null) {
						__match = nuMatch;
					}
				}
			}
			
			return __match;
		}
		
		//------------------------------------------------------------------------------------------
		// look for an e4x-centric way of finding a "classX" name
		// my intuition tells me that this method can be achieved via e4x
		//------------------------------------------------------------------------------------------
		public function findNodeFromClassName (
			__match:XSimpleXMLNode,
			__resourceName:String,
			__className:String,
			__xmlList:Array<XSimpleXMLNode>
		):XSimpleXMLNode {
			
			if (m_cachedClassName.exists (__className)) {			
				return m_cachedClassName.get (__className) /* as XML */;
			}
			
			var i:Int, j:Int;
			
			for (i in 0 ... __xmlList.length) {
				if (__xmlList[i].localName () == "folder") {
					var nuMatch:XSimpleXMLNode = findNodeFromClassName (
						__match,
						__resourceName,
						__className,
						__xmlList[i].child ("*")
					);
					
					if (nuMatch != null) {
						__match = nuMatch;
					}
				}
				else
				{
					if (__resourceName == __xmlList[i].attribute ("name")) {
						var __classList:Array<XSimpleXMLNode> = __xmlList[i].child ("classX");
						
						for (j in 0 ... __classList.length) {
							if (!m_cachedClassName.exists (__classList[j].attribute ("name"))) {
								m_cachedClassName.set (__classList[j].attribute ("name"), __xmlList[i]);
							}
							
							if (__classList[j].attribute ("name") == __className) {
								__match = __xmlList[i];
							}
						}	
					}
				}
			}
			
			return __match;
		}
		
		//------------------------------------------------------------------------------------------
		public function cacheClassNames (__xmlList:Array<XSimpleXMLNode>):Void {
			var i:Int, j:Int;
			
			for (i in 0 ... __xmlList.length) {
//				trace (": caching: ", __xmlList[i].localName ());
				
				if (__xmlList[i].localName () == "folder") {
					cacheClassNames (__xmlList[i].child ("*"));
				}
				else
				{
					var __classList:Array<XSimpleXMLNode> = __xmlList[i].child ("classX");
					
					for (j in 0 ... __classList.length) {
						m_cachedClassName.set (__classList[j].getAttributeString ("name"), __xmlList[i]);
					}	
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function __lookUpResourcePathByClassName (__fullName:String):Array<Dynamic> /* <Dynamic> */ {
			if (m_manifestXML == null) {
				throw (XType.createError ("manifest hasn't been loaded yet"));
			}
			
			var r:XResourceName = new XResourceName (__fullName);
			
			var __manifestName:String = r.manifestName;
			var __resourceName:String = r.resourceName;
			var __className:String = r.className;
			
			if (__manifestName != "") {
				throw (XType.createError ("classname: " + __fullName + " is not valid"));
			}
			
			var match:XSimpleXMLNode =
				findNodeFromClassName (
					null,
					__resourceName,
					__className,
					m_manifestXML.child ("folder")[0].child ("*")
				);
			
			if (match == null) {
				throw (XType.createError ("className not found in manifest: " + __fullName));
			}
			
			return [match, match.attribute ("path") + "\\" + match.attribute ("dst")];
		}
		
		//------------------------------------------------------------------------------------------
		// Given a class name, this function determines if an existing
		// XClass has been cached.  if not, it creates a new XClass
		//------------------------------------------------------------------------------------------
		private function __resolveXClass (__className:String):XClass {
			var	__XClass:XClass;
			
//			trace (": XResourceManager:__resolveXClass (): ", __className);
			
			if (!m_classMap.exists (__className)) {
				var __match:Array<Dynamic> /* <Dynamic> */ = __lookUpResourcePathByClassName (__className);
				
				var __resourceXML:XSimpleXMLNode = __match[0];
				var __resourcePath:String = __match[1];
				
//				trace ("$ __resolveXClass: ", __className, __resourcePath);
				
				__XClass = new XClass (__className, __resourcePath, __resourceXML);
				__XClass.setClass (null);
				m_classMap.set (__className, __XClass);				
			}
			else
			{
				__XClass = cast m_classMap.get (__className); /* as XClass */
			}
			
			return __XClass;
		}
		
		//------------------------------------------------------------------------------------------
		// Given a XClass (Class wrapper), initialize its class definition from its resource.
		// if the resource is not already cached, it creates a new XResource (Resource wrapper)
		// note that XResource loads the resource asynchronously.  until the resource is completely
		// loaded, this function will return null.
		//------------------------------------------------------------------------------------------
		private function __resolveClass (__XClass:XClass):Class<Dynamic> /* <Dynamic> */ {
			var	__resourcePath:String = __XClass.getResourcePath ();
			var __resourceXML:XSimpleXMLNode = __XClass.getResourceXML ();
			
			var __r:XResource = __getXResourceFromPath (__resourcePath, __resourceXML);
			
			if (__XClass.getClass () == null) {
				__XClass.setClass (__r.getClassByName (__XClass.getClassName ()));
			}
			
			return __XClass.getClass ();
		}		
		
		//------------------------------------------------------------------------------------------
		private function __getXResourceFromPath (__resourcePath:String, __resourceXML:XSimpleXMLNode):XResource {
			var __r:XResource = cast m_resourceMap.get (__resourcePath); /* as XResource */
			
			if (__r == null) {
				var	__XResource:XResource;
				
				if (m_projectManager.findEmbeddedResource (__resourcePath) == null) {
					__XResource = new XSWFURLResource ();
					__XResource.setup (m_rootPath + "\\" + __resourcePath, __resourceXML, m_parent, this);
				}
				else
				{
					__XResource = new XSWFEmbeddedResource ();
					__XResource.setup (__resourcePath, __resourceXML, m_parent, this);					
				}
				
				__XResource.loadResource ();
				
				m_resourceMap.set (__resourcePath, __XResource);
				
				__r = __XResource;
			}
			
			return __r;
		}
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
// }