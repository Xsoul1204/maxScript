for geo in geometry  do
	(
		tempName =geo.name
		i= findString tempName " "
		while i!=undefined  do
		(
			rname = replace tempName i 1 ""
			tempName=rname
			i= findString tempName " "			
		)
		geo.name=tempName
				
	)
	
	for geo in geometry  do
	(
		tempName =geo.name
		i= findString tempName "@"
		while i!=undefined  do
		(
			rname = replace tempName i 1 ""
			tempName=rname
			i= findString tempName " "			
		)
		geo.name=tempName
				
	)
	for geo in geometry  do
	(
		tempName =geo.name
		i= findString tempName "#"
		while i!=undefined  do
		(
			rname = replace tempName i 1 ""
			tempName=rname
			i= findString tempName " "			
		)
		geo.name=tempName
				
	)
		for geo in geometry  do
	(
		tempName =geo.name
		i= findString tempName "\\"
		while i!=undefined  do
		(
			rname = replace tempName i 1 ""
			tempName=rname
			i= findString tempName " "			
		)
		geo.name=tempName
				
	)
		for geo in geometry  do
	(
		tempName =geo.name
		i= findString tempName "|"
		while i!=undefined  do
		(
			rname = replace tempName i 1 ""
			tempName=rname
			i= findString tempName " "			
		)
		geo.name=tempName
				
	)
		for geo in geometry  do
	(
		tempName =geo.name
		i= findString tempName "\t"
		while i!=undefined  do
		(
			rname = replace tempName i 1 ""
			tempName=rname
			i= findString tempName " "			
		)
		geo.name=tempName
				
	)
geos = geometry as Array
for i=1 to geos.count  do
(
	iName = geos[i].name
	for j=i+1 to geos.count do
	(
		jName = geos[j].name
		if iName==jName do
		(
		print iName	
		)
	)		
)