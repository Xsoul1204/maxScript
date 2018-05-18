global convertResults=#()
global sameResults=#()
global unNormalResults=#()
global exportPath=maxFilePath

fn getPath=
(
	folderBrowserDialog = DotNetObject"System.Windows.Forms.FolderBrowserDialog"
	OpenFileResult = folderBrowserDialog.ShowDialog()
	if OpenFileResult.Equals OpenFileResult.OK then
	(
		folderBrowserDialog.SelectedPath
	)
		else Undefined
	)
--??????????
--????????? ????????
fn getSameNameList=
(
	names=#()
	newList=#()
	for i=1 to sameResults.count do
	(
		a=sameResults[i]
		if not(a.isDeleted) do
		(
			append names a.name
			append newList a
		)
	)
	sameResults=newList
	return names
)

--???????????
--????????? ????????
fn getunNormalNameList=
(
	unNormals=#()
	newList=#()
	for i=1 to unNormalResults.count do
	(
		a=unNormalResults[i]
		if not(a.isDeleted) do
		(
			append unNormals a.name
			append newList a
		)
	)
	unNormalResults=newList
	return unNormals
)
--????????????
--????????? ????????
fn getConvertNameList=
(
	names=#()
	newList=#()
	for i=1 to convertResults.count do
	(
		a=convertResults[i]
		if not(a.isDeleted) do
		(
			append names (a.name +"'s type is "+((classOf a )as String))
			append newList a
		)
	)
	convertResults=newList
	return names
)
--???
rollout dialog "Dialog"
(
	Label message
)
--??Geometry????????
rollout convertRollout "Failed:" width:280 height:180
(	
	MultiListbox convertListbox items:(getConvertNameList()) width:250  
	on convertListbox selectionEnd do
	(	
		convertListbox.items=(getConvertNameList())
		selectObject convertListbox
	)
	Button selectAllBtn "SelectAll" across:3  align:#center
	on selectAllBtn pressed do
	(
		selectionList =#()
		for i=1 to (convertListbox.items).count do
		(
			append selectionList i 
		)
		convertListbox.selection=selectionList
		selectObject convertListbox
	)
	
	Button cancleBtn "Deselect"
	on cancleBtn pressed do
	(
		convertListbox.selection=#()
		selectObject convertListbox
	)
	Button deleteBtn "Delete" align:#center
	on deleteBtn pressed do
	(
		selectConverts=convertListbox.selection
		for i in selectConverts do 
		(
			convert =convertResults[i]
			if not(convert.isDeleted) do
			(
				delete convertResults[i]
			)
		)
		convertListbox.items=(getConvertNameList())
	)
)
--?????????
rollout unNormalRollout "Failed:" width:280 height:180
(	
	Edittext unNormalEdit  pos:[10,10] width:253
	Listbox unNormalListbox items:(getunNormalNameList()) width:250
	on unNormalListbox selected i do 
	(
		unNormalListbox.items=(getunNormalNameList())
		unNormal=unNormalResults[i]
		if not(unNormal!=undefined and unNormal.isDeleted) do 
		(
			uName=""
			if unNormal!=undefined do
			(
				select unNormal
				uName =unNormal.name
			)
			unNormalEdit.text=uName
		)
	)
	on unNormalEdit changed text do
	(
		unNormalResults[unNormalListbox.selection].name=text
		items =unNormalListbox.items
		unNormalListbox.items[unNormalListbox.selection]=text
		unNormalListbox.items=items
	)
)
--??????????
rollout sameRollout "SameName:" width:280 height:180
(
	Edittext sameEdit  pos:[10,10] width:253
	Listbox sameListbox items:(getSameNameList()) width:250
	on sameListbox selected i do 
	(
		sameListbox.items=(getSameNameList())
		same=sameResults[i]
		if not(same.isDeleted) do 
		(
			select same
			sameEdit.text= same.name
		)
	)
	on sameEdit changed text do
	(
		sameResults[sameListbox.selection].name=text
		items =sameListbox.items
		sameListbox.items[sameListbox.selection]=text
		sameListbox.items=items
	)
)
--????
fn unGroupAll progress=
(
	explodeGroup $*
	createDialog dialog 100 20
	dialog.message.text="UnGroupFinished!"
)

