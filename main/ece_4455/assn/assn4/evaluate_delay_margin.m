function TDM = evaluate_delay_margin(Hw,w)
% Algorithm: Find indices of critical frequencies where |H(w)| passes through 1 (temp2).
% Find <H(w_c) at each critical frequency (temp3) in range 0 <= phi < 2*pi.
% Save lowest <H(w_c) as phi_c.  Use phi_c to compute PM and TDM.

clear temp1 temp2 temp3 temp4

if max(abs(Hw)) < 1
    TDM = inf;
else
    % temp2 is/are freqency(ies) of zero crossing(s) of |H(w)| - 1.
    temp1 = diff(sign(abs(Hw)-1));
    temp2 = find(temp1 ~= 0);
    phi_c = 2*pi;
    for i1 = 1:length(temp2)
        phi_wrap = wrapTo2Pi(angle(Hw(temp2(i1))));
        if phi_wrap == 2*pi
            phi_wrap = 0;
        end
        if phi_wrap < phi_c
            phi_c = phi_wrap;
            w_c = w(temp2(i1));
        end
    end
    PM = phi_c - pi;
    %PM_deg = (360/(2*pi))*PM;
    TDM = PM/w_c;
end
