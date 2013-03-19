
local ffi = require("ffi")

local Collections = require("Collections");
local LeapInterface = require("LeapInterface");
local JSON = require("dkjson");


local LeapScape_t = {}
local LeapScape_mt = {
	__index = LeapScape_t,
}

local LeapScape = function()
	local interface, err = LeapInterface({enableGestures=true});

	if not interface then
		return nil, err;
	end

	local obj = {
		Interface = interface;

		Hands = {};
		Pointables = {};
		Frames = {};

		FrameQueue = Collections.Queue.new();
		ContinueRunning = false;
	};

	setmetatable(obj, LeapScape_mt);

	return obj;
end

LeapScape_t.Start = function(self)
	self.ContinueRunning = true;

	Runtime.Scheduler:Spawn(LeapScape_t.ProcessFrames, self)
	Runtime.Scheduler:Spawn(LeapScape_t.ProcessRawFrames, self);
end

LeapScape_t.ProcessRawFrames = function(self)
	
	for rawframe in self.Interface:RawFrames() do
		local frame = JSON.decode(ffi.string(rawframe.Data, rawframe.DataLength));
		self.FrameQueue:Enqueue(frame);

		coroutine.yield();
	end
end

LeapScape_t.ProcessFrames = function(self, frame)
	while self.ContinueRunning do
		-- get a frame off the queue
		local frame = self.FrameQueue:Dequeue()
		if frame then
			if frame.gestures then
				for _, gesture in ipairs(frame.gestures) do
					self:OnGesture(gesture);
				end
			end
		end
		coroutine.yield();
	end
end


LeapScape_t.OnFrame = function(self, frame)
end

LeapScape_t.OnGesture = function(self, gesture)
	if self.GestureHandler then
		self.GestureHandler:OnGesture(gesture);
	else
		--print("==== GESTURE ====")
		--print("type: ", gesture.type, gesture.state);

		if gesture.type == "screenTap" then
			if self.HandleScreenTap then
				self:HandleScreenTap(gesture)
			end
		elseif gesture.type == "keyTap" then
			if self.HandleKeyTap then
				self:HandleKeyTap(gesture)
			end
		elseif gesture.type == "swipe" then
			if self.HandleSwipe then
				self:HandleSwipe(gesture);
			end
		elseif gesture.type == "circle" then
			if self.HandleCircle then
				self:HandleCircle(gesture);
			end
		end
	end
end




--[=[
{
	"hands":[],
	"id":1237147,
	"pointables":[],
	"r":[[0.837522,0.0947207,-0.538131],[-0.280283,-0.770941,-0.571918],[-0.46904,0.629823,-0.619132]],
	"s":761.842,
	"t":[5717.06,-24638.9,5792.07],
	"timestamp":13583254526
}



{
	"id":1237560,
	"r":[[0.444044,0.663489,-0.602169],[0.184129,-0.725287,-0.663367],[-0.876882,0.183687,-0.444227]],
	"s":762.482,
	"t":[5336.48,-24560.1,5768.29],
	"timestamp":13587071004,

	"hands":[{
		"id":4,
		"direction":[-0.0793992,0.899586,-0.427785],
		"palmNormal":[-0.16208,-0.432144,-0.886711],
		"palmPosition":[27.138,227.235,80.2504],
		"palmVelocity":[-136.716,-134.926,-359.534],
		"sphereCenter":[9.15823,202.468,9.29922],
		"sphereRadius":106.122,
		"r":[[0.989305,-0.132062,-0.0619254],[0.117032,0.97208,-0.203384],[0.0870557,0.193962,0.977139]],
		"s":1.45151,
		"t":[-18.2708,21.6366,-106.687]
	}],
	
	"pointables":[
		{
			"direction":[0.196259,0.670762,-0.715235],
			"handId":4,
			"id":7,
			"length":68.7964,
			"tipPosition":[61.3422,285.46,38.3742],
			"tipVelocity":[-184.398,-119.405,-322.679],
			"tool":false
		},
		{
			"direction":[0.0324904,0.792378,-0.609165],
			"handId":4,
			"id":3,
			"length":76.8893,
			"tipPosition":[14.7425,304.766,41.4163],
			"tipVelocity":[-229.246,-95.6285,-323.667],
			"tool":false
		},
		{
			"direction":[0.271334,0.534838,-0.800204],
			"handId":4,
			"id":8,
			"length":49.8069,
			"tipPosition":[89.5184,249.298,47.0269],
			"tipVelocity":[-154.985,-84.1357,-369.39],
			"tool":false
		},
		{
			"direction":[-0.139337,0.81119,-0.56794],
			"handId":4,
			"id":6,
			"length":65.0902,
			"tipPosition":[-32.0342,288.202,55.0037],
			"tipVelocity":[-210.301,-204.113,-310.102],
			"tool":false
		},
		{
			"direction":[-0.211439,0.860378,-0.463728],
			"handId":4,
			"id":2,
			"length":21.5986,
			"tipPosition":[-63.6876,184.535,108.328],
			"tipVelocity":[-196.117,-171.833,-389.561],
			"tool":false
		}
	]
}
--]=]

return LeapScape;