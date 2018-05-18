global itemList =#()
global nowItem = undefined
global exportPath=maxFilePath
fn getAllItemList = 
(
	itemNameList =#()
	itemList =#()
	for item in $* do
	(
		if not(item.isDeleted) do
		(
			tempUserProp = getUserProp item "CName"
			tempName =item.name
			if tempUserProp == undefined or tempUserProp=="" then
			(
				tempName = tempName+"*"
			)
			append itemNameList tempName
			append itemList item
		)
	)
	return itemNameList
)
fn getPath =
(
	folderBrowserDialog = DotNetObject"System.Windows.Forms.FolderBrowserDialog"
	OpenFileResult = folderBrowserDialog.ShowDialog()
	if OpenFileResult.Equals OpenFileResult.OK then
	(
		return folderBrowserDialog.SelectedPath
	)else
	(
		return undefined
	)
)
rollout dialog "Message" width:150 height:50
(
	Label message align:#center offset:[0,10]
)
fn showMessage message =
(
	createDialog dialog 
	dialog.message.text=message
)
fn exportCName progress=
(
	file=CreateFile (exportPath+"//CName.properties")
	try
	(
		itemList =#()
		for item in $* do
		(
			if not(item.isDeleted) do
			(
				append itemList item
			)
		)
		count=itemList.count
		index=0
		for item in itemList do
		(
			if not(item.isDeleted) do
			(
				userProp = getUserProp item "CName"
				if userProp!= undefined and userProp!="" then
				(
					format "%=%\r\n" item.name userProp to:file
				)
			)
			index+=1
			progress.value=(index as Float)/(count as Float)*100
		)
		flush file
	)catch
	(
		showMessage "Exception!"
	)
	close file
)
rollout nameUtil "VkingNameUtil ver.1.0" width:300 height:420
(
	Listbox nameList items:(getAllItemList()) selection:0 width:280 height:25 align:#center
	Edittext nameEdit width:280 height:20 align:#center
	Edittext chooseEdit width:173 height:20 across:3 align:#left
	Button chooseButton "Choose"width:45 offset:[65,0]
	Button exportButton "Export" width:45 align:#right
	ProgressBar progress "" width:280 height:15 align:#center
	on nameList selected i do 
	(
		nameList.items=getAllItemList()
		if i<=itemList.count do(
			nowItem = itemList[i]
			select nowItem
			userProp = getUserProp nowItem "CName"
			if(userProp!= undefined) then
			(
				nameEdit.text= userProp as string
			)else
			(
				nameEdit.text=""
			)
		)
	)
	on nameEdit changed text do(
		if nowItem!=undefined then
		(	
			setUserProp nowItem "CName" text
			nameList.items=getAllItemList()
		)else
		(
			nameEdit.text=""
			showMessage "Select item please!"
		)
	)
	on chooseButton pressed do
	(
		savePath = getPath()
      if savePath != undefined do
		( 
			chooseEdit.text =savePath
		)
	)
	on exportButton pressed do
	(
		if(chooseEdit.text!="")do
		(
			exportPath = chooseEdit.text
		)
		if(exportPath=="")then
		(
			showMessage "Select correct path please!"
		)else
		(
			exportCName progress
			showMessage "Export success!"
		)
	)
)
createDialog nameUtil