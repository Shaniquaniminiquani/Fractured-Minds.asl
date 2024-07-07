// Written by JayC_ 6/16/2023 intended for use with the amazon prime+ version of "Fractured Minds" available in the speedrun.com resources for the game.
// Updated 7/07/2024

state("FracturedMinds")
{
	string128 chapter: "UnityPlayer.dll", 0x1471DE8, 0x48, 0x10, 0x0;
	int load: "UnityPlayer.dll", 0x144B908, 0xA7C;
	int isCurLoading: "UnityPlayer.dll", 0x1471DE8, 0x38;
	int end: "mono.dll", 0x225050, 0x3C;
	int movement: "UnityPlayer.dll", 0x13B7AE0, 0x0, 0x0, 0x938;
	int allowedMove: "UnityPlayer.dll", 0x1483DC0, 0x58, 0x38, 0x68;
	string15 version: "UnityPlayer.dll", 0x14222B6;
}

startup
{
	settings.Add("Extra Levels", false);
	settings.SetToolTip("Extra Levels", "Allows for additional splits for both the Hallway and WJ respectively");
	settings.CurrentDefaultParent = "Extra Levels";
	settings.Add("Hallway", false);
	settings.Add("Water Jump", false);
	settings.CurrentDefaultParent = null;
	settings.Add("Load Removal");
	settings.SetToolTip("Load Removal", "Pause Menu stops the timer as well as removing the time from 'LoadLevel' between Chapters");
	settings.Add("Any% X10", false);
	settings.SetToolTip("Any% X10", "Enable to split on end screen only");
	settings.CurrentDefaultParent = null;
	settings.Add("Additional Options");
	settings.CurrentDefaultParent = "Additional Options";
	settings.Add("Reset on Exit");
	settings.SetToolTip("Reset on Exit", "Self explanatory");
	
	if(timer.CurrentTimingMethod == TimingMethod.RealTime){
		var response = MessageBox.Show (
			"You have Load Removal enabled in the settings\nFor this to work, you need to compare against Game Time\nCurrently, this is not the case\nWant to change it now?",
			"Fractured Minds", 
			MessageBoxButtons.YesNo, 
			MessageBoxIcon.Question);
		if (response == DialogResult.Yes){
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}
	
	vars.TimerModel = new TimerModel {CurrentState = timer};
}

start
{
	if((current.movement >= 1080860849) && (current.movement <= 1080861975)){
		return;
	} else {
		if(current.allowedMove == 1 && current.movement != 0){
			return true;
		}
	}
}

update
{
	if(current.version != "TLS_MAX_VERSION"){
		return false;
	}
  	current.chapter = Path.GetFileNameWithoutExtension(current.chapter);

  	if(string.IsNullOrEmpty(current.chapter)){
		current.chapter = old.chapter;
  	}
	if(settings["Hallway"]){
		if (current.chapter == "hallway2"){
			current.chapter = "hehexd";
		}
  	}
  	if(settings["Water Jump"]){
		if (current.chapter == "watermid"){
			current.chapter = "hehexd";
		}
  	}
}

split
{
  	if((settings["Any% X10"] == false) && (((old.chapter != current.chapter) && (current.chapter != "LoadLevel") && (current.chapter != "watermid") && (current.chapter != "hallway2")) || ((current.chapter == "finalLevel") && (current.end != old.end)))){
		return true;
 	} else {
		if ((current.chapter == "finalLevel") && (current.end != old.end)){
			return true;
		}
	}
}

reset
{
	if((current.chapter == "menu") && (settings["Any% X10"] == false)){
		return true;
	}
}

exit
{
	if(settings["Reset on Exit"]){
		vars.TimerModel.Reset();
	} else {
		timer.IsGameTimePaused = true;
	}
}

isLoading
{
	if(settings["Load Removal"]){
		if((current.load == 1 && (settings["Any% X10"] == false)) || current.chapter == "LoadLevel" || ((current.chapter == "watermid") && (current.isCurLoading == 1))){
			return true;
		} else {
			return false;
		}
	}
}
