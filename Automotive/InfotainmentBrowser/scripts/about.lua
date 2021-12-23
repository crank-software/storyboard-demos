
local features = {
		"images/features/photoshop_import.png",
		"images/features/prototyping.png",
		"images/features/opengl_es.png",
		"images/features/animation.png"
	}

local fnum = 1
	
function cb_load_feature(mapargs)
	local data = {}
	
	if mapargs.context_screen ~= "info_s" then
		return
	end
	
	data["features_l.feature.image"] = features[fnum]
	gre.set_data(data)
	
	fnum = fnum + 1
	if fnum > table.maxn(features) then
		fnum = 1
	end
	gre.send_event("feature_animation")
	
end