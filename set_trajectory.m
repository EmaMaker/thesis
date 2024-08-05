function [ref, dref] = set_trajectory(i, sim_data)
syms s

switch i
    case 0   
        % a straigth line trajectory at v=0.2m/s
        xref = 0.2*s;
        yref = 0;
    case 1
        % a straigth line trajectory at v=0.8m/s
        xref = 0.8*s;
        yref = 0;
    case 2
        % straight line, with initial error
        xref = 5 + 0.5*s;
        yref = 0;
    case 3
        % straight line, initial error, faster
        xref = 5 + 0.8*s;
        yref = 0;
    case 4
        % circle
        xref = cos(0.25*s);
        yref = sin(0.25*s);
    case 5
        % bigger circle, same velocity
        xref = 2.5*cos(s);
        yref = 2.5*sin(s);
    case 6
        % sin
        xref = sim_data.speed*s; 
        yref = 0.25*sin(2*pi*sim_data.frequency*s);
        %xref = 0.6*s; 
        %yref = cos(0.6*s);
    case 7
        % slightly bigger, slower circle
        xref = 2.55*cos(0.05*s);
        yref = 2.55*sin(0.05*s);
    case 8
        % straightline, on y=1
        xref = 0.5*s;
        yref = 1;
    case 9
        % strange sine
        xref = 0.9*s;
        yref = 0.5*cos(0.65*s);
    case 10
        % figure8 
        xref = cos(sim_data.xrep*sim_data.speed*s);
        yref = sin(sim_data.yrep*sim_data.speed*s);
    case 11
        % cardioid
        a = sim_data.a;
        b = sim_data.b;
        spd = sim_data.speed;
        xref = 2*a*(1-cos(spd*s))*sin(spd*s);
        %xref = 4*a*(0.2-cos(0.5*s))*sin(0.5*s);
        yref = 2*b*(1-cos(spd*s))*cos(spd*s);
    case 12
        % square! in parametic form! https://math.stackexchange.com/questions/978486/parametric-form-of-square
        speed = sim_data.speed;
        %speed = 0.18;
        %side = 1.5;
        side = sim_data.side;
        s_ = speed * s;
        %xref = side * cos(s) / max(abs(cos(speed*s)), abs(sin(speed*s))) ;
        %yref = side * sin(s) / max(abs(cos(speed*s)), abs(sin(speed+s))) ;
        p = (sqrt(2) * (abs(sin(s_ + pi/4)) + abs(cos(s_ + pi/4))));
        xref = side * cos(s_) / p;
        yref = side * sin(s_) / p;
    case 13
	    xref = -2*cos(sim_data.speed*s)+2;
	    yref = sim_data.speed*0.5*s^2;
    case 14
        maxx=sim_data.maxx;
        xspeed=sim_data.xspeed;
        stoptime = maxx/xspeed;
        yspeed=sim_data.ydisplacement/stoptime;
        tms = mod(s, stoptime);
        
        xref = piecewise(s < stoptime, xspeed*tms, s >= stoptime, maxx-xspeed*tms);
        yref=yspeed*s;
        dxref = piecewise(s < stoptime, xspeed, s >= stoptime, -xspeed);
        dyref=yspeed;
        
        ref = [xref; yref];
        dref = [dxref; dyref];
        return
    case 15
	    %st_ = sim_data.stoptime-s;
	    %ss = sim_data.speed*s;
	    %xref=ss*max(st_,0)/(st_+0.00001) + (sim_data.stoptime-ss)*max(-st_,0)/(-st_+0.00001)
	    %yref=0;
	    %vxref=s*max(st_,0)/(st_+0.00001) -s*max(-st_,0)/(-st_+0.00001)
	    %vyref=0;
	    %ref = [xref; yref];
	    %dref = [vxref; vyref];
        %return
        maxx=simdata.maxx;
        xspeed=sim_data.xspeed;
        yspeed=sim_data.yspeed;
        stoptime = maxx/xspeed;
        tms = mod(s, stoptime);
        
        xref = piecewise(s < stoptime, xspeed*tms, s >= stoptime, maxx-xspeed*tms);
        yref=yspeed*s;
        dxref = piecewise(s < stoptime, xspeed, s >= stoptime, -xspeed);
        dyref=yspeed;
        
        ref = [xref; yref];
        dref = [dxref; dyref];
        return
    case 16
        %square 2
        speed = sim_data.speed;
        side = sim_data.side;
        sidet = side / speed;
        ms = mod(s, sidet);
        tms = mod(s, 4*sidet);
        xref = piecewise((0 <= s) & (tms < sidet), side , (tms >= sidet) & (tms < sidet*2), side-speed*ms, (tms >= sidet*2) & (tms < sidet*3), 0, (tms >= sidet*3) & (tms <= sidet*4), speed*ms);
        yref = piecewise((0 <= s) & (tms < sidet), speed*ms, (tms >= sidet) & (tms < sidet*2), side, (tms >= sidet*2) & (tms < sidet*3), side-speed*ms, (tms >= sidet*3) & (tms <= sidet*4), 0);
        dxref = piecewise((0 <= s) & (tms < sidet), 0 , (tms >= sidet) & (tms < sidet*2), -speed, (tms >= sidet*2) & (tms < sidet*3), 0, (tms >= sidet*3) & (tms <= sidet*4), speed);
        dyref = piecewise((0 <= s) & (tms < sidet), speed, (tms >= sidet) & (tms < sidet*2), 0, (tms >= sidet*2) & (tms < sidet*3), -speed, (tms >= sidet*3) & (tms <= sidet*4), 0);
        ref = [xref; yref];
        dref = [dxref; dyref];
        return

end

ref = [xref; yref];
dref = diff(ref, s);
end
