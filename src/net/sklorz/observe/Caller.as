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
				var list:Vector.<Function> = Vector.<Function>(observer[signal]);
				if(list.indexOf(callback) >= 0) 
				{
					trace("Caller.addCallback(" + signal, callback + ") : Callback already added for signal");
					return;
				} 
				
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
				
				if(i < 0)
				{
					trace("Caller.removeCallback(" + signal, callback + ") : Callback not found for signal");
					return;
				}
				
				if(i >= 0) list.splice(i, 1);
			}
			else
			{
				trace("Caller.removeCallback(" + signal, callback + ") : No callbacks available for signal");
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
			else
			{
				trace("Caller.call(" + signal, value + ") : No callbacks available for signal");
			}
		}
		
		/**
		 * Removes all callbacks.
		 */
		public function dispose() : void 
		{
			for (var v:String in observer) 
			{
				Vector.<Function>(observer[v]).length = 0;
				delete observer[v];
			}
		}
	}
}