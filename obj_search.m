%% 27-10-2016 - Alexander Wolff
%% Finds the percentage overlap of a small matrix (B) inside of a larger matric (A)
% Used to find a 2D object inside of a 2D scenary, A and B are typically binarized


function C = obj_search(A,B)
%Where A > B in both directions

%Find out size of A & B 
[Ma, Na] = size(A);
[Mb, Nb] = size(B);

%Create Padding Matrix for A
Ma_ = Ma + (Mb -1);
Na_ = Na + (Nb -1);
A_ = zeros(Ma_, Na_);
for Ni = 1:Na
    for Mi = 1:Ma
        A_(Mi,Ni) = A(Mi,Ni);
    end
end

%Calculate Padding for B
Mb_padding = Ma_ - Mb;
Nb_padding = Na_ - Nb;

%Calculate Black Pixels for B
B_size = sum(sum(B));

%Create the Result Matrix
C = zeros(Ma, Na);

%Along the width
for Ni = 1:Na
   
    %Calculate Padding along width for B
    Ni_Offset = Ni -1;
    Ni_prePadding = Ni_Offset;
    Ni_postPadding = Nb_padding - Ni_Offset;
    
    
    %Along the length
    for Mi = 1:Ma
        
        %Calculate Padding along length for B
        Mi_Offset = Mi - 1;
        Mi_prePadding = Mi_Offset;
        Mi_postPadding = Mb_padding - Mi_Offset;
        
        %Create Padding matrix for B
        B_ = zeros(Ma_, Na_);
        for Nj = 1:Na_
            for Mj = 1:Ma_
                if( ((Mj > Mi_prePadding) && (Mj <= Ma_-Mi_postPadding)) && ...
                    ((Nj > Ni_prePadding) && (Nj <= Na_-Ni_postPadding)) )
                    B_(Mj,Nj) = B(Mj-Mi_Offset,Nj-Ni_Offset);
                end
            end
        end
        
        %Correlate: A_.*B_
        C_ = A_.*B_;
        C(Mi_Offset+1, Ni_Offset+1) = sum(sum(C_))/B_size;
        
    end
    
    
end

return

