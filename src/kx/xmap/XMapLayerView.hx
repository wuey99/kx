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

	import kx.collections.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	import kx.type.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
//------------------------------------------------------------------------------------------
// represents the view for all Items in a XMap.
//
// using the layer's viewport, instantiates/spawns XMapItemModels as XLogicObjects
// that fall within the viewport's rect.
//
// the XLogicObject is responsible for culling.  This class monitor's the XLogicObject's
// life-cycle by listening to the XLogicObject's kill signal.  XMapItemModels are returned
// to the Submap on a cull/kill;  However, objects that have been nuked () are permanently
// removed from the XMapModel.
//------------------------------------------------------------------------------------------
	class XMapLayerView extends XLogicObject {
		private var m_XMapView:XMapView;
		private var m_XMapModel:XMapModel;
		private var m_currLayer:Int;
		
		private var m_XMapItemToXLogicObject:Map<XMapItemModel, XLogicObject>; // <XMapItemModel, XLogicObject>
		private var m_XMapLayerModel:XMapLayerModel;
		private var m_logicClassNameToClass:Dynamic /* Function */;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_XMapView = getArg (args, 0);
			m_XMapModel = getArg (args, 1);
			m_currLayer = getArg (args, 2);
			m_logicClassNameToClass = getArg (args, 3);
			
			m_XMapLayerModel = m_XMapModel.getLayer (m_currLayer);
			
			m_XMapItemToXLogicObject = new Map<XMapItemModel, XLogicObject> (); // <XMapItemModel, XLogicObject>
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
		}

//------------------------------------------------------------------------------------------
		public function updateFromXMapModel ():Void {
			var __view:XRect = xxx.getXWorldLayer (m_currLayer).viewPort (
				xxx.getViewRect ().width, xxx.getViewRect ().height
			);
			
			updateFromXMapModelAtRect (__view);
		}

//------------------------------------------------------------------------------------------
		public function updateFromXMapModelAtRect (__view:XRect):Void {
			if (!m_XMapView.areImageClassNamesCached ()) {
				return;
			}
			
//------------------------------------------------------------------------------------------		
			var __items:Array<XMapItemModel>; // <XMapItemModel>
			
			if (m_XMapModel.useArrayItems) {
				__items = m_XMapModel.getArrayItemsAt (
					m_currLayer,
					__view.left, __view.top,
					__view.right, __view.bottom
				);
			}
			else
			{
				__items = m_XMapModel.getItemsAt (
					m_currLayer,
					__view.left, __view.top,
					__view.right, __view.bottom
				);				
			}
			
//------------------------------------------------------------------------------------------
			var __item:XMapItemModel;
			var i:Int, __length:Int = __items.length;
									
			for (i in 0 ... __length) {
				__item = cast __items[i]; /* as XMapItemModel */
						
				updateXMapItemModel (__item);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateXMapItemModel (__item:XMapItemModel):Void {
			if (__item.inuse == 0) {
				addXMapItem (
					// item
					__item,
					// depth
					__item.depth
				);
			}
			else
			{
				if (m_XMapItemToXLogicObject.exists (__item)) {
					var logicObject:XLogicObject = m_XMapItemToXLogicObject.get (__item);
					
					var __point:XPoint = logicObject.getPos ();
					
//					__point.x = __item.x;
//					__point.y = __item.y;
				}
			}
		}	
		
//------------------------------------------------------------------------------------------
		public function addXMapItem (__item:XMapItemModel, __depth:Float):XLogicObject {
			var __logicObject:XLogicObjectCX;
			
			var __object:Dynamic /* */ = m_logicClassNameToClass (__item.logicClassName);
				
			if (XType.isFunction (__object)) {
				__logicObject = cast (__object ());
			}
			else if (__item.logicClassName.charAt (0) == "$") {
				if (__object == null) {
					trace (": (error) logicClassName: ", __item.logicClassName);
					
					__logicObject = null;
				}
				else {
					__logicObject = cast xxx.getXLogicManager ().initXLogicObjectFromPool (
						// parent
						m_XMapView,
						// class
						cast(__object, Class<Dynamic> /* <Dynamic> */) , 
						// item, layer, depth
						__item, m_currLayer, __depth,
						// x, y, z
						__item.x, __item.y, 0,
						// scale, rotation
						__item.scale, __item.rotation,
						[
							// imageClassName
							__item.imageClassName,
							// frame
							__item.frame
						]
					) /* as XLogicObjectCX */;
				}
			}
			else
			{
				if (__item.logicClassName == "XLogicObjectXMap:XLogicObjectXMap") {
					__logicObject = null;
				}
				else
				{
					__logicObject = cast xxx.getXLogicManager ().createXLogicObjectFromClassName (
						// parent
							m_XMapView,
						// logicClassName
							__item.logicClassName,
						// item, layer, depth
							__item, m_currLayer, __depth,
						// x, y, z
							__item.x, __item.y, 0,
						// scale, rotation
							__item.scale, __item.rotation,
						[
							// imageClassName
								__item.imageClassName,
							// frame
								__item.frame
						]
						) /* as XLogicObjectCX */;
				}
			}

			__item.inuse++;

			if (__logicObject == null) {
				return null;
			}
			
			m_XMapView.addXLogicObject (__logicObject);
			
			m_XMapItemToXLogicObject.set (__item, __logicObject);

			__logicObject.setXMapModel (m_currLayer + 1, m_XMapModel, m_XMapView);
			
			__logicObject.addKillListener (removeXMapItem);

//			__logicObject.show ();
			
			return __logicObject;
		}

//------------------------------------------------------------------------------------------
		public function getXLogicObject (__item:XMapItemModel):XLogicObject {
			return m_XMapItemToXLogicObject.get (__item);
		}
		
//------------------------------------------------------------------------------------------
		public function removeXMapItem (__item:XMapItemModel):Void {
			if (m_XMapItemToXLogicObject.exists (__item)) {		
				m_XMapItemToXLogicObject.remove (__item);
			}
		}

//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
// }
