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
package kx.world.logic;

	import kx.collections.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
//------------------------------------------------------------------------------------------
	class XLogicObjectCX extends XLogicObject {
		private var m_vel:XPoint;
		private var m_oldPos:XPoint;
		
		private var m_cx:XRect;
		private var m_namedCX:Map<String, XRect>; // <String, XRect>
	
		public var m_XMapModel:XMapModel;
		public var m_XMapView:XMapView;
		public var m_XMapLayerModel:XMapLayerModel;
		public var m_XSubmaps:Array<Array<XSubmapModel>>;
		public var m_submapWidth:Int;
		public var m_submapHeight:Int;
		public var m_submapWidthMask:Int;
		public var m_submapHeightMask:Int;
		public var m_cols:Int;
		public var m_rows:Int;

		private var m_CX_Collide_Flag:Int;
		
		private var m_objectCollisionList:Map<XLogicObject, XRect>; // <XLogicObject, XRect>
	
		// begin include "..\\..\\World\\Collision\\cx.h";
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
		// end include "..\\..\\World\\Collision\\cx.h";
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_XMapModel = null;
			m_XMapView = null;
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
			
			xxx.getXPointPoolManager ().returnObject (m_vel);
			xxx.getXPointPoolManager ().returnObject (m_oldPos);
			xxx.getXRectPoolManager ().returnObject (m_cx);
			
			m_vel = null;
			m_oldPos = null;
			m_cx = null;
		}
		
//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			var __vel:XPoint = cast xxx.getXPointPoolManager ().borrowObject (); /* as XPoint */
			var __old:XPoint = cast xxx.getXPointPoolManager ().borrowObject (); /* as XPoint */
//			var __vel:XPoint = new XPoint ();
//			var __old:XPoint = new XPoint ();
					
			__vel.x = __vel.y = 0;
			__old.x = __old.y = 0;
			
			setVel (__vel);
			setOld (__old);

			m_cx = cast xxx.getXRectPoolManager ().borrowObject (); /* as XRect */
//			m_cx = new XRect (0, 0, 0, 0);
					
			m_cx.x = 0;
			m_cx.y = 0;
			m_cx.width = 0;
			m_cx.height = 0;
			
			m_objectCollisionList = null;
					
			m_namedCX = new Map<String, XRect> (); // <String, XRect>
		}

//------------------------------------------------------------------------------------------
		public function setXMapModel (__layer:Int, __XMapModel:XMapModel, __XMapView:XMapView=null):Void {
			m_XMapModel = __XMapModel;
			m_XMapView = __XMapView;
			
			m_XMapLayerModel = m_XMapModel.getLayer (__layer);
			
			m_XSubmaps = m_XMapLayerModel.submaps ();
			
			m_submapWidth = m_XMapLayerModel.getSubmapWidth ();
			m_submapHeight = m_XMapLayerModel.getSubmapHeight ();
			
			m_submapWidthMask = m_submapWidth - 1;
			m_submapHeightMask = m_submapHeight - 1;
			
			m_cols = Std.int (m_submapWidth/XLogicObjectCX.CX_TILE_WIDTH);
			m_rows = Std.int (m_submapHeight/XLogicObjectCX.CX_TILE_HEIGHT);

			/*			
			trace (": --------------------------------:");
			trace (": submapWidth: ", m_submapWidth);
			trace (": submapHeight: ", m_submapHeight);
			trace (": submapWidthMask: ", m_submapWidthMask);
			trace (": submapHeightMask: ", m_submapHeightMask);
			trace (": m_cols: ", m_cols);
			trace (": m_rows: ", m_rows);
			trace (": tileWidth: ", XLogicObjectCX.CX_TILE_WIDTH);
			trace (": tileWidthMask: ", XLogicObjectCX.CX_TILE_WIDTH_MASK);
			trace (": tileWidthUnmask: ", XLogicObjectCX.CX_TILE_WIDTH_UNMASK);
			trace (": tileHeight: ", XLogicObjectCX.CX_TILE_HEIGHT);
			trace (": tileHeightMask: ", XLogicObjectCX.CX_TILE_HEIGHT_MASK);
			trace (": tileHeightUnMask: ", XLogicObjectCX.CX_TILE_HEIGHT_UNMASK);
			*/
		}

//------------------------------------------------------------------------------------------
		public function getXMapModel ():XMapModel {
			return m_XMapModel;
		}
		
//------------------------------------------------------------------------------------------
		public function getXMapLayerModel ():XMapLayerModel {
			return m_XMapLayerModel;
		}
		
//------------------------------------------------------------------------------------------
		public function getXMapView ():XMapView {
			return m_XMapView;
		}

//------------------------------------------------------------------------------------------
		public function hasItemStorage ():Bool {
			if (item == null) {
				return false;
			}
			
			return m_XMapLayerModel.getPersistentStorage ().exists (item.id);
		}
		
