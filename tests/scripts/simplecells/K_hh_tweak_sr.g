/* A replacement for hhtchan.g function make_K_hh_tchan */

function make_K_hh_tabfill
    float alpha, beta, A, B, tau, minf, x, dx
    int i
    str chanpath = "K_hh_tchan"
    if ({argc} == 1)
       chanpath = {argv 1}
    end
    if (({exists {chanpath}}))
	return
    end

    create tabchannel {chanpath}
    setfield ^ Ek {EK} Gbar {360.0*SOMA_A} Ik 0 Gk 0  \
                    Xpower 4 Ypower 0 Zpower 0
/*        
	setupalpha {chanpath} X {10e3*(0.01 + EREST_ACT)} -10.0e3  \
            -1.0 {-1.0*(0.01 + EREST_ACT)} -0.01 125.0 0.0 0.0	\
            {-1.0*EREST_ACT} 80.0e-3
*/

    call {chanpath} TABCREATE X 49 -0.1 0.05
    x = -0.1
    dx = 0.15/49.0
    for (i = 0; i <= 49; i = i + 1)

        alpha = {(10e3*(0.01 + EREST_ACT) -10.0e3*x)/(-1.0 + {exp {(x - \
            1.0*(0.01 + EREST_ACT))/-0.01}})}
	beta = 125.0/({	exp {(x -1.0*EREST_ACT)/ 80.0e-3}})
        A = alpha; B = alpha + beta
	tau = 1.0/B
        minf = A/B
        setfield {chanpath} X_A->table[{i}] {tau}
	setfield {chanpath} X_B->table[{i}] {minf}
        x = x + dx
    end
    tweaktau {chanpath} X
    setfield {chanpath} X_A->calc_mode 0 X_B->calc_mode 0
    call {chanpath} TABFILL X 3000 0
end

