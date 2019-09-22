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
package kx;
	
	import openfl.display.*;
	import openfl.events.*;
	import openfl.system.*;
	import openfl.utils.*;
	
	import kx.bitmap.*;
	import kx.collections.*;
	import kx.debug.*;
	import kx.gamepad.*;
	import kx.geom.*;
	import kx.mvc.*;
	import kx.pool.*;
	import kx.resource.manager.*;
	import kx.signals.*;
	import kx.sound.*;
	import kx.task.*;
	import kx.texture.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	import kx.xml.*;

	
//------------------------------------------------------------------------------------------
	class XApp {
		private var m_parent:Sprite;
		private var m_XTaskManager:XTaskManager;
		private var m_timer:Timer;
		private var m_inuse_TIMER_FRAME:Int;
		private var m_XDebug:XDebug;
		private var m_useTilemaps:Bool;
		private var m_useBGTilemaps:Bool;
		private var m_projectManager:XProjectManager;
		private var m_XSignalManager:XSignalManager;
		private var m_XSoundManager:XSoundManager;
		private var m_XBitmapCacheManager:XBitmapCacheManager;
		private var m_XBitmapDataAnimManager:XBitmapDataAnimManager;
		private var m_XSignalPoolManager:XObjectPoolManager;
		private var m_XRectPoolManager:XObjectPoolManager;
		private var m_XPointPoolManager:XObjectPoolManager;
		private var m_XDepthSpritePoolManager:XObjectPoolManager;
		private var m_XBitmapPoolManager:XObjectPoolManager;
		private var m_XMovieClipPoolManager:XObjectPoolManager;
		private var m_XTilemapPoolManager:XObjectPoolManager;
		private var m_TilePoolManager:XObjectPoolManager;
		private var m_XMapItemModelPoolManager:XObjectPoolManager;
		private var m_XTextureManager:XTextureManager;
		private var m_XMovieClipCacheManager:XMovieClipCacheManager;
		private var m_XClassPoolManager:XClassPoolManager;
		private var m_allClassNames:Map<String, Int>; // <String, Int>
		private var m_frameRateScale:Float;
		private var m_XGamepadManager:XGamepadManager;
		
//------------------------------------------------------------------------------------------
		public function new () {
		}

//------------------------------------------------------------------------------------------
		public function setup (__poolSettings:Dynamic /* Object */):Void {
			m_useTilemaps = true;
			m_useBGTilemaps = true;

			m_XTaskManager = new XTaskManager (this);
			m_XSignalManager = new XSignalManager (this);
			m_XSoundManager = new XSoundManager (this);
			m_XBitmapCacheManager = new XBitmapCacheManager (this);
			m_XBitmapDataAnimManager = new XBitmapDataAnimManager (this);
			m_XTextureManager = new XTextureManager (this);
			m_XMovieClipCacheManager = new XMovieClipCacheManager (this);
			m_XClassPoolManager = new XClassPoolManager ();
			m_XGamepadManager = new XGamepadManager (); m_XGamepadManager.setup ();
			
			XBitmap.setXApp (this);
			XSprite.setXApp (this);
			XMapModel.setXApp (this);
			XTask.setXApp (this);
			XTilemap.setXApp (this);
			XMovieClip.setXApp (this);
			XImagemap.setXApp (this);
			XSubmapTilemap.setXApp (this);
			
			m_frameRateScale = 1.0;
			
			__initPoolManagers (__poolSettings);
			
			m_XDebug = new XDebug ();
			m_XDebug.setup (this);
			
			m_timer = new Timer (16, 0);
			m_timer.start ();
			m_timer.addEventListener (TimerEvent.TIMER, updateTimer);
			m_inuse_TIMER_FRAME = 0;
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}

//------------------------------------------------------------------------------------------
		public function getMaximalPoolSettings ():Dynamic /* Object */ {
			return {
				XSignal: {init: 10000, overflow: 1000},
				XRect: {init: 25000, overflow: 1000},				
				XPoint: {init: 25000, overflow: 1000},
				XDepthSprite: {init: 4000, overflow: 1000},
				XBitmap: {init: 4000, overflow: 1000},
				XMovieClip: {init: 4000, overflow: 1000},
				XTilemap: {init: 4000, overflow: 1000},
				Tile: {init: 4000, overflow: 1000},
				XMapItemModel: {init: 12288, overflow: 2048}
			};
		}
		
//------------------------------------------------------------------------------------------
		public function getDefaultPoolSettings ():Dynamic /* Object */ {
			return {
				XSignal: {init: 2000, overflow: 1000},
				XRect: {init: 2500, overflow: 1000},				
				XPoint: {init: 2500, overflow: 1000},
				XDepthSprite: {init: 2000, overflow: 1000},
				XBitmap: {init: 2000, overflow: 1000},
				XMovieClip: {init: 4000, overflow: 1000},
				XTilemap: {init: 4000, overflow: 1000},
				Tile: {init: 4000, overflow: 1000},
				XMapItemModel: {init: 12288, overflow: 2048}
			};
		}
		
//------------------------------------------------------------------------------------------
		private function __initPoolManagers (__poolSettings:Dynamic /* Object */):Void {

//------------------------------------------------------------------------------------------
// XSignals
//------------------------------------------------------------------------------------------
			m_XSignalPoolManager = new XObjectPoolManager (
				function ():Dynamic /* */ {
					return new XSignal ();
				},
				
				function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
					return null;
				},
				
				__poolSettings.XSignal.init, __poolSettings.XSignal.overflow
			);
				
//------------------------------------------------------------------------------------------
// XRect
//------------------------------------------------------------------------------------------
			m_XRectPoolManager = new XObjectPoolManager (
				function ():Dynamic /* */ {
					return new XRect ();
				},
				
				function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
					var __rect1:XRect = cast __src; /* as XRect */
					var __rect2:XRect = cast __dst; /* as XRect */
					
					__rect2.x = __rect1.x;
					__rect2.y = __rect1.y;
					__rect2.width = __rect1.width;
					__rect2.height = __rect1.height;
					
					return __rect2;
				},
				
				__poolSettings.XRect.init, __poolSettings.XRect.overflow
			);
		
