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
	import kx.type.*;
	
	//------------------------------------------------------------------------------------------
	// this class maps a list of ReferenceNames to unique indexes
	//------------------------------------------------------------------------------------------
	class XReferenceNameToIndex  {
		private var m_referenceNamesStrings:Array<String>; // <String>
		private var m_referenceNamesCounts:Array<Int>; // <Int>
		private var m_freeReferenceNameIndexes:Array<Int>; // <Int>
		
		//------------------------------------------------------------------------------------------	
		public function new () {
			m_referenceNamesStrings = new Array<String> (); // <String>
			m_referenceNamesCounts = new Array<Int> (); // <Int>
			m_freeReferenceNameIndexes = new Array<Int> (); // <Int>
		}	
		
		//------------------------------------------------------------------------------------------
		public function setup ():Void {
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}

		//------------------------------------------------------------------------------------------
		public function setReferenceNamesStrings (__value:Array<String> /* <String> */):Void {
			m_referenceNamesStrings = __value;
		}
		
		//------------------------------------------------------------------------------------------
		public function setReferenceNamesCounts (__value:Array<Int> /* <Int> */):Void {
			m_referenceNamesCounts = __value;
		}
		
		//------------------------------------------------------------------------------------------
		public function setFreeReferenceNameIndexes (__value:Array<Int> /* <Int> */):Void {
			m_freeReferenceNameIndexes = __value;
		}
		
		//------------------------------------------------------------------------------------------
		public function clone ():XReferenceNameToIndex {
			var __dst:XReferenceNameToIndex = new XReferenceNameToIndex ();
			
			__dst.setReferenceNamesStrings (cast XType.copyArray (m_referenceNamesStrings));
			__dst.setReferenceNamesCounts (cast XType.copyArray (m_referenceNamesCounts));
			__dst.setFreeReferenceNameIndexes (cast XType.copyArray (m_freeReferenceNameIndexes));
			
			return __dst;
		}
		
		//------------------------------------------------------------------------------------------
		// given an index, find its ReferenceName.
		//------------------------------------------------------------------------------------------
		public function getReferenceNameFromIndex (__index:Int):String {
			return m_referenceNamesStrings[__index];
		}
		
		//------------------------------------------------------------------------------------------
		// given a reference assign a unique index to it.
		//------------------------------------------------------------------------------------------
		public function getIndexFromReferenceName (__referenceName:String):Int {
			var index:Int;
			
			// look up the index associated with the ReferenceName
			index = m_referenceNamesStrings.indexOf (__referenceName);
			
			// if no index can be found, create a new index
			if (index == -1) {
				
				// create a new ReferenceName if there are no previously deleted ones
				if (m_freeReferenceNameIndexes.length == 0) {		
					m_referenceNamesStrings.push (__referenceName);
					m_referenceNamesCounts.push (1);
					index = m_referenceNamesStrings.indexOf (__referenceName);
				}
					// reclaim a previously deleted ReferenceName's index
				else
				{	
					index = m_freeReferenceNameIndexes.pop ();
					m_referenceNamesStrings[index] = __referenceName;	
					m_referenceNamesCounts[index]++;	
				}		
			}
				// increment the ReferenceName's ref count
			else
			{		
				m_referenceNamesCounts[index]++;
			}
			
			return index;
		}
		
		//------------------------------------------------------------------------------------------
		// remove a ReferenceName from the list
		//
		// ReferenceNames aren't physically removed from the list: the entry is cleared out and the index
		// in the Array is made available for reuse.
		//------------------------------------------------------------------------------------------
		public function removeIndexFromReferenceNames (__index:Int):Void {
			if (m_referenceNamesCounts[__index] > 0) {
				m_referenceNamesCounts[__index]--;
			}
			
			/*
			if (m_referenceNamesCounts[__index] == 0) {
				m_referenceNamesStrings[__index] = "";
				
				m_freeReferenceNameIndexes.push (__index);
			}
			*/
		}
		
		//------------------------------------------------------------------------------------------
		public function getAllReferenceNames ():Array<String> /* <String> */ {
			var __referenceNames:Array<String> /* <String> */ = new Array<String> (); // <String>
			var i:Int;
			
			for (i in 0 ... m_referenceNamesStrings.length) {
				if (m_referenceNamesStrings[i] != "") {
					__referenceNames.push (m_referenceNamesStrings[i]);
				}
			}
			
			return __referenceNames;
		}
		
		//------------------------------------------------------------------------------------------
		public function getReferenceNameCount (__index:Int):Int {
			return m_referenceNamesCounts[__index];
		}
		
		//------------------------------------------------------------------------------------------
		public function setReferenceNameCount (__index:Int, __value:Int):Void {
			m_referenceNamesCounts[__index] = __value;
		}

		//------------------------------------------------------------------------------------------
		public function clearReferenceNamesCounts ():Void {
			var i:Int;
			
			for (i in 0 ... m_referenceNamesCounts.length) {
				m_referenceNamesCounts[i] = 0;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function serialize ():XSimpleXMLNode {
			var __xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			__xml.setupWithParams ("classNames", "", []);
			
			var i:Int;
			var __name:String;
			var __count:Int;
			
			for (i in 0 ... m_referenceNamesStrings.length) {
				__name = m_referenceNamesStrings[i];
				__count = m_referenceNamesCounts[i];
				
				if (__count == 0) {
					__name = "";
				}
				
				var __attribs:Array<Dynamic> /* <Dynamic> */ = [
					"index",		i,
					"name",			__name,
					"count",		__count					
				];
				
				var __referenceName:XSimpleXMLNode = new XSimpleXMLNode ();
				
				__referenceName.setupWithParams ("className", "", __attribs);
				
				__xml.addChildWithXMLNode (__referenceName);
			}
			
			return __xml;
		}
		
		//------------------------------------------------------------------------------------------
		public function deserialize (__xml:XSimpleXMLNode):Void {
			m_referenceNamesStrings = new Array<String> (); // <String>
			m_referenceNamesCounts = new Array<Int> (); // <Int>
			m_freeReferenceNameIndexes = new Array<Int> (); // <Int>
			
			trace (": XReferenceNameIndex: deserialize: ");
			
			if (__xml.child ("classNames").length == 0) {
				return;
			}
			
			var __xmlList:Array<XSimpleXMLNode> /* <XSimpleXMLNode> */ = __xml.child ("classNames")[0].child ("className");
			
			var i:Int;
			var __name:String;
			var __count:Int;
			
			for (i in 0 ... __xmlList.length) {
				__name = __xmlList[i].getAttributeString ("name");
				__count = __xmlList[i].getAttributeInt ("count");
				
				trace (": XReferenceNameIndex: deserialize: ", __name, __count);
				
				m_referenceNamesStrings.push (__name);
				
				// don't use the count because the rest of the deserialization code is going to add
				// the items back to the XMap.
				//				m_referenceNamesCounts.push (__count);
				m_referenceNamesCounts.push (0);
			}
			
			for (i in 0 ... m_referenceNamesStrings.length) {
				if (m_referenceNamesStrings[i] == "") {
					m_freeReferenceNameIndexes.push (i);
				}
			}
		}
		
		//------------------------------------------------------------------------------------------	
	}
	
	//------------------------------------------------------------------------------------------	
// }
