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
package gx.music;
	
	import gx.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.ui.*;
	
	import openfl.events.*;
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class SoundToggleButtonsX extends XLogicObjectCX {
		private var m_BGMToggleButton:BGMToggleButtonX;
		private var m_SFXToggleButton:SFXToggleButtonX;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic>  /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			createSprites ();
		}

		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
			
			m_BGMToggleButton.nukeLater ();
			m_SFXToggleButton.nukeLater ();
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			addTask ([
				XTask.WAIT, 0x0100,
				
				function ():Void {
					m_BGMToggleButton = cast xxx.getXLogicManager ().initXLogicObject (
						// parent
						GX.appX.getLevelObject (),
						// logicObject
						cast new BGMToggleButtonX () /* as XLogicObject */,
						// item, layer, depth
						null, GX.appX.PLAYFIELD_LAYER, 100000,
						// x, y, z
						oX, oY, 0,
						// scale, rotation
						1.0, 0,
						[
							GX.appX.getBGMVolume ()
						]
					) /* as BGMToggleButtonX */;
					
					GX.appX.getLevelObject ().addXLogicObject (m_BGMToggleButton);
					
					m_BGMToggleButton.addToggleListener (
						function (__volume:Float):Void {	
							GX.appX.setBGMVolume (__volume);
						}
					);
					
					m_SFXToggleButton = cast xxx.getXLogicManager ().initXLogicObject (
						// parent
						GX.appX.getLevelObject (),
						// logicObject
						cast new SFXToggleButtonX () /* as XLogicObject */,
						// item, layer, depth
						null, GX.appX.PLAYFIELD_LAYER, 100000,
						// x, y, z
						oX + 52, oY, 0,
						// scale, rotation
						1.0, 0,
						[
							GX.appX.getSFXVolume ()
						]
					) /* as SFXToggleButtonX */;
					
					GX.appX.getLevelObject ().addXLogicObject (m_SFXToggleButton);
					
					m_SFXToggleButton.addToggleListener (
						function (__volume:Float):Void {
							GX.appX.setSFXVolume (__volume);
						}
					);
				},
				
				XTask.RETN,
			]);
			
			show ();
		}

	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }