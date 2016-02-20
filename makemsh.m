function makemsh(name,geom)
%MAKEMSH make a *.MSH file for JIGSAW.
%
%   MAKEMSH(NAME,MESH);
%
%   The following entities are optionally written to "NAME.MSH". Entities 
%   are written if they are present in the sructure MESH:
%
%   MESH.POINT.COORD - [NPxND] array of point coordinates, where ND is the
%       number of spatial dimenions.
%
%   MESH.EDGE2.INDEX - [N2x 3] array of indexing for edge-2 elements, whe-
%       re INDEX(K,1:2) is the array of "points" associated with the K-TH 
%       edge, and INDEX(K,3) is an ID tag for the K-TH edge.
%
%   MESH.TRIA3.INDEX - [N3x 4] array of indexing for tria-3 elements, whe-
%       re INDEX(K,1:3) is the array of "points" associated with the K-TH 
%       tria, and INDEX(K,4) is an ID tag for the K-TH tria.
%
%   MESH.TRIA4.INDEX - [N4x 5] array of indexing for tria-4 elements, whe-
%       re INDEX(K,1:4) is the array of "points" associated with the K-TH 
%       tria, and INDEX(K,5) is an ID tag for the K-TH tria.
%
%   See also READMSH

%   Darren Engwirda
%   02-Feb-2016
%   d_engwirda@outlook.com


   [path,file,fext] = fileparts(name);
   
    if(~strcmp(lower(fext),'.msh'))
        error('Invalid file name');
    end
 
    try
    
    ffid = fopen(name, 'w') ;
    
    nver = +1;
    
    endl = '\r\n';
    real = '%1.16g;';
    ints = '%i;';
    
    fprintf(ffid,['# %s.msh geometry file',endl],file);
    fprintf(ffid,['mshid=%u',endl],nver);
    
    if (isfield(geom,'point') && ...
            isfield(geom.point,'coord'))
    
    ndim = size(geom.point.coord,2) - 1 ;
    
    fprintf(ffid,['ndims=%u',endl],ndim);
    
%-- write "POINT" data
        
    fprintf(ffid,['point=%u',endl],size(geom.point.coord,1));        
    fprintf(ffid,[repmat(real,1,ndim),'%i',endl],...
        geom.point.coord' ) ;

    end
    
    if (isfield(geom,'edge2') && ...
            isfield(geom.edge2,'index'))
       
%-- write "EDGE2" data
        
    index = geom.edge2.index;
    index(:,1:2) = index(:,1:2)-1 ; % file is zero-indexed!
       
    fprintf(ffid,['edge2=%u',endl],size(geom.edge2.index,1));        
    fprintf(ffid,[repmat(ints,1,2),'%i',endl],index');

    end
    
    if (isfield(geom,'tria3') && ...
            isfield(geom.tria3,'index'))
       
%-- write "TRIA3" data
        
    index = geom.tria3.index;
    index(:,1:3) = index(:,1:3)-1 ; % file is zero-indexed!
       
    fprintf(ffid,['tria3=%u',endl],size(geom.tria3.index,1));        
    fprintf(ffid,[repmat(ints,1,3),'%i',endl],index');

    end
    
    if (isfield(geom,'tria4') && ...
            isfield(geom.tria4,'index'))

%-- write "TRIA4" data
        
    index = geom.tria4.index;
    index(:,1:4) = index(:,1:4)-1 ; % file is zero-indexed!
       
    fprintf(ffid,['tria4=%u',endl],size(geom.tria4.index,1));        
    fprintf(ffid,[repmat(ints,1,4),'%i',endl],index');

    end
        
    fclose(ffid);
    
    catch err
    
%-- ensure that we close the file regardless!
    if (ffid>-1)
    fclose(ffid) ;
    end
    rethrow(err) ;
        
    end
    
end
