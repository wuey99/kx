﻿//------------------------------------------------------------------------------------------
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
package kx.world;

// X classes
	import kx.*;
	import kx.collections.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.type.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	
	import openfl.geom.*;
	
//------------------------------------------------------------------------------------------	
	class XLogicManager {
		private var xxx:XWorld;
		private var m_XTaskManager0:XTaskManager;
		private var m_XTaskManager:XTaskManager;
		private var m_XTaskManagerCX:XTaskManager;
		private var m_XLogicObjects:Map<XLogicObject, Int>; // <XLogicObject, Int>
		private var m_XLogicObjectsTopLevel:Map<XLogicObject, Int>; // <XLogicObject, Int>
		private var m_killQueue:Map<XLogicObject, Int>; // <XLogicObject, Int>
		private var m_paused:Bool;
		
//------------------------------------------------------------------------------------------
		public function new (__XApp:XApp, __xxx:XWorld) {
			xxx = __xxx;
			
			m_XLogicObjects = new Map<XLogicObject, Int> (); // <XLogicObject, Int>
			m_XLogicObjectsTopLevel = new Map<XLogicObject, Int> (); // <XLogicObject, Int>
			m_XTaskManager0 = new XTaskManager (__XApp);
			m_XTaskManager = new XTaskManager (__XApp);
			m_XTaskManagerCX = new XTaskManager (__XApp);
			
			m_killQueue = new Map<XLogicObject, Int> (); // <XLogicObject, Int>
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
			m_XTaskManager0.removeAllTasks ();
			m_XTaskManager.removeAllTasks ();
			m_XTaskManagerCX.removeAllTasks ();
		}
		
//------------------------------------------------------------------------------------------
		public function createXLogicObjectFromClassName (
			__parent:XLogicObject,
			__className:String,
			__item:XMapItemModel, __layer:Int, __depth:Float,
			__x:Float, __y:Float, __z:Float, 
			__scale:Float, __rotation:Float,
			args:Array<Dynamic> /* <Dynamic> */ = null
			):XLogicObject {
				
			args = (args == null) ? args = [] : args;
			
			var __class:Class<Dynamic> /* <Dynamic> */ = xxx.getClass (__className);
			
			var __logicObject:XLogicObject = cast XType.createInstance(__class); /* as XLogicObject */
				
			return __initXLogicObject (
				__parent,
				__logicObject,
				null,
				__item, __layer, __depth,
				__x, __y, __z,
				__scale, __rotation,
				args);
		}
		
//------------------------------------------------------------------------------------------
		public function initXLogicObjectFromPool (
			__parent:XLogicObject,
			__class:Class<Dynamic> /* <Dynamic> */,
			__item:XMapItemModel, __layer:Int, __depth:Float,
			__x:Float, __y:Float, __z:Float, 
			__scale:Float, __rotation:Float,
			args:Array<Dynamic> /* <Dynamic> */ = null
		):XLogicObject {
			
			args = (args == null) ? args = [] : args;
			
			var __logicObject:XLogicObject = cast xxx.getXLogicObjectPoolManager ().borrowObject (__class); /* as XLogicObject */
			
			return __initXLogicObject (
				__parent,
				__logicObject,
				__class,
				__item, __layer, __depth,
				__x, __y, __z,
				__scale, __rotation,
				args);
		}
		
//------------------------------------------------------------------------------------------
		public function initXLogicObjectFromXML (
			__parent:XLogicObject,
			__logicObject:XLogicObject,
			args:Array<Dynamic> /* <Dynamic> */ = null
			):XLogicObject {
				
			args = (args == null) ? args = [] : args;
			
			if (__logicObject.iClassName != "") {
				return __initXLogicObject (
						__parent,
						__logicObject,
						null,
						__logicObject.iItem, __logicObject.iLayer, __logicObject.iDepth,
						__logicObject.iX, __logicObject.iY, 0,
						__logicObject.iScale, __logicObject.iRotation,
						[__logicObject.iClassName]);				
			}
			else
			{
				return __initXLogicObject (
						__parent,
						__logicObject,
						null,
						__logicObject.iItem, __logicObject.iLayer, __logicObject.iDepth,
						__logicObject.iX, __logicObject.iY, 0,
						__logicObject.iScale, __logicObject.iRotation,
						args);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function initXLogicObject (
			__parent:XLogicObject,
			__logicObject:XLogicObject,
			__item:XMapItemModel, __layer:Int, __depth:Float,
			__x:Float, __y:Float, __z:Float, 
			__scale:Float, __rotation:Float,
			args:Array<Dynamic> /* <Dynamic> */ = null
			):XLogicObject {

			args = (args == null) ? args = [] : args;
			
			return __initXLogicObject (
					__parent,
					__logicObject,
					null,
					__item, __layer, __depth,
					__x, __y, __z,
					__scale, __rotation,
					args
				);
		}

//------------------------------------------------------------------------------------------
		public function initXLogicObjectRel (
			__parent:XLogicObject,
			__logicObject:XLogicObject,
			__item:XMapItemModel, __layer:Int, __depth:Float, __relative:Bool,
			__x:Float, __y:Float, __z:Float, 
			__scale:Float, __rotation:Float,
			args:Array<Dynamic> /* <Dynamic> */ = null
			):XLogicObject {
				
			args = (args == null) ? args = [] : args;
			
			return __initXLogicObjectRel (
					__parent,
					__logicObject,
					null,
					__item, __layer, __depth, __relative,
					__x, __y, __z,
					__scale, __rotation,
					args
				);
		}
					
//------------------------------------------------------------------------------------------
		public function __initXLogicObject (
			__parent:XLogicObject,
			__logicObject:XLogicObject,
			__class:Class<Dynamic> /* <Dynamic> */,
			__item:XMapItemModel, __layer:Int, __depth:Float,
			__x:Float, __y:Float, __z:Float, 
			__scale:Float, __rotation:Float,
			args:Array<Dynamic> /* <Dynamic> */ = null
			):XLogicObject {

			xxx.addChild (__logicObject);
			
			__logicObject.oXLogicManager = this;
			__logicObject.setDepth (__depth);
			__logicObject.setRelativeDepthFlag (false);
			__logicObject.setLayer (__layer);
									
//			trace (": XLogicManager:init: ", __logicObject, args.length, args);
							
			__logicObject.setup (xxx, args);

			__logicObject.setItem (__item);
//			__logicObject.setPos (new XPoint (__x, __y));
			__logicObject.oX = __x;
			__logicObject.oY = __y;
//			__logicObject.setLayer (__layer);
//			__logicObject.setDepth (__depth);
			__logicObject.setScale (__scale);
			__logicObject.setRotation (__rotation);
			__logicObject.setParent (__parent);
			__logicObject.oAlpha = 1.0;
			
			if (__class != null) {
				__logicObject.setPoolClass (__class);
			}
			
			__logicObject.setupX ();
						
//			xxx.addChild (__logicObject);
			
			m_XLogicObjects.set (__logicObject, 0);
			
			if (__parent == null) {
				m_XLogicObjectsTopLevel.set (__logicObject, 0);
			}
			
			return __logicObject;
		}
		
//------------------------------------------------------------------------------------------
		public function __initXLogicObjectRel (
			__parent:XLogicObject,
			__logicObject:XLogicObject,
			__class:Class<Dynamic> /* <Dynamic> */,
			__item:XMapItemModel, __layer:Int, __depth:Float, __relative:Bool,
			__x:Float, __y:Float, __z:Float, 
			__scale:Float, __rotation:Float,
			args:Array<Dynamic> /* <Dynamic> */ = null
			):XLogicObject {

			xxx.addChild (__logicObject);
			
			__logicObject.oXLogicManager = this;
			__logicObject.setDepth (__depth);
			__logicObject.setRelativeDepthFlag (__relative);
			__logicObject.setLayer (__layer);

//			trace (": XLogicManager:init: ", __logicObject, args.length, args);
							
			__logicObject.setup (xxx, args);

			__logicObject.setItem (__item);
//			__logicObject.setPos (new XPoint (__x, __y));
			__logicObject.oX = __x;
			__logicObject.oY = __y;
//			__logicObject.setLayer (__layer);
//			__logicObject.setDepth (__depth);
			__logicObject.setScale (__scale);
			__logicObject.setRotation (__rotation);
			__logicObject.setParent (__parent);
			__logicObject.oAlpha = 1.0;
			
			if (__class != null) {
				__logicObject.setPoolClass (__class);
			}
			
			__logicObject.setupX ();
						
//			xxx.addChild (__logicObject);
			
			m_XLogicObjects.set (__logicObject, 0);
			
			if (__parent == null) {
				m_XLogicObjectsTopLevel.set (__logicObject, 0);
			}
			
			return __logicObject;
		}

//------------------------------------------------------------------------------------------
		public function killLater (__object:XLogicObject):Void {
//			trace (": kill? ", __object);
			
			if (!m_killQueue.exists (__object)) {
				m_killQueue.set (__object, 0);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function emptyKillQueue ():Void {	
			for (__key__ in m_killQueue.keys ()) {
				function (x:Dynamic /* */):Void {
					var __logicObject:XLogicObject = cast x; /* as XLogicObject */
					
					if (!__logicObject.cleanedUp) {
						__logicObject.cleanup ();
					}
					
					removeXLogicObject (__logicObject);
					
					m_killQueue.remove (__logicObject);
				} (__key__);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeXLogicObject (x:XLogicObject):Void {
			if (m_XLogicObjects.exists (x)) {
				m_XLogicObjects.remove (x);
			}
						
			if (m_XLogicObjectsTopLevel.exists (x)) {
				m_XLogicObjectsTopLevel.remove (x);
			}
				
//			trace (": kill: ", x, x.m_GUID, x.xxx, xxx);
				
			if (xxx.contains (x)) {
				xxx.removeChild (x);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function getXLogicObjects ():Map<XLogicObject, Int> /* t<XLogicObject, Int> */ {
			return m_XLogicObjects;
		}

//------------------------------------------------------------------------------------------
		public function updateTasks ():Void {
			m_XTaskManager0.updateTasks ();
			m_XTaskManager.updateTasks ();
			m_XTaskManagerCX.updateTasks ();
		}

//------------------------------------------------------------------------------------------
		public function getXTaskManager0 ():XTaskManager {
			return m_XTaskManager0;
		}

//------------------------------------------------------------------------------------------
		public function getXTaskManager ():XTaskManager {
			return m_XTaskManager;
		}

//------------------------------------------------------------------------------------------
		public function getXTaskManagerCX ():XTaskManager {
			return m_XTaskManagerCX;
		}
		
//------------------------------------------------------------------------------------------
		public function setCollisions ():Void {
			for (__key__ in m_XLogicObjects.keys ()) {
				function (x:Dynamic /* */):Void {
					var __logicObject:XLogicObject = cast x; /* as XLogicObject */
					
					if (!__logicObject.isDead) {
						__logicObject.setCollisions ();
					}
				} (__key__);
			}		
		}
		
//------------------------------------------------------------------------------------------
		public function updateLogic ():Void {
			for (__key__ in m_XLogicObjects.keys ()) {
				function (x:Dynamic /* */):Void {
					var __logicObject:XLogicObject = cast x; /* as XLogicObject */
					
					if (!__logicObject.isDead) {
						__logicObject.updateLogic ();
					}
				} (__key__);
			}		
		}

//------------------------------------------------------------------------------------------
		public function updatePhysics ():Void {
			for (__key__ in m_XLogicObjects.keys ()) {
				function (x:Dynamic /* */):Void {
					var __logicObject:XLogicObject = cast x; /* as XLogicObject */
					
					if (!__logicObject.isDead) {
						__logicObject.updatePhysics ();
					}
				} (__key__);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function cullObjects ():Void {
			for (__key__ in m_XLogicObjectsTopLevel.keys ()) {
				function (x:Dynamic /* */):Void {
					var __logicObject:XLogicObject = cast x; /* as XLogicObject */
					
					if (!__logicObject.isDead) {
						__logicObject.cullObject ();
					}
				} (__key__);
			}
		}

//------------------------------------------------------------------------------------------
		public function setValues ():Void {
			for (__key__ in m_XLogicObjects.keys ()) {
				function (x:Dynamic /* */):Void {
					var __logicObject:XLogicObject = cast x; /* as XLogicObject */
					
					if (!__logicObject.isDead) {
						__logicObject.setValues ();
					}
				} (__key__);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateDisplay ():Void {					
			for (__key__ in m_XLogicObjectsTopLevel.keys ()) {
				function (x:Dynamic /* */):Void {
					var __logicObject:XLogicObject = cast x; /* as XLogicObject */
				
					if (!__logicObject.isDead) {
						__logicObject.x2 = __logicObject.y2 = 0;
						__logicObject.setMasterAlpha (__logicObject.getAlpha ());
						__logicObject.setMasterDepth (__logicObject.getDepth ());
						__logicObject.setMasterVisible (__logicObject.getVisible ());
						__logicObject.setMasterScaleX (__logicObject.getScaleX ());
						__logicObject.setMasterScaleY (__logicObject.getScaleY ());
						__logicObject.setMasterFlipX (__logicObject.getFlipX ());
						__logicObject.setMasterFlipY (__logicObject.getFlipY ());
						__logicObject.setMasterRotation (__logicObject.getRotation ());
								
						__logicObject.updateDisplay ();
					}
				} (__key__);
			}
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
