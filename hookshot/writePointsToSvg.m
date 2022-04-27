function writePointsToSvg(points, filepath)
	
	minX = min(points(:,1));
	maxX = max(points(:,1));
	diffX = max(1,maxX - minX);
	maxX = minX + diffX;
	width = max(1, maxX);
	
	minY = min(points(:,2));
	maxY = max(points(:,2));
	diffY = max(1,maxY - minY);
	maxY = minY + diffY;
	height = max(1, maxY);
	
	fout = fopen(filepath, 'w');
	fprintf(fout, '<?xml version="1.0" standalone="no"?>\n');
	fprintf(fout, '<svg width="%d" height="%d" xmlns="http://www.w3.org/2000/svg">\n', width, height);

	fprintf(fout, '    <path d="');
	letter = 'M';
	for ii = 1:size(points,1)
		if isnan(points(ii,1)) || isnan(points(ii,2))
			fprintf(fout, '" fill="none" stroke="black" stroke-width="0.1px"/>\n');
			fprintf(fout, '    <path d="');
			letter = 'M';
		else
			fprintf(fout, '%c %d %d ', letter, points(ii,1), points(ii,2));
			letter = 'L';
		end
	end
	% end with Z to connect to start
	fprintf(fout, '" fill="none" stroke="black" stroke-width="0.1px"/>\n');
	
	fprintf(fout, '<svg/>\n');
	fclose(fout);
end
