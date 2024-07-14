function x = sistema_discr(t, x)
    global u_discr
    x = unicycle(t, x, u_discr);
end
