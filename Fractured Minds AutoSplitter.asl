// Written by JayC_ 6/16/2023 intended for use with the amazon prime version of "Fractured Minds" available in the speedrun.com resources for the game.
state("FracturedMinds")
{
	string128 chapter: "UnityPlayer.dll", 0x1471DE8, 0x48, 0x10, 0x0;
	int load: "UnityPlayer.dll", 0x144B908, 0xA7C;
	int end: "mono.dll", 0x225050, 0x3C;
	int movement: "UnityPlayer.dll", 0x13B7AE0, 0x0, 0x0, 0x938;
	int allowedMove: "UnityPlayer.dll", 0x1483DC0, 0x58, 0x38, 0x68;
	string15 version: "UnityPlayer.dll", 0x14222B6;
}

startup
{
	settings.Add("Extra Levels");
	settings.SetToolTip("Extra Levels", "Allows for additional splits for both the Hallway and WJ respectively");
	settings.CurrentDefaultParent = "Extra Levels";
	settings.Add("Hallway");
	settings.Add("Water Jump");
	settings.CurrentDefaultParent = null;
	settings.Add("Load Removal");
	settings.SetToolTip("Load Removal", "Pause Menu stops the timer as well as removing the time from 'LoadLevel' between Chapters");
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
  	if(settings["Hallway"] != true){
		if (current.chapter == "hallway2"){
			current.chapter = old.chapter;
		}
  	}
  	if(settings["Water Jump"] != true){
		if (current.chapter == "watermid"){
			current.chapter = old.chapter;
		}
  	}
}

split
{
  	if(((old.chapter != current.chapter) && (current.chapter == "LoadLevel")) || ((current.chapter == "finalLevel") && (current.end != old.end))){
	return true;
 	}
}

reset
{
	if(current.chapter == "menu"){
	return true;
	}
}

exit
{
	timer.IsGameTimePaused = true;
}

isLoading
{
	if(settings["Load Removal"]){
		if(current.load == 1 || current.chapter == "LoadLevel"){
			return true;
		} else {
			return false;
		}
	}
}
