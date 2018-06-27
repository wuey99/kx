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
	import kx.geom.*;
	import kx.mvc.*;
	import kx.xml.*;
	
	import openfl.events.*;
	import openfl.utils.*;

//------------------------------------------------------------------------------------------		
	class XMapItemModel extends XModelBase {
		
		private var m_layerModel:XMapLayerModel;
		private var m_logicClassIndex:Int;
		private var m_hasLogic:Bool;
		private var m_name:String;
		private var m_id:Int;
		private var m_imageClassIndex:Int;
		private var m_frame:Int;
		private var m_XMapItem:String;
		private var m_x:Float;
		private var m_y:Float;
		private var m_rotation:Float;
		private var m_scale:Float;
		private var m_depth:Float;
		private var m_collisionRect:XRect;
		private var m_boundingRect:XRect;
		private var m_params:String;

//------------------------------------------------------------------------------------------	
		public function new () {
			super ();
			
			m_id = -1;
		}	

//------------------------------------------------------------------------------------------	
		public function setup (
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
			):Void {
				
				m_layerModel = __layerModel;
				m_logicClassIndex = m_layerModel.getIndexFromClassName (__logicClassName);
				m_hasLogic = __hasLogic;
				m_name = __name;
				m_id = __id;
				m_imageClassIndex = m_layerModel.getIndexFromClassName (__imageClassName);
				m_frame = __frame;
				m_XMapItem = __XMapItem;
				m_x = __x;
				m_y = __y;
				m_scale = __scale;
				m_rotation = __rotation;
				m_depth = __depth;
				m_collisionRect = __collisionRect;
				m_boundingRect = __boundingRect;
				m_params = __params;
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function kill ():Void {
			m_layerModel.removeIndexFromClassNames (logicClassIndex);
			m_layerModel.removeIndexFromClassNames (imageClassIndex);
		}

//------------------------------------------------------------------------------------------
		public function copy2 (__dst:XMapItemModel):Void {
			__dst.layerModel = layerModel;
			__dst.hasLogic = hasLogic;
			__dst.name = name;
			__dst.id = id;
			__dst.imageClassIndex = imageClassIndex;
			__dst.frame = frame;
			__dst.XMapItem = XMapItem;
			__dst.scale = scale;
			__dst.rotation = rotation;
			__dst.depth = depth;
			collisionRect.copy2 (__dst.collisionRect);
			boundingRect.copy2 (__dst.boundingRect);
			__dst.params = params;
		}
		
//------------------------------------------------------------------------------------------
		public function clone (__newLayerModel:XMapLayerModel = null):XMapItemModel {
			var __item:XMapItemModel = new XMapItemModel ();

			if (__newLayerModel == null) {
				__newLayerModel = this.layerModel;
			}
			
			__item.setup (
				__newLayerModel,
// __logicClassName
				this.layerModel.getClassNameFromIndex (m_logicClassIndex),
// __hasLogic
				this.hasLogic,
// __name, __id
				"", __newLayerModel.generateID (),
// __imageClassName, __frame
				this.layerModel.getClassNameFromIndex (m_imageClassIndex), this.frame,
// XMapItem
				this.XMapItem,
// __x, __y,
				this.x, this.y,
// __scale, __rotation, __depth
				this.scale, this.rotation, this.depth,
// __collisionRect,
				this.collisionRect.cloneX (),
// __boundingRect,
				this.boundingRect.cloneX (),
// __params
				this.params,
// args
				[]
				);
			
			return __item;
		}
	
//------------------------------------------------------------------------------------------
		public function getID ():Int {
			return m_id;
		}
		
//------------------------------------------------------------------------------------------
		public function setID (__id:Int):Void {
			m_id = __id;
		}

//------------------------------------------------------------------------------------------
		public var layerModel (get, set):XMapLayerModel;
		
		public function get_layerModel ():XMapLayerModel {
			return m_layerModel;
		}
		
		public function set_layerModel (__layerModel:XMapLayerModel): XMapLayerModel {
			m_layerModel = __layerModel;
			
			return __layerModel;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var inuse (get, set):Int;
		
		public function get_inuse ():Int {
			return m_layerModel.getItemInuse (id);
		}
		
		public function set_inuse (__inuse:Int): Int {
			m_layerModel.setItemInuse (id, __inuse);
			
			return __inuse;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var id (get, set):Int;
		
		public function get_id ():Int {
			return m_id;
		}
		
		public function set_id (__id:Int): Int {
			m_id = __id;
			
			return __id;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var name (get, set):String;
		
		public function get_name ():String {
			return m_name;
		}
		
		public function set_name (__name:String): String {
			m_name = __name;
			
			return __name;			
		}
		/* @:end */
				
//------------------------------------------------------------------------------------------
		public var logicClassIndex (get, set):Int;
		
		public function get_logicClassIndex ():Int {
			return m_logicClassIndex;
		}
		
		public function set_logicClassIndex (__val:Int): Int {
			m_logicClassIndex = __val;
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var logicClassName (get, set):String;
		
		public function get_logicClassName ():String {
			return m_layerModel.getClassNameFromIndex (logicClassIndex);
		}

		public function set_logicClassName (__val:String): String {
			return "";			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var hasLogic (get, set):Bool;
		
		public function get_hasLogic ():Bool {
			return m_hasLogic;
		}
		
		public function set_hasLogic (__val:Bool): Bool {
			m_hasLogic = __val;
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var XMapItem (get, set):String;
		
		public function get_XMapItem ():String {
			return m_XMapItem;
		}
		
		public function set_XMapItem (__val:String): String {
			m_XMapItem = __val;
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var imageClassIndex (get, set):Int;
		
		public function get_imageClassIndex ():Int {
			return m_imageClassIndex;
		}

		public function set_imageClassIndex (__val:Int): Int {
			m_imageClassIndex = __val;
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var imageClassName (get, set):String;
		
		public function get_imageClassName ():String {
			return m_layerModel.getClassNameFromIndex (imageClassIndex);
		}

		public function set_imageClassName (__val:String): String {
			return "";			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public var frame (get, set):Int;
		
		public function get_frame ():Int {
			return m_frame;
		}

		public function set_frame (__frame:Int): Int {
			m_frame = __frame;
			
			return __frame;			
		}
		/* @:end */
								
//------------------------------------------------------------------------------------------
		public var x (get, set):Float;
		
		public function get_x ():Float {
			return m_x;
		}

		public function set_x (__x:Float): Float {
			m_x = __x;
			
			return __x;			
		}
		/* @:end */
				
//------------------------------------------------------------------------------------------
		public var y (get, set):Float;
			
		public function get_y ():Float {
			return m_y;
		}

		public function set_y (__y:Float): Float {
			m_y = __y;
			
			return __y;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var rotation (get, set):Float;
		
		public function get_rotation ():Float {
			return m_rotation;
		}
	
		public function set_rotation (__rotation:Float): Float {
			m_rotation = __rotation;
			
			return __rotation;			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public var scale (get, set):Float;
		
		public function get_scale ():Float {
			return m_scale;
		}
		
		public function set_scale (__scale:Float): Float {
			m_scale = __scale;
			
			return __scale;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var depth (get, set):Float;
		
		public function get_depth ():Float {
			return m_depth;
		}

		public function set_depth (__depth:Float): Float {
			m_depth = __depth;
			
			return __depth;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var boundingRect (get, set):XRect;
		
		public function get_boundingRect ():XRect {
			return m_boundingRect;
		}

		public function set_boundingRect (__rect:XRect): XRect {
			m_boundingRect = __rect;
			
			return __rect;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var collisionRect (get, set):XRect;
		
		public function get_collisionRect ():XRect {
			return m_collisionRect;
		}

		public function set_collisionRect (__rect:XRect): XRect {
			m_collisionRect = __rect;
			
			return __rect;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var params (get, set):String;
		
		public function get_params ():String {
			return m_params;
		}
		
		public function set_params (__params:String): String {
			m_params = __params;
			
			return __params;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public function serialize ():XSimpleXMLNode {
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			var __attribs:Array<Dynamic> /* <Dynamic> */ = [
				"logicClassIndex",	logicClassIndex,
				"hasLogic",			hasLogic ? "true" : "false",
				"name",				name,
				"id",				id,
				"imageClassIndex",	imageClassIndex,
				"frame",			frame,
				"XMapItem",			XMapItem,
				"x",				x,
				"y",				y,
				"rotation",			rotation,
				"scale",			scale,
				"depth",			depth,
				"cx",				collisionRect.x,
				"cy",				collisionRect.y,
				"cw",				collisionRect.width,
				"ch",				collisionRect.height,
				"bx",				boundingRect.x,
				"by",				boundingRect.y,
				"bw",				boundingRect.width,
				"bh",				boundingRect.height
			];
			
			xml.setupWithParams ("XMapItem", "", __attribs);
			
			xml.addChildWithXMLString (params);
			
			return xml;
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