//------------------------------------------------------------------------------------------
		public function initItemStorage (__val:Dynamic /* */):Void {
			if (!hasItemStorage ()) {
				m_XMapLayerModel.getPersistentStorage ().set (item.id, __val);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function getItemStorage ():Dynamic /* */ {
			if (hasItemStorage ()) {		
				return m_XMapLayerModel.getPersistentStorage ().get (item.id);
			}
			else
			{
				return null;
			}
		}

//------------------------------------------------------------------------------------------
		public function setCX (
			__x1:Float,
			__x2:Float,
			__y1:Float,
			__y2:Float
			):Void {
				
//			m_cx = new XRect (__x1, __y1, __x2-__x1+1, __y2-__y1+1);
	
			m_cx.x = __x1;
			m_cx.y = __y1;
			m_cx.width = __x2-__x1+1;
			m_cx.height = __y2-__y1+1;
				
//			trace (": left, right, top, bottom ", m_cx.left, m_cx.right, m_cx.top, m_cx.bottom);
//			trace (": width, height: ", m_cx.width, m_cx.height);
		}

//------------------------------------------------------------------------------------------
		public function getCX ():XRect {
			return m_cx;
		}
		
//------------------------------------------------------------------------------------------
		public function setNamedCX (
			__name:String,
			__x1:Float,
			__x2:Float,
			__y1:Float,
			__y2:Float
			):Void {
				
			m_namedCX.set (__name, new XRect (__x1, __y1, __x2-__x1+1, __y2-__y1+1));
		}

//------------------------------------------------------------------------------------------
		public function getNamedCX (__name:String):XRect {
			return m_namedCX.get (__name).cloneX ();
		}
		
//------------------------------------------------------------------------------------------
		public function getAdjustedNamedCX (__name:String):XRect {
			var __rect:XRect = m_namedCX.get (__name).cloneX ();	
			__rect.offset (oX, oY);
			return __rect;
		}
		
//------------------------------------------------------------------------------------------
		public function getVel ():XPoint {
			return m_vel;
		}
		 
		public function setVel (__vel:XPoint):Void {
			m_vel = __vel;
		}
		
//------------------------------------------------------------------------------------------
		public var oDX (get, set):Float;
		
		// [Inline]
		public function get_oDX ():Float {
			return m_vel.x;
		}

		// [Inline]
		public function set_oDX (__val:Float): Float {
			m_vel.x = __val;
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var oDY (get, set):Float;
		
		// [Inline]
		public function get_oDY ():Float {
			return m_vel.y;
		}
		
		// [Inline]
		public function set_oDY (__val:Float): Float {
			m_vel.y = __val;
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function getOld ():XPoint {
			return m_oldPos;
		}
		
		public function setOld (__pos:XPoint):Void {
			m_oldPos = __pos;
		}
		
//------------------------------------------------------------------------------------------
		public var oldX (get, set):Float;
		
		public function get_oldX ():Float {
			return m_oldPos.x;
		}

		public function set_oldX (__val:Float): Float {
			m_oldPos.x = __val;
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var oldY (get, set):Float;
		
		public function get_oldY ():Float {
			return m_oldPos.y;
		}

		public function set_oldY (__val:Float): Float {
			m_oldPos.y = __val;
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function collidesWithNamedCX (__name:String, __rectDst:XRect):Bool {
			var __rectSrc:XRect = getAdjustedNamedCX (__name);
			
			return __rectSrc.intersects (__rectDst);
		}
		
//------------------------------------------------------------------------------------------
		public var CX_Collide_Flag (get, set):Int;
		
		public function get_CX_Collide_Flag ():Int {
			return m_CX_Collide_Flag;
		}

		public function set_CX_Collide_Flag (__val:Int): Int {
			m_CX_Collide_Flag = __val;
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function handleCollision (__collider:XLogicObject):Void {
		}

//------------------------------------------------------------------------------------------
		public function objectCollisionCallback (__logicObject:XLogicObject):Void {	
		}
		
//------------------------------------------------------------------------------------------
		public var allowLFCollisions (get, set):Bool;
		
		public function get_allowLFCollisions ():Bool {
			return true;
		}

		public function set_allowLFCollisions (__val:Bool): Bool {
			
			return true;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var allowRTCollisions (get, set):Bool;
		
		public function get_allowRTCollisions ():Bool {
			return true;
		}
		
		public function set_allowRTCollisions (__val:Bool): Bool {
			
			return true;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var allowUPCollisions (get, set):Bool;
		
		public function get_allowUPCollisions ():Bool {
			return true;
		}
	
		public function set_allowUPCollisions (__val:Bool): Bool {
			
			return true;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var allowDNCollisions (get, set):Bool;
		
		public function get_allowDNCollisions ():Bool {
			return true;
		}
		
		public function set_allowDNCollisions (__val:Bool): Bool {
			
			return true;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public override function updatePhysics ():Void {
			handleCX ();	
		}
		
//------------------------------------------------------------------------------------------
		public function handleCX ():Void {
			m_CX_Collide_Flag = 0;

//------------------------------------------------------------------------------------------			
			oX += oDX;
			
//			if (int (oX) != int (oldX)) {
			{
				if (oDX == 0) {
					
				}
				else if (oDX < 0) {
					Ck_Collide_LF ();
					Ck_Slope_LF ();
				}
				else
				{
					Ck_Collide_RT ();
					Ck_Slope_RT (); 
				}
			}
			
//------------------------------------------------------------------------------------------
			oY += oDY;
			
//			if (int (oY) != int (oldY)) {
			{
				if (oDY == 0) {
					
				}
				else if (oDY < 0) {
					Ck_Collide_UP ();
					Ck_Slope_UP ();
				}
				else
				{
					Ck_Collide_DN ();
					Ck_Slope_DN ();
				}
			}
		}

//------------------------------------------------------------------------------------------
		public function Ck_Collide_UP ():Bool {
			var x1:Int, y1:Int, x2:Int, y2:Int;
			var i:Int, __x:Int, __y:Int;
			var collided:Bool;
			var r:Int, c:Int;
			var submapRow:Int, submapCol:Int;
			
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
						
			y1 &= XLogicObjectCX.CX_TILE_HEIGHT_UNMASK;
			r = y1 >> 9;
			submapRow = ((y1 & 496) << 1);
			
			collided = false;
			
			__x = (x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK);
//			for (__x = (x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK); __x <= (x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK); __x += XLogicObjectCX.CX_TILE_WIDTH) {
			while (__x <= (x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK)) {
//				c = __x/m_submapWidth;
//				r = y1/m_submapHeight;
//				i = (int ((y1 & m_submapHeightMask)/XLogicObjectCX.CX_TILE_HEIGHT) * m_cols) + int ((__x & m_submapWidthMask)/XLogicObjectCX.CX_TILE_WIDTH);
//				switch (m_XSubmaps[r][c].cmap[i]) {
					
				switch (m_XSubmaps[r][__x >> 9].cmap[submapRow + ((__x & 511) >> 4)]) {
				// ([
					case XLogicObjectCX.CX_EMPTY:
						// break;
					case XLogicObjectCX.CX_SOLID:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_UP;
						
						oY = (y1 + XLogicObjectCX.CX_TILE_HEIGHT - m_cx.top);
						
						collided = true;
						// break; // },
					case XLogicObjectCX.CX_SOLIDX001:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_UP;
				
							oY = (y1 + XLogicObjectCX.CX_TILE_HEIGHT - m_cx.top);
			
							collided = true;
						// break; // },
					case XLogicObjectCX.CX_SOFT:
						// break;
					case XLogicObjectCX.CX_JUMP_THRU:
						// break;
						
					case XLogicObjectCX.CX_UL45:
						// break;
					case XLogicObjectCX.CX_UR45:
						// break;
					case XLogicObjectCX.CX_LL45:
						// break;
					case XLogicObjectCX.CX_LR45:
						// break;
					
					case XLogicObjectCX.CX_UL225A:
						// break;
					case XLogicObjectCX.CX_UL225B:
						// break;
					case XLogicObjectCX.CX_UR225A:
						// break;
					case XLogicObjectCX.CX_UR225B:
						// break;
					case XLogicObjectCX.CX_LL225A:
						// break;
					case XLogicObjectCX.CX_LL225B:
						// break;
					case XLogicObjectCX.CX_LR225A:
						// break;
					case XLogicObjectCX.CX_LR225B:
						// break;
					
					case XLogicObjectCX.CX_UL675A:
						// break;
					case XLogicObjectCX.CX_UL675B:
						// break;
					case XLogicObjectCX.CX_UR675A:
						// break;
					case XLogicObjectCX.CX_UR675B:
						// break;
					case XLogicObjectCX.CX_LL675A:
						// break;
					case XLogicObjectCX.CX_LL675B:
						// break;
					case XLogicObjectCX.CX_LR675A:
						// break;
					case XLogicObjectCX.CX_LR675B:
						// break;
						
					case XLogicObjectCX.CX_SOFTLF:
						// break;
					case XLogicObjectCX.CX_SOFTRT:
						// break;
					case XLogicObjectCX.CX_SOFTUP:
						// break;
					case XLogicObjectCX.CX_SOFTDN:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_UP;
				
							oY = (y1 + XLogicObjectCX.CX_TILE_HEIGHT - m_cx.top);
			
							collided = true;
						// break;
					case XLogicObjectCX.CX_DEATH:
						// break;
					default:
						// break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
				
				__x += XLogicObjectCX.CX_TILE_WIDTH;
			}
			
			return false;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Collide_DN ():Bool {
			var x1:Int, y1:Int, x2:Int, y2:Int;
			var i:Int, __x:Int, __y:Int;
			var collided:Bool;
			var r:Int, c:Int;
			var submapRow:Int, submapCol:Int;
			
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
							
			y2 &= XLogicObjectCX.CX_TILE_HEIGHT_UNMASK;
			r = y2 >> 9;
			submapRow = ((y2 & 496) << 1);
			
			collided = false;
			
			__x = (x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK);
//			for (__x = (x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK); __x <= (x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK); __x += XLogicObjectCX.CX_TILE_WIDTH) {
			while (__x <= (x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK)) {
//				c = __x/m_submapWidth;
//				r = y2/m_submapHeight;
//				i = (int ((y2 & m_submapHeightMask)/XLogicObjectCX.CX_TILE_HEIGHT) * m_cols) + int ((__x & m_submapWidthMask)/XLogicObjectCX.CX_TILE_WIDTH);
//				switch (m_XSubmaps[r][c].cmap[i]) {
					
				switch (m_XSubmaps[r][__x >> 9].cmap[submapRow + ((__x & 511) >> 4)]) {
				// ([
					case XLogicObjectCX.CX_EMPTY:
						// break;
					case XLogicObjectCX.CX_SOLID:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_DN;
						
						oY = (y2 - (m_cx.bottom) - 1);
						
						collided = true;
						// break; // },
					case XLogicObjectCX.CX_SOLIDX001:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_DN;
						
						oY = (y2 - (m_cx.bottom) - 1);
						
						collided = true;
						// break; // },
					case XLogicObjectCX.CX_JUMP_THRU:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_DN;
				
							oY = (y2 - (m_cx.bottom) - 1);
										
							collided = true;
						// break; // },
					case XLogicObjectCX.CX_SOFT:
						// break;
//					case XLogicObjectCX.CX_JUMP_THRU:
//						break;
						
					case XLogicObjectCX.CX_UL45:
						// break;
					case XLogicObjectCX.CX_UR45:
						// break;
					case XLogicObjectCX.CX_LL45:
						// break;
					case XLogicObjectCX.CX_LR45:
						// break;
					
					case XLogicObjectCX.CX_UL225A:
						// break;
					case XLogicObjectCX.CX_UL225B:
						// break;
					case XLogicObjectCX.CX_UR225A:
						// break;
					case XLogicObjectCX.CX_UR225B:
						// break;
					case XLogicObjectCX.CX_LL225A:
						// break;
					case XLogicObjectCX.CX_LL225B:
						// break;
					case XLogicObjectCX.CX_LR225A:
						// break;
					case XLogicObjectCX.CX_LR225B:
						// break;
					
					case XLogicObjectCX.CX_UL675A:
						// break;
					case XLogicObjectCX.CX_UL675B:
						// break;
					case XLogicObjectCX.CX_UR675A:
						// break;
					case XLogicObjectCX.CX_UR675B:
						// break;
					case XLogicObjectCX.CX_LL675A:
						// break;
					case XLogicObjectCX.CX_LL675B:
						// break;
					case XLogicObjectCX.CX_LR675A:
						// break;
					case XLogicObjectCX.CX_LR675B:
						// break;
						
					case XLogicObjectCX.CX_SOFTLF:
						// break;
					case XLogicObjectCX.CX_SOFTRT:
						// break;
					case XLogicObjectCX.CX_SOFTUP:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_DN;
				
							oY = (y2 - (m_cx.bottom) - 1);
										
							collided = true;
						// break;
					case XLogicObjectCX.CX_SOFTDN:
						// break;
					case XLogicObjectCX.CX_DEATH:
						// break;
					default:
						// break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
				
				__x += XLogicObjectCX.CX_TILE_WIDTH;
			}
			
			return false;
		}
	
//------------------------------------------------------------------------------------------
		public function Ck_Collide_LF ():Bool {
			var x1:Int, y1:Int, x2:Int, y2:Int;
			var i:Int, __x:Int, __y:Int;
			var collided:Bool;
			var r:Int, c:Int;
			var submapRow:Int, submapCol:Int;
			
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
	
			x1 &= XLogicObjectCX.CX_TILE_WIDTH_UNMASK;
			c = x1 >> 9;
			submapCol = (x1 & 511) >> 4;
			
			collided = false;
			
			__y = (y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK);
//			for (__y = (y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK); __y <= (y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK); __y += XLogicObjectCX.CX_TILE_HEIGHT) {
			while (__y <= (y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK)) {
//				c = x1/m_submapWidth;
//				r = __y/m_submapHeight;
//				i = (int ((__y & m_submapHeightMask)/XLogicObjectCX.CX_TILE_HEIGHT) * m_cols) + int ((x1 & m_submapWidthMask)/XLogicObjectCX.CX_TILE_WIDTH);
//				switch (m_XSubmaps[r][c].cmap[i]) {
					
				switch (m_XSubmaps[__y >> 9][c].cmap[((__y & 496) << 1) + submapCol]) {
				// ([
					case XLogicObjectCX.CX_EMPTY:
						// break;
					case XLogicObjectCX.CX_SOLID:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_LF;
						
						oX = (x1 + XLogicObjectCX.CX_TILE_WIDTH - m_cx.left);
						
						collided = true;
						// break; // },
					case XLogicObjectCX.CX_SOLIDX001:
							// function ():void {
								m_CX_Collide_Flag |= CX_COLLIDE_LF;
			
								oX = (x1 + XLogicObjectCX.CX_TILE_WIDTH - m_cx.left);
				
								collided = true;
							// break; // },
					case XLogicObjectCX.CX_SOFT:
						// break;
					case XLogicObjectCX.CX_JUMP_THRU:
						// break;
						
					case XLogicObjectCX.CX_UL45:
						// break;
					case XLogicObjectCX.CX_UR45:
						// break;
					case XLogicObjectCX.CX_LL45:
						// break;
					case XLogicObjectCX.CX_LR45:
						// break;
					
					case XLogicObjectCX.CX_UL225A:
						// break;
					case XLogicObjectCX.CX_UL225B:
						// break;
					case XLogicObjectCX.CX_UR225A:
						// break;
					case XLogicObjectCX.CX_UR225B:
						// break;
					case XLogicObjectCX.CX_LL225A:
						// break;
					case XLogicObjectCX.CX_LL225B:
						// break;
					case XLogicObjectCX.CX_LR225A:
						// break;
					case XLogicObjectCX.CX_LR225B:
						// break;
					
					case XLogicObjectCX.CX_UL675A:
						// break;
					case XLogicObjectCX.CX_UL675B:
						// break;
					case XLogicObjectCX.CX_UR675A:
						// break;
					case XLogicObjectCX.CX_UR675B:
						// break;
					case XLogicObjectCX.CX_LL675A:
						// break;
					case XLogicObjectCX.CX_LL675B:
						// break;
					case XLogicObjectCX.CX_LR675A:
						// break;
					case XLogicObjectCX.CX_LR675B:
						// break;
						
					case XLogicObjectCX.CX_SOFTLF:
						// break;
					case XLogicObjectCX.CX_SOFTRT:
							// function ():void {
								m_CX_Collide_Flag |= CX_COLLIDE_LF;
			
								oX = (x1 + XLogicObjectCX.CX_TILE_WIDTH - m_cx.left);
				
								collided = true;
							// break; 
					case XLogicObjectCX.CX_SOFTUP:
						// break;
					case XLogicObjectCX.CX_SOFTDN:
						// break;
					case XLogicObjectCX.CX_DEATH:
						// break;
					default:
						// break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
				
				__y += XLogicObjectCX.CX_TILE_HEIGHT;
			}
			
			return false;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Collide_RT ():Bool {
			var x1:Int, y1:Int, x2:Int, y2:Int;
			var i:Int, __x:Int, __y:Int;
			var collided:Bool;
			var r:Int, c:Int;
			var submapRow:Int, submapCol:Int;
			
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
						
			x2 &= XLogicObjectCX.CX_TILE_WIDTH_UNMASK;
			c = x2 >> 9;
			submapCol = (x2 & 511) >> 4;
			
			collided = false;
			
			__y = (y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK);
//			for (__y = (y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK); __y <= (y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK); __y += XLogicObjectCX.CX_TILE_HEIGHT) {
			while (__y <= (y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK)) {
//				c = x2/m_submapWidth;
//				r = __y/m_submapHeight;
//				i = (int ((__y & m_submapHeightMask)/XLogicObjectCX.CX_TILE_HEIGHT) * m_cols) + int ((x2 & 511)/XLogicObjectCX.CX_TILE_WIDTH);
//				switch (m_XSubmaps[r][c].cmap[i]) {
					
				switch (m_XSubmaps[__y >> 9][c].cmap[((__y & 496) << 1) + submapCol]) {
				// ([
					case XLogicObjectCX.CX_EMPTY:
						// break;
					case XLogicObjectCX.CX_SOLID:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_RT;
						
						oX = (x2 - (m_cx.right) - 1);
						
						collided = true;
						// break; // },
					case XLogicObjectCX.CX_SOLIDX001:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_RT;
		
							oX = (x2 - (m_cx.right) - 1);
			
							collided = true;
						// break; // },
					case XLogicObjectCX.CX_SOFT:
						// break;
					case XLogicObjectCX.CX_JUMP_THRU:
						// break;
						
					case XLogicObjectCX.CX_UL45:
						// break;
					case XLogicObjectCX.CX_UR45:
						// break;
					case XLogicObjectCX.CX_LL45:
						// break;
					case XLogicObjectCX.CX_LR45:
						// break;
					
					case XLogicObjectCX.CX_UL225A:
						// break;
					case XLogicObjectCX.CX_UL225B:
						// break;
					case XLogicObjectCX.CX_UR225A:
						// break;
					case XLogicObjectCX.CX_UR225B:
						// break;
					case XLogicObjectCX.CX_LL225A:
						// break;
					case XLogicObjectCX.CX_LL225B:
						// break;
					case XLogicObjectCX.CX_LR225A:
						// break;
					case XLogicObjectCX.CX_LR225B:
						// break;
					
					case XLogicObjectCX.CX_UL675A:
						// break;
					case XLogicObjectCX.CX_UL675B:
						// break;
					case XLogicObjectCX.CX_UR675A:
						// break;
					case XLogicObjectCX.CX_UR675B:
						// break;
					case XLogicObjectCX.CX_LL675A:
						// break;
					case XLogicObjectCX.CX_LL675B:
						// break;
					case XLogicObjectCX.CX_LR675A:
						// break;
					case XLogicObjectCX.CX_LR675B:
						// break;
						
					case XLogicObjectCX.CX_SOFTLF:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_RT;
		
							oX = (x2 - (m_cx.right) - 1);
			
							collided = true;
						// break;
					case XLogicObjectCX.CX_SOFTRT:
						// break;
					case XLogicObjectCX.CX_SOFTUP:
						// break;
					case XLogicObjectCX.CX_SOFTDN:
						// break;
					case XLogicObjectCX.CX_DEATH:
						// break;
					default:
						// break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
				
				__y += XLogicObjectCX.CX_TILE_HEIGHT;
			}
			
			return false;
		}
				
		//------------------------------------------------------------------------------------------
		public function Ck_Slope_RT ():Bool {
			var x1:Int, y1:Int, x2:Int, y2:Int;
			var i:Int, __x:Int, __y:Int;
			var collided:Bool;
			var looking:Bool = true;
			var r:Int, c:Int;
			var x15:Int;
			var y15:Int;
			
			collided = false;
			
			//------------------------------------------------------------------------------------------
			// top
			//------------------------------------------------------------------------------------------
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x2/m_submapWidth;
				//				r = y1/m_submapHeight;
				//				i = (int ((y1 & m_submapHeightMask)/XLogicObjectCX.CX_TILE_HEIGHT) * m_cols) + int ((x2 & m_submapWidthMask)/XLogicObjectCX.CX_TILE_WIDTH);
				
				c = x2 >> 9;
				r = y1 >> 9;
				i = ( ((y1 & m_submapHeightMask) >> 4) * m_cols) + ((x2 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XLogicObjectCX.CX_EMPTY:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLIDX001:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLID:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFT:
						// function ():void {
						y1 = (y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + XLogicObjectCX.CX_TILE_HEIGHT;
						// break; // },
					case XLogicObjectCX.CX_JUMP_THRU:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL45:
						// function ():void {	
						var __x_LL45:Array<Int> /* <Int> */ = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __x_LL45[x15]) {
							oY = ((y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + __x_LL45[x15] - m_cx.top);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_LR45:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL225A:
						// function ():void {	
						var __x_LL225A:Array<Int> /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __x_LL225A[x15]) {
							oY = ((y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + __x_LL225A[x15] - m_cx.top);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_LL225B:
						// function ():void {	
						var __x_LL225B:Array<Int> /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __x_LL225B[x15]) {
							oY = ((y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + __x_LL225B[x15] - m_cx.top);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_LR225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR225B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL675A: // new
						// function ():void {								
						var __x_LL675A:Array<Int> /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						var __y_LL675A:Array<Int> /* <Int> */ = [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_LL675A[y15]) {
							oY = ((y1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_LL675A[x15] - m_cx.top);
						}
						
						looking = false;
						
						// break;
					case XLogicObjectCX.CX_LL675B: // new
						// function ():void {							
						var __x_LL675B:Array<Int> /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						var __y_LL675B:Array<Int> /* <Int> */ = [0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, 10, 12, 14];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_LL675B[y15]) {
							oY = ((y1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_LL675B[x15] - m_cx.top);
						}
						
						looking = false;
						
						// break;	
					case XLogicObjectCX.CX_LR675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR675B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_SOFTLF:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTRT:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTUP:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTDN:
						// function ():void {
						oY = ((y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + XLogicObjectCX.CX_TILE_HEIGHT - m_cx.top);
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_DEATH:
						looking = false;
						// break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			//------------------------------------------------------------------------------------------
			// bottom
			//------------------------------------------------------------------------------------------
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x2/m_submapWidth;
				//				r = y2/m_submapHeight;
				//				i = (int ((y2 & m_submapHeightMask)/XLogicObjectCX.CX_TILE_HEIGHT) * m_cols) + int ((x2 & m_submapWidthMask)/XLogicObjectCX.CX_TILE_WIDTH);
				
				c = x2 >> 9;
				r = y2 >> 9;
				i = ( ((y2 & m_submapHeightMask) >> 4) * m_cols) + ((x2 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XLogicObjectCX.CX_EMPTY:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLIDX001:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLID:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFT:
						// function ():void {
						y2 = (y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) - 1;
						// break; // },
					case XLogicObjectCX.CX_JUMP_THRU:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL45:
						// function ():void {	
						var __x_UL45:Array<Int> /* <Int> */ = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __x_UL45[x15]) {
							oY = ((y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + __x_UL45[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						// break; // },			
					case XLogicObjectCX.CX_UR45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR45:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL225A:
						// function ():void {	
						var __x_UL225A:Array<Int> /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __x_UL225A[x15]) {
							oY = ((y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + __x_UL225A[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						// break; // },	
					case XLogicObjectCX.CX_UL225B:
						// function ():void {	
						var __x_UL225B:Array<Int> /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __x_UL225B[x15]) {
							oY = ((y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + __x_UL225B[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						// break; // },	
					case XLogicObjectCX.CX_UR225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR225B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL675A: // new
						// function ():void {								
						var __x_UL675A:Array<Int> /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						var __y_UL675A:Array<Int> /* <Int> */ = [0, 0, 0, 0, 0, 0, 0, 0, 14, 12, 10, 8, 6, 4, 2, 0];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_UL675A[y15]) {
							oY = ((y2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_UL675A[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						
						// break;
					case XLogicObjectCX.CX_UL675B: // new
						// function ():void {							
						var __x_UL675B:Array<Int> /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						var __y_UL675B:Array<Int> /* <Int> */ = [14, 12, 10, 8, 6, 4, 2, 0, -2, -4, -6, -8, -10, -12, -14, -16];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_UL675B[y15]) {
							oY = ((y2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_UL675B[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						
						// break;	
					case XLogicObjectCX.CX_UR675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR675B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_SOFTLF:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTRT:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTUP:
						// function ():void {
						oY = ((y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) - (m_cx.bottom) - 1);
						
						looking = false;								
						// break; // },
					case XLogicObjectCX.CX_SOFTDN:
						looking = false;
						// break;
					case XLogicObjectCX.CX_DEATH:
						looking = false;
						// break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;
		}
		
		//------------------------------------------------------------------------------------------
		public function Ck_Slope_LF ():Bool {
			var x1:Int, y1:Int, x2:Int, y2:Int;
			var i:Int, __x:Int, __y:Int;
			var collided:Bool;
			var looking:Bool = true;
			var r:Int, c:Int;
			var x15:Int;
			var y15:Int;
			
			collided = false;
			
			//------------------------------------------------------------------------------------------
			// top
			//------------------------------------------------------------------------------------------
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x1/m_submapWidth;
				//				r = y1/m_submapHeight;
				//				i = (int ((y1 & m_submapHeightMask)/XLogicObjectCX.CX_TILE_HEIGHT) * m_cols) + int ((x1 & m_submapWidthMask)/XLogicObjectCX.CX_TILE_WIDTH);
				
				c = x1 >> 9;
				r = y1 >> 9;
				i = ( ((y1 & m_submapHeightMask) >> 4) * m_cols) + ((x1 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XLogicObjectCX.CX_EMPTY:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLIDX001:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLID:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFT:
						// function ():void {
						y1 = (y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + XLogicObjectCX.CX_TILE_HEIGHT;
						// break; // },
					case XLogicObjectCX.CX_JUMP_THRU:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR45:
						// function ():void {	
						var __x_LR45:Array<Int> /* <Int> */ = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __x_LR45[x15]) {
							oY = ((y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + __x_LR45[x15] - m_cx.top);
						}
						
						looking = false;
						// break; // },			
					case XLogicObjectCX.CX_UL225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR225A:
						// function ():void {	
						var __x_LR225A:Array<Int> /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __x_LR225A[x15]) {
							oY = ((y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + __x_LR225A[x15] - m_cx.top);
						}
						
						looking = false;
						// break; // },		
					case XLogicObjectCX.CX_LR225B:
						// function ():void {	
						var __x_LR225B:Array<Int> /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __x_LR225B[x15]) {
							oY = ((y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + __x_LR225B[x15] - m_cx.top);
						}
						
						looking = false;
						// break; // },		
					
					case XLogicObjectCX.CX_UL675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR675A: // new
						// function ():void {								
						var __x_LR675A:Array<Int> /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						var __y_LR675A:Array<Int> /* <Int> */ = [32, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_LR675A[y15]) {
							oY = ((y1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_LR675A[x15] - m_cx.top);
						}
						
						looking = false;
						
						// break;
					case XLogicObjectCX.CX_LR675B: // new
						// function ():void {							
						var __x_LR675B:Array<Int> /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						var __y_LR675B:Array<Int> /* <Int> */ = [16, 14, 12, 10, 8, 6, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_LR675B[y15]) {
							oY = ((y1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_LR675B[x15] - m_cx.top);
						}
						
						looking = false;
						
						// break;	
					
					case XLogicObjectCX.CX_SOFTLF:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTRT:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTUP:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTDN:
						// function ():void {
						oY = ((y1 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + XLogicObjectCX.CX_TILE_HEIGHT - m_cx.top);
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_DEATH:
						looking = false;
						// break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			//------------------------------------------------------------------------------------------
			// bottom
			//------------------------------------------------------------------------------------------
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x1/m_submapWidth;
				//				r = y2/m_submapHeight;
				//				i = (int ((y2 & m_submapHeightMask)/XLogicObjectCX.CX_TILE_HEIGHT) * m_cols) + int ((x1 & m_submapWidthMask)/XLogicObjectCX.CX_TILE_WIDTH);
				
				c = x1 >> 9;
				r = y2 >> 9;
				i = ( ((y2 & m_submapHeightMask) >> 4) * m_cols) + ((x1 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XLogicObjectCX.CX_EMPTY:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLIDX001:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLID:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFT:
						// function ():void {
						y2 = (y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) - 1;
						// break; // },
					case XLogicObjectCX.CX_JUMP_THRU:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR45:
						// function ():void {	
						var __x_UR45:Array<Int> /* <Int> */ = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __x_UR45[x15]) {
							oY = ((y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + __x_UR45[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_LL45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR45:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR225A:
						// function ():void {	
						var __x_UR225A:Array<Int> /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __x_UR225A[x15]) {
							oY = ((y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + __x_UR225A[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_UR225B:
						// function ():void {	
						var __x_UR225B:Array<Int> /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __x_UR225B[x15]) {
							oY = ((y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) + __x_UR225B[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_LL225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR225B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR675A: //new
						// function ():void {				
						var __x_UR675A:Array<Int> /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						var __y_UR675A:Array<Int> /* <Int> */ = [0, 2, 4, 6, 8, 10, 12, 14, 0, 0, 0, 0, 0, 0, 0, 0];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_UR675A[y15]) {
							oY = ((y2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_UR675A[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_UR675B: // new
						// function ():void {				
						var __x_UR675B:Array<Int> /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						var __y_UR675B:Array<Int> /* <Int> */ = [-16, -14, -12, -10, -8, -6, -4, -2, 0, 2, 4, 6, 8, 10, 12, 14];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_UR675B[y15]) {
							oY = ((y2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_UR675B[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_LL675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR675B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_SOFTLF:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTRT:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTUP:
						// function ():void {
						oY = ((y2 & XLogicObjectCX.CX_TILE_HEIGHT_UNMASK) - (m_cx.bottom) - 1);
						
						looking = false;								
						// break; // },
					case XLogicObjectCX.CX_SOFTDN:
						looking = false;
						// break;
					case XLogicObjectCX.CX_DEATH:
						looking = false;
						// break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;
		}
		
		//------------------------------------------------------------------------------------------
		public function Ck_Slope_DN ():Bool {
			var x1:Int, y1:Int, x2:Int, y2:Int;
			var i:Int, __x:Int, __y:Int;
			var collided:Bool;
			var looking:Bool = true;
			var r:Int, c:Int;
			var x15:Int;
			var y15:Int;
			
			collided = false;
			
			//------------------------------------------------------------------------------------------
			// left
			//------------------------------------------------------------------------------------------
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x1/m_submapWidth;
				//				r = y2/m_submapHeight;
				//				i = (int ((y2 & m_submapHeightMask)/XLogicObjectCX.CX_TILE_HEIGHT) * m_cols) + int ((x1 & m_submapWidthMask)/XLogicObjectCX.CX_TILE_WIDTH);
				
				c = x1 >> 9;
				r = y2 >> 9;
				i = ( ((y2 & m_submapHeightMask) >> 4) * m_cols) + ((x1 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XLogicObjectCX.CX_EMPTY:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLIDX001:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLID:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFT:
						// function ():void {
						x1 = (x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + XLogicObjectCX.CX_TILE_WIDTH;
						// break; // },
					case XLogicObjectCX.CX_JUMP_THRU:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR45:
						// function ():void {				
						var __y_UR45:Array<Int> /* <Int> */ = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __y_UR45[y15]) {
							oX = ((x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_UR45[y15] - m_cx.left);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_LL45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR45:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR225A:
						// function ():void {				
						var __y_UR225A:Array<Int> /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						var __x_UR225A:Array<Int> /* <Int> */ = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __y_UR225A[x15]) {
							oX = ((x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __x_UR225A[y15] - m_cx.left);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_UR225B:
						// function ():void {				
						var __y_UR225B:Array<Int> /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						var __x_UR225B:Array<Int> /* <Int> */ = [0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 8, 10, 12, 14, 16];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __y_UR225B[x15]) {
							oX = ((x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __x_UR225B[y15] - m_cx.left);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_LL225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR225B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL675B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UR675A: // new
						// function ():void {								
						var __x_UR675A:Array<Int> /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						var __y_UR675A:Array<Int> /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_UR675A[y15]) {
							oX = ((x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_UR675A[y15] - m_cx.left);
						}
						
						looking = false;
						
						// break;
					case XLogicObjectCX.CX_UR675B: // new
						// function ():void {							
						var __x_UR675B:Array<Int> /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						var __y_UR675B:Array<Int> /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_UR675B[y15]) {
							oX = ((x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_UR675B[y15] - m_cx.left);
						}
						
						looking = false;
						
						// break;	
					
					case XLogicObjectCX.CX_LL675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR675B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_SOFTLF:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTRT:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_LF;
						
						oX = ((x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + XLogicObjectCX.CX_TILE_WIDTH - m_cx.left);
						
						collided = true;
						// break; // },
					case XLogicObjectCX.CX_SOFTUP:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTDN:
						looking = false;
						// break;
					case XLogicObjectCX.CX_DEATH:
						looking = false;
						// break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			//------------------------------------------------------------------------------------------
			// right
			//------------------------------------------------------------------------------------------
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x2/m_submapWidth;
				//				r = y2/m_submapHeight;
				//				i = (int ((y2 & m_submapHeightMask)/XLogicObjectCX.CX_TILE_HEIGHT) * m_cols) + int ((x2 & m_submapWidthMask)/XLogicObjectCX.CX_TILE_WIDTH);
				
				c = x2 >> 9;
				r = y2 >> 9;
				i = ( ((y2 & m_submapHeightMask) >> 4) * m_cols) + ((x2 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XLogicObjectCX.CX_EMPTY:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLIDX001:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLID:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFT:
						// function ():void {
						x2 = (x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) - 1;
						// break; // },
					case XLogicObjectCX.CX_JUMP_THRU:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL45:
						// function ():void {				
						var __y_UL45:Array<Int> /* <Int> */ = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __y_UL45[y15]) {
							oX = ((x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_UL45[y15] - m_cx.right - 1);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_UR45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR45:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL225A:
						// function ():void {				
						var __y_UL225A:Array<Int> /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						var __x_UL225A:Array<Int> /* <Int> */ = [0, 0, 0, 0, 0, 0, 0, 0, 13, 11, 9, 7, 5, 3, 1, -1];   
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __y_UL225A[x15]) {
							oX = ((x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __x_UL225A[y15] - m_cx.right - 1);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_UL225B:
						// function ():void {				
						var __y_UL225B:Array<Int> /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						var __x_UL225B:Array<Int> /* <Int> */ = [13, 11, 9, 7, 5, 3, 1, -1, -3, -5, -7, -9, -11, -13, -15, -17];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __y_UL225B[x15]) {
							oX = ((x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __x_UL225B[y15] - m_cx.right - 1);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_UR225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR225B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL675A: // new
						// function ():void {								
						var __x_UL675A:Array<Int> /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						var __y_UL675A:Array<Int> /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_UL675A[y15]) {
							oX = ((x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_UL675A[y15] - m_cx.bottom - 1);
						}
						
						looking = false;
						
						// break;
					case XLogicObjectCX.CX_UL675B: // new
						// function ():void {							
						var __x_UL675B:Array<Int> /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						var __y_UL675B:Array<Int> /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y2 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_UL675B[y15]) {
							oX = ((x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_UL675B[y15] - m_cx.bottom - 1);
						}
						
						looking = false;
						
						// break;
					
					case XLogicObjectCX.CX_UR675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR675B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_SOFTLF:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_RT;
						
						oX = ((x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) - (m_cx.right) - 1);
						
						collided = true;
						// break; // },
					case XLogicObjectCX.CX_SOFTRT:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTUP:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTDN:
						looking = false;
						// break;
					case XLogicObjectCX.CX_DEATH:
						looking = false;
						// break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;		
		}
		
		//------------------------------------------------------------------------------------------
		public function Ck_Slope_UP ():Bool {
			var x1:Int, y1:Int, x2:Int, y2:Int;
			var i:Int, __x:Int, __y:Int;
			var collided:Bool;
			var looking:Bool = true;
			var r:Int, c:Int;
			var x15:Int;
			var y15:Int;
			
			collided = false;
			
			//------------------------------------------------------------------------------------------
			// left
			//------------------------------------------------------------------------------------------
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x1/m_submapWidth;
				//				r = y1/m_submapHeight;
				//				i = (int ((y1 & m_submapHeightMask)/XLogicObjectCX.CX_TILE_HEIGHT) * m_cols) + int ((x1 & m_submapWidthMask)/XLogicObjectCX.CX_TILE_WIDTH);
				
				c = x1 >> 9;
				r = y1 >> 9;
				i = ( ((y1 & m_submapHeightMask) >> 4) * m_cols) +  ((x1 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XLogicObjectCX.CX_EMPTY:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLIDX001:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLID:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFT:
						// function ():void {
						x1 = (x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + XLogicObjectCX.CX_TILE_WIDTH;
						// break; // },
					case XLogicObjectCX.CX_JUMP_THRU:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR45:
						// function ():void {				
						var __y_LR45:Array<Int> /* <Int> */ = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __y_LR45[y15]) {
							oX = ((x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_LR45[y15] - m_cx.left);
						}
						
						looking = false;
						// break; // },
					
					case XLogicObjectCX.CX_UL225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR225A:
						// function ():void {								
						var __y_LR225A:Array<Int> /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						var __x_LR225A:Array<Int> /* <Int> */ = [32, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __y_LR225A[x15]) {
							oX = ((x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __x_LR225A[y15] - m_cx.left);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_LR225B:
						// function ():void {							
						var __y_LR225B:Array<Int> /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						var __x_LR225B:Array<Int> /* <Int> */ = [16, 14, 12, 10, 8, 6, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __y_LR225B[x15]) {
							oX = ((x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __x_LR225B[y15] - m_cx.left);
						}
						
						looking = false;
						// break; // },
					
					case XLogicObjectCX.CX_UL675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL675B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_LR675A: // new
						// function ():void {								
						var __x_LR675A:Array<Int> /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						var __y_LR675A:Array<Int> /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_LR675A[y15]) {
							oX = ((x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_LR675A[y15] - m_cx.left);
						}
						
						looking = false;
						
						// break;
					case XLogicObjectCX.CX_LR675B: // new
						// function ():void {							
						var __x_LR675B:Array<Int> /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						var __y_LR675B:Array<Int> /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						
						x15 = x1 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_LR675B[y15]) {
							oX = ((x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_LR675B[y15] - m_cx.left);
						}
						
						looking = false;
						
						// break;	
					
					case XLogicObjectCX.CX_SOFTLF:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTRT:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_LF;
						
						oX = ((x1 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + XLogicObjectCX.CX_TILE_WIDTH - m_cx.left);
						
						collided = true;
						// break; // },
					case XLogicObjectCX.CX_SOFTUP:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTDN:
						looking = false;
						// break;
					case XLogicObjectCX.CX_DEATH:
						looking = false;
						// break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			//------------------------------------------------------------------------------------------
			// right
			//------------------------------------------------------------------------------------------
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x2/m_submapWidth;
				//				r = y1/m_submapHeight;
				//				i = (int ((y1 & m_submapHeightMask)/XLogicObjectCX.CX_TILE_HEIGHT) * m_cols) + int ((x2 & m_submapWidthMask)/XLogicObjectCX.CX_TILE_WIDTH);
				
				c = x2 >> 9;
				r = y1 >> 9;
				i = ( ((y1 & m_submapHeightMask) >> 4) * m_cols) + ((x2 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XLogicObjectCX.CX_EMPTY:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLIDX001:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOLID:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFT:
						// function ():void {
						x2 = (x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) - 1;
						// break; // },
					case XLogicObjectCX.CX_JUMP_THRU:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR45:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL45:
						// function ():void {				
						var __y_LL45:Array<Int> /* <Int> */ = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __y_LL45[y15]) {
							oX = ((x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_LL45[y15] - m_cx.right - 1);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_LR45:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR225B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LL225A:
						// function ():void {					
						var __y_LL225A:Array<Int> /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						var __x_LL225A:Array<Int> /* <Int> */ = [0, 2, 4, 6, 8, 10, 12, 14, 0, 0, 0, 0, 0, 0, 0, 0];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __y_LL225A[x15]) {		
							oX = ((x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __x_LL225A[y15] - m_cx.right - 1);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_LL225B:
						// function ():void {				
						var __y_LL225B:Array<Int> /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						var __x_LL225B:Array<Int> /* <Int> */ = [-16, -14, -12, -10, -8, -6, -4, -2, 0, 2, 4, 6, 8, 10, 12, 14];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __y_LL225B[x15]) {
							oX = ((x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __x_LL225B[y15] - m_cx.right - 1);
						}
						
						looking = false;
						// break; // },
					case XLogicObjectCX.CX_LR225A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR225B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_UL675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UL675B:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_UR675B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_LL675A: // new
						// function ():void {								
						var __x_LL675A:Array<Int> /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						var __y_LL675A:Array<Int> /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_LL675A[y15]) {
							oX = ((x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_LL675A[y15] - m_cx.right - 1);
						}
						
						looking = false;
						
						// break;
					case XLogicObjectCX.CX_LL675B: // new
						// function ():void {							
						var __x_LL675B:Array<Int> /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						var __y_LL675B:Array<Int> /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						
						x15 = x2 & XLogicObjectCX.CX_TILE_WIDTH_MASK;
						y15 = y1 & XLogicObjectCX.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_LL675B[y15]) {
							oX = ((x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) + __y_LL675B[y15] - m_cx.right - 1);
						}
						
						looking = false;
						
						// break;	
					
					case XLogicObjectCX.CX_LR675A:
						looking = false;
						// break;
					case XLogicObjectCX.CX_LR675B:
						looking = false;
						// break;
					
					case XLogicObjectCX.CX_SOFTLF:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_RT;
						
						oX = ((x2 & XLogicObjectCX.CX_TILE_WIDTH_UNMASK) - (m_cx.right) - 1);
						
						collided = true;
						// break; // },
					case XLogicObjectCX.CX_SOFTRT:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTUP:
						looking = false;
						// break;
					case XLogicObjectCX.CX_SOFTDN:
						looking = false;
						// break;
					case XLogicObjectCX.CX_DEATH:
						looking = false;
						// break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;		
		}

//------------------------------------------------------------------------------------------		
		public function Ck_Obj_LF ():Bool {
			if (m_objectCollisionList == null) {
				m_objectCollisionList = getObjectCollisionList ();
			}
			
			return Ck_Obj_LF9 (m_objectCollisionList);
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_RT ():Bool {
			if (m_objectCollisionList == null) {
				m_objectCollisionList = getObjectCollisionList ();
			}
			
			return Ck_Obj_RT9 (m_objectCollisionList);
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_UP ():Bool {
			if (m_objectCollisionList == null) {
				m_objectCollisionList = getObjectCollisionList ();
			}
			
			return Ck_Obj_UP9 (m_objectCollisionList);
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_DN ():Bool {
			if (m_objectCollisionList == null) {
				m_objectCollisionList = getObjectCollisionList ();
			}
			
			return Ck_Obj_DN9 (m_objectCollisionList);
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_LF9 (__objectCollisionList:Map<XLogicObject, XRect> /* <XLogicObject, XRect> */):Bool {
			var x1:Int, y1:Int, x2:Int, y2:Int;
			
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
			
			var __collided:Bool = false;
			
			function __collisionCallback (__logicObject:XLogicObjectCX, __rect:XRect):Void {
				if (__logicObject.allowLFCollisions) {
					oX = __rect.right - m_cx.left + 1;
					
					__logicObject.objectCollisionCallback (self);
					
					m_CX_Collide_Flag |= CX_COLLIDE_LF;
				}
			}
			
			for (__key__ in __objectCollisionList.keys ()) {
				if (!function (__logicObject:XLogicObjectCX):Bool {
					var __rect:XRect = cast __objectCollisionList.get (__logicObject); /* as XRect */
					
					if (x2 < __rect.left || x1 > __rect.right || y2 < __rect.top || y1 > __rect.bottom) {
						return true;
					}
					
					__collisionCallback (__logicObject, __rect);
					
					__collided = true;
					
					return true;
				} (cast __key__)) break;
			}
			
			return __collided;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_RT9 (__objectCollisionList:Map<XLogicObject, XRect> /* <XLogicObject, XRect> */):Bool {
			var x1:Int, y1:Int, x2:Int, y2:Int;
			
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
			
			var __collided:Bool = false;
			
			function __collisionCallback (__logicObject:XLogicObjectCX, __rect:XRect):Void {
				if (__logicObject.allowRTCollisions) {
					oX = __rect.left - m_cx.right - 1;
					
					__logicObject.objectCollisionCallback (self);
					
					m_CX_Collide_Flag |= CX_COLLIDE_RT;
				}
			}
			
			for (__key__ in __objectCollisionList.keys ()) {
				if (!function (__logicObject:XLogicObjectCX):Bool {
					var __rect:XRect = cast __objectCollisionList.get (__logicObject); /* as XRect */
					
					if (x2 < __rect.left || x1 > __rect.right || y2 < __rect.top || y1 > __rect.bottom) {
						return true;
					}
					
					__collisionCallback (__logicObject, __rect);
					
					__collided = true;
					
					return true;
				} (cast __key__)) break;
			}
			
			return __collided;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_UP9 (__objectCollisionList:Map<XLogicObject, XRect> /* <XLogicObject, XRect> */):Bool {
			var x1:Int, y1:Int, x2:Int, y2:Int;
			
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
			
			var __collided:Bool = false;

			function __collisionCallback (__logicObject:XLogicObjectCX, __rect:XRect):Void {
				if (__logicObject.allowUPCollisions) {
					oY = __rect.bottom - m_cx.top + 1;
					
					__logicObject.objectCollisionCallback (self);
					
					m_CX_Collide_Flag |= CX_COLLIDE_UP;
				}
			}
			
			for (__key__ in __objectCollisionList.keys ()) {
				if (!function (__logicObject:XLogicObjectCX):Bool {
					var __rect:XRect = cast __objectCollisionList.get (__logicObject); /* as XRect */
					
					if (x2 < __rect.left || x1 > __rect.right || y2 < __rect.top || y1 > __rect.bottom) {
						return true;
					}
					
					__collisionCallback (__logicObject, __rect);
					
					__collided = true;
					
					return true;
				} (cast __key__)) break;
			}
			
			return __collided;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_DN9 (__objectCollisionList:Map<XLogicObject, XRect> /* <XLogicObject, XRect> */):Bool {
			var x1:Int, y1:Int, x2:Int, y2:Int;
			
			x1 = Std.int (oX + m_cx.left);
			x2 = Std.int (oX + m_cx.right);
			y1 = Std.int (oY + m_cx.top);
			y2 = Std.int (oY + m_cx.bottom);
			
			var __collided:Bool = false;
			
			function __collisionCallback (__logicObject:XLogicObjectCX, __rect:XRect):Void {
				if (__logicObject.allowDNCollisions) {
					oY = __rect.top - m_cx.bottom - 1;
					
					__logicObject.objectCollisionCallback (self);
					
					m_CX_Collide_Flag |= CX_COLLIDE_DN;
				}
			}
			
			for (__key__ in __objectCollisionList.keys ()) {
				if (!function (__logicObject:XLogicObjectCX):Bool {
					var __rect:XRect = cast __objectCollisionList.get (__logicObject); /* as XRect */
					
					if (x2 < __rect.left || x1 > __rect.right || y2 < __rect.top || y1 > __rect.bottom || y2 > __rect.bottom) {
						return true;
					}
					
					__collisionCallback (__logicObject, __rect);
					
					__collided = true;
					
					return true;
				} (cast __key__)) break;
			}
			
			return __collided;
		}

//------------------------------------------------------------------------------------------
		public function getObjectCollisionList ():Map<XLogicObject, XRect> /* <XLogicObject, XRect> */ {
			return xxx.getObjectCollisionList ().getRects (getLayer ());	
		}
				
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }