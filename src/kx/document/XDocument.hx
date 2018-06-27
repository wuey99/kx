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
package kx.document;
	
	import kx.mvc.XModelBase;
	import kx.XApp;
	import kx.xml.*;

//------------------------------------------------------------------------------------------
	class XDocument {
		private var m_model:XModelBase;
		private var m_XApp:XApp;
		private var m_name:String;
		private var m_xml:XSimpleXMLNode;
		private var m_documentName:String;
				
//------------------------------------------------------------------------------------------
		public function new () {	
			// super ();
		}

//------------------------------------------------------------------------------------------
		public function setup (__XApp:XApp, __model:XModelBase, __xml:XSimpleXMLNode):Void {
			m_XApp = __XApp;
			model = __model;
			xml = __xml;
			
			if (xml != null) {
				model.deserializeAll (xml);
			}
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}

//------------------------------------------------------------------------------------------
		public function setDocumentName (__name:String):Void {
			m_documentName = __name;
		}
		
//------------------------------------------------------------------------------------------
		public function getDocumentName ():String {
			return m_documentName;
		}
				
//------------------------------------------------------------------------------------------
		public var model (get, set):XModelBase;
		
		public function get_model ():XModelBase {
			return m_model;
		}
		
		public function set_model (__model:XModelBase): XModelBase {
			m_model = __model;
			
			return __model;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var xml (get, set):XSimpleXMLNode;
		
		public function get_xml ():XSimpleXMLNode {
			return m_xml;
		}
		
		public function set_xml (__xml:XSimpleXMLNode): XSimpleXMLNode {
			m_xml = __xml;
			
			return __xml;			
		}
		/* @:end */
				
//------------------------------------------------------------------------------------------
		public function serializeAll ():XSimpleXMLNode {
			return m_model.serializeAll ();
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeAll (__xml:XSimpleXMLNode):Void {
			m_model.deserializeAll (__xml);
		}
		
//------------------------------------------------------------------------------------------		
	}
	
//------------------------------------------------------------------------------------------
// }