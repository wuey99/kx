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
package kx.utils;
			
	import kx.xml.*;
	
//------------------------------------------------------------------------------------------
// this class maps a list of classNames to unique indexes
//------------------------------------------------------------------------------------------
	class XClassNameToIndex  {
		private var m_classNamesStrings:Array<String>; // <String>
		private var m_classNamesCounts:Array<Float>; // <Float>
		private var m_freeClassNameIndexes:Array<Float> ; // <Float> 
		
//------------------------------------------------------------------------------------------	
		public function new () {
			m_classNamesStrings = new Array<String> (); // <String>
			m_classNamesCounts = new Array<Float> (); // <Float>
			m_freeClassNameIndexes = new Array<Float> (); // <Float>
		}	

//------------------------------------------------------------------------------------------
		public function setup ():Void {
		}
	
//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}
		
//------------------------------------------------------------------------------------------
// given an index, find its className.
//------------------------------------------------------------------------------------------
		public function getClassNameFromIndex (__index:Int):String {
			return m_classNamesStrings[__index];
		}

//------------------------------------------------------------------------------------------
// given a className assign a unique index to it.
//------------------------------------------------------------------------------------------
		public function getIndexFromClassName (__className:String):Int {
			var index:Int;
			
// look up the index associated with the className
			index = m_classNamesStrings.indexOf (__className);
			
// if no index can be found, create a new index
			if (index == -1) {
				
				// create a new className if there are no previously deleted ones
				if (m_freeClassNameIndexes.length == 0) {		
					m_classNamesStrings.push (__className);
					m_classNamesCounts.push (1);
					index = m_classNamesStrings.indexOf (__className);
				}
				// reclaim a previously deleted className's index
				else
				{	
					index = m_freeClassNameIndexes.pop ();
					m_classNamesStrings[index] = __className;	
					m_classNamesCounts[index]++;	
				}		
			}
			// increment the className's ref count
			else
			{		
				m_classNamesCounts[index]++;
			}
			
			return index;
		}

//------------------------------------------------------------------------------------------
// remove a className from the list
//
// classNames aren't physically removed from the list: the entry is cleared out and the index
// in the Array is made available for reuse.
//------------------------------------------------------------------------------------------
		public function removeIndexFromClassNames (__index:Int):Void {
			m_classNamesCounts[__index]--;
			
			if (m_classNamesCounts[__index] == 0) {
				m_classNamesStrings[__index] = "";
				
				m_freeClassNameIndexes.push (__index);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function getAllClassNames ():Array<String> /* <String> */ {
			var __classNames:Array<String> /* <String> */ = new Array<String> (); // <String>
			var i:Int;
			
			for (i in 0 ... m_classNamesStrings.length) {
				if (m_classNamesStrings[i] != "") {
					__classNames.push (m_classNamesStrings[i]);
				}
			}
			
			return __classNames;
		}

//------------------------------------------------------------------------------------------
		public function getClassNameCount (__index:Int):Int {
			return m_classNamesCounts[__index];
		}
		
//------------------------------------------------------------------------------------------
		public function serialize ():XSimpleXMLNode {
			var __xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			__xml.setupWithParams ("classNames", "", []);
			
			var i:Int;
			
			for (i in 0 ... m_classNamesStrings.length) {
				var __attribs:Array<Dynamic> /* <Dynamic> */ = [
					"index",		i,
					"name",			m_classNamesStrings[i],
					"count",		m_classNamesCounts[i]					
				];
				
				var __className:XSimpleXMLNode = new XSimpleXMLNode ();
				
				__className.setupWithParams ("className", "", __attribs);
				
				__xml.addChildWithXMLNode (__className);
			}
			
			return __xml;
		}

//------------------------------------------------------------------------------------------
		public function deserialize (__xml:XSimpleXMLNode):Void {
			m_classNamesStrings = new Array<String> (); // <String>
			m_classNamesCounts = new Array<Float> (); // <Float>
			m_freeClassNameIndexes = new Array<Float> (); // <Float>
			
			trace (": XClassNameToIndex: deserialize: ");
			
			var __xmlList:Array<XSimpleXMLNode> /* <XSimpleXMLNode> */ = __xml.child ("classNames")[0].child ("className");
			
			var i:Int;
			var __name:String;
			var __count:Int;
			
			for (i in 0 ... __xmlList.length) {
				__name = __xmlList[i].getAttributeString ("name");
				__count = __xmlList[i].getAttributeInt ("count");
				
				trace (": XClassNameToIndex: deserialize: ", __name, __count);
				
				m_classNamesStrings.push (__name);
				
// don't use the count because the rest of the deserialization code is going to add
// the items back to the XMap.
//				m_classNamesCounts.push (__count);
				m_classNamesCounts.push (0);
			}
			
			for (i in 0 ... m_classNamesStrings.length) {
				if (m_classNamesStrings[i] == "") {
					m_freeClassNameIndexes.push (i);
				}
			}
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
