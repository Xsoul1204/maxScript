rollout dialog "提示"
(
	Label message
)
rollout objExportRollout "Obj Export" width:100 height:100
(
	button exportBtn "Export" pos:[10,10] width:80 height:80
	
	
	on exportBtn pressed do
	(	
		if maxFilePath != "" do
		(	
			for geo in geometry  do
			(
					select geo 
					exportFile (maxFilePath+"//"+ geo.name+ ".obj") #noPrompt selectedOnly: true--导出max场景中的物
				
			)
		)
		createDialog dialog 100 20
		dialog.message.text="导出成功！"
	)
)
createDialog objExportRollout