//------------------------------------------------------------------------------------------
// XPoint
//------------------------------------------------------------------------------------------
			m_XPointPoolManager = new XObjectPoolManager (
				function ():Dynamic /* */ {
					return new XPoint ();
				},
				
				function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
					var __point1:XPoint = cast __src; /* as XPoint */
					var __point2:XPoint = cast __dst; /* as XPoint */
					
					__point2.x = __point1.x;
					__point2.y = __point1.y;

					return __point2;
				},
				
				__poolSettings.XPoint.init, __poolSettings.XPoint.overflow
			);

//------------------------------------------------------------------------------------------
// XDepthSprite
//------------------------------------------------------------------------------------------
			m_XDepthSpritePoolManager = new XObjectPoolManager (
				function ():Dynamic /* */ {
					var __sprite:XDepthSprite = new XDepthSprite ();
					
					__sprite.clear ();
					
					return __sprite;
				},
				
				function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
					return null;
				},
				
				__poolSettings.XDepthSprite.init, __poolSettings.XDepthSprite.overflow
			);
			
//------------------------------------------------------------------------------------------
// XBItmap
//------------------------------------------------------------------------------------------
			m_XBitmapPoolManager = new XObjectPoolManager (
				function ():Dynamic /* */ {
					var __bitmap:XBitmap = new XBitmap ();

					return __bitmap;
				},
				
				function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
					return null;
				},
				
				__poolSettings.XBitmap.init, __poolSettings.XBitmap.overflow
			);
			
//------------------------------------------------------------------------------------------
// XMovieClip
//------------------------------------------------------------------------------------------
			m_XMovieClipPoolManager = new XObjectPoolManager (
				function ():Dynamic /* */ {
					var __bitmap:XMovieClip = new XMovieClip ();
					
					return __bitmap;
				},
				
				function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
					return null;
				},
				
				__poolSettings.XMovieClip.init, __poolSettings.XMovieClip.overflow
			);
			
//------------------------------------------------------------------------------------------
// XTilemap
//------------------------------------------------------------------------------------------
			m_XTilemapPoolManager = new XObjectPoolManager (
				function ():Dynamic /* */ {
					var __bitmap:XTilemap = new XTilemap ();
					
					return __bitmap;
				},
				
				function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
					return null;
				},
				
				__poolSettings.XTilemap.init, __poolSettings.XTilemap.overflow
			);
			
