#@load "json"
@load "rwarray"
@include "../utils.awk"
@include "../color.awk"
@include "../utils.awk"
BEGIN {
    SUBSEP=","
}
/Immune System:/{
    unit_type = "immune"
    next
}
/Infection:/{
    unit_type = "infection"
    next
}
/^.+$/{
    match($0,/([0-9]+) units each with /, arr)
    units[NR] = arr[1]
    match($0,/([0-9]+) hit points/, arr)
    hit_points[NR] = arr[1]
    match($0,/with an attack that does ([0-9]+) ([^ ]+) damage/, arr)




    if(unit_type == "immune")
        power[NR] = arr[1] + boost
    else
        power[NR] = arr[1]

    power_type[NR] = arr[2]
    match($0,/at initiative ([0-9]+)/, arr)
    initiative[NR] = arr[1]

    match($0,/\(.*weak to ([^, ;]+)?[, ]*([^, ;]+)?[, ]*([^, ;]+)?.*[;\)]/,arr)
    for(i=1;i<=3;i++){
        if(i in arr){
            weak[NR][arr[i]]=1
        }
    }
    match($0,/\(.*immune to ([^, ;]+)?[, ]*([^, ;]+)?[, ]*([^, ;]+)?.*[;\)]/,arr)
    for(i=1;i<=3;i++){
        if(i in arr){
            immune[NR][arr[i]]=1
        }
    }
    unit[NR]=unit_type
    
}
END {
    #printa(units)
    #printa(power)
    for(rounds=1;rounds<10000000;rounds++){
        if(combat_over_q()) break

        delete selection
        delete battle
        target_selection(selection,battle)

        attack_phase(selection,battle)
        #print "round",rounds
        #printa(units)
    }
    print combat_over_q()
    print "exit"
    exit
}
function combat_over_q(n, immune, infection){
    immune=0
    infection=0
    for(n in units){
        if(unit[n] == "immune")
            immune += units[n]
        else
            infection += units[n]
    }
    if( immune == 0)
        print "infection wins with", boost
    if( infection == 0)
        print "immune wins with", boost
    if( immune == 0 || infection == 0)
        return immune + infection
    return 0
}
function attack_phase(selection,battle, n, initiative_s){
    #printa(selection)
    #printa(initiative)
    asorti(initiative,initiative_s,"@val_num_desc")
    for(n in initiative_s){
        #print n,initiative_s[n],initiative[initiative_s[n]]
        attacker = initiative_s[n]
        defender = selection[attacker]
        if(!(defender in units)) continue
        if(!(attacker in units)) continue
        battle[attacker,defender] = int(damage_to(attacker,defender) / hit_points[defender])
        units[defender] -= battle[attacker,defender]
        print attacker,defender, battle[attacker,defender]
        if(units[defender] <= 0) {
            killed = defender
            print "eliminated:",killed
            delete units[killed]
            delete targets[killed]
            delete initiative[killed]
        }
    }
}
function target_selection(selection,battle,nr, nr_i ){
    asorti(units, units_s,"cmp_effective_power")
    #printa(units_s)
    delete selection

    delete targets
    for(i in units) targets[i]=1

    #delete battle
    for(nr_i in units_s){
        nr = units_s[nr_i]
        if(!(nr in units)) continue
        selection[nr] = pick_target(nr,targets)
    }
    #printa(battle)
}
function pick_target(nr,   targets, enemy_type, n,damage_a,damage_s){
    delete damage_a
    enemy_type = enemy(nr)

    delete targets_n
    for(i in targets) targets_n[i]=1
    for(n in targets_n){
        if(unit[n] != enemy_type) 
            delete targets_n[n]
    }
    cmp_nr = nr
    asorti(targets_n,damage_s,"cmp_damage_to")
    #printa(damage_s)
    #print length(damage_s)
    #print damage_to(nr,damage_s[1])
    if(length(damage_s) <= 0 || damage_to(nr,damage_s[1]) <= 0) return -1

    delete targets[damage_s[1]]
    return damage_s[1]
}
function cmp_damage_to(i1,v1,i2,v2, d1,d2){
    d1 = damage_to(cmp_nr,i1)
    d2 = damage_to(cmp_nr,i2)
    #print cmp_nr,i1,i2,d1,d2
    if(d1 < d2)
        return 1
    else if(d1 == d2){
        return cmp_effective_power(i1,v1,i2,v2)
    }
    else return -1

}

function damage_to(nr,nr2){
    mod = 1
    if(nr2 in weak && power_type[nr] in weak[nr2])
        mod = 2

    if(nr2 in immune && power_type[nr] in immune[nr2])
        mod = 0
    return effective_power(nr) * mod
}

function cmp_effective_power(i1,v1,i2,v2,p1,p2,in1,in2){
    p1 = effective_power(i1)
    p2 = effective_power(i2)
    if(p1 < p2)
        return 1
    else if(p1 == p2){
        if(initiative[i1] > initiative[i2])
            return -1
        else if(initiative[i1] < initiative[i2])
            return 1
        else {
            print "error in cmp_effective_power"
            exit
        }
        return 0
    }
    else return -1
}
function effective_power(nr){
    return units[nr] * power[nr]
}
function enemy(nr){
    if(unit[nr] == "immune")
        return "infection"
    else
        return "immune"
}
