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
	import kx.pool.XSubObjectPoolManager;
	import kx.type.*;
	import kx.utils.XReferenceNameToIndex;
	import kx.xml.*;

//------------------------------------------------------------------------------------------	
	class XSubmapModel extends XModelBase {
		private var m_XMapLayer:XMapLayerModel;
			
		private var m_submapWidth:Int;
		private var m_cols:Int;
		
		private var m_submapHeight:Int;
		private var m_rows:Int;
		
		private var m_col:Int;
		private var m_row:Int;
		
		private var m_cmap:Array<Int>;
		private var m_inuse:Int;
		
		private var m_tileCols:Int;
		private var m_tileRows:Int;
		
		private var m_submapWidthMask:Int;
		private var m_submapHeightMask:Int;
		
		private var m_tmap:Array<Array<Dynamic>>;
		
		private var m_boundingRect:XRect;
		
		private var m_src:XRect;
		private var m_dst:XRect;

		private var m_items:Map<XMapItemModel, Int>; // <XMapItemModel, Int>
		private var m_arrayItems:Array<XMapItemModel>;
		private var m_arrayItemIndex:Int;
		
		private var m_XMapItemModelPoolManager:XSubObjectPoolManager;
		private var m_XRectPoolManager:XSubObjectPoolManager;
		
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
		
		private static var CXToChar:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		
//------------------------------------------------------------------------------------------	
		public function new (
			__XMapLayer:XMapLayerModel,
			__col:Int, __row:Int,
			__width:Int, __height:Int
			) {
				
			super ();
			
			var i:Int;
			
			m_XMapLayer = __XMapLayer;
				
			m_submapWidth = __width;
			m_submapHeight = __height;
		
			m_submapWidthMask = m_submapWidth - 1;
			m_submapHeightMask = m_submapHeight - 1;
			
			m_col = __col;
			m_row = __row;
		
			m_cols = Std.int (m_submapWidth/CX_TILE_WIDTH);
			m_rows = Std.int (m_submapHeight/CX_TILE_HEIGHT);

			m_boundingRect = new XRect (0, 0, m_submapWidth, m_submapHeight);
			
			m_cmap = new Array<Int> ();
			for (i in 0 ... m_cols * m_rows) {
				m_cmap.push (0);
			}
			
			for (i in 0 ... m_cmap.length) {
				m_cmap[i] = CX_EMPTY;
			}
		
			m_tileCols = Std.int (m_submapWidth/TX_TILE_WIDTH);
			m_tileRows = Std.int (m_submapHeight/TX_TILE_HEIGHT);
			
			m_tmap = new Array<Array<Dynamic>> (); 
			
			for (i in 0 ... m_tileCols * m_tileRows) {
				m_tmap.push([-1, 0]);
			}
			
			m_inuse = 0;

			m_items = new Map<XMapItemModel, Int> (); // <XMapItemModel, Int>
			m_arrayItems = new Array<XMapItemModel> ();
			m_arrayItemIndex = 0;

			m_src = new XRect ();
			m_dst = new XRect ();
			
			m_XMapItemModelPoolManager = m_XMapLayer.getXMapModel ().getXMapItemModelPoolManager ();
			m_XRectPoolManager = m_XMapLayer.getXMapModel ().getXRectPoolManager ();
		}	

//------------------------------------------------------------------------------------------
		public var useArrayItems (get, set):Bool;
		
		public function get_useArrayItems ():Bool {
			return m_XMapLayer.getXMapModel ().useArrayItems;
		}
	
		public function set_useArrayItems (__val:Bool): Bool {
			return true;			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public var cmap (get, set):Array<Int>;
		
		public function get_cmap ():Array<Int> {
			return m_cmap;
		}
		
		public function set_cmap (__val:Array<Int>): Array<Int> {
			return null;			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public var tmap (get, set):Array<Array<Dynamic>>;
		
		public function get_tmap ():Array<Array<Dynamic>> {
			return m_tmap;
		}
		
		public function set_tmap (__val:Array<Array<Dynamic>>): Array<Array<Dynamic>> {
			return null;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function setCXTile (__type:Int, __col:Int, __row:Int):Void {
			m_cmap[__row * m_cols + __col] = __type;
		}
		
//------------------------------------------------------------------------------------------
		public function getCXTile (__col:Int, __row:Int):Int {
			return m_cmap[__row * m_cols + __col];
		}

//------------------------------------------------------------------------------------------
		public function hasCXTiles ():Bool {
			var __row:Int, __col:Int;
			
			for (__row in 0 ... m_rows) {
				for (__col in 0 ... m_cols) {
					if (m_cmap[__row * m_cols + __col] != CX_EMPTY) {
						return true;
					}
				}
			}
			
			return false;
		}	
		
//------------------------------------------------------------------------------------------
		public var inuse (get, set):Int;
		
		public function get_inuse ():Int {
			return m_inuse;
		}
		
		public function set_inuse (__inuse:Int): Int {
			m_inuse = __inuse;
			
			return __inuse;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var cols (get, set):Int;
		
		public function get_cols ():Int {
			return m_cols;
		}
		
		public function set_cols (__val:Int): Int {
			return 0;			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public var rows (get, set):Int;
		
		public function get_rows ():Int {
			return m_rows;
		}
		
		public function set_rows (__val:Int): Int {
			return 0;			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public var tileCols (get, set):Int;
		
		public function get_tileCols ():Int {
			return m_tileCols;
		}
		
		public function set_tileCols (__val:Int): Int {
			return 0;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var tileRows (get, set):Int;
		
		public function get_tileRows ():Int {
			return m_tileRows;
		}
		
		public function set_tileRows (__val:Int): Int {
			return 0;			
		}
		/* @:end */
				
//------------------------------------------------------------------------------------------
		public var boundingRect (get, set):XRect;
		
		public function get_boundingRect ():XRect {
			return m_boundingRect;
		}
		
		public function set_boundingRect (__val:XRect): XRect {
			m_boundingRect = __val;
			
			return __val;			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public var x (get, set):Float;
		
		public function get_x ():Float {
			return m_col * m_submapWidth;
		}		
		
		public function set_x (__val:Float): Float {
			return 0;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var y (get, set):Float;
		
		public function get_y ():Float {
			return m_row * m_submapHeight;
		}

		public function set_y (__val:Float): Float {
			return 0;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var width (get, set):Int;
		
		public function get_width ():Int {
			return m_submapWidth;
		}
		
		public function set_width (__val:Int): Int {
			return 0;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var height (get, set):Int;
		
		public function get_height ():Int {
			return  m_submapHeight;
		}
		
		public function set_height (__val:Int): Int {
			return 0;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var XMapLayer (get, set):XMapLayerModel;
		
		public function get_XMapLayer ():XMapLayerModel {
			return  m_XMapLayer;
		}
		
		public function set_XMapLayer (__val:XMapLayerModel): XMapLayerModel {
			m_XMapLayer = __val;
			
			return XMapLayer;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function addItem (
			__item:XMapItemModel
			):XMapItemModel {
							
			trace (": XSubmapModel: additem: ",  m_col, m_row, __item.getID (), m_items.exists (__item));
			
			if (!m_items.exists (__item)) {
				m_items.set (__item, __item.id);
			}
					
			return __item;
		}
		
//------------------------------------------------------------------------------------------
		public function addArrayItem (
			__item:XMapItemModel
		):XMapItemModel {
			
//			trace (": XSubmapModel: additemarray: ",  m_col, m_row, __item.getID (), m_items.exists (__item));
			
//			if (!(__item in m_arrayItems)) {
				m_arrayItems[m_arrayItemIndex++] = __item;
//			}
			
			return __item;
		}		

//------------------------------------------------------------------------------------------
		public function replaceItems (
			__item:XMapItemModel
			):Array<XMapItemModel> /* <XMapItemModel> */ {
	
			trace (": XSubmapModel: replaceitem: ",  m_col, m_row, __item.getID (), m_items.exists (__item));
			
			var __removedItems:Array<XMapItemModel> /* <XMapItemModel> */ = new Array<XMapItemModel> (); // <XMapItemModel>
			
			__item.boundingRect.copy2 (m_src);
			m_src.offset (__item.x, __item.y);
			
			for (__key__ in m_items.keys ()) {
				function (x:Dynamic /* */):Void {
					var __dstItem:XMapItemModel = cast x; /* as XMapItemModel */
					
					__dstItem.boundingRect.copy2 (m_dst);
					m_dst.offset (__dstItem.x, __dstItem.y);
					
					if (m_src.intersects (m_dst)) {
						removeItem (__dstItem);
						
						__removedItems.push (__dstItem);
					}
				} (__key__);
			}
			
			addItem (__item);
			
			trace (": XSubmapModel: replaceItems: ", __removedItems);
			
			return __removedItems;
		}
		
//------------------------------------------------------------------------------------------
		public function removeItem (
			__item:XMapItemModel
			):Void {

			trace (": XSubmapModel: removeItem: ",  m_col, m_row, __item.getID (), m_items.exists (__item));
						
			if (m_items.exists (__item)) {
				m_items.remove (__item);
			}
		}
				
//------------------------------------------------------------------------------------------
		public function items ():Map<XMapItemModel, Int> /* <XMapItemModel, Int> */ {
			return m_items;
		}

//------------------------------------------------------------------------------------------
		public function arrayItems ():Array<XMapItemModel> {
			return m_arrayItems;
		}

//------------------------------------------------------------------------------------------
		public function iterateAllItems (__iterationCallback:Dynamic /* Function */):Void {
			if (useArrayItems) {
				var __items:Array<XMapItemModel>;
				var __length:Int;
				
				__items = arrayItems ();
				
				__length = __items.length;
				
				for (i in 0 ... __length) {
					__iterationCallback (__items[i]);
				}
			}
			else
			{
				for (__key__ in items ().keys ()) {
					function (x:Dynamic /* */):Void {
						__iterationCallback (x);
					} (__key__);
				}		
			}
		}

//------------------------------------------------------------------------------------------
		public function serializeRowCol (__row:Int, __col:Int):XSimpleXMLNode {	
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			var __attribs:Array<Dynamic> /* <Dynamic> */ = [
				"row",	__row,
				"col",	__col
			];
			
			xml.setupWithParams ("XSubmap", "", __attribs);
			
			if (hasCXTiles ()) {
				xml.addChildWithXMLNode (serializeCXTiles ());
			}
			
			if (m_XMapLayer.grid) {
				xml = serializeRowCol_TileArray (xml);
			} else {				
				xml = serializeRowCol_XMapItem (xml);
			}
			
			return xml;
		}
		
//------------------------------------------------------------------------------------------
		public function serializeRowCol_XMapItem (xml:XSimpleXMLNode):XSimpleXMLNode {						
			var item:XMapItemModel;
	
			for (__key__ in items ().keys ()) {
				function (x:Dynamic /* */):Void {
					item = cast x; /* as XMapItemModel */
					
					xml.addChildWithXMLNode (item.serialize ());
				} (__key__);
			}
			
			return xml;
		}

		//------------------------------------------------------------------------------------------
		public function serializeRowCol_TileArray (xml:XSimpleXMLNode):XSimpleXMLNode {	
			var __item:XMapItemModel;
			
			var __submapX:Int = Std.int (x);
			var __submapY:Int = Std.int (y);
			var __tileCol:Int, __tileRow:Int;
						
			var __tmap:Array<Array<Dynamic>> = new Array<Array<Dynamic>> (); 
			
			for (i in 0 ... m_tileCols * m_tileRows) {
				__tmap.push([0, 0]);
			}
			
			for (__key__ in items ().keys ()) {
				function (x:Dynamic /* */):Void {
					__item = cast x; /* as XMapItemModel */
					
					__tileCol = Std.int ((Std.int (__item.x) - __submapX) / TX_TILE_WIDTH);
					__tileRow = Std.int ((Std.int (__item.y) - __submapY) / TX_TILE_HEIGHT);
				
					trace(": imageClassIndex, frame: ", formatImageClassIndex (__item.imageClassIndex) + formatFrame (__item.frame));
					
					__tmap[__tileRow * m_tileCols + __tileCol] = [__item.imageClassIndex, __item.frame];
				} (__key__);
			}
			
			var __tmapString:String = "";
			
			for (__row in 0 ... m_tileRows) {
				for (__col in 0 ... m_tileCols) {
					var __tile:Dynamic /* */ = __tmap[__row * m_tileCols + __col];
					
					if (__tile[0] == 0 && __tile[1] == 0) {
						__tmapString += "XXXX";	
					} else {
						__tmapString += formatImageClassIndex (__tile[0]) + formatFrame (__tile[1]);			
					}
				}
			}

			var __xmlTiles:XSimpleXMLNode = new XSimpleXMLNode ();			
			__xmlTiles.setupWithParams ("Tiles", __tmapString, []);
			
			xml.addChildWithXMLNode (__xmlTiles);
			
			return xml;
		}

//------------------------------------------------------------------------------------------
		private function formatImageClassIndex(__imageClassIndex:Int):String {
			return CXToChar.charAt(__imageClassIndex);
		}
		
//------------------------------------------------------------------------------------------
		private function formatFrame(__frame:Int):String {
			var digit100:Int = Std.int ((__frame%1000) / 100);
			var digit10:Int = Std.int ((__frame%100) / 10);
			var digit1:Int = Std.int ((__frame%10) / 1);
			
			return "" + digit100 + digit10 + digit1;
		}
		
//------------------------------------------------------------------------------------------
		public function serializeCXTiles ():XSimpleXMLNode {
			var __xmlCX:XSimpleXMLNode = new XSimpleXMLNode ();			
			__xmlCX.setupWithParams ("CX", "", []);
			
			var __row:Int, __col:Int;
				
			for (__row in 0 ... m_rows) {
				var __xmlRow:XSimpleXMLNode = new XSimpleXMLNode ();
		
				var __rowString:String = "";
				
				for (__col in 0 ... m_cols) {
					__rowString += CXToChar.charAt (m_cmap[__row * m_cols + __col]);
				}
				
				__xmlRow.setupWithParams ("row", __rowString, []);
				
				__xmlCX.addChildWithXMLNode (__xmlRow);
			}

			return __xmlCX;
		}
	
//------------------------------------------------------------------------------------------
		public function deserializeRowCol (__xml:XSimpleXMLNode):Void {
			var __xmlList:Array<XSimpleXMLNode>; // <XSimpleXMLNode>
			__xmlList = __xml.child ("CX");
			
			if (__xmlList.length > 0) {
				deserializeCXTiles (__xmlList[0]);
			}
			
			//------------------------------------------------------------------------------------------
			var __xmlList:Array<XSimpleXMLNode>; // <XSimpleXMLNode>
			__xmlList = __xml.child ("Tiles");
			
			var __hasTiles:Bool = __xmlList.length > 0;
			
			//------------------------------------------------------------------------------------------
			trace ("//------------------------------------------------------------------------------------------");
			trace (": deserializeRowCol: ", m_XMapLayer.grid);
			
			//------------------------------------------------------------------------------------------
			// even layers numbers are always encoded as XMapItems and decoded as XMapItems
			//------------------------------------------------------------------------------------------
			if (!m_XMapLayer.grid) {
				trace (": 0: ");
				deserializeRowCol_XMapItemXML_To_Items (__xml);
			}
			
			//------------------------------------------------------------------------------------------
			// encoded as XMapItemXML
			//------------------------------------------------------------------------------------------
			else if (!__hasTiles) {
				if (useArrayItems == false) { // TikiEdit
					trace(": 1: ");
					deserializeRowCol_XMapItemXML_To_Items (__xml); 				
				} else {
					trace(": 2: ");
					deserializeRowCol_XMapItemXML_To_TileArray (__xml);
				}
			}
			
			//------------------------------------------------------------------------------------------
			// encoded as TilesXML
			//------------------------------------------------------------------------------------------
			else {
				if (useArrayItems == false) { // TikiEdit
					trace(": 3: ");
					deserializeRowCol_TilesXML_To_Items (__xml);
				} else {
					trace(": 4: ");
					deserializeRowCol_TilesXML_To_TileArray (__xml);
				}
			}
		}
	
//------------------------------------------------------------------------------------------
		public function deserializeRowCol_TilesXML_To_TileArray (__xml:XSimpleXMLNode):Void {
			trace (": TilesXML to TileArray: ");
			
			var __xmlList:Array<XSimpleXMLNode>; // <XSimpleXMLNode>
			__xmlList = __xml.child ("Tiles");
			
			if (__xmlList.length > 0) {
				var __xml:XSimpleXMLNode = __xmlList[0];
			
				var __tilesString:String = __xml.getTextTrim();
				var __imageClassIndex:Int;
				var	__frame:Int;
				
				trace (": <Tiles/>: ", __tilesString, __tilesString.length);
			
				var i:Int;
				
				for (__row in 0 ... m_tileRows) {
					for (__col in 0 ... m_tileCols) {
						i = __row * m_tileCols + __col;
						
						if (__tilesString.substr (i * 4, 4) != "XXXX") {
							__imageClassIndex = CXToChar.indexOf (__tilesString.charAt (i * 4));
							__frame = XType.parseInt (__tilesString.substr (i * 4 + 1, 3));
	
							m_tmap[__row * m_tileCols + __col] = [__imageClassIndex, __frame];
						} else {
							m_tmap[__row * m_tileCols + __col] = [-1, 0];
						}
					}
				}
			}
		}
	
//------------------------------------------------------------------------------------------
		public function deserializeRowCol_TilesXML_To_Items (__xml:XSimpleXMLNode):Void {
			trace (": TilesXML to Items: ");
			
			var __xmlList:Array<XSimpleXMLNode>; // <XSimpleXMLNode>
			__xmlList = __xml.child ("Tiles");
			
			if (__xmlList.length > 0) {
				var __xml:XSimpleXMLNode = __xmlList[0];
				
				var __tilesString:String = __xml.getTextTrim();
				var __imageClassIndex:Int;
				var	__frame:Int;
				
				trace (": <Tiles/>: ", __tilesString, __tilesString.length);
				
				var __item:XMapItemModel;
				
				var i:Int;
				
				if (useArrayItems) {
					m_arrayItems = new Array<XMapItemModel> (/* __xmlList.length */);	
					for (i in 0 ... __xmlList.length) {
						m_arrayItems.push (null);
					}
				}
				
				var __collisionRect:XRect = cast m_XRectPoolManager.borrowObject (); /* as XRect */
				var __boundingRect:XRect = cast m_XRectPoolManager.borrowObject (); /* as XRect */
				
				__collisionRect.setRect (
					0,
					0,
					TX_TILE_WIDTH,
					TX_TILE_HEIGHT
				);
				
				__boundingRect.setRect (
					0,
					0,
					TX_TILE_WIDTH,
					TX_TILE_HEIGHT
				);
				
				var __x:Float = m_col * m_submapWidth;
				var __y:Float = m_row * m_submapHeight;
				
				for (__row in 0 ... m_tileRows) {
					for (__col in 0 ... m_tileCols) {
						i = __row * m_tileCols + __col;
						
						if (__tilesString.substr (i * 4, 4) != "XXXX") {
							__imageClassIndex = CXToChar.indexOf (__tilesString.charAt (i * 4));
							__frame = XType.parseInt (__tilesString.substr (i * 4 + 1, 3));
							
							/*
							__layerModel:XMapLayerModel,
							__logicClassName:String,
							__hasLogic:Bool,
							__name:String, __id:Int,
							__imageClassName:String, __frame:Int,
							__XMapItem:String,
							__x:Float, __y:Float,
							__scale:Float, __rotation:Float, __depth:Float,
							__collisionRect:XRect,
							__boundingRect:XRect,
							__params:String,
							args:Array<Dynamic>
							*/
						
							__item = cast m_XMapItemModelPoolManager.borrowObject (); /* as XMapItemModel */
						
							var __id:Int = m_XMapLayer.generateID ();
								
							trace (":      --->: ", __tilesString.substr (i*4, 4), __imageClassIndex, m_XMapLayer.getClassNameFromIndex (__imageClassIndex));
							
							__item.setup (
								m_XMapLayer,
								// __logicClassName
								"XLogicObjectXMap:XLogicObjectXMap",
								// m_XMapLayer.getClassNameFromIndex (__logicClassIndex),
								// __hasLogic
								false,
								// __xml.hasAttribute ("hasLogic") && __xml.getAttribute ("hasLogic") == "true" ? true : false,
								// __name, __id
								"", __id,
								// __xml.getAttributeString ("name"), __id,
								m_XMapLayer.getClassNameFromIndex (__imageClassIndex), __frame,
								// m_XMapLayer.getClassNameFromIndex (__imageClassIndex), __xml.getAttributeInt ("frame"),
								// XMapItem
								"",
								// __xml.hasAttribute ("XMapItem") ? __xml.getAttribute ("XMapItem") : "",
								__x + __col * TX_TILE_WIDTH, __y + __row * TX_TILE_HEIGHT,
								// __xml.getAttributeFloat ("x"), __xml.getAttributeFloat ("y"),
								// __scale, __rotation, __depth
								1.0, 0.0, 0.0,
								// __xml.getAttributeFloat ("scale"), __xml.getAttributeFloat ("rotation"), __xml.getAttributeFloat ("depth"),
								// __collisionRect,
								__collisionRect,
								// __boundingRect,
								__boundingRect,
								// __params
								"<params/>",
								// __xml.child ("params")[0].toXMLString (),
								// args
								[]
							);
							
							if (useArrayItems) {
								m_arrayItems[m_arrayItemIndex++] = __item;
							}
							else
							{
								addItem (__item);
							}
							
							m_XMapLayer.trackItem (__item);
						}
					}
				}
			}
		}

//------------------------------------------------------------------------------------------
		public function deserializeRowCol_XMapItemXML_To_TileArray (__xml:XSimpleXMLNode):Void {
			trace (": XMapItemXML to TileArray: ");
			
			var __xmlList:Array<XSimpleXMLNode>; // <XSimpleXMLNode>
			__xmlList = __xml.child ("XMapItem");
			
			var i:Int;
			
			for (i in 0 ... __xmlList.length) {
				var __xml:XSimpleXMLNode = __xmlList[i];
				
				var __imageClassIndex:Int = __xml.getAttributeInt ("imageClassIndex");
				var __imageClassName:String = m_XMapLayer.getClassNameFromIndex (__imageClassIndex);
				var __frame:Int = __xml.getAttributeInt ("frame");
				var __x:Int = Std.int (__xml.getAttributeFloat ("x"));
				var __y:Int = Std.int (__xml.getAttributeFloat ("y"));
				
				if (__y >= m_row * m_submapHeight && __y < m_row * m_submapHeight + 512) {
					var __col:Int = Std.int ((__x & m_submapWidthMask) / TX_TILE_WIDTH);
					var __row:Int = Std.int ((__y & m_submapHeightMask) / TX_TILE_HEIGHT);
					
					m_tmap[__row * m_tileCols + __col] = [__imageClassIndex, __frame];
				}
			}			
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeRowCol_XMapItemXML_To_Items (__xml:XSimpleXMLNode):Void {
			var __xmlList:Array<XSimpleXMLNode>; // <XSimpleXMLNode>
			__xmlList = __xml.child ("XMapItem");

			var i:Int;
			
			if (useArrayItems) {
				m_arrayItems = new Array<XMapItemModel> (/* __xmlList.length */);	
				for (i in 0 ... __xmlList.length) {
					m_arrayItems.push (null);
				}
			}
			
			for (i in 0 ... __xmlList.length) {
				var __xml:XSimpleXMLNode = __xmlList[i];
				
//				trace (": deserializeRowCol: ", m_col, m_row);

				var __id:Int = __xml.getAttributeInt ("id");
				var __item:XMapItemModel = m_XMapLayer.ids ().get (__id);
				
				if (__item != null) {
					trace (": **** existing item found ****: ", __item, __item.id);
				}
				else
				{
					__item = cast m_XMapItemModelPoolManager.borrowObject (); /* as XMapItemModel */
				}

				var __classNameToIndex:XReferenceNameToIndex = m_XMapLayer.getClassNames ();
				
				var __logicClassIndex:Int = __xml.getAttributeInt ("logicClassIndex");
				var __imageClassIndex:Int = __xml.getAttributeInt ("imageClassIndex");
				
//				trace (": logicClassName: ", m_XMapLayer.getClassNameFromIndex (__logicClassIndex), __classNameToIndex.getReferenceNameCount (__logicClassIndex));
//				trace (": imageClassName: ", m_XMapLayer.getClassNameFromIndex (__imageClassIndex),  __classNameToIndex.getReferenceNameCount (__imageClassIndex));
								
				var __collisionRect:XRect = cast m_XRectPoolManager.borrowObject (); /* as XRect */
				var __boundingRect:XRect = cast m_XRectPoolManager.borrowObject (); /* as XRect */
				
				__collisionRect.setRect (
					__xml.getAttributeFloat ("cx"),
					__xml.getAttributeFloat ("cy"),
					__xml.getAttributeFloat ("cw"),
					__xml.getAttributeFloat ("ch")
				);
				
				__boundingRect.setRect (
					__xml.getAttributeFloat ("bx"),
					__xml.getAttributeFloat ("by"),
					__xml.getAttributeFloat ("bw"),
					__xml.getAttributeFloat ("bh")
				);
					
				__item.setup (
					m_XMapLayer,
// __logicClassName
					m_XMapLayer.getClassNameFromIndex (__logicClassIndex),
// __hasLogic
					__xml.hasAttribute ("hasLogic") && __xml.getAttribute ("hasLogic") == "true" ? true : false,
// __name, __id
					__xml.getAttributeString ("name"), __id,
// __imageClassName, __frame
					m_XMapLayer.getClassNameFromIndex (__imageClassIndex), __xml.getAttributeInt ("frame"),
// XMapItem
					__xml.hasAttribute ("XMapItem") ? __xml.getAttribute ("XMapItem") : "",
// __x, __y,
					__xml.getAttributeFloat ("x"), __xml.getAttributeFloat ("y"),
// __scale, __rotation, __depth
					__xml.getAttributeFloat ("scale"), __xml.getAttributeFloat ("rotation"), __xml.getAttributeFloat ("depth"),
// __collisionRect,
					__collisionRect,
// __boundingRect,
					__boundingRect,
// __params
					__xml.child ("params")[0].toXMLString (),
// args
					[]
					);

					if (useArrayItems) {
						m_arrayItems[m_arrayItemIndex++] = __item;
					}
					else
					{
						addItem (__item);
					}
	
					m_XMapLayer.trackItem (__item);
			}
		}
		
//----------------------------------------------------------------------------------------
		public function deserializeCXTiles (__cx:XSimpleXMLNode):Void {
			var __xmlList:Array<XSimpleXMLNode> /* <XSimpleXMLNode> */ = __cx.child ("row");
			var __row:Int, __col:Int;
			var __xml:XSimpleXMLNode;
			var __rowString:String;
			
			for (__row in 0 ... __xmlList.length) {
				__xml = __xmlList[__row];
				__rowString = XType.trim (__xml.getText ());
				
				for (__col in 0 ... __rowString.length) {
					m_cmap[__row * m_cols + __col] = CXToChar.indexOf (__rowString.charAt (__col));
				}
			}
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
