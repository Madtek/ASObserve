package net.sklorz.observe 
{
	import flash.utils.Dictionary;

	/**
	 * Simple callback Manager
	 * 
	 * @author Gregor Sklorz
	 */ 
	public class Caller
	{
		public var observer:Dictionary = new Dictionary();
		
		/**
		 * Add a new callback Function for notifications.
		 */ 
		public function addCallback(signal:String, callback:Function):void 
		{
			if (observer[signal])
			{
				Vector.<Function>(observer[signal]).push(callback);
			}
			else
			{
				var vtmp:Vector.<Function> = new Vector.<Function>();
				vtmp.push(callback);
				observer[signal] = vtmp;
			}
		}

		/**
		 * Removes a callback Function 
		 */ 
		public function removeCallback(signal:String, callback:Function):void 
		{
			var list:Vector.<Function> = Vector.<Function>(observer[signal]);
			if (list != null)
			{
				var i:int = list.indexOf(callback);
				if(i >= 0) list.splice(i, 1);
			}
		}
		
		/**
		 * Calls the specific callbacks to all callbacks
		 */
		public function call(signal:String, value:Object):void
		{
			if (observer[signal] != null)
			{
				var vtmp:Vector.<Function> = Vector.<Function>().concat();
				var i:int; 
				var n:int = vtmp.length;
				for (i = 0; i < n; i++)
				{
					vtmp[i](value);
				}
			}
		}
	}
}