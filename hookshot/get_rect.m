% make a rectangle
function p = get_rect(w, h)
    p = [
        -w/2, -h/2;
        -w/2, +h/2;
        +w/2, +h/2;
        +w/2, -h/2;
        -w/2, -h/2;
    ];
end
