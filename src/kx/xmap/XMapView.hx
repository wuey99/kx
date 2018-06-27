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
package kx.xmap;

// X classes
	import kx.collections.*;
	import kx.geom.*;
	import kx.pool.XObjectPoolManager;
	import kx.task.*;
	import kx.texture.XSubTextureManager;
	import kx.utils.*;
	import kx.world.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	import kx.xmap.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
//------------------------------------------------------------------------------------------	
	class XMapView extends XLogicObject {
		private var m_XMapModel:XMapModel;
		private var m_submapBitmapPoolManager:XObjectPoolManager;
		private var m_subTextureManager:XSubTextureManager;
		private var m_textureManagerName:String;
		private var m_imageNamesCached:Bool;
				
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_imageNamesCached = false;
			
			if (false /* CONFIG::starling */) {
				m_textureManagerName = GUID.create ();
				
//				m_subTextureManager = xxx.getTextureManager ().createSubManager (m_textureManagerName);
			}
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
			
			uncacheImageClassNames ();
			
			if (m_subTextureManager != null) {
				xxx.getTextureManager ().removeSubManager (m_textureManagerName);
			}
			
			if (m_submapBitmapPoolManager != null) {
				m_submapBitmapPoolManager.cleanup ();
			}
		}
		
//--------------------------------------------f----------------------------------------------
		public override function setupX ():Void {
		}

//------------------------------------------------------------------------------------------
		public override function cullObject ():Void {
			for (__key__ in getXLogicObjects ().keys ()) {
				function (x:Dynamic /* */):Void {
					var __logicObject:XLogicObject = cast x; /* as XLogicObject */
					
					__logicObject.cullObject ();
				} (__key__);
			}
			
			super.cullObject ();
		}
		
//------------------------------------------------------------------------------------------
// all levels/XMaps contain a list of images used in the level.  We cache them all as
// bitmap's (in flash) and textures/movieclips (in starling).		
//------------------------------------------------------------------------------------------
		
//------------------------------------------------------------------------------------------
		public function areImageClassNamesCached ():Bool {
			var __flags:Bool;
			var i:Int;
			
			if (m_imageNamesCached) {
				return true;
			}
			
			__flags = true;
			
			for (i in 0 ... m_XMapModel.getLayers ().length) {
				var __layer:XMapLayerModel = cast m_XMapModel.getLayers ()[i]; /* as XMapLayerModel */
	
				for (__key__ in __layer.getImageClassNames ().keys ()) {
					function (__name:Dynamic /* */):Void {
						if (__name == "ErrorImages:undefinedClass") {
							return;	
						}

						if (xxx.useBGTilemaps ()) {
							if (xxx.getMovieClipCacheManager ().isQueued (cast __name /* as String */)) {
								trace (": not cached: ", __name);
								
								__flags = false;
							}							
						}
						else
						{
							if (xxx.getBitmapCacheManager ().isQueued (cast __name /* as String */)) {
								trace (": not cached: ", __name);
								
								__flags = false;
							}
						}
					} (__key__);
				}
				
				if (!__flags) {
					return false;
				}
			}
			
			m_imageNamesCached = true;
			
			return true;	
		}

//------------------------------------------------------------------------------------------
		public function cacheImageClassNames ():Void {
			var i:Int;
				
			for (i in 0 ... m_XMapModel.getLayers ().length) {
					var __layer:XMapLayerModel = cast m_XMapModel.getLayers ()[i]; /* as XMapLayerModel */
					
					for (__key__ in __layer.getImageClassNames ().keys ()) {
						function (__name:Dynamic /* */):Void {
							trace (": cacheImageClassName: ", __name);
			
							if (xxx.useBGTilemaps ()) {
								xxx.getMovieClipCacheManager ().add (cast __name /* as String */);
							}
							else
							{
								xxx.getBitmapCacheManager ().add (cast __name /* as String */);
							}
						} (__key__);
					}
			}			
		}	
		
//------------------------------------------------------------------------------------------
		public function uncacheImageClassNames ():Void {
			var i:Int;
			
				for (i in 0 ... m_XMapModel.getLayers ().length) {
					var __layer:XMapLayerModel = cast m_XMapModel.getLayers ()[i]; /* as XMapLayerModel */
		
					for (__key__ in __layer.getImageClassNames ().keys ()) {
						function (__name:Dynamic /* */):Void {
							if (xxx.useBGTilemaps ()) {
								xxx.getMovieClipCacheManager () /* as String) */;
							}
							else
							{
								xxx.getBitmapCacheManager () /* as String) */;
							}
						} (__key__);
					}
				}
		}

//------------------------------------------------------------------------------------------
		public function getSubTextureManager ():XSubTextureManager {
			return m_subTextureManager;
		}
		
//------------------------------------------------------------------------------------------
		public function initSubmapPoolManager ():Void {
			initSubmapBitmapPoolManager (512, 512);
		}
		
//------------------------------------------------------------------------------------------
		public function initSubmapBitmapPoolManager (
			__width:Int=512, __height:Int=512,
			__alloc:Int=64, __spill:Int=16
			):Void {
				
			if (xxx.useBGTilemaps ()) {
				m_submapBitmapPoolManager = new XObjectPoolManager (
					function ():Dynamic /* */ {
						var __tilemap:XSubmapTilemap = new XSubmapTilemap (512, 512, null);
						__tilemap.setup ();					
						
						return __tilemap;
					},
					
					function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
						return null;
					},
					
					__alloc, __spill,
					
					function (x:Dynamic /* */):Void {
						var __tilemap:XSubmapTilemap = cast x; /* as XSubmapTilemap */
						
						__tilemap.cleanup ();
					}
				);				
			}
			else
			{
				m_submapBitmapPoolManager = new XObjectPoolManager (
					function ():Dynamic /* */ {
						var __bitmap:XSubmapBitmap = new XSubmapBitmap ();
						__bitmap.setup ();					
						__bitmap.createBitmap ("tiles", __width, __height);
					
						return __bitmap;
					},
					
					function (__src:Dynamic /* */, __dst:Dynamic /* */):Dynamic /* */ {
						return null;
					},
					
					__alloc, __spill,
					
					function (x:Dynamic /* */):Void {
						var __bitmap:XBitmap = cast x; /* as XBitmap */
						
						__bitmap.cleanup ();
					}
				);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapBitmapPoolManager ():XObjectPoolManager {
			return m_submapBitmapPoolManager;
		}
		
//------------------------------------------------------------------------------------------
		public function createModelFromXML (__xml:XSimpleXMLNode, __useArrayItems:Bool=false):Void {
			var __model:XMapModel = new XMapModel ();
			
			__model.deserializeAllNormal (__xml, __useArrayItems);	
			
			setModel (__model);		
		}

//------------------------------------------------------------------------------------------
		public function createModelFromXMLReadOnly (__xml:XSimpleXMLNode, __useArrayItems:Bool=false):Void {
			var __model:XMapModel = new XMapModel ();
			
			__model.deserializeAllReadOnly (__xml, __useArrayItems);	
			
			setModel (__model);		
		}
		
//------------------------------------------------------------------------------------------
		public function getModel ():XMapModel {
			return m_XMapModel;
		}
		
//------------------------------------------------------------------------------------------
		public function setModel (__model:XMapModel):Void {
			m_XMapModel = __model;
			
			cacheImageClassNames ();
		}
		
//------------------------------------------------------------------------------------------
		public function scrollTo (__layer:Int, __x:Float, __y:Float):Void {
		}

//------------------------------------------------------------------------------------------
		public function updateScroll ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function updateFromXMapModel ():Void {
		}

//------------------------------------------------------------------------------------------
		public function prepareUpdateScroll ():Void {	
		}

//------------------------------------------------------------------------------------------
		public function finishUpdateScroll ():Void {	
		}
						
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
