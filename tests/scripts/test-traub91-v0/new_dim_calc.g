// genesis 2 - new_dim_calc.g

/* calculate new compartment dimensions for converting a linear
   chain of symcompartments to one of compartments.

   The algorthim is:

   (1) Keep the surface area the same, so that 1/Rm, Cm, channel gmax,
       etc. all can use the same value per unit area.

    new_len*new_dia = len*dia == a

   (2) The axial resistance Ra is proportional to len/cross-sectional-area.
       Ra of the asymmetric compartment = Ra/2 + Ra(child)/2,
       where "child" is the compartment connected to the Ra of the
       parent compartment.

   new_len/(new_dia*new_dia) = 
       (len/(dia*dia)  + child_len/(child_dia*child_dia))/2.0

   (3) Solve these for new_len and new_dia
*/

float len, dia, new_len, new_dia, child_len, child_dia, a, b
str compt_name

/* Of course, these values should be obtained automatically from
   getfield of model fields.  However, finding parent-child relationships
   in GENESIS 2 is tricky.
*/


compt_name = "apical_18"
len = 120
dia = 5.78
child_len = 120
child_dia = 5.78

function calc_dims
    echo
    echo "---------------"
    echo {compt_name}
    echo "original len*dia = " {len*dia}
    a = len*dia // = new_len*new_dia (preserve surface area)
    echo "a = " {a}
    b = (len/(dia*dia)  + child_len/(child_dia*child_dia))/2.0
    echo "b = " {b} // preserve length/x-area

    new_len = a*{pow {b/a} {1.0/3.0}}
    new_dia = a/new_len
    echo "len = " {len} " new_len = " {new_len}
    echo "dia = " {dia}  " new_dia = " {new_dia}
    echo "new_len*new_dia = " {new_len*new_dia}
    echo "---------------"
end

calc_dims

// for apical_10 parent of soma
compt_name = "apical_10"
//soma
len = 120
dia = 5.78
child_len = 125
child_dia = 8.46
calc_dims

// for soma parent of basal_8
compt_name = "soma"
// soma
len = 125
dia = 8.46
// basal_8
child_len = 110
child_dia = 4.84
calc_dims
