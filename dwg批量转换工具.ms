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
fn getnames Title FilterName =
(
	dialog = DotNetObject"System.Windows.Forms.OpenFileDialog"
	dialog.title = Title
	dialog.filter = FilterName
	dialog.Multiselect = true
	OpenFileResult = dialog.ShowDialog()
	if OpenFileResult.Equals OpenFileResult.OK then
	(
		dialog.FileNames
	)
	else Undefined
)

--if form !=undefined do destroydialogmytools
rollout form "批量导入dwg"
(
	label lbl "批量导入dwg,根据需要选择文件个数"
	button btn "选择导入.dwg路径" width:120 height:25
	edittext fileText "" width:120 height:15 across:2
	button chooseBtn "Choose" width:50 height:18 align:#right
	on btn pressed do
	(
		
		file_names= getnames "选择导入文件" "DWG (*.dwg)|*.dwg"
		--file_names= getnames "选择导入文件" "OBJ (*.obj)|*.obj"
		if file_names != undefined do
		(       
			for f in file_names do  
			( 
				if ( doesfileexist f ) do 
				(	
					importFile f #noPrompt using:Wavefront_Object 
					for geo in geometry  
					where (matchPattern geo.name pattern:"3D_Object*") do
					( 
						--geo.name = (f as string)  
						pathaa = filterString (f as string)"//" 
						geo.name = pathaa[pathaa.count]
					)
					fileName=getFilenameFile f
					final_full_Path ="D:\\work\\导出模型"
					if fileText.text=="" then
					(
						makeDir final_full_Path
					)
					else
					(
						final_full_Path=fileText.text 
					)
					max select all
					exportFile (final_full_Path +"\\"+ fileName+ ".fbx") #noPrompt selectedOnly:true
					resetMaxFile #noprompt
				)
			)
		)
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
createdialog form 200 80