--???????????????
--???????
--???????
--????????
fn deleteSymbol progress=
(	
	unNormalResults=#()
	count=$*.count
	index=0
	for ob in $*  do
	(
		if not isGroupHead ob do
		(
			tempName=ob.name
			newName=""
			for i=1 to tempName.count do
			(
				char = tempName[i]
				ascii=bit.charAsInt char
				if (ascii>=97 and ascii<=122) then
				(
					char=bit.intAsChar (ascii-32)
				)
				else
				(
					if ascii==95 then
					(
						char="-"
					)else
					(
						if( (ascii<48 and ascii!=45) or (ascii>57 and ascii<65) or (ascii>90 and ascii<97)or(ascii>122))do
						(
							f=findItem unNormalResults ob
							if f==0 do
							(
								append unNormalResults ob
							)
						)
					)	
				)
				newName+=char
				ob.name=newName
			)
		)
		index+=1
		progress.value=(index as Float)/(count as Float)*100
	)
	if unNormalResults.count>0 then
	(
		createDialog unNormalRollout
	)else
	(
		createDialog dialog 120 20
		dialog.message.text="NormalizeNameFinished!"
	)
)

--???????Geometry
fn turnToGeometry progress=
(	
	count=$*.count
	index=0
	--??????
	convertResults=#()
	for ob in $* do
	(
		if canConvertTo ob Editable_Poly then
		(
			convertTo ob Editable_Poly
		)else
		(
			append convertResults ob
		)
		index+=1
		progress.value=(index as Float)/(count as Float)*100
	)
	if convertResults.count>0 then
	(
		createDialog convertRollout
	)else
	(
		createDialog dialog 100 20
		dialog.message.text="TurnToPolyFinished!"	
	)
)

--???????
fn findSame progress=
(
	count=$*.count
	index=0
	--??????
	sameResults=#()
	for ob in $* do
	(
		if not isGroupHead ob do
		(
			for oba in $* do
			(
				if not isGroupHead oba do
				(
					if ob!=oba do
					(
						if ob.name==oba.name do
						(
							f=findItem sameResults ob
							if f==0 do
							(
								append sameResults ob
							)
							fa=findItem sameResults oba
							if fa==0 do
							(
								append sameResults oba
							)
						)
					)
				)
			)
		)
		index+=1
		progress.value=(index as Float)/(count as Float)*100
	)
	if sameResults.count>0 then
	(
		createDialog sameRollout
	)else
	(
		createDialog dialog 100 20
		dialog.message.text="WithoutSameName!"
	)
)






