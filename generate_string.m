function [STR,Notething] = generate_string(centroids, HalfNoteHeight, NumStaffSegs, peaks)
    % Eights contains the note names (strings)
    load Eights;
    load Fourths;
    % INDEXNOTEMAP helps fetch values from Eights
    INDEXNOTEMAP = (-9:20)';
 
    % Measure distance to the first line of each staff line segment
    DistMap = zeros(length(centroids(:,2)), NumStaffSegs);
    for i = 1:NumStaffSegs
        DistMap(:,i) = centroids(:,2) - peaks(1+5*(i-1),1);
    end
    [~, ind] = min(abs(DistMap), [], 2);
    for k = 1:size(DistMap,1)
        TempDistMap(k,1) = DistMap(k,ind(k,1));
    end
    DistMap = TempDistMap;
    DistMap(:,2) = ind;
    Notething = round(DistMap(:,1)./HalfNoteHeight);
    Notething(:,2) = ind;
    Notething(:,3) = centroids(:,3);
    Notething = sortrows(Notething,2);
    STR = "";
    for i = 1:size(Notething(:,1))
        X = find(INDEXNOTEMAP == Notething(i,1));
        if(Notething(i,3) == 16)
            continue
        elseif(Notething(i,3) == 8)
            STR = STR + Eights(X);
        else
            STR = STR + Fourths(X);
        end
        
    end
end