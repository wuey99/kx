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
	import openfl.events.*;
	
	import kx.collections.*;
	import kx.geom.*;
	import kx.mvc.*;
	import kx.type.*;
	import kx.utils.*;
	import kx.world.collision.*;
	import kx.xmap.*;
	import kx.xml.*;
			
//------------------------------------------------------------------------------------------	
	class XMapLayerModel extends XModelBase {
		private var m_XMap:XMapModel;
		
		private var m_layer:Int;
		
		private var m_XSubmaps:Array<Array<XSubmapModel>>;
		
		private var m_submapRows:Int;
		private var m_submapCols:Int;
		private var m_submapWidth:Int;
		private var m_submapHeight:Int;
		
		private var m_currID:Int;

		private var m_items:Map<XMapItemModel, Int>; // <XMapItemModel, Int>
		private var m_ids:Map<Int, XMapItemModel>; // <Int, XMapItemModel>

		private var m_classNames:XReferenceNameToIndex;
		private var m_imageClassNames:Map<String, Int>; // <String, Int>
		
		private var m_viewPort:XRect;
		
		private var m_visible:Bool;
		private var m_name:String;
		private var m_grid:Bool;
		
		private var m_itemInuse:Map<Int, Int>; // <Int, Int>
		
		private var m_persistentStorage:Map<Int, Dynamic>; // <Int, Dynamic>

		private var m_retrievedSubmaps:Array<XSubmapModel>; // <XSubmapModel>
		private var m_retrievedItems:Array<XMapItemModel>; // <XMapItemModel>
		
		// begin include "..\\World\\Collision\\cx.h";
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
		public var CX_COLLIDE_LF:Int = 0x0001;
		public var CX_COLLIDE_RT:Int = 0x0002;
		public var CX_COLLIDE_HORZ:Int = 0x0001 | 0x0002; 
		public var CX_COLLIDE_UP:Int = 0x0004;
		public var CX_COLLIDE_DN:Int = 0x0008;
		public var CX_COLLIDE_VERT:Int = 0x0004 | 0x0008;
	
		// empty
		public static inline var CX_EMPTY:Int = 0;
		
		// solid solid
		public static inline var CX_SOLID:Int = 1;
		
		// soft
		public static inline var CX_SOFT:Int = 2;	
		
		// jump thru
		public static inline var CX_JUMP_THRU:Int = 3;
		
		// 45 degree diagonals
		public static inline var CX_UL45:Int = 4;
		public static inline var CX_UR45:Int = 5;
		public static inline var CX_LL45:Int = 6;
		public static inline var CX_LR45:Int = 7;
		
		// 22.5 degree diagonals
		public static inline var CX_UL225A:Int = 8;
		public static inline var CX_UL225B:Int = 9;
		public static inline var CX_UR225A:Int = 10;
		public static inline var CX_UR225B:Int = 11;
		public static inline var CX_LL225A:Int = 12;
		public static inline var CX_LL225B:Int = 13;
		public static inline var CX_LR225A:Int = 14;
		public static inline var CX_LR225B:Int = 15;
		
		// 67.5 degree diagonals
		public static inline var CX_UL675A:Int = 16;
		public static inline var CX_UL675B:Int = 17;
		public static inline var CX_UR675A:Int = 18;
		public static inline var CX_UR675B:Int = 19;
		public static inline var CX_LL675A:Int = 20;
		public static inline var CX_LL675B:Int = 21;
		public static inline var CX_LR675A:Int = 22;
		public static inline var CX_LR675B:Int = 23;
		
		// soft tiles
		public static inline var CX_SOFTLF:Int = 24;
		public static inline var CX_SOFTRT:Int = 25;
		public static inline var CX_SOFTUP:Int = 26;
		public static inline var CX_SOFTDN:Int = 27;
	
		// special solids
		public static inline var CX_SOLIDX001:Int = 28;
		
		// death
		public static inline var CX_DEATH:Int = 29;
		
		// ice
		public static inline var CX_ICE:Int = 30;
		
		// max
		public static inline var CX_MAX:Int = 31;
		
		// collision tile width, height
		public static inline var CX_TILE_WIDTH:Int = 16;
		public static inline var CX_TILE_HEIGHT:Int = 16;
		
		public static inline var CX_TILE_WIDTH_MASK:Int = 15;
		public static inline var CX_TILE_HEIGHT_MASK:Int = 15;
		
		public static inline var CX_TILE_WIDTH_UNMASK:Int = 0xfffffff0;
		public static inline var CX_TILE_HEIGHT_UNMASK:Int = 0xfffffff0;
		
		// alternate tile width, height
		public static inline var TX_TILE_WIDTH:Int = 64;
		public static inline var TX_TILE_HEIGHT:Int = 64;
		
		public static inline var TX_TILE_WIDTH_MASK:Int = 63;
		public static inline var TX_TILE_HEIGHT_MASK:Int = 63;
		
		public static inline var TX_TILE_WIDTH_UNMASK:Int = 0xffffffc0;
		public static inline var TX_TILE_HEIGHT_UNMASK:Int = 0xffffffc0;
		// end include "..\\World\\Collision\\cx.h";
		
//------------------------------------------------------------------------------------------	
		public function new () {
			super ();
		}	

//------------------------------------------------------------------------------------------
		public function setup (
			__layer:Int,
			__submapCols:Int, __submapRows:Int,
			__submapWidth:Int, __submapHeight:Int
			):Void {

			var i:Int;
			
			var __row:Int;
			var __col:Int;

			m_submapRows = __submapRows;
			m_submapCols = __submapCols;
			m_submapWidth = __submapWidth;
			m_submapHeight = __submapHeight;

			m_currID = 0;
			m_items = new Map<XMapItemModel, Int> ();  // <XMapItemModel, Int>
			m_ids = new Map<Int, XMapItemModel> ();  // <Int, XMapItemModel>
			m_layer = __layer;
			m_XSubmaps = new Array<Array<XSubmapModel>> ();
			for (i in 0 ... __submapRows) {
				m_XSubmaps.push (null);
			}
			m_visible = true;
			m_name = "layer" + __layer;
			m_grid = false;
			m_retrievedSubmaps = new Array<XSubmapModel> (); // <XSubmapModel>
			m_retrievedItems = new Array<XMapItemModel> (); // <XMapItemModel>
	
			for (__row in 0 ... __submapRows) {
				m_XSubmaps[__row] = new Array<XSubmapModel> ();
				for (i in 0 ... __submapCols) {
					m_XSubmaps[__row].push (null);
				}
				
				for (__col in 0 ... __submapCols) {
					m_XSubmaps[__row][__col] = new XSubmapModel (this, __col, __row, m_submapWidth, m_submapHeight);
				}
			}
			
			m_persistentStorage = new Map<Int, Dynamic> ();  // <Int, Dynamic>
			
			m_classNames = new XReferenceNameToIndex ();
			m_imageClassNames = new Map<String, Int> ();  // <String, Int>
			
			m_itemInuse = new Map<Int, Int> ();  // <Int, Int>
			
			m_viewPort = new XRect ();
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}

//------------------------------------------------------------------------------------------
		public function setParent (__XMap:XMapModel):Void {
			m_XMap = __XMap;
		}

//------------------------------------------------------------------------------------------
		public function getXMapModel ():XMapModel {
			return m_XMap;
		}

//------------------------------------------------------------------------------------------
		public var useArrayItems (get, set):Bool;
		
		public function get_useArrayItems ():Bool {
			return m_XMap.useArrayItems;
		}
		
		public function set_useArrayItems (__val:Bool): Bool {
			return true;			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public function setViewPort (__viewPort:XRect):Void {
			m_viewPort = __viewPort;
		}
		
//------------------------------------------------------------------------------------------
		public var viewPort (get, set):XRect;
		
		public function get_viewPort ():XRect {
			return m_viewPort;
		}
		
		public function set_viewPort (__val:XRect): XRect {
			m_viewPort = __val;
			
			return __val;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var visible (get, set):Bool;
		
		public function get_visible ():Bool {
			return m_visible;
		}

		public function set_visible (__val:Bool): Bool {
			m_visible = __val;
			
			return __val;			
		}
		/* @:end */
	
//------------------------------------------------------------------------------------------
		public var name (get, set):String;
		
		public function get_name ():String {
			return m_name;
		}

		public function set_name (__val:String): String {
			m_name = __val;
			
			return __val;			
		}
		/* @:end */
	
//------------------------------------------------------------------------------------------
		public var grid (get, set):Bool;
		
		public function get_grid ():Bool {
			return m_grid;
		}

		public function set_grid (__val:Bool): Bool {
			m_grid = __val;
			
			return __val;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public function getPersistentStorage ():Map<Int, Dynamic> /* <Int, Dynamic> */ {
			return m_persistentStorage;
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapRows ():Int {
			return m_submapRows;
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapCols ():Int {
			return m_submapCols;
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapWidth ():Int {
			return m_submapWidth;
		}	
		
//------------------------------------------------------------------------------------------
		public function getSubmapHeight ():Int {
			return m_submapHeight;
		}
	
//------------------------------------------------------------------------------------------
		public function getItemInuse (__id:Int):Int {
			/*
			if (m_itemInuse[__id] == null) {
				m_itemInuse[__id] = 0;
			}

			return m_itemInuse[__id];
			*/
			
			if (!m_itemInuse.exists (__id)) {
				m_itemInuse.set (__id, 0);
			}
			
			return m_itemInuse.get (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function setItemInuse (__id:Int, __inuse:Int):Void {
			/*
			if (m_itemInuse[__id] == null) {
				m_itemInuse[__id] = 0;
			}
			
			if (__inuse == 0) {
				delete m_itemInuse[__id];
			}
			else
			{
				m_itemInuse[__id] = __inuse;
			}
			*/
			
			if (!m_itemInuse.exists (__id)) {
				m_itemInuse.set (__id, 0);
			}
			
			if (__inuse == 0) {
				m_itemInuse.remove (__id);
			}
			else
			{
				m_itemInuse.set (__id, __inuse);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function addItem (__item:XMapItemModel):XMapItemModel {
			var __c1:Int, __r1:Int, __c2:Int, __r2:Int;
			
			var __id:Int = __item.getID ();
			
			if (__id == -1) {
// obtain unique ID for this item			
				__id = generateID ();
				
				__item.setID (__id);
			}
			
			var r:XRect = __item.boundingRect.cloneX ();
			r.offset (__item.x, __item.y);
			
// determine submaps that the item straddles
			__c1 = Std.int (r.left/m_submapWidth);
			__r1 = Std.int (r.top/m_submapHeight);
			
			__c2 = Std.int (r.right/m_submapWidth);
			__r2 = Std.int (r.bottom/m_submapHeight);

			trace (": -----------------------: ");
			trace (": XXMapLayerModel: addItem: ", __id);
			trace (": x, y: ", __item.x, __item.y);
			trace (": ", r.left, r.top, r.right, r.bottom);
			trace (": ", __c1, __r1, __c2, __r2);
			
			__c1 = XType.max (__c1, 0);
			__c2 = XType.max (__c2, 0);
			__r1 = XType.max (__r1, 0);
			__r2 = XType.max (__r2, 0);
			
			__c1 = XType.min (__c1, m_submapCols-1);
			__c2 = XType.min (__c2, m_submapCols-1);
			__r1 = XType.min (__r1, m_submapRows-1);
			__r2 = XType.min (__r2, m_submapRows-1);
			
			/*
// ul
			m_XSubmaps[__r1][__c1].addItem (__item);
// ur
			m_XSubmaps[__r1][__c2].addItem (__item);
// ll
			m_XSubmaps[__r2][__c1].addItem (__item);
// lr
			m_XSubmaps[__r2][__c2].addItem (__item);
			*/
			
			var __r:Int;
			var __c:Int;
			
			for (__r in __r1 ... __r2+1) {
				for (__c in __c1 ... __c2+1) {
					m_XSubmaps[__r][__c].addItem (__item);
				}
			}
			
			trackItem (__item);
			
			return __item;
		}

//------------------------------------------------------------------------------------------
		public function replaceItems (__item:XMapItemModel):Array<XMapItemModel> /* <XMapItemModel> */ {
			var __c1:Int, __r1:Int, __c2:Int, __r2:Int;
			
			var __id:Int = __item.getID ();
			
			if (__id == -1) {
				// obtain unique ID for this item			
				__id = generateID ();
				
				__item.setID (__id);
			}
			
			var __removedItems:Array<XMapItemModel> /* <XMapItemModel> */ = new Array<XMapItemModel> (); // <XMapItemModel>
			
			var r:XRect = __item.boundingRect.cloneX ();
			r.offset (__item.x, __item.y);
			
			// determine submaps that the item straddles
			__c1 = Std.int (r.left/m_submapWidth);
			__r1 = Std.int (r.top/m_submapHeight);
			
			__c2 = Std.int (r.right/m_submapWidth);
			__r2 = Std.int (r.bottom/m_submapHeight);
			
			trace (": -----------------------: ");
			trace (": XXMapLayerModel: replaceItems: ", __id);
			trace (": x, y: ", __item.x, __item.y);
			trace (": ", r.left, r.top, r.right, r.bottom);
			trace (": ", __c1, __r1, __c2, __r2);
			
			__c1 = XType.max (__c1, 0);
			__c2 = XType.max (__c2, 0);
			__r1 = XType.max (__r1, 0);
			__r2 = XType.max (__r2, 0);
			
			__c1 = XType.min (__c1, m_submapCols-1);
			__c2 = XType.min (__c2, m_submapCols-1);
			__r1 = XType.min (__r1, m_submapRows-1);
			__r2 = XType.min (__r2, m_submapRows-1);
			
			function __extend (__items:Array<XMapItemModel> /* <XMapItemModel> */):Void {
				var __item:XMapItemModel;
				
				var i:Int;
				
				//				for each (var __item:XMapItemModel in __items) {
				for (i in 0 ... __items.length) {
					__item = cast __items[i]; /* as XMapItemModel */
					
					if (__removedItems.indexOf (__item) == -1) {
						__removedItems.push (__item);
					}
				}
			}
			
			// ul
			__extend (m_XSubmaps[__r1][__c1].replaceItems (__item));
			// ur
			__extend (m_XSubmaps[__r1][__c2].replaceItems (__item));
			// ll
			__extend (m_XSubmaps[__r2][__c1].replaceItems (__item));
			// lr
			__extend (m_XSubmaps[__r2][__c2].replaceItems (__item));
			
			trackItem (__item);
			
			return __removedItems;
		}
		
//------------------------------------------------------------------------------------------
		public function removeItem (__item:XMapItemModel):Void {		
//			if (!m_items.exists (__item)) {
//				return;
//			}
			
			var __c1:Int, __r1:Int, __c2:Int, __r2:Int;
		
			var r:XRect = __item.boundingRect.cloneX ();
			r.offset (__item.x, __item.y);
			
// determine submaps that the item straddles
			__c1 = Std.int (r.left/m_submapWidth);
			__r1 = Std.int (r.top/m_submapHeight);
			
			__c2 = Std.int (r.right/m_submapWidth);
			__r2 = Std.int (r.bottom/m_submapHeight);

			__c1 = XType.max (__c1, 0);
			__c2 = XType.max (__c2, 0);
			__r1 = XType.max (__r1, 0);
			__r2 = XType.max (__r2, 0);
			
			__c1 = XType.min (__c1, m_submapCols-1);
			__c2 = XType.min (__c2, m_submapCols-1);
			__r1 = XType.min (__r1, m_submapRows-1);
			__r2 = XType.min (__r2, m_submapRows-1);
			
			/*
// ul
			m_XSubmaps[__r1][__c1].removeItem (__item);
// ur
			m_XSubmaps[__r1][__c2].removeItem (__item);
// ll
			m_XSubmaps[__r2][__c1].removeItem (__item);
// lr
			m_XSubmaps[__r2][__c2].removeItem (__item);
			*/
	
			var __r:Int;
			var __c:Int;
			
			for (__r in __r1 ... __r2+1) {
						for (__c in __c1 ... __c2+1) {
					m_XSubmaps[__r][__c].removeItem (__item);
				}
			}
			
			untrackItem (__item);
		}
				
//------------------------------------------------------------------------------------------
		public function getSubmapsAt (
				__x1:Float, __y1:Float,
				__x2:Float, __y2:Float
				):Array<XSubmapModel> /* <XSubmapModel> */ {
					
			var __c1:Int, __r1:Int, __c2:Int, __r2:Int;
	
// determine submaps that the rect straddles
			__c1 = Std.int (__x1/m_submapWidth);
			__r1 = Std.int (__y1/m_submapHeight);
			
			__c2 = Std.int (__x2/m_submapWidth);
			__r2 = Std.int (__y2/m_submapHeight);

			var __row:Int, __col:Int;
						
//			var __submaps:Array = new Array ();
//			m_retrievedSubmaps.length = 0;
			XType.clearArray (m_retrievedSubmaps);
			
			__c1 = XType.max (__c1, 0);
			__c2 = XType.min (__c2, m_submapCols-1);
			__r1 = XType.max (__r1, 0);
			__r2 = XType.min (__r2, m_submapRows-1);
									
			var push:Int = 0;
			
			for (__row in __r1 ... __r2+1) {
				for (__col in __c1 ... __c2+1) {
					m_retrievedSubmaps[push++] = ( m_XSubmaps[__row][__col] );
				}
			}
												
			return m_retrievedSubmaps;
		}	
		
//------------------------------------------------------------------------------------------
		public function getItemsAt (
				__x1:Float, __y1:Float,
				__x2:Float, __y2:Float
				):Array<XMapItemModel> /* <XMapItemModel> */ {
			
			if (useArrayItems) {
				return getArrayItemsAt (__x1, __y1, __x2, __y2);
			}
			
			var submaps:Array<XSubmapModel> /* <XSubmapModel> */ = getSubmapsAt (__x1, __y1, __x2, __y2);
			
			var i:Int;
			var src_items:Map<XMapItemModel, Int>;  // <XMapItemModel, Int>
//			var dst_items:Array = new Array ();
//			m_retrievedItems.length = 0;
			XType.clearArray (m_retrievedItems);
			var x:Dynamic /* */;
			var item:XMapItemModel;
			
			var __x:Float, __y:Float;
			var b:XRect;
						
			var push:Int= 0;
			
			for (i in 0 ... submaps.length) {
				src_items = submaps[i].items ();
											
				for (__key__ in src_items.keys ()) {
					function (x:Dynamic /* */):Void {
						item = cast x; /* as XMapItemModel */
						
						b = item.boundingRect; __x = item.x; __y = item.y;
						
						if (
							!(__x2 < b.left + __x || __x1 > b.right + __x ||
							  __y2 < b.top + __y || __y1 > b.bottom + __y)
							) {
								
//							if (!(item in dst_items)) {
								m_retrievedItems[push++] = (item);
//							}
						}
					} (__key__);
				}
			}
			
			return m_retrievedItems;		
		}

//------------------------------------------------------------------------------------------
		public function getArrayItemsAt (
			__x1:Float, __y1:Float,
			__x2:Float, __y2:Float
		):Array<XMapItemModel> /* <XMapItemModel> */ {
			
			var submaps:Array<XSubmapModel> /* <XSubmapModel> */ = getSubmapsAt (__x1, __y1, __x2, __y2);
			
			var i:Int;
			var src_items:Array<XMapItemModel>;
//			var dst_items:Array = new Array ();
//			m_retrievedItems.length = 0;
			XType.clearArray (m_retrievedItems);
			var item:XMapItemModel;
			
			var __length:Int;
			var __x:Float, __y:Float;
			var b:XRect;
			
			var push:Int = 0;
			
			for (i in 0 ... submaps.length) {
				src_items = submaps[i].arrayItems ();
				
				__length = src_items.length;
				
				for (x in 0 ... __length) {
					item = src_items[x];
						
					b = item.boundingRect; __x = item.x; __y = item.y;
						
					if (
						!(__x2 < b.left + __x || __x1 > b.right + __x ||
						__y2 < b.top + __y || __y1 > b.bottom + __y)
					) {
							
//						if (!(item in dst_items)) {
							m_retrievedItems[push++] = (item);
//						}
					}
				}
			}
			
			return m_retrievedItems;		
		}
		
//------------------------------------------------------------------------------------------
		public function getItemsAtCX (
				__x1:Float, __y1:Float,
				__x2:Float, __y2:Float
				):Array<XMapItemModel> /* <XMapItemModel> */ {
			
			if (useArrayItems) {
				return getArrayItemsAtCX (__x1, __y1, __x2, __y2);
			}
			
			__x2--; __y2--;
			
			var submaps:Array<XSubmapModel> /* <XSubmapModel> */ = getSubmapsAt (__x1, __y1, __x2, __y2);
							
			var i:Int;
			var src_items:Map<XMapItemModel, Int>;  // <XMapItemModel, Int>
			var dst_items:Array<XMapItemModel> /* <XMapItemModel> */ = new Array<XMapItemModel> () /* <XMapItemModel> */ ;
			var x:Dynamic /* */;
			var item:XMapItemModel;

			trace (": ---------------------: ");	
			trace (": getItemsAt: submaps: ", submaps.length);
			trace (": ---------------------: ");
				
			for (i in 0 ... submaps.length) {
				src_items = submaps[i].items ();
								
				for (__key__ in src_items.keys ()) {
					function (x:Dynamic /* */):Void {
						item = cast x; /* as XMapItemModel */
				
						var cx:XRect = item.collisionRect.cloneX ();
						cx.offset (item.x, item.y);
						
						if (
							!(__x2 < cx.left || __x1 > cx.right - 1 ||
							  __y2 < cx.top || __y1 > cx.bottom - 1)
							) {
								
							if (dst_items.indexOf (item) == -1) {
								dst_items.push (item);
							}
						}
					} (__key__);
				}
			}
			
			return dst_items;		
		}

//------------------------------------------------------------------------------------------
		public function getArrayItemsAtCX (
			__x1:Float, __y1:Float,
			__x2:Float, __y2:Float
		):Array<XMapItemModel> /* <XMapItemModel> */ {
			
			__x2--; __y2--;
			
			var submaps:Array<XSubmapModel> /* <XSubmapModel> */ = getSubmapsAt (__x1, __y1, __x2, __y2);
			
			var i:Int;
			var src_items:Array<XMapItemModel>;
			var dst_items:Array<XMapItemModel> /* <XMapItemModel> */ = new Array<XMapItemModel> () /* <XMapItemModel> */;
			var item:XMapItemModel;

			var __length:Int;
			
			trace (": ---------------------: ");	
			trace (": getItemsAt: submaps: ", submaps.length);
			trace (": ---------------------: ");
			
			for (i in 0 ... submaps.length) {
				src_items = submaps[i].arrayItems ();
				
				__length = src_items.length;
				
				for (x in 0 ... __length) {
					item = src_items[x];
					
					var cx:XRect = item.collisionRect.cloneX ();
					cx.offset (item.x, item.y);
						
					if (
						!(__x2 < cx.left || __x1 > cx.right - 1 ||
						__y2 < cx.top || __y1 > cx.bottom - 1)
					) {
							
						if (dst_items.indexOf (item) == -1) {
							dst_items.push (item);
						}
					}
				}
			}
			
			return dst_items;		
		}
		
//------------------------------------------------------------------------------------------
		public function getCXTiles (
			c1:Int, r1:Int,
			c2:Int, r2:Int
		):Array<Int> /* <Int> */ {
			
// tile array to return
			var tiles:Array<Int>; // <Int>

// col, row divisor
			var row32:Int = Std.int (m_submapHeight/CX_TILE_HEIGHT);
			var col32:Int = Std.int (m_submapWidth/CX_TILE_WIDTH);

// col, row mask for the submap
			var rowMask:Int = Std.int (row32-1);
			var colMask:Int = Std.int (col32-1);
			
// total columns wide, rows high
			var cols:Int = c2-c1+1;
			var rows:Int = r2-r1+1;

			tiles = new Array<Int> (); // <Int>
			for (i in 0 ... cols * rows) {
				tiles.push (0);
			}
			
			for (row in r1 ... r2+1) {
				var submapRow:Int = Std.int (row/row32);
				
				for (col in c1 ... c2+1) {
					var dstCol:Int = col-c1, dstRow:Int = row-r1;
					
					var submapCol:Int = Std.int (col/col32);
				
					tiles[dstRow * cols + dstCol] =
						m_XSubmaps[submapRow][submapCol].getCXTile (col & colMask, row & rowMask);
				}
			}
			
			return tiles;
		}

//------------------------------------------------------------------------------------------
		public function setCXTiles (
			tiles:Array<Int> /* <Int> */,
			c1:Int, r1:Int,
			c2:Int, r2:Int
		):Void {
// col, row divisor
			var row32:Int = Std.int (m_submapHeight/CX_TILE_HEIGHT);
			var col32:Int = Std.int (m_submapWidth/CX_TILE_WIDTH);

// col, row mask for the submap
			var rowMask:Int = Std.int (row32-1);
			var colMask:Int = Std.int (col32-1);
			
// total columns wide, rows high
			var cols:Int = c2-c1+1;
			var rows:Int = r2-r1+1;
	
			for (row in r1 ... r2+1) {
				var submapRow:Int = Std.int (row/row32);
				
				for (col in c1 ... c2+1) {
					var dstCol:Int = col-c1, dstRow:Int = row-r1;
					
					var submapCol:Int = Std.int (col/col32);
								
					m_XSubmaps[submapRow][submapCol].setCXTile (
						tiles[dstRow * cols + dstCol],
						col & colMask, row & rowMask
					);
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function eraseWithCXTiles (
			tiles:Array<Int> /* <Int> */,
			c1:Int, r1:Int,
			c2:Int, r2:Int
		):Void {
// col, row divisor
			var row32:Int = Std.int (m_submapHeight/CX_TILE_HEIGHT);
			var col32:Int = Std.int (m_submapWidth/CX_TILE_WIDTH);

// col, row mask for the submap
			var rowMask:Int = Std.int (row32-1);
			var colMask:Int = Std.int (col32-1);
					
// total columns wide, rows high
			var cols:Int = c2-c1+1;
			var rows:Int = r2-r1+1;
	
			for (row in r1 ... r2+1) {
				var submapRow:Int = Std.int (row/row32);
				
				for (col in c1 ... c2+1) {
					var dstCol:Int = col-c1, dstRow:Int = row-r1;
					
					var submapCol:Int = Std.int (col/col32);
								
					m_XSubmaps[submapRow][submapCol].setCXTile (
						CX_EMPTY,
						col & colMask, row & rowMask
					);
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateItem (__item:XMapItemModel):Void {
		}
		
//------------------------------------------------------------------------------------------
		public function generateID ():Int {
			m_currID += 1;
			
			return m_currID;
		}
				
//------------------------------------------------------------------------------------------
		public function items0 ():Map<XMapItemModel, Int> /* <XMapItemModel, Int> */ {
			return m_items;
		}
		
//------------------------------------------------------------------------------------------
		public function ids ():Map<Int, XMapItemModel> /* <Int, XMapItemModel> */ {
			return m_ids;
		}
		
//------------------------------------------------------------------------------------------
		public function submaps ():Array<Array<XSubmapModel>> {
			return m_XSubmaps;
		}
		
//------------------------------------------------------------------------------------------
		public function ___getItemId___ (__item:XMapItemModel):Int {
			return m_items.get (__item);
		}	
		
//------------------------------------------------------------------------------------------
		public function ___getIdItem___ (__id:Int):XMapItemModel {
			return m_ids.get (__id);
		}

//------------------------------------------------------------------------------------------
		public function trackItem (__item:XMapItemModel):Void {
			m_items.set (__item, __item.id);
			m_ids.set (__item.id, __item);
		}
		
//------------------------------------------------------------------------------------------
		public function untrackItem (__item:XMapItemModel):Void {
			m_items.remove (__item);
			m_ids.remove (__item.id);
		}
		
//------------------------------------------------------------------------------------------
		public function getClassNameFromIndex (__index:Int):String {
			return m_classNames.getReferenceNameFromIndex (__index);
		}

//------------------------------------------------------------------------------------------
		public function getIndexFromClassName (__className:String):Int {
			return m_classNames.getIndexFromReferenceName (__className);
		}

//------------------------------------------------------------------------------------------
		public function removeIndexFromClassNames (__index:Int):Void {
			m_classNames.removeIndexFromReferenceNames (__index);
		}

//------------------------------------------------------------------------------------------
		public function getAllClassNames ():Array<String> /* <String> */ {
			return m_classNames.getAllReferenceNames ();
		}

//------------------------------------------------------------------------------------------
		public function getClassNames ():XReferenceNameToIndex {
			return m_classNames;
		}

//------------------------------------------------------------------------------------------
		public function getImageClassNames ():Map<String, Int> /* <String, Int> */ {
			return m_imageClassNames;
		}

//------------------------------------------------------------------------------------------
		public function lookForItem (__itemName:String, __list:Map<Int, XMapItemModel>=null):Map<Int, XMapItemModel> /* <Int, XMapItemModel> */ {
			var __row:Int, __col:Int;
			
			if (__list == null) {
				__list = new Map<Int, XMapItemModel> (); // <Int, XMapItemModel>
			}
		
			for (__row in 0 ... m_submapRows) {
				for (__col in 0 ... m_submapCols) {
					m_XSubmaps[__row][__col].iterateAllItems (
						function (x:Dynamic /* */):Void {
							var __item:XMapItemModel = cast x; /* as XMapItemModel */
								
							if (__item.XMapItem == __itemName) {
								__list.set (__item.id, __item);
							}
						}
					);
				}
			}
			
			return __list;	
		}

//------------------------------------------------------------------------------------------
		public function iterateAllSubmaps (__iterationCallback:Dynamic /* Function */):Void {
			var __row:Int, __col:Int;
			
			for (__row in 0 ... m_submapRows) {
				for (__col in 0 ... m_submapCols) {
					__iterationCallback (m_XSubmaps[__row][__col], __row, __col);
				}
			}				
		}
		
//------------------------------------------------------------------------------------------
		public function serialize (__xml:XSimpleXMLNode):XSimpleXMLNode {
			var __attribs:Array<Dynamic> /* <Dynamic> */ = [
				"vx",			viewPort.x,
				"vy",			viewPort.y,
				"vw",			viewPort.width,
				"vh",			viewPort.height,
				"layer",		m_layer,
				"submapRows",	m_submapRows,
				"submapCols",	m_submapCols,
				"submapWidth",	m_submapWidth,
				"submapHeight",	m_submapHeight,
				"currID",		m_currID,
				"visible", 		m_visible,
				"name",			m_name,
				"grid", 		m_grid,
			];

			__xml = __xml.addChildWithParams ("XLayer", "", __attribs);
	
			__xml.addChildWithXMLNode (serializeImageClassNames ());
			__xml.addChildWithXMLNode (m_classNames.serialize ());
			__xml.addChildWithXMLNode (serializeItems ());
			__xml.addChildWithXMLNode (serializeSubmaps ());

			return __xml;
		}

//------------------------------------------------------------------------------------------
		public function serializeItems ():XSimpleXMLNode {
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			xml.setupWithParams ("items", "", []);
		
			return xml;
		}
		
//------------------------------------------------------------------------------------------
		public function serializeSubmaps ():XSimpleXMLNode {
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			xml.setupWithParams ("XSubmaps", "", []);
			
			var __row:Float, __col:Float;
			var __x1:Float, __y1:Float, __x2:Float, __y2:Float;
			
			cullUnneededItems ();
			
			for (__row in 0 ... m_submapRows) {
				__y1 = __row * m_submapHeight;
				__y2 = __y1 + m_submapHeight-1;
				
				for (__col in 0 ... m_submapCols) {
					__x1 = __col * m_submapWidth;
					__x2 = __x1 + m_submapWidth-1;
					
					var submaps:Array<XSubmapModel> /* <XSubmapModel> */ = getSubmapsAt (__x1, __y1, __x2, __y2);
					
					if (submaps.length == 1) {
						var submap:XSubmapModel = cast submaps[0]; /* as XSubmapModel */
						
						if (submapIsNotEmpty (submap)) {
							xml.addChildWithXMLNode (submap.serializeRowCol (__row, __col));
						}
					}
				}
			}
			
			return xml;
		}

//------------------------------------------------------------------------------------------
		public function serializeImageClassNames ():XSimpleXMLNode {
			var __imageClassNames:Map<String, Int> /* <String, Int> */ = new Map<String, Int> (); // <String, Int>
			
			var __row:Float, __col:Float;
			
			for (__row in 0 ... m_submapRows) {
				for (__col in 0 ... m_submapCols) {
					for (__key__ in m_XSubmaps[__row][__col].items ().keys ()) {
						function (__item:XMapItemModel):Void {
							__imageClassNames.set (__item.imageClassName, 0);
						} (__key__);
					}
				}
			}
	
			var __xml:XSimpleXMLNode = new XSimpleXMLNode ();		
			__xml.setupWithParams ("imageClassNames", "", []);
					
			for (__key__ in __imageClassNames.keys ()) {
				function (__imageClassName:Dynamic /* */):Void {
					var __attribs:Array<Dynamic> /* <Dynamic> */ = [
						"name",	cast(__imageClassName, String) ,					
					];
					
					var __className:XSimpleXMLNode = new XSimpleXMLNode ();				
					__className.setupWithParams ("imageClassName", "", __attribs);
					__xml.addChildWithXMLNode (__className);
				} (__key__);
			}
			
			return __xml;
		}
		
//------------------------------------------------------------------------------------------
		public function submapIsNotEmpty (submap:XSubmapModel):Bool {
			var count:Float = 0;
					
			for (__key__ in submap.items ().keys ()) {
				function (x:Dynamic /* */):Void {	
					count++;
				} (__key__);
			}
			
			return count > 0 || submap.hasCXTiles ();
		}

//------------------------------------------------------------------------------------------
		public function deserialize (__xml:XSimpleXMLNode, __readOnly:Bool=false):Void {
			trace (": [XMapLayer]: deserialize: ");
			
			m_viewPort = new XRect (
				__xml.getAttributeFloat ("vx"),
				__xml.getAttributeFloat ("vy"),
				__xml.getAttributeFloat ("vw"),
				__xml.getAttributeFloat ("vh")
			);
			
			m_layer = __xml.getAttributeInt ("layer");
			m_submapRows = __xml.getAttributeInt ("submapRows");
			m_submapCols = __xml.getAttributeInt ("submapCols");
			m_submapWidth = __xml.getAttributeInt ("submapWidth");
			m_submapHeight = __xml.getAttributeInt ("submapHeight");
			m_currID = __xml.getAttribute ("currID");
			if (__xml.hasAttribute ("visible")) {
				m_visible = __xml.getAttributeBoolean ("visible");
			}
			else
			{
				m_visible = true;
			}
			if (__xml.hasAttribute ("name")) {
				m_name = __xml.getAttributeString ("name");
			}
			else
			{
				m_name = "";
			}
			if (__xml.hasAttribute ("grid")) {
				m_grid = __xml.getAttributeBoolean ("grid");
			}
			else
			{
				m_grid = false;
			}	
			
			m_persistentStorage = new Map<Int, Dynamic> ();  // <Int, Dynamic>
			
			m_classNames = new XReferenceNameToIndex ();
			m_imageClassNames = new Map<String, Int> (); // <String, Int>

			m_itemInuse = new Map<Int, Int> ();  // <Int, Int>
			
			m_items = new Map<XMapItemModel, Int> (); // <XMapItemModel, Int>
			m_ids = new Map<Int, XMapItemModel> (); // <Int, XMapItemModel>
			m_XSubmaps = new Array<Array<XSubmapModel>> ();
			for (i in 0 ... m_submapRows) {
				m_XSubmaps.push (null);
			}
			m_retrievedSubmaps = new Array<XSubmapModel> (); // <XSubmapModel>
			m_retrievedItems = new Array<XMapItemModel> (); // <XMapItemModel>
			
			deserializeImageClassNames (__xml);
			m_classNames.deserialize (__xml);
			deserializeItems (__xml);
			deserializeSubmaps (__xml, __readOnly);
		}
	
//------------------------------------------------------------------------------------------
		public function deserializeItems (__xml:XSimpleXMLNode):Void {
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeSubmaps (__xml:XSimpleXMLNode, __readOnly:Bool):Void {
			trace (": [XMapLayer]: deserializeSubmaps: ");
			
//------------------------------------------------------------------------------------------
			trace (": creating XSubmaps: ");
			
			var __row:Int;
			var __col:Int;
			
			if (__readOnly) {
				var __empty:XSubmapModel = new XSubmapModel (this, 0, 0, m_submapWidth, m_submapHeight);

				for (__row in 0 ... m_submapRows) {
					m_XSubmaps[__row] = new Array<XSubmapModel> ();
					
					for (__col in 0 ... m_submapCols) {
						m_XSubmaps[__row].push (__empty);
					}
				}
			}
			else
			{
				for (__row in 0 ... m_submapRows) {
					m_XSubmaps[__row] = new Array<XSubmapModel> ();
	
					for (__col in 0 ... m_submapCols) {
						m_XSubmaps[__row].push (new XSubmapModel (this, __col,__row, m_submapWidth, m_submapHeight));
					}
				}
			}
			
//------------------------------------------------------------------------------------------
			trace (": deserializing XSubmaps: ");
			
			var __xmlList:Array<XSimpleXMLNode>; // <XSimpleXMLNode>
			var i:Float;
			
			__xmlList = __xml.child ("XSubmaps")[0].child ("XSubmap");
				
			for (i in 0 ... __xmlList.length) {
				var __submapXML:XSimpleXMLNode = __xmlList[i];
				
				__row = __submapXML.getAttributeInt ("row");
				__col = __submapXML.getAttributeInt ("col");
					
				if (__readOnly) {
					m_XSubmaps[__row][__col] = new XSubmapModel (this, __col,__row, m_submapWidth, m_submapHeight);
				}
				
				m_XSubmaps[__row][__col].deserializeRowCol (__submapXML);
			}

//------------------------------------------------------------------------------------------
// we're going to assume that we won't need clean-up with using ArrayItems
//------------------------------------------------------------------------------------------
			if (useArrayItems) {
				return;
			}
			
//------------------------------------------------------------------------------------------	
// add items to the layer's dictionary
//------------------------------------------------------------------------------------------
			trace (": adding items: ");
			
			if (useArrayItems) {
				var src_items:Array<XMapItemModel>;
				var __length:Int;
				
				for (__row in 0 ... m_submapRows) {
					for (__col in 0 ... m_submapCols) {
						src_items = m_XSubmaps[__row][__col].arrayItems ();
						
						__length = src_items.length;
						
						for (x in 0 ... __length) {
							trackItem (src_items[x]);
						}
					}
				}				
			}
			else
			{
				for (__row in 0 ... m_submapRows) {
					for (__col in 0 ... m_submapCols) {
						for (__key__ in m_XSubmaps[__row][__col].items ().keys ()) {
							function (__item:Dynamic /* */):Void {
								trackItem (__item);
							} (__key__);
						}
					}
				}
			}
			
//------------------------------------------------------------------------------------------
			cullUnneededItems ();
		}

//------------------------------------------------------------------------------------------
		public function deserializeImageClassNames (__xml:XSimpleXMLNode):Void {
			if (__xml.child ("imageClassNames").length == 0) {
				return;
			}

			var __xmlList:Array<XSimpleXMLNode> /* <XSimpleXMLNode> */ = __xml.child ("imageClassNames")[0].child ("imageClassName");

			var __name:String;	
			var i:Float;
		
			for (i in 0 ... __xmlList.length) {
				__name = __xmlList[i].getAttributeString ("name");
				
				trace (": deserializeImageClassName: ", __name);
				
				m_imageClassNames.set (__name, 0);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function cullUnneededItems ():Void {
			var __row:Float;
			var __col:Float;
			var __submapRect:XRect; 
										
			for (__row in 0 ... m_submapRows) {
				for (__col in 0 ... m_submapCols) {
					__submapRect = new XRect (
						__col * m_submapWidth, __row * m_submapHeight,
						m_submapWidth, m_submapHeight
					);
							
					for (__key__ in m_XSubmaps[__row][__col].items ().keys ()) {
						function (__item:XMapItemModel):Void {			
							var __itemRect:XRect = __item.boundingRect.cloneX ();
							__itemRect.offset (__item.x, __item.y);
							
							trace (": submapRect, itemRect: ", __item.id, __submapRect, __itemRect, __submapRect.intersects (__itemRect));
							
							if (!__submapRect.intersects (__itemRect)) {
								m_XSubmaps[__row][__col].removeItem (__item);
							}
						} (__key__);
					}
				}
			}		
		}
			
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