//------------------------------------------------------------------------------------------
// Tile
//------------------------------------------------------------------------------------------
			m_TilePoolManager = new XObjectPoolManager (
				function ():Dynamic /* */ {
					var __tile:Tile = new Tile (0, 0, 0, 1.0, 1.0, 0.0);
					
					return __tile;
				},
				
				function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
					return null;
				},
				
				__poolSettings.Tile.init, __poolSettings.Tile.overflow
			);
			
//------------------------------------------------------------------------------------------
// XMapItemModel
//------------------------------------------------------------------------------------------
			m_XMapItemModelPoolManager = new XObjectPoolManager (
				function ():Dynamic /* */ {
					var __xmapItem:XMapItemModel = new XMapItemModel ();
					
					return __xmapItem;
				},
				
				function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
					return null;
				},
				
				__poolSettings.XMapItemModel.init, __poolSettings.XMapItemModel.overflow
			);
		}
			
//------------------------------------------------------------------------------------------
		public function updateTimer (e:Event):Void {
			if (m_inuse_TIMER_FRAME > 0) {
				trace (": overflow: TIMER_FRAME: ");
				
				return;
			}

			m_inuse_TIMER_FRAME++;
			
			getXTaskManager ().updateTasks ();
			
			m_inuse_TIMER_FRAME--;
		}
		
//------------------------------------------------------------------------------------------
		public function getParent ():Dynamic /* */ {
			return m_parent;
		}
		
//------------------------------------------------------------------------------------------
		public function getTime ():Float {
			var __date:Date = XType.getNowDate();
			
			return __date.getTime ();
		}

//------------------------------------------------------------------------------------------		\
		public function useTilemaps ():Bool {
			return m_useTilemaps;
		}
		
//------------------------------------------------------------------------------------------		\
		public function useBGTilemaps ():Bool {
			return m_useBGTilemaps;
		}
		
//------------------------------------------------------------------------------------------
		public function getFrameRateScale ():Float {
			return m_frameRateScale;
		}
		
//------------------------------------------------------------------------------------------
		public function setFrameRateScale (__val:Float):Void {
			m_frameRateScale = __val;
		}
		
