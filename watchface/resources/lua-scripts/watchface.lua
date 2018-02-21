gSceneLauncher = nil -- global var pointing the scene launcher application.

-- Key state.
local DOWN = 0
local UP = 1
local LAST = 2

-- Key codes.
local ESC_KEY = 9
local KEY_BACK = 166

function OnCreate( sceneLauncher )
  gSceneLauncher = sceneLauncher
  ConnectKeyEvent( gSceneLauncher )
end

function OnKeyEvent( keyCode, keyModifier, state )
  if UP == state then
    if ESC_KEY == keyCode or KEY_BACK == keyCode then
      QuitApplication( gSceneLauncher )
    end
  end

end --function

function OnHourChange( hour011Minute )
  angle = 720.0 * hour011Minute / 24.0

  RotateActor( "Hand_Hours", angle, 0.0, 0.0, 1.0 )
end -- function

function OnMinuteChange( minuteSecond )
  angle = 360.0 * minuteSecond / 60.0

  RotateActor( "Hand_Minutes", angle, 0.0, 0.0, 1.0 )
end --function

function OnSecondChange( secondMillisecond )
  angle = 360.0 * secondMillisecond / 60.0

  RotateActor( "Hand_Seconds", angle, 0.0, 0.0, 1.0 )
end --function
