Fn getnames Title FilterName =
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
 
rollout form "��������obj"
(
         label lbl "��������obj"
         button btn "ѡ����obj·��" width:120 height:25
         on btn pressed do
         (
                   file_names= getnames "ѡ�����ļ�" "OBJ (*.obj)|*.obj"
                   if file_names != undefined do
                   (       
						for f in file_names do  
					   ( 
						if ( doesfileexist f ) do 
						   importFile f #noPrompt using:Wavefront_Object 
							
					   )
                   )
 
         )
)
createdialog form 200 50