//------------------------------------------------------------------------------------------
		public function getXGamepadManager ():XGamepadManager {
			return m_XGamepadManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getXTaskManager ():XTaskManager {
			return m_XTaskManager;
		}

//------------------------------------------------------------------------------------------
		public function getXSignalPoolManager ():XObjectPoolManager {
			return m_XSignalPoolManager;
		}

//------------------------------------------------------------------------------------------
		public function getXRectPoolManager ():XObjectPoolManager {
			return m_XRectPoolManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getXPointPoolManager ():XObjectPoolManager {
			return m_XPointPoolManager;
		}

//------------------------------------------------------------------------------------------
		public function getXDepthSpritePoolManager ():XObjectPoolManager {
			return m_XDepthSpritePoolManager;
		}
			
//------------------------------------------------------------------------------------------
		public function getXBitmapPoolManager ():XObjectPoolManager {
			return m_XBitmapPoolManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getXMovieClipPoolManager ():XObjectPoolManager {
			return m_XMovieClipPoolManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getXTilemapPoolManager ():XObjectPoolManager {
			return m_XTilemapPoolManager;
		}

//------------------------------------------------------------------------------------------
		public function getTilePoolManager ():XObjectPoolManager {
			return m_TilePoolManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getXMapItemModelPoolManager ():XObjectPoolManager {
			return m_XMapItemModelPoolManager;
		}
		
//------------------------------------------------------------------------------------------
		public function createXSignal ():XSignal {
			return m_XSignalManager.createXSignal ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXSignalManager ():XSignalManager {
			return m_XSignalManager;
		}

//------------------------------------------------------------------------------------------
		public function getClassPoolManager ():XClassPoolManager {
			return m_XClassPoolManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getSoundManager ():XSoundManager {
			return m_XSoundManager;
		}
				
//------------------------------------------------------------------------------------------
		public function setProjectManager (__projectManager:XProjectManager):Void {
			m_projectManager = __projectManager;
		}

//------------------------------------------------------------------------------------------
		public function getProjectManager ():XProjectManager {
			return m_projectManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getMovieClipCacheManager ():XMovieClipCacheManager {
			return m_XMovieClipCacheManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getBitmapCacheManager ():XBitmapCacheManager {
			return m_XBitmapCacheManager;
		}

//------------------------------------------------------------------------------------------
		public function getBitmapDataAnimManager ():XBitmapDataAnimManager {
			return m_XBitmapDataAnimManager;
		}

//------------------------------------------------------------------------------------------
		public function getTextureManager ():XTextureManager {
			return m_XTextureManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getResourceManagerByName (__name:String):XSubResourceManager {
			return getProjectManager ().getResourceManagerByName (__name);
		}

//------------------------------------------------------------------------------------------
		public function getClass (__className:String):Class<Dynamic> /* <Dynamic> */ {
			return getProjectManager ().getClassByName (__className);
		}
		
//------------------------------------------------------------------------------------------
		public function getClassByName (__className:String):Class<Dynamic> /* <Dynamic> */ {
			return getProjectManager ().getClassByName (__className);
		}
		
//------------------------------------------------------------------------------------------
		public function unloadClass (__className:String):Bool {
			return getProjectManager ().unloadClassByName (__className);
		}
		
//------------------------------------------------------------------------------------------
		public function unloadClassByName (__className:String):Bool {
			return getProjectManager ().unloadClassByName (__className);
		}

//------------------------------------------------------------------------------------------
		public function createInstance (__class:Class<Dynamic> /* <Dynamic> */):Dynamic /* */ {
			return XType.createInstance (__class);
		}
		
//------------------------------------------------------------------------------------------
		public function createInstanceFromClassName (__className:String):Dynamic /* */ {
			return XType.createInstance (getClassByName (__className));
		}
		
//------------------------------------------------------------------------------------------
		public function createLevelXML (__className:String):XSimpleXMLNode {
			var __xml:XSimpleXMLNode;
			
			__xml = new XSimpleXMLNode ();
			
			var __bytes:ByteArray = cast createInstanceFromClassName (__className);
			__xml.setupWithXMLString (__bytes.toString ());
			
			return __xml;
		}
		
//------------------------------------------------------------------------------------------
		public function cacheAllClasses (__project:XSimpleXMLNode):Bool {			

			var ready:Bool = true;
			
			trace (": cacheAllClasses: ");
			
			//------------------------------------------------------------------------------------------
			function __cacheAllClasses (__cacheAll:Bool, __xmlList:Array<XSimpleXMLNode>):Void {
				var i:Int, j:Int;
				
				for (i in 0 ... __xmlList.length) {
					if (__xmlList[i].localName () == "folder") {
						__cacheAllClasses (
							__cacheAll,
							__xmlList[i].child ("*")
						);
					}
					if (__xmlList[i].localName () == "manifest") {
						__cacheAllClasses (
							__cacheAll,
							__xmlList[i].child ("*")
						);
					}
					else
					{
						var __resourceName:String = __xmlList[i].attribute ("name");		
						var __resourceType:String = __xmlList[i].attribute ("type");
						var __classList:Array<XSimpleXMLNode> = __xmlList[i].child ("classX");
						
						if (__cacheAll || (!__cacheAll && __xmlList[i].attribute ("embed") == "true")) {	
							for (j in 0 ... __classList.length) {
								var __fullName:String = __resourceName + ":" + __classList[j].attribute ("name");
								
								trace (": class: ", __fullName, m_allClassNames.exists (__fullName));
								
								if (getClass (__fullName) == null) {
									ready = false;
								}
								
								if (__resourceType != ".as") {
									if (__fullName == "sfx:sfx" || __fullName == "square:square") {	
									}
									else
									{
										m_allClassNames.set (__fullName, 0);
									}
								}
							}
						}
					}
				}
			}
			
			//------------------------------------------------------------------------------------------			
			m_allClassNames = new Map<String, Int> (); // <String, Int>
			
			__cacheAllClasses (true, __project.child ("*"));
			
			var i:Int;
			
			i = 0;
//			
//			if (false) m_allClassNames.forEach (
//				function (x:*):void {
//					var __fullName:String = x as String;
//					
//					trace (": fullName: ", i++, __fullName);
//				}
//			);
			
			return (ready);
			
		//------------------------------------------------------------------------------------------
		}

//------------------------------------------------------------------------------------------
		public function getAllClassNames ():Map<String, Int> /* <String, Int> */ {
			return m_allClassNames;
		}
		
//------------------------------------------------------------------------------------------
		public function disableDebug ():Void {
			m_XDebug.disable (true);
		}
		
//------------------------------------------------------------------------------------------
		public function print (args:Array<Dynamic>):Void {
			trace (args);
		}
	
//------------------------------------------------------------------------------------------
		public function getCommonClasses ():Bool {
			trace (": -------------------------: ");
			trace (": getting common classes: ");

// 10/05/2013: removed external loading of classes
//
//			trace (": getting XLogicObjectXMap:XLogicObjectXMap: ");
//			getClass ("XLogicObjectXMap:XLogicObjectXMap");
			
			trace (": getting ErrorImages:undefinedClass: ");
			getClass ("ErrorImages:undefinedClass");
				
			trace (": finished getting commonClasses: ");
	
			return (
//				getClass ("XLogicObjectXMap:XLogicObjectXMap") == null ||
				getClass ("ErrorImages:undefinedClass") == null
				);
		}

//------------------------------------------------------------------------------------------
// report memory leaks
//------------------------------------------------------------------------------------------
		public function reportMemoryLeaks (m_XApp:XApp, xxx:XWorld):Void {
			var i:Int;
			var x:Dynamic /* */;

			trace ("------------------------------");
			trace ("active XSignals xxx");
			
			i = 0;
			
//			if (false) getXSignalManager ().getXSignals ().forEach (
//				function (x:XSignal):void {
////					trace (": signal: " , i, ": ", x,  ", parent: ", x.getParent ());
//				}
//			);
			
			trace ("------------------------------");
			trace ("active XSignals XApp");
			
			i = 0;
			
//			if (false) m_XApp.getXSignalManager ().getXSignals ().forEach ( /* @:castkey */
//				function (x:XSignal):void {
////					trace (": signal: ", i, ": ", x,  ", parent: ", x.getParent ());
//				}
//			);
									
			trace ("------------------------------");
			trace ("active XLogicObjects");

			i = 0;
				
//			if (false) xxx.getXLogicManager ().getXLogicObjects ().forEach (
//				function (x:*):void {
//					trace (": XLogicObject: ", i,  ": ",  x);
//						
//					i++;
//				}
//			);
							
			trace ("------------------------------");
			trace ("active tasks xxx: ");
				
			i = 0;
				
//			if (false) xxx.getXTaskManager ().getTasks ().forEach ( /* @:castkey */
//				function (x:XSignal):void {
////					trace (": task: ",  i,  ": ",  x,  ", parent: ",  x.getParent ());
//					
//					i++;
//				}	
//			);

			trace ("------------------------------");
			trace ("active tasks XApp: ");
												
			XType.forEach (m_XApp.getXTaskManager ().getTasks (),  /* @:castkey */
				function (x:XTask):Void {
//					trace (": task: ",  i, ": ",  x,  ", parent: ", x.getParent ());
				}
			);
			
			trace ("------------------------------");
			trace ("XSignalPoolManager XApp: ");
			
			trace (": XSignalPoolManager: ", m_XSignalPoolManager.numberOfBorrowedObjects ());
			
			trace ("------------------------------");
			trace ("XRectPoolManager XApp: ");
			
			trace (": XRectPoolManager: ", m_XRectPoolManager.numberOfBorrowedObjects ());

			trace ("------------------------------");
			trace ("XPointPoolManager XApp: ");
			
			trace (": XPointPoolManager: ", m_XPointPoolManager.numberOfBorrowedObjects ());		

			trace ("------------------------------");
			trace ("XDepthSpritePoolManager XApp: ");
			
			trace (": XDepthSpritePoolManager: ", m_XDepthSpritePoolManager.numberOfBorrowedObjects ());
		}
			
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }	