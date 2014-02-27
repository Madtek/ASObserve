package net.sklorz.test {
	import net.sklorz.observe.Caller;
	import flexunit.framework.Assert;

	public class CallerTest {
		private var c : Caller;
		private var value1:Object;
		private var value2:Object;
		
		public const SIGNAL:String = "SIGNAL";
		
		[BeforeClass]
		public static function construct() : void {
		}

		[AfterClass]
		public static function destroy() : void {
		}

		[Before]
		public function setUp() : void {
			c = new Caller();
		}

		[After]
		public function tearDown() : void {
			c.dispose();
			value1 = null;
			value2 = null;
		}

		public function callback(value:Object) : void {
			this.value1 = value;
		}
		
		public function callback2(value:Object) : void {
			this.value2 = value;
		}

		[Test]
		public function sureTest() : void {
			Assert.assertTrue(true);
		}
		
		[Test]
		public function add_callback_by_signal() : void {
			Assert.assertTrue(c.addCallback(callback, SIGNAL));
			Assert.assertTrue(c.hasCallback(callback, SIGNAL));
			Assert.assertTrue(c.hasCallback(callback));
		}
		
		[Test]
		public function remove_callback_by_signal() : void {
			c.addCallback(callback, SIGNAL);
			
			Assert.assertTrue(c.removeCallback(callback, SIGNAL));
			Assert.assertFalse(c.hasCallback(callback, SIGNAL));
			Assert.assertFalse(c.hasCallback(callback));
		}
		
		[Test]
		public function add_callback() : void {
			Assert.assertTrue(c.addCallback(callback));
			Assert.assertTrue(c.hasCallback(callback));
		}
		
		[Test]
		public function remove_callback() : void {
			c.addCallback(callback);
			
			Assert.assertTrue(c.removeCallback(callback));
			Assert.assertFalse(c.hasCallback(callback));
		}
		
		[Test]
		public function call_callback_by_signal() : void {
			var str:String = "TEST";
			
			c.addCallback(callback, SIGNAL);
			c.addCallback(callback2);
			
			Assert.assertTrue(c.call(str, SIGNAL));
			Assert.assertTrue(str == value1);
			Assert.assertFalse(str == value2);
		}
		
		[Test]
		public function call_callback() : void {
			var str:String = "TEST";
			
			c.addCallback(callback, SIGNAL);
			c.addCallback(callback2);
			
			Assert.assertTrue(c.call(str));
			Assert.assertTrue(str == value1);
			Assert.assertTrue(str == value2);
		}
	}
}
