import numpy as np
    
def part1(seq, num_lst, pos, skip):
    lst_len = len(num_lst)
    curr_pos = pos
    skip_size = skip
    lengths = seq.split(',')
        
    for leng in lengths:
        leng = int(leng.strip())
        if leng > lst_len:
            continue
        rev_end = (curr_pos + leng) % lst_len
        if rev_end == 0:
            rev_end = lst_len
        inds = list(range(curr_pos, rev_end))
        if leng > 0 and rev_end <= curr_pos:
            inds = list(range(curr_pos, lst_len)) + list(range(rev_end)) 

        num_lst[inds] = np.flipud(num_lst[inds])                  
        curr_pos = (curr_pos + leng + skip_size) % lst_len
        skip_size += 1

    return num_lst[0] * num_lst[1], num_lst, curr_pos, skip_size
    
def part2(seq):
    sparse = np.array(range(RANGE))
    pos = 0
    skip = 0
    block_size = 16
    dense = []
    
    byte_str = ''.join([str(ord(char)) + ',' for char in seq.strip()])
    byte_str += "17,31,73,47,23"
    
    for i in range(64):
        num_mult, sparse, pos, skip = part1(byte_str, sparse, pos, skip)   
    for block in range(0,RANGE,block_size):
        xored = 0
        for i in range(block, block + block_size): 
            xored ^= sparse[i]
        dense.append(xored)        
        
    hash_str = ''.join([('0' + format(num, 'x'))[-2:] for num in dense])    
     
    return hash_str       


inp = "3,4,1,5"
RANGE = 5
print(part1(inp, np.array(range(RANGE)), 0, 0)[0])
RANGE = 256
inp = "225,171,131,2,35,5,0,13,1,246,54,97,255,98,254,110"
print(part2(inp))
