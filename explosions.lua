return function(button_list, stepstype, skin_params)
	local ret= {}
	local rots= {
		Left= 90, Down= 0, Up= 180, Right= 270,
		UpLeft= 90, UpRight= 180, 
		DownLeft= 0, DownRight= 270,  Center= 0
	}
	local tap_redir= {
		Left= "down", Right= "down", Down= "down", Up= "down", 
		UpLeft= "DownLeft", UpRight= "DownLeft", -- shared for dance and pump
		DownLeft= "DownLeft", DownRight= "DownLeft", Center= "Center"
	}
	for i, button in ipairs(button_list) do
		local column_frame= Def.ActorFrame{
			InitCommand= function(self)
				self:rotationz(rots[button] or 0)
			end,
			Def.Sprite{
				Texture= tap_redir[button].." explosion (doubleres).png", InitCommand= function(self)
					self:visible(false):SetAllStateDelays(.05)
				end,
				ColumnJudgmentCommand= function(self, param)
					local diffuse= {
						TapNoteScore_W1= {0.73,0.87,1.00,1},
						TapNoteScore_W2= {1.00,0.93,0.74,1},
						TapNoteScore_W3= {0.60,0.87,0.65, 1},
						TapNoteScore_W4= {0.74,0.67,0.85, 1},
						TapNoteScore_W5= {.8, 0, .6, 1},
						HoldNoteScore_Held= {1, 1, 1, 1},
					}
					local exp_color= diffuse[param.tap_note_score or param.hold_note_score]
					if exp_color then
						self:stoptweening()
							:diffuse(exp_color):zoom(1):diffusealpha(0.9):visible(true)
							:smooth(0.2):zoom(1.1):diffusealpha(0)
							:sleep(0):queuecommand("hide")
					end
				end,
				hideCommand= function(self)
					self:visible(false)
				end,
			},
			Def.Sprite{
				Texture= tap_redir[button].." explosion (doubleres).png", InitCommand= function(self)
					self:visible(false):SetAllStateDelays(.05)
				end,
				HoldCommand= function(self, param)
					if param.start then
						self:finishtweening()
							:zoom(1):diffusealpha(1):visible(true)
					elseif param.finished then
						self:stopeffect():linear(0.06):diffusealpha(0)
							:sleep(0):queuecommand("hide")
					else
						self:zoom(1)
					end
				end,
				hideCommand= function(self)
					self:visible(false)
				end,
			},
		}
		ret[i]= column_frame
	end
	return ret
end
