function GM = evaluate_gain_margin(Hw)
% Algorithm: Find real-axis crossings of Nyquist plot (temp2).  
% Select crossings on negative half of real axis (temp3 < 0).
% Select gain margin computed from most negative real-zxis crossing,
% which corresponds to the critical frequency that yields the
% minimum gain margin in the frequency band of Hw.

clear temp1 temp2 temp3 temp4

GM = inf;
temp1 = diff(sign(angle(Hw)));
temp2 = find(temp1 ~= 0);
for k1 = 1:length(temp2)
    temp3 = real(Hw(temp2(k1)));           
    if temp3 < 0
        temp4 = -1/temp3;
        if temp4 < GM
            GM = temp4;
        end
    end
end
