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

	import kx.resource.manager.XSubResourceManager;
	import kx.type.*;
	import kx.xml.*;
	
	import openfl.display.Loader;
	import openfl.display.Sprite;
	import openfl.events.Event;
	import openfl.events.HTTPStatusEvent;
	import openfl.events.IEventDispatcher;
	import openfl.events.IOErrorEvent;
	import openfl.events.ProgressEvent;
	import openfl.net.URLLoader;
	import openfl.net.URLLoaderDataFormat;
	import openfl.net.URLRequest;
	import openfl.system.LoaderContext;
	
//------------------------------------------------------------------------------------------		
	class XSWFURLResource extends XSWFResource {
		var m_urlLoader:URLLoader;
		var m_urlReq:URLRequest;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public override function setup (
			__resourcePath:String,
			__resourceXML:XSimpleXMLNode,
			__parent:Sprite,
			__resourceManager:XSubResourceManager
			):Void {
				
			m_resourcePath = __fixPath (__resourcePath);
			m_resourceXML = __resourceXML;
			m_parent = __parent;
			m_loader = null;
			m_loadComplete = false;
			m_resourceManager = __resourceManager;
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
		}

//------------------------------------------------------------------------------------------
		public function __fixPath (__path:String):String {
			var __newPath:String = "";
			var __previous:Bool = false;
			var i:Int;
			
			for (i in 0 ... __path.length) {
				
				if (__path.charAt (i) == "\\") {
					if (!__previous) {
						__newPath += __path.charAt (i);
					}
					__previous = true;
				}
				else
				{
					__newPath += __path.charAt (i);
					__previous = false;
				}
			}
			
			return __newPath;
		}
		
//------------------------------------------------------------------------------------------
		public override function getDefinition (__className:String):Class<Dynamic> /* <Dynamic> */ {
			return cast m_loader.contentLoaderInfo.applicationDomain.getDefinition (__className) /* as Class */; 
		}
		
//------------------------------------------------------------------------------------------
		public override function loadResource ():Void {		
			m_loader = new Loader();

			try {
				m_urlLoader = new URLLoader();
				m_urlReq = new URLRequest(m_resourcePath);
				m_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				m_urlLoader.addEventListener(Event.COMPLETE, __onBytesLoaded);
				m_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, __onIOError);
				m_urlLoader.load(m_urlReq);
			}
			catch (e:Dynamic) {
				throw (XType.createError ("Load resource error: " + e));
			}			
			
			m_parent.addChild (m_loader);
			m_loader.visible = false;	
		}
		
	//------------------------------------------------------------------------------------------
			private function __onIOError(event:Event):Void {
				throw (XType.createError ("I/O Error reading: " + event + ", " + m_resourcePath));
			}
			
	//------------------------------------------------------------------------------------------
			private function __onBytesLoaded(event:Event):Void {
 				try {
 					trace (":-----------------");
 					trace (": ", m_resourcePath);
 					
					m_urlLoader.removeEventListener(Event.COMPLETE, __onBytesLoaded);		
					__configureListeners (m_loader.contentLoaderInfo);	

					var __loaderContext:LoaderContext;
					
					if (resourceManager ().loaderContextFactory () != null) {
						__loaderContext = resourceManager ().loaderContextFactory () ();
					}
					else
					{
						__loaderContext = new LoaderContext();
					}

					m_loader.loadBytes(m_urlLoader.data);
 				}
 				catch (e:Dynamic) {
					throw (XType.createError ("Load resource error: " + e));
 				}
			}
			
	//------------------------------------------------------------------------------------------
			private function __configureListeners(dispatcher:IEventDispatcher):Void {
				dispatcher.addEventListener (Event.COMPLETE, __completeHandler);
				dispatcher.addEventListener (HTTPStatusEvent.HTTP_STATUS, __httpStatusHandler);
				dispatcher.addEventListener (Event.INIT, __initHandler);
				dispatcher.addEventListener (IOErrorEvent.IO_ERROR, __ioErrorHandler);
				dispatcher.addEventListener (Event.OPEN, __openHandler);
				dispatcher.addEventListener (ProgressEvent.PROGRESS, __progressHandler);
				dispatcher.addEventListener (Event.UNLOAD, __unLoadHandler);
			}
			
	//------------------------------------------------------------------------------------------
			private function __removeListeners(dispatcher:IEventDispatcher):Void {
				dispatcher.removeEventListener (Event.COMPLETE, __completeHandler);
				dispatcher.removeEventListener (HTTPStatusEvent.HTTP_STATUS, __httpStatusHandler);
				dispatcher.removeEventListener (Event.INIT, __initHandler);
				dispatcher.removeEventListener (IOErrorEvent.IO_ERROR, __ioErrorHandler);
				dispatcher.removeEventListener (Event.OPEN, __openHandler);
				dispatcher.removeEventListener (ProgressEvent.PROGRESS, __progressHandler);
				dispatcher.removeEventListener (Event.UNLOAD, __unLoadHandler);
			}

	//------------------------------------------------------------------------------------------											
     	   private function __completeHandler(event:Event):Void {
        	    trace("completeHandler: " + event);
            
				trace ("xxx url: ", m_loader.contentLoaderInfo.url);
//				trace ("xxx actionScriptVersion: ", m_loader.contentLoaderInfo.actionScriptVersion);		
						
				__removeListeners (m_loader.contentLoaderInfo);
				
				m_loadComplete = true;
        	}

	//------------------------------------------------------------------------------------------
        	private function __httpStatusHandler(event:HTTPStatusEvent):Void {
            	trace("httpStatusHandler: " + event);
        	}

	//------------------------------------------------------------------------------------------
        	private function __initHandler(event:Event):Void {
            	trace("initHandler: " + event);
        	}

	//------------------------------------------------------------------------------------------
        	private function __ioErrorHandler(event:IOErrorEvent):Void {
            	trace("ioErrorHandler: " + event);
        	}

	//------------------------------------------------------------------------------------------
        	private function __openHandler(event:Event):Void {
            	trace("openHandler: " + event);
        	}

	//------------------------------------------------------------------------------------------
        	private function __progressHandler(event:ProgressEvent):Void {
            	trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
        	}

	//------------------------------------------------------------------------------------------
        	private function __unLoadHandler(event:Event):Void {
            	trace("unLoadHandler: " + event);
        	}
        		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }