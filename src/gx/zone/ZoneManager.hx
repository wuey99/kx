//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "GX-Engine"
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
package gx.zone;
	
	import gx.*;
	
	import kx.collections.*;
	import kx.geom.*;
	import kx.pool.*;
	import kx.task.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.logic.*;
	import kx.*;
	import kx.xmap.*;
	
	//------------------------------------------------------------------------------------------
	class ZoneManager {
		private var xxx:XWorld;
		private var m_XApp:XApp;
		
		private var m_starterRingItems:Map<Int, XMapItemModel>; /* <Int, XMapItemModel> */
		private var m_starterRingItemObjects:Map<Int, StarterRingControllerX>; /* <Int, StarterRingControllerX> */
		
		private var m_zoneItems:Map<Int, XMapItemModel>; /* <Int, XMapItemModel> */
		private var m_zoneItemObjects:Map<Int, ZoneX>; /* <Int, ZoneX> */
		
		private var m_gateItems:Map<Int, XMapItemModel>; /* <Int, XMapItemModel> */
		private var m_gateItemObjects:Map<Int, GateX>; /* <Int, GateX> */
		
		private var m_currentGateItems:Map<Int, XMapItemModel>; /* <Int, XMapItemModel> */
		private var m_currentGateItemObjects:Map<Int, CurrentGateX>;	/* <Int, CurrentGateX> */
		
		private var m_doorItems:Map<Int, XMapItemModel>; /* <Int, XMapItemModel> */
		private var m_doorItemObjects:Map<Int, DoorX>; /* <Int, DoorX> */
		
		private var m_zoneKillCount:Int;
		
		private var m_playFieldLayer:Int;
		private var m_zoneObjectsMap:Dynamic /* Object */;
		private var m_zoneObjectsMapNoKill:Dynamic /* Object */;
		private var m_Horz_GateX:Class<Dynamic>; // <Dynamic>
		private var m_Vert_GateX:Class<Dynamic>; // <Dynamic>
		private var m_Horz_DoorX:Class<Dynamic>; // <Dynamic>
		private var m_Vert_DoorX:Class<Dynamic>; // <Dynamic>
		private var m_GateArrowX:Class<Dynamic>; // <Dynamic>
		private var m_WaterCurrentX:Class<Dynamic>; // <Dynamic>
		private var m_StarterRingControllerX:Class<Dynamic>; // <Dynamic>
		private var m_ZoneX:Class<Dynamic>; // <Dynamic>
		
		//------------------------------------------------------------------------------------------
		public function new () {
			// super ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setup (
			__xxx:XWorld,
			__XApp:XApp,
			__playfieldLayer:Int,
			__zoneObjectsMap:Dynamic /* Object */,
			__zoneObjectsMapNoKill:Dynamic /* Object */,
			__Horz_GateX:Class<Dynamic> /* <Dynamic> */,
			__Vert_GateX:Class<Dynamic> /* <Dynamic> */,
			__Horz_DoorX:Class<Dynamic> /* <Dynamic> */,
			__Vert_DoorX:Class<Dynamic> /* <Dynamic> */,
			__GateArrowX:Class<Dynamic> /* <Dynamic> */,
			__WaterCurrentX:Class<Dynamic> /* <Dynamic> */,
			__StarterRingControllerX:Class<Dynamic>  /* <Dynamic> */,
			__ZoneX:Class<Dynamic> = null /* <Dynamic> */
		):Void {
			xxx = __xxx;
			m_XApp = __XApp;
			
			m_playFieldLayer = __playfieldLayer;
			
			m_zoneObjectsMap = __zoneObjectsMap;
			m_zoneObjectsMapNoKill = __zoneObjectsMapNoKill;
			
			m_Horz_GateX = __Horz_GateX;
			m_Vert_GateX = __Vert_GateX;
			m_Horz_DoorX = __Horz_DoorX;
			m_Vert_DoorX = __Vert_DoorX;
			m_GateArrowX = __GateArrowX;
			m_WaterCurrentX = __WaterCurrentX;
			m_StarterRingControllerX = __StarterRingControllerX;
			if (__ZoneX == null) {
				m_ZoneX = ZoneX;
			} else {
				m_ZoneX = __ZoneX;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}
		
		//------------------------------------------------------------------------------------------
		public function setCurrentZone (__zone:Int):Void {
			GX.appX.m_currentZone = __zone;
			
			resetZoneKillCount ();
			
			var __layerModel:XMapLayerModel = xxx.getXMapModel ().getLayer (m_playFieldLayer + 0);
			var __currentZoneItemObject:ZoneX = getZoneItemObject (getCurrentZone ());
			var __itemRect:XRect = new XRect ();
			var __list:Map<Int, XMapItemModel> /* <Int, XMapItemModel> */ = new Map<Int, XMapItemModel> (); // <Int, XMapItemModel>
			
			//------------------------------------------------------------------------------------------
			trace (": currentItemZoneObject: ", __currentZoneItemObject, __currentZoneItemObject.boundingRect);
			trace (": itemRect: ", __itemRect);
			
			//------------------------------------------------------------------------------------------
			if (__currentZoneItemObject == null) {
				throw (XType.createError ("no zone item object found!"));	
			}
			
			//------------------------------------------------------------------------------------------
			// find all items that intersect zone's boundingRect
			//------------------------------------------------------------------------------------------
			trace (": zoneRect: ", __currentZoneItemObject.boundingRect);
			
			__layerModel.iterateAllSubmaps (
				function (__XSubmapModel:XSubmapModel, __row:Int, __col:Int):Void {
					__XSubmapModel.iterateAllItems (
						function (x:Dynamic /* */):Void {
							var __item:XMapItemModel = cast x; /* as XMapItemModel */
							
							__item.boundingRect.copy2 (__itemRect);
							__itemRect.offset (__item.x, __item.y);
							
							if (
								__currentZoneItemObject.boundingRect.width != 0 && __currentZoneItemObject.boundingRect.height != 0 &&
								__currentZoneItemObject.boundingRect.intersects (__itemRect) &&
								isValidZoneObjectItem (__item.XMapItem)) {
								trace (": itemRect: ", __item.logicClassName, __itemRect);
								
								__list.set (__item.id, __item);
							}
						}
					);
				}
			);
			
			//------------------------------------------------------------------------------------------
			// find killCount for the zone
			//------------------------------------------------------------------------------------------
			for (__key__ in __list.keys ()) {
				function (__id:Dynamic /* */):Void {
					var __item:XMapItemModel = cast __list.get (__id); /* as XMapItemModel */
					// objects are double instantiated here.  normal XMapLayerView instantiates it first sometimes.
					
					var __logicObject:ZoneObjectCX;
					
					if (__item.inuse == 0) {
						__logicObject = cast GX.appX.getLevelObject ().addXMapItem (__item, 0); /* as ZoneObjectCX */
					}
					else
					{
						__logicObject = cast GX.appX.getLevelObject ().getXLogicObject (__item); /* as ZoneObjectCX */
					}
					
					trace (": setCurrentZone: item: ", __item.logicClassName, __logicObject);
					
					if (__logicObject != null) {
						__logicObject.setAsPersistedObject (true);
						
						if (!isZoneObjectItemNoKill (__item.XMapItem)) {
							addToZoneKillCount ();
						}
					}
				}	 (__key__);
			}
			
			//----------------------------------------------------------------------------------------
			trace (": zoneKillCount: ", m_zoneKillCount);
			
			m_XApp.getXTaskManager ().addTask ([
				XTask.WAIT, 0x0800,
				
				function ():Void {
					if (m_zoneKillCount == 0) {
						GX.appX.fireZoneFinishedSignal ();
					}
				},
				
				XTask.RETN,
			]);
		}
				
		//------------------------------------------------------------------------------------------
		public function getCurrentZone ():Int {
			return GX.appX.m_currentZone;
		}
		
		//------------------------------------------------------------------------------------------
		// m_zoneItems: map of all zone items in the level
		// we iterate through all the zome items and instantiate XLogicObjects for each.
		//      m_zoneItemObjects: map of all the instantiated zoneItemObjects 
		//		
		// m_starterItems: map of all the start items in the level
		// we iterate through all the zone items and instantiate XLogicObjects for each.
		//      m_starterItemObjects: map of all the instantiated startItemObjects
		//
		// m_gateItems: map of all the gate items in the level (horz and vert)
		// we iterate through all the gate items and instantiate XLogicObjects for each.
		//     m_gateItemObjects: map of all the instantiated gateItemObjects
		//------------------------------------------------------------------------------------------
		public function getAllGlobalItems ():Void {
			var __layerModel:XMapLayerModel = xxx.getXMapModel ().getLayer (m_playFieldLayer + 0);
					
			//------------------------------------------------------------------------------------------
			m_zoneItems = __layerModel.lookForItem ("Zone_Item");
					
			m_zoneItemObjects = new Map<Int, ZoneX> (); /* <Int, ZoneX> */
					
			for (__key__ in m_zoneItems.keys ()) {
				function (__id:Dynamic /* */):Void {
					var __item:XMapItemModel = m_zoneItems.get (__id);
							
					var __zoneItemObject:ZoneX = cast xxx.getXLogicManager ().initXLogicObject (
						// parent
						GX.appX.getLevelObject (),
						// logicObject
						cast XType.createInstance (m_ZoneX) /* as XLogicObject */,
						// item, layer, depth
						__item, m_playFieldLayer + 0, 10000,
						// x, y, z
						__item.x, __item.y, 0,
						// scale, rotation
						1.0, 0
					) /* as ZoneX */;
							
					GX.appX.getLevelObject ().addXLogicObject (__zoneItemObject);
							
					__item.inuse++;
							
					m_zoneItemObjects.set (__zoneItemObject.getZone (), __zoneItemObject);
				} (__key__);
			}
					
			//------------------------------------------------------------------------------------------
			m_starterRingItems = __layerModel.lookForItem ("StarterRing_Item");
					
			m_starterRingItemObjects = new Map<Int, StarterRingControllerX> (); /* <Int, StarterRingControllerX> */
					
			for (__key__ in m_starterRingItems.keys ()) {
				function (__id:Dynamic /* */):Void {
					var __item:XMapItemModel = m_starterRingItems.get (__id);
							
					var __starterRingItemObject:StarterRingControllerX = cast xxx.getXLogicManager ().initXLogicObject (
						// parent
						GX.appX.getLevelObject (),
						// logicObject
						cast XType.createInstance (m_StarterRingControllerX) /* as XLogicObject */,
						// item, layer, depth
						__item, m_playFieldLayer + 0, 10000,
						// x, y, z
						__item.x, __item.y, 0,
						// scale, rotation
						1.0, 0
					) /* as StarterRingControllerX */;
							
					GX.appX.getLevelObject ().addXLogicObject (__starterRingItemObject);
							
					__item.inuse++;
							
					m_starterRingItemObjects.set (__starterRingItemObject.getZone (), __starterRingItemObject);
				} (__key__);
			}
					
			//------------------------------------------------------------------------------------------
			m_gateItems = __layerModel.lookForItem ("Horz_Gate_Item");
			m_gateItems = __layerModel.lookForItem ("Vert_Gate_Item", m_gateItems);
					
			m_gateItemObjects = new Map<Int, GateX> (); /* <Int, GateX> */
					
			if (m_Horz_GateX != null && m_Vert_GateX != null)
				for (__key__ in m_gateItems.keys ()) {
					function (__id:Dynamic /* */):Void {
						var __item:XMapItemModel = m_gateItems.get (__id);
								
						var __gateItemObject:GateX;
								
						trace (": gateItems: ", __item.id, __item.XMapItem);
								
						if (__item.XMapItem == "Horz_Gate_Item") {
							__gateItemObject = cast xxx.getXLogicManager ().initXLogicObject (
								// parent
								GX.appX.getLevelObject (),
								// logicObject
								cast XType.createInstance (m_Horz_GateX) /* as XLogicObject */,
								// item, layer, depth
								__item, m_playFieldLayer + 0, 10000,
								// x, y, z
								__item.x, __item.y, 0,
								// scale, rotation
								1.0, 0,
								[
									m_GateArrowX
								]
							) /* as GateX */;
						}
						else
						{
							__gateItemObject = cast xxx.getXLogicManager ().initXLogicObject (
								// parent
								GX.appX.getLevelObject (),
								// logicObject
								cast XType.createInstance (m_Vert_GateX) /* as XLogicObject */,
								// item, layer, depth
								__item, m_playFieldLayer + 0, 10000,
								// x, y, z
								__item.x, __item.y, 0,
								// scale, rotation
								1.0, 0,
								[
									m_GateArrowX
								]
							) /* as GateX */;
						}
								
						GX.appX.getLevelObject ().addXLogicObject (__gateItemObject);
								
						__item.inuse++;
								
						__gateItemObject.setXMapModel (GX.appX.__getMickeyObject ().getLayer () + 1, xxx.getXMapModel (), GX.appX.getLevelObject ());	
					} (__key__);
				}
					
			//------------------------------------------------------------------------------------------
			m_doorItems = __layerModel.lookForItem ("Horz_Door_Item");
			m_doorItems = __layerModel.lookForItem ("Vert_Door_Item", m_doorItems);
					
			m_doorItemObjects = new Map<Int, DoorX> (); /* <Int, DoorX> */
					
			if (m_Horz_DoorX != null && m_Vert_DoorX != null)
				for (__key__ in m_doorItems.keys ()) {
					function (__id:Dynamic /* */):Void {
						var __item:XMapItemModel = m_doorItems.get (__id);
								
						var __doorItemObject:DoorX;
								
						trace (": doorItems: ", __item.id, __item.XMapItem);
								
						if (__item.XMapItem == "Horz_Door_Item") {
							__doorItemObject = cast xxx.getXLogicManager ().initXLogicObject (
								// parent
								GX.appX.getLevelObject (),
								// logicObject
								cast XType.createInstance (m_Horz_DoorX) /* as XLogicObject */,
								// item, layer, depth
								__item, m_playFieldLayer + 0, 10000,
								// x, y, z
								__item.x, __item.y, 0,
								// scale, rotation
								1.0, 0
							) /* as DoorX */;
						}
						else
						{
							__doorItemObject = cast xxx.getXLogicManager ().initXLogicObject (
								// parent
								GX.appX.getLevelObject (),
								// logicObject
								cast XType.createInstance (m_Vert_DoorX) /* as XLogicObject */,
								// item, layer, depth
								__item, m_playFieldLayer + 0, 10000,
								// x, y, z
								__item.x, __item.y, 0,
								// scale, rotation
								1.0, 0
							) /* as DoorX */;
						}
								
						GX.appX.getLevelObject ().addXLogicObject (__doorItemObject);
								
						__item.inuse++;
								
						__doorItemObject.setXMapModel (GX.appX.__getMickeyObject ().getLayer () + 1, xxx.getXMapModel (), GX.appX.getLevelObject ());	
					} (__key__);
				}
					
			//------------------------------------------------------------------------------------------
			m_currentGateItems = __layerModel.lookForItem ("Current_Gate_Item");
					
			m_currentGateItemObjects = new Map<Int, CurrentGateX> (); /* <Int, CurrentGateX> */
					
			for (__key__ in m_currentGateItems.keys ()) {
				function (__id:Dynamic /* */):Void {
					var __item:XMapItemModel = m_currentGateItems.get (__id);
							
					var __currentGateItemObject:CurrentGateX;
							
					trace (": currentGateItems: ", __item.id, __item.XMapItem);
							
					__currentGateItemObject = cast xxx.getXLogicManager ().initXLogicObject (
						// parent
						GX.appX.getLevelObject (),
						// logicObject
						cast new CurrentGateX () /* as XLogicObject */,
						// item, layer, depth
						__item, m_playFieldLayer + 0, 10000,
						// x, y, z
						__item.x, __item.y, 0,
						// scale, rotation
						1.0, 0,
						[
							m_WaterCurrentX
						]
					) /* as CurrentGateX */;
							
					GX.appX.getLevelObject ().addXLogicObject (__currentGateItemObject);
							
					__item.inuse++;
							
					__currentGateItemObject.setXMapModel (GX.appX.__getMickeyObject ().getLayer () + 1, xxx.getXMapModel (), GX.appX.getLevelObject ());	
				} (__key__);
			}
		}
				
		//------------------------------------------------------------------------------------------
		public function isValidZoneObjectItem (__itemName:String):Bool {
			return XType.hasField (m_zoneObjectsMap, __itemName);
		}
				
		//------------------------------------------------------------------------------------------
		public function isZoneObjectItemNoKill (__itemName:String):Bool {
			return XType.hasField (m_zoneObjectsMapNoKill, __itemName);
		}
				
		//------------------------------------------------------------------------------------------
		public function getZoneItems ():Map<Int, XMapItemModel> /* <Int, XMapItemModel> */ {
			return m_zoneItems;
		}
				
		//------------------------------------------------------------------------------------------
		public function getZoneItemObject (__zone:Int):ZoneX {
			if (m_zoneItemObjects.exists (__zone)) {
				return m_zoneItemObjects.get (__zone) /* as ZoneX */;
			}
					
			return null;
		}
				
		//------------------------------------------------------------------------------------------
		public function getStarterRingItems ():Map<Int, XMapItemModel> /* <Int, XMapItemModel> */ {
			return m_starterRingItems;
		}
				
		//------------------------------------------------------------------------------------------
		public function setMickeyToStartPosition (__zone:Int):Void {	
			var __logicObject:StarterRingControllerX = cast m_starterRingItemObjects.get (__zone); /* as StarterRingControllerX */
					
			if (__logicObject.getZone () == __zone) {
				GX.appX.__getMickeyObject ().oX = __logicObject.oX;
				GX.appX.__getMickeyObject ().oY = __logicObject.oY;
				GX.appX.__getMickeyObject ().oRotation = 0;
			}
		}
				
		//------------------------------------------------------------------------------------------
		public function resetZoneKillCount ():Void {
			m_zoneKillCount = 0;
		}
				
		//------------------------------------------------------------------------------------------
		public function addToZoneKillCount ():Void {
			m_zoneKillCount++;
					
			trace (": addToZoneKillCount: ", m_zoneKillCount);
		}
				
		//------------------------------------------------------------------------------------------
		public function removeFromZoneKillCount ():Void {
			m_zoneKillCount--;
					
			trace (": removeFromZoneKillCount: ", m_zoneKillCount);
					
			xxx.getXTaskManager ().addTask ([
				XTask.WAIT, 0x1000,
						
				function ():Void {
					if (m_zoneKillCount == 0) {
						GX.appX.fireZoneFinishedSignal ();
					}
				},
						
				XTask.RETN,
			]);
		}
						
		//------------------------------------------------------------------------------------------
		public function getZoneKillCount ():Int {
			return m_zoneKillCount;
		}
					
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
