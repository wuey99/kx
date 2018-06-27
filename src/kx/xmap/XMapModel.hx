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
	import kx.pool.*;
	import kx.XApp;
	import kx.xml.*;
	
	import openfl.events.*;
				
//------------------------------------------------------------------------------------------
// XMapModel:
//      consists of 1-n layers (XMapLayerModel).  Each layer is sub-divided
//		into a grid of submaps (XSubmapModel) submapCols wide and submapRows high.
//		each submap is submapWidth pixels wide and submapHeight pixels high.
//------------------------------------------------------------------------------------------
	class XMapModel extends XModelBase {
		private var m_numLayers:Int;
		private var m_layers:Array<XMapLayerModel>; // <XMapLayerModel>
		private var m_allClassNames:Array<String>; // <String>
		private var m_currLayer:Int;
		private var m_useArrayItems:Bool;
		private var m_XSubXMapItemModelPoolManager:XSubObjectPoolManager;
		private var m_XSubXRectPoolManager:XSubObjectPoolManager;
		private var m_XApp:XApp;
		public static var g_XApp:XApp;
		
//------------------------------------------------------------------------------------------	
		public function new () {
			super ();
			
			m_allClassNames = new Array<String> (); // <String>
			m_useArrayItems = false;
			
			m_XApp = g_XApp;
		}	

//------------------------------------------------------------------------------------------
		public function setup (
			__layers:Array<XMapLayerModel> /* <XMapLayerModel> */ = null,
			__useArrayItems:Bool = false
			):Void {
				
			if (__layers == null) {
				return;
			}
			
			m_numLayers = __layers.length;	
			m_layers = new Array<XMapLayerModel> (); // <XMapLayerModel>
			for (i in 0 ... m_numLayers) {
				m_layers.push (null);
			}
			m_currLayer = 0;
			m_useArrayItems = __useArrayItems;
			m_XSubXMapItemModelPoolManager = new XSubObjectPoolManager (m_XApp.getXMapItemModelPoolManager ());
			m_XSubXRectPoolManager = new XSubObjectPoolManager (m_XApp.getXRectPoolManager ());
			
			var i:Int;
			
			for (i in 0 ... m_numLayers) {
				m_layers[i] = __layers[i];
				m_layers[i].setParent (this);
			}
		}				

//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
			var i:Int;
			
			for (i in 0 ... m_numLayers) {
				m_layers[i].cleanup ();
			}
			
			m_XSubXMapItemModelPoolManager.returnAllObjects ();
			m_XSubXRectPoolManager.returnAllObjects ();
		}
		
//------------------------------------------------------------------------------------------
		public static function setXApp (__XApp:XApp):Void {
			g_XApp = __XApp;
		}

//------------------------------------------------------------------------------------------
		public function getXMapItemModelPoolManager ():XSubObjectPoolManager {
			return m_XSubXMapItemModelPoolManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getXRectPoolManager ():XSubObjectPoolManager {
			return m_XSubXRectPoolManager;
		}
		
//------------------------------------------------------------------------------------------
		public var useArrayItems (get, set):Bool;
		
		public function get_useArrayItems ():Bool {
			return m_useArrayItems;
		}
		
		public function set_useArrayItems (__val:Bool): Bool {
			return true;			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public function getNumLayers ():Int {
			return m_numLayers;
		}
		
//------------------------------------------------------------------------------------------
		public function setCurrLayer (__layer:Int):Void {
			m_currLayer = __layer;
		}
		
//------------------------------------------------------------------------------------------
		public function getCurrLayer ():Int {
			return m_currLayer;
		}
		
//------------------------------------------------------------------------------------------
		public function getAllClassNames ():Array<String> /* <String> */ {
			var i:Int, j:Int;
			
			if (m_allClassNames.length == 0) {
				for (i in 0 ... m_numLayers) {
					var __classNames:Array<String> /* <String> */ = m_layers[i].getAllClassNames ();
				
					for (j in 0 ... __classNames.length) {
						if (__classNames[j] != null && m_allClassNames.indexOf (__classNames[j]) == -1) {
							m_allClassNames.push (__classNames[j]);
						}
					}
				}
			}
			
			return m_allClassNames;
		}

//------------------------------------------------------------------------------------------
		public function getLayers ():Array<XMapLayerModel> /* <XMapLayerModel> */ {
			return m_layers;
		}	
				
//------------------------------------------------------------------------------------------
		public function getLayer (__layer:Int):XMapLayerModel {
			return m_layers[__layer];
		}		
		
//------------------------------------------------------------------------------------------
		public function addItem (__layer:Int, __item:XMapItemModel):Void {
			m_layers[__layer].addItem (__item);
		}

//------------------------------------------------------------------------------------------
		public function replaceItems (__layer:Int, __item:XMapItemModel):Array<XMapItemModel> /* <XMapItemModel> */ {
			return m_layers[__layer].replaceItems (__item);
		}
		
//------------------------------------------------------------------------------------------
		public function removeItem (__layer:Int, __item:XMapItemModel):Void {
			m_layers[__layer].removeItem (__item);
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapsAt (
			__layer:Int,
			__x1:Float, __y1:Float,
			__x2:Float, __y2:Float
			):Array<XSubmapModel> /* <XSubmapModel> */ {
				
			return m_layers[__layer].getSubmapsAt (__x1, __y1, __x2, __y2);
		}

//------------------------------------------------------------------------------------------
		public function getItemsAt (
			__layer:Int,
			__x1:Float, __y1:Float,
			__x2:Float, __y2:Float
			):Array<XMapItemModel> /* <XMapItemModel> */ {
				
			return m_layers[__layer].getItemsAt (__x1, __y1, __x2, __y2);
		}

//------------------------------------------------------------------------------------------
		public function getArrayItemsAt (
			__layer:Int,
			__x1:Float, __y1:Float,
			__x2:Float, __y2:Float
		):Array<XMapItemModel> /* <XMapItemModel> */ {
			
			return m_layers[__layer].getArrayItemsAt (__x1, __y1, __x2, __y2);
		}
		
//------------------------------------------------------------------------------------------
		public function getItemsAtCX (
			__layer:Int,
			__x1:Float, __y1:Float,
			__x2:Float, __y2:Float
			):Array<XMapItemModel> /* <XMapItemModel> */ {
				
			return m_layers[__layer].getItemsAtCX (__x1, __y1, __x2, __y2);
		}

//------------------------------------------------------------------------------------------
		public override function serializeAll ():XSimpleXMLNode {
			return serialize ();
		}
		
//------------------------------------------------------------------------------------------
		public override function deserializeAll (__xml:XSimpleXMLNode):Void {
			trace (": [XMap] deserializeAll: ");
			
			deserialize (__xml, false);
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeAllNormal (__xml:XSimpleXMLNode, __useArrayItems:Bool=false):Void {
			trace (": [XMap] deserializeAll: ");
			
			deserialize (__xml, false, __useArrayItems);
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeAllReadOnly (__xml:XSimpleXMLNode, __useArrayItems:Bool=false):Void {
			trace (": [XMap] deserializeAll: ");
			
			deserialize (__xml, true, __useArrayItems);
		}
		
//------------------------------------------------------------------------------------------
		public function serialize ():XSimpleXMLNode {
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			xml.setupWithParams ("XMap", "", []);
			
			xml.addChildWithXMLNode (serializeLayers ());
							
			return xml;
		}

//------------------------------------------------------------------------------------------	
		private function serializeLayers ():XSimpleXMLNode {
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			xml.setupWithParams ("XLayers", "", []);
	
			var i:Int;
			
			for (i in 0 ... m_numLayers) {
				m_layers[i].serialize (xml);
			}
			
			return xml;
		}

//------------------------------------------------------------------------------------------
		private function deserialize (__xml:XSimpleXMLNode, __readOnly:Bool=false, __useArrayItems:Bool=false):Void {
			trace (": [XMap] deserialize: ");
			
			var i:Int;
			
			var __xmlList:Array<XSimpleXMLNode> /* <XSimpleXMLNode> */ = __xml.child ("XLayers")[0].child ("XLayer");
			
			m_numLayers = __xmlList.length;
			m_layers = new Array<XMapLayerModel> (); // <XMapLayerModel>
			for (i in 0 ... m_numLayers) {
				m_layers.push (null);
			}
			m_useArrayItems = __useArrayItems;
			m_XSubXMapItemModelPoolManager = new XSubObjectPoolManager (m_XApp.getXMapItemModelPoolManager ());
			m_XSubXRectPoolManager = new XSubObjectPoolManager (m_XApp.getXRectPoolManager ());
				
			for (i in 0 ... __xmlList.length) {
				m_layers[i] = new XMapLayerModel ();
				m_layers[i].setParent (this);
				m_layers[i].deserialize (__xmlList[i], __readOnly);
			}
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
