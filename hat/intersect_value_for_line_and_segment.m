function r = intersect_value_for_line_and_segment(lp, lv, sp, sv)
    % lp + l * lv == sp +  s * sv
    % l * lv - s * sv == sp - lp
    % [lv -sv]*[l s]' == (sp-lp)
    % rref([lv, -sv | sp-lp])
    rr = rref([lv, -sv, sp-lp]);
    rn = rr(2,3);
    if (rank(rr) == 2) && (sum(sum(rr(1:2,1:2) == eye(2))) == 4) && (rn >= 0) && (rn <= 1)
        r = rn;
    else
        r = NaN;
    end
end
