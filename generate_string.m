function [STR] = generate_string(centroids, HalfNoteHeight, NumStaffSegs, peaks)
    % Eights contains the note names (strings)
    load Eights;
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
    Notething = sortrows(Notething,2);
    for i = 1:size(Notething(:,1))
        X = find(INDEXNOTEMAP == Notething(i,1));
        STR(i) = Eights(X);
    end
end