global convertSelectList=#{}
fn selectObject convertListbox=
(
	for convertSelect in convertSelectList do
	(
		convert =convertResults[convertSelect]
		if not(convert==undefined) and not(convert.isDeleted) then 
		(
			deselect convert
		)
	)
	convertSelectList=convertListbox.selection
	for convertSelect in convertSelectList do
	(	
		convert =convertResults[convertSelect]
		if not(convert.isDeleted) then 
		(
			selectMore convert
		)
	)
	
)
--????????
fn existFile fname =(getfiles fname).count != 0
--??
fn export progress=
(
	if exportPath!=""then
	(
		max select all
		for m in selectionSets do 
		(
			select m
			exportFile (exportPath +"//"+ m.name+ ".3ds") #noPrompt selectedOnly: true
			--exportFile (maxFilePath +"//"+ m.name+ ".fbx") #noPrompt selectedOnly: true
		)
		n = getNumNamedSelSets()
		for i= 1 to n do
		(
			select selectionSets[i]  	
			freeze selectionSets[i]
		)
		file=CreateFile (exportPath+"//config")
		count=geometry.count+shapes.count
		index=0
		for tempGeo in geometry  do
		(
			if tempGeo.isFrozen ==false do
			(
				if not isGroupHead tempGeo do
				(
					geo=copy tempGeo
					deleteItem tempGeo.parent.children geo
					CenterPivot geo
					fileName =exportPath +"//"+ tempGeo.name+ ".obj"
					InstanceMgr.GetInstances tempGeo&instances
					format "#" to: file
					for j in instances do
					(
						format "%@%@%@%" j.name (inverse j.objecttransform.rotation) (j.objecttransform.pos) (j.objecttransform.scale) to:file
						format "|" to:file
					)
					if existFile fileName==false do
					(
						select geo
						gPos=geo.pos
						gScale =geo.scale
						gRot=geo.rotation
						gOPos=geo.objectoffsetpos
						gOScale =geo.objectoffsetscale
						gORot=geo.objectoffsetrot
						geo.pos=[0,0,0]
						geo.objectoffsetpos=[0,0,0]
						geo.scale=[1,1,1]
						geo.objectoffsetscale=[1,1,1]
						geo.rotation=(quat 0 0 0 1)
						geo.objectoffsetrot=(quat 0 0 0 1)
						exportFile (fileName) #noPrompt selectedOnly: true
						geo.rotation=gRot
						geo.objectoffsetrot=gORot
						geo.scale=gScale
						geo.objectoffsetscale=gOScale
						geo.pos=gPos
						geo.objectoffsetpos=gOPos
					)
					delete geo
				)
				
			)
			index+=1
			progress.value=(index as Float)/(count as Float)*100
		)
		for tempLin in shapes  do
		(
			if tempLin.isFrozen ==false do
			(	
				if not isGroupHead tempLin do
				(
					lin=copy tempLin
					deleteItem tempLin.parent.children lin
					CenterPivot lin
					fileName =exportPath +"//"+ tempLin.name+ ".obj"
					InstanceMgr.GetInstances tempLin&instances
					format "#" to: file
					for j in instances do
					(
						format "%@%@%@%" j.name (inverse j.objecttransform.rotation) (j.objecttransform.pos) (j.objecttransform.scale) to:file
						format "|" to:file
					)
					if existFile fileName==false do
					(
						select lin
						gPos=lin.pos
						gScale =lin.scale
						gRot=lin.rotation
						gOPos=lin.objectoffsetpos
						gOScale =lin.objectoffsetscale
						gORot=lin.objectoffsetrot
						lin.pos=[0,0,0]
						lin.objectoffsetpos=[0,0,0]
						lin.scale=[1,1,1]
						lin.objectoffsetscale=[1,1,1]
						lin.rotation=(quat 0 0 0 1)
						lin.objectoffsetrot=(quat 0 0 0 1)
						exportFile (fileName) #noPrompt selectedOnly: true
						lin.rotation=gRot
						lin.objectoffsetrot=gORot
						lin.scale=gScale
						lin.objectoffsetscale=gOScale
						lin.pos=gPos
						lin.objectoffsetpos=gOPos
					)
				)
			)
			index+=1
			progress.value=(index as Float)/(count as Float)*100
		)
		flush file
		close file
		for i= 1 to n do
		(
			select selectionSets[i]  	
			unfreeze selectionSets[i]
		)
		createDialog dialog 100 20
		dialog.message.text="ExportFinished!"	
	)else
	(
		createDialog dialog 100 20
		dialog.message.text="PleaseChoosePathFirst!"	
	)
)


--???
rollout utilRollout "VKingExportUtil ver.1.4" width:200 height:150
(
	--button unGroupAllBtn "UnGroupAll" width:80 align:#left
	button deleteSymbolBtn "NormalizeName" width:80 height:47 align:#left
	--button turnToGeometryBtn "AllTurnToPoly"width:80 align:#left
	button findSameBtn "FindSameName" width:80 height:47 align:#left 
	edittext fileText "" width:120 height:15 across:2
	button chooseBtn "Choose" width:50 height:18 align:#right
	ProgressBar progress "" width:180 height:15 across:2
	button exportBtn "Export" width:95 height:100 offset:[2,-128]
	on unGroupAllBtn pressed do
	(	
		disableSceneRedraw()
		--??
		unGroupAll(progress)
		enableSceneRedraw()
	)
	on deleteSymbolBtn pressed do
	(	
		disableSceneRedraw()
		--????
		deleteSymbol(progress)
		enableSceneRedraw()
	)
	on turnToGeometryBtn pressed do
	(	
		disableSceneRedraw()
		--?????Geometry
		turnToGeometry(progress)
		enableSceneRedraw()
	)
	on findSameBtn pressed do
	(	
		disableSceneRedraw()
		--????
		findSame(progress)
		enableSceneRedraw()
	)
	on exportBtn pressed do
	(
		disableSceneRedraw()
		--??
		if fileText.text!="" do
		(
			exportPath=fileText.text
		)
		export(progress)
		enableSceneRedraw()
	)
	on chooseBTn pressed do
	(
		path = getPath()
      if path != undefined do
		( 
			fileText.text =path
		)      
	
	)
)
createDialog utilRollout



