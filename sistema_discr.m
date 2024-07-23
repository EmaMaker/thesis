function x = sistema_discr(t, q)
    global u_discr
    q = unicycle(t, q, u_discr);
end
